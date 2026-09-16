-- ==============================================================================
-- MIGRATION: HURUF HIJAIYAH, ANGKA, DAN ALFABET KE TABEL CATALOG SUPABASE
-- Project Supabase: sagnmquiewnypuplhxhs
-- Jalankan di: https://supabase.com/dashboard/project/sagnmquiewnypuplhxhs/sql
-- ==============================================================================

-- 1. TAMBAHKAN KATEGORI HIJAIYAH & ALFABET_ANGKA KE TABEL CATALOG_CATEGORIES
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

-- 2. PASTIKAN KOLOM AUDIO_URL ADA DI TABEL CATALOG_ITEMS
ALTER TABLE public.catalog_items ADD COLUMN IF NOT EXISTS audio_url TEXT;

-- 3. MASUKKAN 30 HURUF HIJAIYAH KE TABEL CATALOG_ITEMS
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

-- 4. MASUKKAN ANGKA 1-10 KE TABEL CATALOG_ITEMS
INSERT INTO public.catalog_items (id, category_id, name, image_url, audio_url, phonics, syllables, emoji, difficulty, is_active)
VALUES
    ('num_1', 'alfabet_angka', 'Angka 1', '', '', 'Satu', '["Satu"]'::jsonb, '1', 1, true),
    ('num_2', 'alfabet_angka', 'Angka 2', '', '', 'Dua', '["Dua"]'::jsonb, '2', 1, true),
    ('num_3', 'alfabet_angka', 'Angka 3', '', '', 'Tiga', '["Tiga"]'::jsonb, '3', 1, true),
    ('num_4', 'alfabet_angka', 'Angka 4', '', '', 'Empat', '["Empat"]'::jsonb, '4', 1, true),
    ('num_5', 'alfabet_angka', 'Angka 5', '', '', 'Lima', '["Lima"]'::jsonb, '5', 1, true),
    ('num_6', 'alfabet_angka', 'Angka 6', '', '', 'Enam', '["Enam"]'::jsonb, '6', 1, true),
    ('num_7', 'alfabet_angka', 'Angka 7', '', '', 'Tujuh', '["Tujuh"]'::jsonb, '7', 1, true),
    ('num_8', 'alfabet_angka', 'Angka 8', '', '', 'Delapan', '["Delapan"]'::jsonb, '8', 1, true),
    ('num_9', 'alfabet_angka', 'Angka 9', '', '', 'Sembilan', '["Sembilan"]'::jsonb, '9', 1, true),
    ('num_10', 'alfabet_angka', 'Angka 10', '', '', 'Sepuluh', '["Sepuluh"]'::jsonb, '10', 1, true)
ON CONFLICT (id) DO NOTHING;

-- 5. MASUKKAN HURUF A-Z KE TABEL CATALOG_ITEMS
INSERT INTO public.catalog_items (id, category_id, name, image_url, audio_url, phonics, syllables, emoji, difficulty, is_active)
VALUES
    ('letter_A', 'alfabet_angka', 'Huruf A', '', '', 'A', '["A"]'::jsonb, 'A', 1, true),
    ('letter_B', 'alfabet_angka', 'Huruf B', '', '', 'B', '["B"]'::jsonb, 'B', 1, true),
    ('letter_C', 'alfabet_angka', 'Huruf C', '', '', 'C', '["C"]'::jsonb, 'C', 1, true),
    ('letter_D', 'alfabet_angka', 'Huruf D', '', '', 'D', '["D"]'::jsonb, 'D', 1, true),
    ('letter_E', 'alfabet_angka', 'Huruf E', '', '', 'E', '["E"]'::jsonb, 'E', 1, true),
    ('letter_F', 'alfabet_angka', 'Huruf F', '', '', 'F', '["F"]'::jsonb, 'F', 1, true),
    ('letter_G', 'alfabet_angka', 'Huruf G', '', '', 'G', '["G"]'::jsonb, 'G', 1, true),
    ('letter_H', 'alfabet_angka', 'Huruf H', '', '', 'H', '["H"]'::jsonb, 'H', 1, true),
    ('letter_I', 'alfabet_angka', 'Huruf I', '', '', 'I', '["I"]'::jsonb, 'I', 1, true),
    ('letter_J', 'alfabet_angka', 'Huruf J', '', '', 'J', '["J"]'::jsonb, 'J', 1, true),
    ('letter_K', 'alfabet_angka', 'Huruf K', '', '', 'K', '["K"]'::jsonb, 'K', 1, true),
    ('letter_L', 'alfabet_angka', 'Huruf L', '', '', 'L', '["L"]'::jsonb, 'L', 1, true),
    ('letter_M', 'alfabet_angka', 'Huruf M', '', '', 'M', '["M"]'::jsonb, 'M', 1, true),
    ('letter_N', 'alfabet_angka', 'Huruf N', '', '', 'N', '["N"]'::jsonb, 'N', 1, true),
    ('letter_O', 'alfabet_angka', 'Huruf O', '', '', 'O', '["O"]'::jsonb, 'O', 1, true),
    ('letter_P', 'alfabet_angka', 'Huruf P', '', '', 'P', '["P"]'::jsonb, 'P', 1, true),
    ('letter_Q', 'alfabet_angka', 'Huruf Q', '', '', 'Q', '["Q"]'::jsonb, 'Q', 1, true),
    ('letter_R', 'alfabet_angka', 'Huruf R', '', '', 'R', '["R"]'::jsonb, 'R', 1, true),
    ('letter_S', 'alfabet_angka', 'Huruf S', '', '', 'S', '["S"]'::jsonb, 'S', 1, true),
    ('letter_T', 'alfabet_angka', 'Huruf T', '', '', 'T', '["T"]'::jsonb, 'T', 1, true),
    ('letter_U', 'alfabet_angka', 'Huruf U', '', '', 'U', '["U"]'::jsonb, 'U', 1, true),
    ('letter_V', 'alfabet_angka', 'Huruf V', '', '', 'V', '["V"]'::jsonb, 'V', 1, true),
    ('letter_W', 'alfabet_angka', 'Huruf W', '', '', 'W', '["W"]'::jsonb, 'W', 1, true),
    ('letter_X', 'alfabet_angka', 'Huruf X', '', '', 'X', '["X"]'::jsonb, 'X', 1, true),
    ('letter_Y', 'alfabet_angka', 'Huruf Y', '', '', 'Y', '["Y"]'::jsonb, 'Y', 1, true),
    ('letter_Z', 'alfabet_angka', 'Huruf Z', '', '', 'Z', '["Z"]'::jsonb, 'Z', 1, true)
ON CONFLICT (id) DO NOTHING;
