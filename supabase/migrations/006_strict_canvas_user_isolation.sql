-- ==============================================================================
-- MIGRASI 006: STRICT CANVAS ART USER ISOLATION
-- Masalah: ali_canvas_art policy lama masih memperbolehkan anon membaca/menulis semua karya,
-- atau query tanpa filter user_id sehingga gambar antar akun bisa terlihat.
-- Fix:
-- 1. Tambah user_id REFERENCES auth.users(id) ON DELETE CASCADE jika belum ada.
-- 2. Set default auth.uid().
-- 3. Hapus semua policy lama (Allow anon read/insert, dll).
-- 4. Pasang RLS ketat: Hanya user pemilik yang bisa SELECT, INSERT, UPDATE, DELETE.
-- ==============================================================================

-- 1. Pastikan kolom user_id ada & default auth.uid()
ALTER TABLE public.ali_canvas_art 
ADD COLUMN IF NOT EXISTS user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE DEFAULT auth.uid();

ALTER TABLE public.ali_canvas_art ALTER COLUMN user_id SET DEFAULT auth.uid();

-- 2. Aktifkan RLS
ALTER TABLE public.ali_canvas_art ENABLE ROW LEVEL SECURITY;

-- 3. Bersihkan policy lama
DROP POLICY IF EXISTS "Allow anon read ali_canvas_art" ON public.ali_canvas_art;
DROP POLICY IF EXISTS "Allow anon insert ali_canvas_art" ON public.ali_canvas_art;
DROP POLICY IF EXISTS "User can select own drawings" ON public.ali_canvas_art;
DROP POLICY IF EXISTS "User can insert own drawings" ON public.ali_canvas_art;
DROP POLICY IF EXISTS "User can update own drawings" ON public.ali_canvas_art;
DROP POLICY IF EXISTS "User can delete own drawings" ON public.ali_canvas_art;

-- 4. Buat policy ketat per-user
CREATE POLICY "User can select own drawings"
  ON public.ali_canvas_art FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "User can insert own drawings"
  ON public.ali_canvas_art FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "User can update own drawings"
  ON public.ali_canvas_art FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "User can delete own drawings"
  ON public.ali_canvas_art FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);
