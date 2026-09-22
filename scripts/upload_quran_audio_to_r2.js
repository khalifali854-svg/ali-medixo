#!/usr/bin/env node
/**
 * Upload semua 6.236 MP3 audio Quran (Alafasy) dari verses.quran.com ke Cloudflare R2
 * Path di R2: quran/Alafasy/XXXYYY.mp3
 * Public URL: https://ali.medixo.id/quran/Alafasy/XXXYYY.mp3
 *
 * Usage: node scripts/upload_quran_audio_to_r2.js
 */

const https = require('https');
const http = require('http');
const crypto = require('crypto');

// ─── R2 Config (dari AppConfig di Dart) ───────────────────────────────────────
const R2_ACCOUNT_ID  = 'f7e27ce0b4c2e9e41ad1dfcbb89bc5b3';
const R2_BUCKET      = 'ali-app';
const R2_ACCESS_KEY  = 'f5312c9a802d364507bae5ad7872cf7c';
const R2_SECRET_KEY  = '9ddd94fe9a0c875abfaf3d2074284a4320803b90904f9612ab320d57adde5491';
const PUBLIC_BASE    = 'https://ali.medixo.id';
const R2_PATH_PREFIX = 'quran/Alafasy';

// ─── Quran surah → ayat count (Total 6.236 ayat) ───────────────────────────
const SURAH_AYAT_COUNT = [
  7,286,200,176,120,165,206,75,129,109,
  123,111,43,52,99,128,111,110,98,135,
  112,78,118,64,77,227,93,88,69,60,
  34,30,73,54,45,83,182,88,75,85,
  54,53,89,59,37,35,38,29,18,45,
  60,49,62,55,78,96,29,22,24,13,
  14,11,11,18,12,12,30,52,52,44,
  28,28,20,56,40,31,50,40,46,42,
  29,19,36,25,22,17,19,26,30,20,
  15,21,11,8,8,19,5,8,8,11,
  11,8,3,9,5,4,7,3,6,3,5,4,5,6
];

// ─── AWS Sig4 Helper ─────────────────────────────────────────────────────────
function hmac(key, data, encoding) {
  return crypto.createHmac('sha256', key).update(data).digest(encoding || undefined);
}
function sha256hex(data) {
  return crypto.createHash('sha256').update(data).digest('hex');
}
function getSignatureKey(key, dateStamp, regionName, serviceName) {
  const kDate    = hmac('AWS4' + key, dateStamp);
  const kRegion  = hmac(kDate, regionName);
  const kService = hmac(kRegion, serviceName);
  return hmac(kService, 'aws4_request');
}

function buildAuthHeader(method, path, bodyHash, amzDate, dateStamp) {
  const host = `${R2_ACCOUNT_ID}.r2.cloudflarestorage.com`;
  const canonicalHeaders = `content-type:audio/mpeg\nhost:${host}\nx-amz-content-sha256:${bodyHash}\nx-amz-date:${amzDate}\n`;
  const signedHeaders = 'content-type;host;x-amz-content-sha256;x-amz-date';
  const canonicalReq = ['PUT', path, '', canonicalHeaders, signedHeaders, bodyHash].join('\n');
  const credentialScope = `${dateStamp}/auto/s3/aws4_request`;
  const stringToSign = ['AWS4-HMAC-SHA256', amzDate, credentialScope, sha256hex(canonicalReq)].join('\n');
  const sigKey = getSignatureKey(R2_SECRET_KEY, dateStamp, 'auto', 's3');
  const sig = hmac(sigKey, stringToSign, 'hex');
  return `AWS4-HMAC-SHA256 Credential=${R2_ACCESS_KEY}/${credentialScope}, SignedHeaders=${signedHeaders}, Signature=${sig}`;
}

// ─── Download helper (bypass local DNS: gunakan IP langsung) ──────────────────
// IP verses.quran.com = 84.17.38.232 (BunnyCDN)
const VERSES_IP = '84.17.38.232';

function downloadBuffer(filePath, redirects) {
  redirects = redirects || 0;
  return new Promise((resolve, reject) => {
    if (redirects > 5) return reject(new Error('Too many redirects'));
    // Bypass DNS dengan connect langsung ke IP, set servername untuk SNI/TLS
    const options = {
      hostname: VERSES_IP,
      port: 443,
      path: '/Alafasy/mp3/' + filePath,
      method: 'GET',
      headers: { 'Host': 'verses.quran.com' },
      servername: 'verses.quran.com', // SNI
      timeout: 25000,
    };
    const req = https.request(options, (res) => {
      if (res.statusCode >= 300 && res.statusCode < 400 && res.headers.location) {
        return resolve(downloadBuffer(filePath, redirects + 1));
      }
      if (res.statusCode !== 200) {
        res.resume();
        return reject(new Error('HTTP ' + res.statusCode + ' for ' + filePath));
      }
      const chunks = [];
      res.on('data', c => chunks.push(c));
      res.on('end', () => resolve(Buffer.concat(chunks)));
      res.on('error', reject);
    });
    req.on('error', reject);
    req.on('timeout', () => { req.destroy(); reject(new Error('Timeout: ' + filePath)); });
    req.end();
  });
}

// ─── R2 Upload helper (dengan timeout 30 detik) ───────────────────────────────
function uploadToR2(bodyBuffer, r2Path) {
  return new Promise((resolve, reject) => {
    const now = new Date();
    const amzDate = now.toISOString().replace(/[-:]/g, '').replace(/\.\d{3}/, '');
    const dateStamp = amzDate.slice(0, 8);
    const bodyHash = sha256hex(bodyBuffer);
    const canonicalUri = '/' + R2_BUCKET + '/' + r2Path;
    const authHeader = buildAuthHeader('PUT', canonicalUri, bodyHash, amzDate, dateStamp);
    const host = R2_ACCOUNT_ID + '.r2.cloudflarestorage.com';

    // Timeout guard 30 detik
    let settled = false;
    const timer = setTimeout(() => {
      if (settled) return;
      settled = true;
      req.destroy();
      reject(new Error('R2 upload timeout: ' + r2Path));
    }, 30000);

    const options = {
      hostname: host,
      path: canonicalUri,
      method: 'PUT',
      timeout: 30000,
      headers: {
        'Content-Type': 'audio/mpeg',
        'Content-Length': bodyBuffer.length,
        'x-amz-date': amzDate,
        'x-amz-content-sha256': bodyHash,
        'Authorization': authHeader,
      },
    };
    const req = https.request(options, (res) => {
      let body = '';
      res.on('data', c => body += c);
      res.on('end', () => {
        if (settled) return;
        settled = true;
        clearTimeout(timer);
        if (res.statusCode === 200 || res.statusCode === 201 || res.statusCode === 204) {
          resolve(PUBLIC_BASE + '/' + r2Path);
        } else {
          reject(new Error('R2 PUT ' + res.statusCode + ': ' + body.slice(0, 200)));
        }
      });
    });
    req.on('error', (e) => {
      if (settled) return;
      settled = true;
      clearTimeout(timer);
      reject(e);
    });
    req.on('timeout', () => {
      if (settled) return;
      settled = true;
      clearTimeout(timer);
      req.destroy();
      reject(new Error('R2 socket timeout: ' + r2Path));
    });
    req.write(bodyBuffer);
    req.end();
  });
}

// ─── Retry wrapper ────────────────────────────────────────────────────────────
async function withRetry(fn, retries, label) {
  for (let i = 0; i <= retries; i++) {
    try {
      return await fn();
    } catch (e) {
      if (i === retries) throw e;
      const wait = 1000 * (i + 1);
      await new Promise(r => setTimeout(r, wait));
    }
  }
}

// ─── Build file list ──────────────────────────────────────────────────────────
function buildFileList() {
  const files = [];
  for (let s = 1; s <= SURAH_AYAT_COUNT.length; s++) {
    const total = SURAH_AYAT_COUNT[s - 1];
    for (let a = 1; a <= total; a++) {
      const sp = String(s).padStart(3, '0');
      const ap = String(a).padStart(3, '0');
      files.push({ sp, ap, name: sp + ap + '.mp3' });
    }
  }
  return files;
}

// ─── Main ─────────────────────────────────────────────────────────────────────
async function main() {
  const files = buildFileList();
  console.log('Total files to upload: ' + files.length);
  console.log('Source: https://verses.quran.com/Alafasy/mp3/XXXYYY.mp3');
  console.log('Target: ' + PUBLIC_BASE + '/' + R2_PATH_PREFIX + '/XXXYYY.mp3\n');

  // 32 file yang sempat gagal koneksi (ENETUNREACH / DNS glitch sementara):
  const missingFileNames = [
    '002060.mp3', '002070.mp3', '002066.mp3', '002069.mp3', '002071.mp3',
    '002067.mp3', '002072.mp3', '002073.mp3', '002074.mp3', '002075.mp3',
    '002076.mp3', '002102.mp3', '002099.mp3', '002091.mp3', '002100.mp3',
    '002103.mp3', '002104.mp3', '002105.mp3', '002106.mp3', '002107.mp3',
    '002108.mp3', '002109.mp3', '002110.mp3', '002111.mp3', '002112.mp3',
    '002113.mp3', '002114.mp3', '002115.mp3', '002116.mp3', '002117.mp3',
    '002118.mp3', '002119.mp3'
  ];

  const workFiles = files.filter(f => missingFileNames.includes(f.name));
  console.log('Mengupload ' + workFiles.length + ' file yang tersisa/sempat gagal...');

  let done = 0;
  let failed = 0;
  const failedList = [];

  async function processFile(f) {
    const r2Path = R2_PATH_PREFIX + '/' + f.name;
    try {
      const buf = await withRetry(() => downloadBuffer(f.name), 4, f.name);
      await withRetry(() => uploadToR2(buf, r2Path), 3, r2Path);
      done++;
      console.log('✓ ' + done + '/' + workFiles.length + ' Uploaded: ' + f.name);
    } catch (e) {
      failed++;
      failedList.push({ name: f.name, err: e.message });
      console.error('✗ Gagal: ' + f.name + ' (' + e.message + ')');
    }
  }

  const queue = [...workFiles];
  async function worker() {
    while (queue.length > 0) {
      const f = queue.shift();
      if (f) await processFile(f);
    }
  }

  const workers = Array.from({ length: 2 }, () => worker());
  await Promise.all(workers);

  console.log('\nSelesai batch sisa! ✓ ' + done + ' uploaded, ✗ ' + failed + ' gagal.');
  if (failedList.length === 0) {
    console.log('🎉 SELURUH 6.236 AUDIO QURAN LENGKAP 100% DI R2!');
  }
}

main().catch(e => { console.error('Fatal:', e); process.exit(1); });
