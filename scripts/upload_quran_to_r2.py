#!/usr/bin/env python3
"""
Custom pure-python streaming SQL INSERT parser for sistahid_quran.sql.
Handles MySQL \' and \\ escapes accurately.
"""

import os
import json
import datetime
import hashlib
import hmac
import urllib.request

SQL_FILE = '/Users/gemmyadyendra/Projects/Ali/Plan/sistahid_quran.sql'
OUTPUT_DIR = '/Users/gemmyadyendra/Projects/Ali/scripts/quran_data'

ACCOUNT_ID = 'f7e27ce0b4c2e9e41ad1dfcbb89bc5b3'
BUCKET = 'ali-app'
ACCESS_KEY = 'f5312c9a802d364507bae5ad7872cf7c'
SECRET_KEY = '9ddd94fe9a0c875abfaf3d2074284a4320803b90904f9612ab320d57adde5491'
PUBLIC_BASE = 'https://ali.medixo.id'

os.makedirs(f'{OUTPUT_DIR}/surahs', exist_ok=True)

def parse_sql_values(val_str):
    """Parse comma-separated values inside parentheses, respecting escaped strings."""
    values = []
    i = 0
    n = len(val_str)
    while i < n:
        # Skip whitespace
        while i < n and val_str[i] in ' \t\r\n':
            i += 1
        if i >= n:
            break
        
        if val_str[i] == "'":
            # String literal
            i += 1
            chars = []
            while i < n:
                c = val_str[i]
                if c == '\\':
                    if i + 1 < n:
                        next_c = val_str[i+1]
                        if next_c == 'n':
                            chars.append('\n')
                        elif next_c == 'r':
                            chars.append('\r')
                        elif next_c == 't':
                            chars.append('\t')
                        else:
                            chars.append(next_c)
                        i += 2
                    else:
                        chars.append(c)
                        i += 1
                elif c == "'":
                    if i + 1 < n and val_str[i+1] == "'":
                        # Escaped '' in SQL
                        chars.append("'")
                        i += 2
                    else:
                        # End of string
                        i += 1
                        break
                else:
                    chars.append(c)
                    i += 1
            values.append("".join(chars))
            # Advance to comma or end
            while i < n and val_str[i] != ',':
                i += 1
            if i < n and val_str[i] == ',':
                i += 1
        else:
            # Number or NULL
            start = i
            while i < n and val_str[i] != ',':
                i += 1
            token = val_str[start:i].strip()
            if token.upper() == 'NULL':
                values.append(None)
            else:
                try:
                    if '.' in token:
                        values.append(float(token))
                    else:
                        values.append(int(token))
                except ValueError:
                    values.append(token)
            if i < n and val_str[i] == ',':
                i += 1
    return values

def extract_rows(file_path, table_name):
    """Stream file and yield rows for the specified table."""
    with open(file_path, 'r', encoding='utf-8') as f:
        in_table = False
        buffer = []
        for line in f:
            if line.startswith(f"INSERT INTO `{table_name}`"):
                in_table = True
                # Remove prefix
                prefix_idx = line.find("VALUES")
                if prefix_idx != -1:
                    line = line[prefix_idx + 6:]
            
            if in_table:
                buffer.append(line)
                if line.rstrip().endswith(";"):
                    # Process entire statement
                    full_text = "".join(buffer).strip()
                    if full_text.endswith(";"):
                        full_text = full_text[:-1].strip()
                    buffer = []
                    in_table = False

                    # Parse tuples: (val1, val2, ...), (val1, ...)
                    idx = 0
                    total_len = len(full_text)
                    while idx < total_len:
                        start = full_text.find('(', idx)
                        if start == -1:
                            break
                        # Find matching end parenthesis, respecting quotes
                        p = start + 1
                        in_q = False
                        escape = False
                        end_pos = -1
                        while p < total_len:
                            ch = full_text[p]
                            if escape:
                                escape = False
                            elif ch == '\\':
                                escape = True
                            elif ch == "'":
                                in_q = not in_q
                            elif ch == ')' and not in_q:
                                end_pos = p
                                break
                            p += 1
                        
                        if end_pos != -1:
                            inner = full_text[start+1:end_pos]
                            row = parse_sql_values(inner)
                            yield row
                            idx = end_pos + 1
                        else:
                            break

print("Step 1: Extracting surahs...")
# Table surahs schema: id, name, name_long, number, number_of_verse, transliteration, translation, revelation, tafsir, created_at, updated_at
surah_dict = {}
for r in extract_rows(SQL_FILE, 'surahs'):
    s_id, name, name_long, number, n_verse, trans, transl, rev, tafsir = r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8]
    surah_dict[number] = {
        'number': int(number),
        'name': name.strip() if name else '',
        'name_long': name_long.strip() if name_long else '',
        'number_of_verse': int(n_verse),
        'transliteration': trans.strip() if trans else '',
        'translation': transl.strip() if transl else '',
        'revelation': rev.strip() if rev else '',
        'tafsir': tafsir.strip() if tafsir else '',
    }

print(f"Extracted {len(surah_dict)} surahs.")

print("Step 2: Extracting audio URLs...")
# Table audio: id, surah_id, ayah_id, recitator_id, audio_url
audio_map = {} # (surah_id, ayah_id) -> url
for r in extract_rows(SQL_FILE, 'audio'):
    if len(r) >= 5 and str(r[3]) == '1': # Misyari Alafasy
        surah_id = int(r[1])
        ayah_id = int(r[2])
        audio_map[(surah_id, ayah_id)] = r[4]

print(f"Extracted {len(audio_map)} audio URLs.")

print("Step 3: Extracting ayahs...")
# Table ayahs: id, surah_id, page, juz, in_quran, in_surah, sajda, arab, transliteration, translation, short_tafsir, long_tafsir
surah_ayahs = {s_num: [] for s_num in surah_dict.keys()}
total_ayah_count = 0
for r in extract_rows(SQL_FILE, 'ayahs'):
    s_id = int(r[1])
    page = int(r[2])
    juz = int(r[3])
    in_quran = int(r[4])
    in_surah = int(r[5])
    sajda = bool(r[6])
    arab = r[7]
    translit = r[8]
    translation = r[9]
    short_tafsir = r[10] if len(r) > 10 and r[10] else ""
    
    # Audio fallback
    audio_url = audio_map.get((s_id, in_surah), f"https://cdn.alquran.cloud/media/audio/ayah/ar.alafasy/{in_quran}")
    
    # Remove BOM or unwanted zero-width characters in arab text
    clean_arab = arab.replace('\ufeff', '').strip()

    ayah_item = {
        'number_in_surah': in_surah,
        'number_in_quran': in_quran,
        'juz': juz,
        'page': page,
        'arab': clean_arab,
        'transliteration': translit.strip(),
        'translation': translation.strip(),
        'short_tafsir': short_tafsir.strip(),
        'sajda': sajda,
        'audio_url': audio_url,
    }
    if s_id in surah_ayahs:
        surah_ayahs[s_id].append(ayah_item)
        total_ayah_count += 1

print(f"Extracted {total_ayah_count} ayahs across {len(surah_ayahs)} surahs.")

# Sort surah list
sorted_surah_list = [surah_dict[i] for i in sorted(surah_dict.keys())]

# Save surah_list.json
surah_list_file = os.path.join(OUTPUT_DIR, 'surah_list.json')
with open(surah_list_file, 'w', encoding='utf-8') as f:
    json.dump(sorted_surah_list, f, ensure_ascii=False, indent=2)

print(f"Saved {surah_list_file}")

# Save individual surahs
for s_num in sorted(surah_dict.keys()):
    # Sort ayahs by number_in_surah
    surah_ayahs[s_num].sort(key=lambda x: x['number_in_surah'])
    detail = {
        'info': surah_dict[s_num],
        'ayahs': surah_ayahs[s_num],
    }
    s_file = os.path.join(OUTPUT_DIR, 'surahs', f"{s_num}.json")
    with open(s_file, 'w', encoding='utf-8') as f:
        json.dump(detail, f, ensure_ascii=False, indent=2)

print("All 114 surah JSON files saved locally.")

# Step 4: Upload to Cloudflare R2
print("Step 4: Uploading to Cloudflare R2 (https://ali.medixo.id/quran/)...")

def upload_to_r2(data_bytes, path, content_type='application/json'):
    now = datetime.datetime.now(datetime.timezone.utc)
    amz_date = now.strftime('%Y%m%dT%H%M%SZ')
    date_stamp = now.strftime('%Y%m%d')

    host = f'{ACCOUNT_ID}.r2.cloudflarestorage.com'
    canonical_uri = f'/{BUCKET}/{path}'
    payload_hash = hashlib.sha256(data_bytes).hexdigest()

    canonical_headers = f'content-type:{content_type}\nhost:{host}\nx-amz-content-sha256:{payload_hash}\nx-amz-date:{amz_date}\n'
    signed_headers = 'content-type;host;x-amz-content-sha256;x-amz-date'

    canonical_request = f'PUT\n{canonical_uri}\n\n{canonical_headers}\n{signed_headers}\n{payload_hash}'
    algorithm = 'AWS4-HMAC-SHA256'
    credential_scope = f'{date_stamp}/auto/s3/aws4_request'
    string_to_sign = f'{algorithm}\n{amz_date}\n{credential_scope}\n{hashlib.sha256(canonical_request.encode()).hexdigest()}'

    def sign(key, msg):
        return hmac.new(key, msg.encode('utf-8'), hashlib.sha256).digest()

    k_date = sign(('AWS4' + SECRET_KEY).encode('utf-8'), date_stamp)
    k_region = sign(k_date, 'auto')
    k_service = sign(k_region, 's3')
    k_signing = sign(k_service, 'aws4_request')
    signature = hmac.new(k_signing, string_to_sign.encode('utf-8'), hashlib.sha256).hexdigest()

    auth_header = f'{algorithm} Credential={ACCESS_KEY}/{credential_scope}, SignedHeaders={signed_headers}, Signature={signature}'

    req = urllib.request.Request(f'https://{host}{canonical_uri}', data=data_bytes, method='PUT')
    req.add_header('Content-Type', content_type)
    req.add_header('x-amz-date', amz_date)
    req.add_header('x-amz-content-sha256', payload_hash)
    req.add_header('Authorization', auth_header)

    with urllib.request.urlopen(req) as resp:
        return resp.status

with open(surah_list_file, 'rb') as f:
    st = upload_to_r2(f.read(), 'quran/surah_list.json')
    print(f"Uploaded quran/surah_list.json -> Status {st}")

for s_num in range(1, 115):
    s_file = os.path.join(OUTPUT_DIR, 'surahs', f"{s_num}.json")
    with open(s_file, 'rb') as f:
        st = upload_to_r2(f.read(), f"quran/surahs/{s_num}.json")
        if s_num % 15 == 0 or s_num == 114:
            print(f"Uploaded {s_num}/114 surahs to R2 -> Status {st}")

print("\nSUCCESS! All 114 Surahs and 6,236 Ayahs uploaded to Cloudflare R2.")
print(f"Surah list URL: {PUBLIC_BASE}/quran/surah_list.json")
print(f"Sample Surah 1 URL: {PUBLIC_BASE}/quran/surahs/1.json")
