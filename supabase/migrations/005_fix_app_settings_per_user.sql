-- ==============================================================================
-- MIGRASI 005: FIX APP_SETTINGS PER-USER ISOLATION
-- Masalah: app_settings memakai PK 'key' saja - semua user berbagi setting sama.
-- Fix: ganti menjadi composite unique (user_id, key).
-- ==============================================================================

-- 1. Tambah user_id jika belum ada
ALTER TABLE public.app_settings
  ADD COLUMN IF NOT EXISTS user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE DEFAULT auth.uid();

-- 2. Hapus constraint lama
ALTER TABLE public.app_settings DROP CONSTRAINT IF EXISTS app_settings_pkey;
ALTER TABLE public.app_settings DROP CONSTRAINT IF EXISTS app_settings_key_key;
ALTER TABLE public.app_settings DROP CONSTRAINT IF EXISTS app_settings_user_id_key_key;

-- 3. Tambah composite unique constraint (user_id, key)
ALTER TABLE public.app_settings
  ADD CONSTRAINT app_settings_user_id_key_unique UNIQUE (user_id, key);

-- 4. RLS
ALTER TABLE public.app_settings ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Read own app settings" ON public.app_settings;
CREATE POLICY "Read own app settings"
  ON public.app_settings FOR SELECT TO authenticated
  USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Upsert own app settings" ON public.app_settings;
CREATE POLICY "Upsert own app settings"
  ON public.app_settings FOR ALL TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);
