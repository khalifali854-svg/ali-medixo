-- ==============================================================================
-- MIGRASI 003: Multi-Tenant Per-Akun & Copy-on-Write (CoW) Kartu AAC Ali
-- Project Supabase: sagnmquiewnypuplhxhs (Aplikasi Ali)
-- ==============================================================================

-- 1. Tambahkan kolom original_card_id dan is_deleted ke vocab_cards jika belum ada
ALTER TABLE public.vocab_cards 
ADD COLUMN IF NOT EXISTS original_card_id UUID REFERENCES public.vocab_cards(id) ON DELETE CASCADE;

ALTER TABLE public.vocab_cards 
ADD COLUMN IF NOT EXISTS is_deleted BOOLEAN DEFAULT false;

-- 2. Pastikan kolom is_system dan user_id ada
ALTER TABLE public.vocab_cards 
ADD COLUMN IF NOT EXISTS is_system BOOLEAN DEFAULT false;

ALTER TABLE public.vocab_cards 
ADD COLUMN IF NOT EXISTS user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE;

-- 3. Setel seluruh kartu bawaan sistem awal agar is_system = true dan original_card_id = NULL
UPDATE public.vocab_cards 
SET is_system = true, original_card_id = NULL 
WHERE id IN (
  '1bb6aa3e-1b07-4b49-b140-73034210c469',
  '817321b0-4dc9-4ce4-8bd6-e61fc727d898',
  'fcc4b07d-aad0-4fc2-86f4-07e5b29e9306',
  '6136626b-f725-432d-b834-ba653fd3921c',
  '2d81615b-c92b-48d0-a9d5-e532d9444160',
  'bb2b7026-eb8a-4462-91ef-d6b95f77f974',
  'ed911f58-2e69-4061-bafe-db7774a81b41',
  'b8b689a5-efab-4287-8365-6fccb409147a',
  '3873bb9f-5cfb-4783-97b1-76c30d951135',
  '5ee5b48b-fb6b-40b7-87dd-92acf1f9d78a',
  '83249733-7f7b-49d2-8711-c67e48b3c267',
  'b17bc491-a3b1-4c0a-9846-772cb9249541',
  'a952d00a-ff05-460e-ada9-8056ee50317c',
  'b0000001-0000-0000-0000-000000000001',
  'b0000001-0000-0000-0000-000000000002',
  'b0000001-0000-0000-0000-000000000003',
  'b0000001-0000-0000-0000-000000000004',
  'b0000001-0000-0000-0000-000000000005',
  'b0000001-0000-0000-0000-000000000006',
  'b0000001-0000-0000-0000-000000000008',
  'b0000001-0000-0000-0000-000000000009',
  'b0000001-0000-0000-0000-000000000010'
);

-- Buat indeks untuk percepatan kueri per-user dan per-original_card_id
CREATE INDEX IF NOT EXISTS idx_vocab_cards_user_id ON public.vocab_cards(user_id);
CREATE INDEX IF NOT EXISTS idx_vocab_cards_original_card_id ON public.vocab_cards(original_card_id);
CREATE INDEX IF NOT EXISTS idx_vocab_cards_is_system ON public.vocab_cards(is_system);

-- 4. Konfigurasi Row Level Security (RLS)
ALTER TABLE public.vocab_cards ENABLE ROW LEVEL SECURITY;

-- SELECT: Siapapun (termasuk anon) bisa membaca kartu sistem default,
-- dan pengguna yang login bisa membaca kartu kustom miliknya sendiri
DROP POLICY IF EXISTS "Read system cards or user own cards" ON public.vocab_cards;
CREATE POLICY "Read system cards or user own cards"
  ON public.vocab_cards FOR SELECT
  TO public
  USING (is_system = true OR user_id IS NULL OR auth.uid() = user_id);

-- INSERT: Hanya bisa menambahkan kartu dengan user_id miliknya sendiri
DROP POLICY IF EXISTS "Insert own cards" ON public.vocab_cards;
CREATE POLICY "Insert own cards"
  ON public.vocab_cards FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- UPDATE: Hanya bisa memperbarui kartu miliknya sendiri
DROP POLICY IF EXISTS "Update own cards" ON public.vocab_cards;
CREATE POLICY "Update own cards"
  ON public.vocab_cards FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- DELETE: Hanya bisa menghapus kartu miliknya sendiri
DROP POLICY IF EXISTS "Delete own cards" ON public.vocab_cards;
CREATE POLICY "Delete own cards"
  ON public.vocab_cards FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);
