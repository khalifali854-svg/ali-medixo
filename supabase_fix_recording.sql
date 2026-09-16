-- ==============================================================================
-- FIX SUPABASE AUDIO STORAGE & REKAMAN SUARA ALI APP (1-Click SQL Script)
-- Jalankan skrip ini sekali di Supabase SQL Editor:
-- https://supabase.com/dashboard/project/sagnmquiewnypuplhxhs/sql
-- ==============================================================================

-- 1. PASTIKAN KOLOM AUDIO ADA DI TABEL VOCAB_CARDS
ALTER TABLE public.vocab_cards ADD COLUMN IF NOT EXISTS audio_url TEXT;
ALTER TABLE public.vocab_cards ADD COLUMN IF NOT EXISTS audio_abi_url TEXT;
ALTER TABLE public.vocab_cards ADD COLUMN IF NOT EXISTS audio_umma_url TEXT;
ALTER TABLE public.vocab_cards ADD COLUMN IF NOT EXISTS created_by TEXT DEFAULT 'abi';

-- 2. PASTIKAN KOLOM AUDIO ADA DI TABEL CATALOG_ITEMS
ALTER TABLE public.catalog_items ADD COLUMN IF NOT EXISTS audio_url TEXT;

-- 3. BIKIN STORAGE BUCKET 'audio' DAN 'photos' (PUBLIC)
INSERT INTO storage.buckets (id, name, public)
VALUES 
    ('audio', 'audio', true),
    ('photos', 'photos', true)
ON CONFLICT (id) DO UPDATE SET public = true;

-- 4. BIKIN ATURAN KEAMANAN (RLS POLICIES) AGAR UPLOAD AUDIO KE STORAGE DIIZINKAN
DROP POLICY IF EXISTS "Allow public read audio" ON storage.objects;
CREATE POLICY "Allow public read audio"
ON storage.objects FOR SELECT
TO public
USING (bucket_id IN ('audio', 'photos'));

DROP POLICY IF EXISTS "Allow public upload audio" ON storage.objects;
CREATE POLICY "Allow public upload audio"
ON storage.objects FOR INSERT
TO public
WITH CHECK (bucket_id IN ('audio', 'photos'));

DROP POLICY IF EXISTS "Allow public update audio" ON storage.objects;
CREATE POLICY "Allow public update audio"
ON storage.objects FOR UPDATE
TO public
USING (bucket_id IN ('audio', 'photos'))
WITH CHECK (bucket_id IN ('audio', 'photos'));

-- 5. BIKIN ATURAN KEAMANAN (RLS POLICIES) AGAR SIMPAN & UPDATE KARTU SELALU BERHASIL
ALTER TABLE public.vocab_cards ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow all read vocab_cards" ON public.vocab_cards;
CREATE POLICY "Allow all read vocab_cards" ON public.vocab_cards FOR SELECT USING (true);

DROP POLICY IF EXISTS "Allow all insert vocab_cards" ON public.vocab_cards;
CREATE POLICY "Allow all insert vocab_cards" ON public.vocab_cards FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "Allow all update vocab_cards" ON public.vocab_cards;
CREATE POLICY "Allow all update vocab_cards" ON public.vocab_cards FOR UPDATE USING (true) WITH CHECK (true);

ALTER TABLE public.catalog_items ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow all read catalog_items" ON public.catalog_items;
CREATE POLICY "Allow all read catalog_items" ON public.catalog_items FOR SELECT USING (true);

DROP POLICY IF EXISTS "Allow all update catalog_items" ON public.catalog_items;
CREATE POLICY "Allow all update catalog_items" ON public.catalog_items FOR UPDATE USING (true) WITH CHECK (true);

-- 6. PASTIKAN REALTIME AKTIF UNTUK UPDATE LANGSUNG DI SEMUA DEVICE
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_publication_tables 
        WHERE pubname = 'supabase_realtime' AND schemaname = 'public' AND tablename = 'vocab_cards'
    ) THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.vocab_cards;
    END IF;
    IF NOT EXISTS (
        SELECT 1 FROM pg_publication_tables 
        WHERE pubname = 'supabase_realtime' AND schemaname = 'public' AND tablename = 'catalog_items'
    ) THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.catalog_items;
    END IF;
END $$;

-- 7. TAMBAHKAN KATEGORI HIJAIYAH & ALFABET_ANGKA KE TABEL CATALOG_CATEGORIES
INSERT INTO public.catalog_categories (id, name_id, name_en, icon_name, color_hex, sort_order)
VALUES 
    ('hijaiyah', 'Huruf Hijaiyah', 'Hijaiyah Letters', 'menu_book', '#10B981', 8),
    ('alfabet_angka', 'Huruf & Angka', 'Letters & Numbers', 'spellcheck', '#6366F1', 9)
ON CONFLICT (id) DO UPDATE SET
    name_id = EXCLUDED.name_id,
    name_en = EXCLUDED.name_en,
    icon_name = EXCLUDED.icon_name,
    color_hex = EXCLUDED.color_hex,
    sort_order = EXCLUDED.sort_order;

-- 8. MASUKKAN 30 HURUF HIJAIYAH LENGKAP KE TABEL CATALOG_ITEMS
INSERT INTO public.catalog_items (id, category_id, name, image_url, audio_url, phonics, syllables, emoji, difficulty, is_active)
VALUES
    ('hij_alif', 'hijaiyah', 'ا (Alif)', '', 'assets/audio/hijaiyah/hij_alif.mp3', 'أَلِف', '["Alif"]'::jsonb, 'ا', 1, true),
    ('hij_ba', 'hijaiyah', 'ب (Ba)', '', 'assets/audio/hijaiyah/hij_ba.mp3', 'بَاء', '["Ba"]'::jsonb, 'ب', 1, true),
    ('hij_ta', 'hijaiyah', 'ت (Ta)', '', 'assets/audio/hijaiyah/hij_ta.mp3', 'تَاء', '["Ta"]'::jsonb, 'ت', 1, true),
    ('hij_tsa', 'hijaiyah', 'ث (Tsa)', '', 'assets/audio/hijaiyah/hij_tsa.mp3', 'ثَاء', '["Tsa"]'::jsonb, 'ث', 1, true),
    ('hij_jim', 'hijaiyah', 'ج (Jim)', '', 'assets/audio/hijaiyah/hij_jim.mp3', 'جِيم', '["Jim"]'::jsonb, 'ج', 1, true),
    ('hij_ha', 'hijaiyah', 'ح (Ha)', '', 'assets/audio/hijaiyah/hij_ha.mp3', 'حَاء', '["Ha"]'::jsonb, 'ح', 1, true),
    ('hij_kha', 'hijaiyah', 'خ (Kha)', '', 'assets/audio/hijaiyah/hij_kha.mp3', 'خَاء', '["Kha"]'::jsonb, 'خ', 1, true),
    ('hij_dal', 'hijaiyah', 'د (Dal)', '', 'assets/audio/hijaiyah/hij_dal.mp3', 'دَال', '["Dal"]'::jsonb, 'د', 1, true),
    ('hij_dzal', 'hijaiyah', 'ذ (Dzal)', '', 'assets/audio/hijaiyah/hij_dzal.mp3', 'ذَال', '["Dzal"]'::jsonb, 'ذ', 1, true),
    ('hij_ra', 'hijaiyah', 'ر (Ra)', '', 'assets/audio/hijaiyah/hij_ra.mp3', 'رَاء', '["Ra"]'::jsonb, 'ر', 1, true),
    ('hij_zai', 'hijaiyah', 'ز (Zai)', '', 'assets/audio/hijaiyah/hij_zai.mp3', 'زَاي', '["Zai"]'::jsonb, 'ز', 1, true),
    ('hij_sin', 'hijaiyah', 'س (Sin)', '', 'assets/audio/hijaiyah/hij_sin.mp3', 'سِين', '["Sin"]'::jsonb, 'س', 1, true),
    ('hij_syin', 'hijaiyah', 'ش (Syin)', '', 'assets/audio/hijaiyah/hij_syin.mp3', 'شِين', '["Syin"]'::jsonb, 'ش', 1, true),
    ('hij_shad', 'hijaiyah', 'ص (Shad)', '', 'assets/audio/hijaiyah/hij_shad.mp3', 'صَاد', '["Shad"]'::jsonb, 'ص', 1, true),
    ('hij_dhad', 'hijaiyah', 'ض (Dhad)', '', 'assets/audio/hijaiyah/hij_dhad.mp3', 'ضَاد', '["Dhad"]'::jsonb, 'ض', 1, true),
    ('hij_tha', 'hijaiyah', 'ط (Tha)', '', 'assets/audio/hijaiyah/hij_tha.mp3', 'طَاء', '["Tha"]'::jsonb, 'ط', 1, true),
    ('hij_zha', 'hijaiyah', 'ظ (Zha)', '', 'assets/audio/hijaiyah/hij_zha.mp3', 'ظَاء', '["Zha"]'::jsonb, 'ظ', 1, true),
    ('hij_ain', 'hijaiyah', 'ع (Ain)', '', 'assets/audio/hijaiyah/hij_ain.mp3', 'عَيْن', '["Ain"]'::jsonb, 'ع', 1, true),
    ('hij_ghain', 'hijaiyah', 'غ (Ghain)', '', 'assets/audio/hijaiyah/hij_ghain.mp3', 'غَيْن', '["Ghain"]'::jsonb, 'غ', 1, true),
    ('hij_fa', 'hijaiyah', 'ف (Fa)', '', 'assets/audio/hijaiyah/hij_fa.mp3', 'فَاء', '["Fa"]'::jsonb, 'ف', 1, true),
    ('hij_qaf', 'hijaiyah', 'ق (Qaf)', '', 'assets/audio/hijaiyah/hij_qaf.mp3', 'قَاف', '["Qaf"]'::jsonb, 'ق', 1, true),
    ('hij_kaf', 'hijaiyah', 'ك (Kaf)', '', 'assets/audio/hijaiyah/hij_kaf.mp3', 'كَاف', '["Kaf"]'::jsonb, 'ك', 1, true),
    ('hij_lam', 'hijaiyah', 'ل (Lam)', '', 'assets/audio/hijaiyah/hij_lam.mp3', 'لَام', '["Lam"]'::jsonb, 'ل', 1, true),
    ('hij_mim', 'hijaiyah', 'م (Mim)', '', 'assets/audio/hijaiyah/hij_mim.mp3', 'مِيم', '["Mim"]'::jsonb, 'م', 1, true),
    ('hij_nun', 'hijaiyah', 'ن (Nun)', '', 'assets/audio/hijaiyah/hij_nun.mp3', 'نُون', '["Nun"]'::jsonb, 'ن', 1, true),
    ('hij_wawu', 'hijaiyah', 'و (Wawu)', '', 'assets/audio/hijaiyah/hij_wawu.mp3', 'وَاو', '["Wawu"]'::jsonb, 'و', 1, true),
    ('hij_ha_bulat', 'hijaiyah', 'ه (Ha)', '', 'assets/audio/hijaiyah/hij_ha_bulat.mp3', 'هَاء', '["Ha"]'::jsonb, 'ه', 1, true),
    ('hij_lam_alif', 'hijaiyah', 'لا (Lam Alif)', '', 'assets/audio/hijaiyah/hij_lam_alif.m4a', 'لَا', '["Lam Alif"]'::jsonb, 'لا', 1, true),
    ('hij_hamzah', 'hijaiyah', 'ء (Hamzah)', '', 'assets/audio/hijaiyah/hij_hamzah.mp3', 'هَمْزَة', '["Hamzah"]'::jsonb, 'ء', 1, true),
    ('hij_ya', 'hijaiyah', 'ي (Ya)', '', 'assets/audio/hijaiyah/hij_ya.mp3', 'يَاء', '["Ya"]'::jsonb, 'ي', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    audio_url = EXCLUDED.audio_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji;
