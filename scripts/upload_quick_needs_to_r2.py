#!/usr/bin/env python3
import os
import datetime
import hashlib
import hmac
import urllib.request

ACCOUNT_ID = 'f7e27ce0b4c2e9e41ad1dfcbb89bc5b3'
BUCKET = 'ali-app'
ACCESS_KEY = 'f5312c9a802d364507bae5ad7872cf7c'
SECRET_KEY = '9ddd94fe9a0c875abfaf3d2074284a4320803b90904f9612ab320d57adde5491'
PUBLIC_BASE = 'https://ali.medixo.id'

IMAGES_DIR = '/Users/gemmyadyendra/Projects/Ali/assets/images/quick_needs'

def upload_to_r2(data_bytes, path, content_type='image/jpeg'):
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

files = ['toilet.jpg', 'drink.jpg', 'eat.jpg', 'sick.jpg', 'hug.jpg']
for filename in files:
    filepath = os.path.join(IMAGES_DIR, filename)
    if os.path.exists(filepath):
        with open(filepath, 'rb') as f:
            data = f.read()
        target_path = f'quick_needs/{filename}'
        status = upload_to_r2(data, target_path, 'image/jpeg')
        print(f"Uploaded {filename} -> {PUBLIC_BASE}/{target_path} (Status {status})")
    else:
        print(f"File not found: {filepath}")
