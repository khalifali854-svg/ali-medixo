-- ==============================================================================
-- SKEMA DATABASE APLIKASI AAC "ALI" (Supabase PostgreSQL - Idempotent Migration)
-- ==============================================================================

-- 1. Enable UUID Extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. Tabel Kategori Kosa Kata
CREATE TABLE IF NOT EXISTS public.categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL UNIQUE,
    icon_name TEXT DEFAULT 'grid_1',
    sort_order INT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3. Tabel Kartu Kosa Kata (Vocab Cards)
CREATE TABLE IF NOT EXISTS public.vocab_cards (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category_id UUID REFERENCES public.categories(id) ON DELETE CASCADE,
    label TEXT NOT NULL,
    image_url TEXT NOT NULL,
    audio_url TEXT,            -- Fallback
    audio_abi_url TEXT,        -- Suara Asli Abi
    audio_umma_url TEXT,       -- Suara Asli Umma
    is_favorite BOOLEAN DEFAULT false,
    created_by TEXT DEFAULT 'abi', -- 'abi', 'umma', 'ali'
    sort_order INT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Pastikan kolom baru ada jika tabel sudah pernah dibuat sebelumnya
DO $$ 
BEGIN 
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='vocab_cards' AND column_name='audio_abi_url') THEN
        ALTER TABLE public.vocab_cards ADD COLUMN audio_abi_url TEXT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='vocab_cards' AND column_name='audio_umma_url') THEN
        ALTER TABLE public.vocab_cards ADD COLUMN audio_umma_url TEXT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='vocab_cards' AND column_name='user_id') THEN
        ALTER TABLE public.vocab_cards ADD COLUMN user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='vocab_cards' AND column_name='is_system') THEN
        ALTER TABLE public.vocab_cards ADD COLUMN is_system BOOLEAN DEFAULT false;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='vocab_cards' AND column_name='original_card_id') THEN
        ALTER TABLE public.vocab_cards ADD COLUMN original_card_id UUID REFERENCES public.vocab_cards(id) ON DELETE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='vocab_cards' AND column_name='is_deleted') THEN
        ALTER TABLE public.vocab_cards ADD COLUMN is_deleted BOOLEAN DEFAULT false;
    END IF;
END $$;

-- 4. Tabel Karya Kanvas Ali (Dual-Canvas Art)
CREATE TABLE IF NOT EXISTS public.ali_canvas_art (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    vocab_id UUID REFERENCES public.vocab_cards(id) ON DELETE SET NULL,
    label TEXT NOT NULL,
    image_url TEXT,
    stroke_data JSONB,
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 5. Tabel Log Penggunaan & Analisis Kebutuhan Ali (Usage Logs)
CREATE TABLE IF NOT EXISTS public.usage_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    card_id UUID REFERENCES public.vocab_cards(id) ON DELETE CASCADE,
    pressed_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- ==============================================================================
-- ROW LEVEL SECURITY (RLS) - Drop Old Policies First to Prevent Conflict
-- ==============================================================================
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.vocab_cards ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ali_canvas_art ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.usage_logs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow anon read categories" ON public.categories;
DROP POLICY IF EXISTS "Allow anon insert/update categories" ON public.categories;
CREATE POLICY "Allow anon read categories" ON public.categories FOR SELECT USING (true);
CREATE POLICY "Allow anon insert/update categories" ON public.categories FOR ALL USING (true);

DROP POLICY IF EXISTS "Allow anon read vocab_cards" ON public.vocab_cards;
DROP POLICY IF EXISTS "Allow anon insert/update vocab_cards" ON public.vocab_cards;
CREATE POLICY "Allow anon read vocab_cards" ON public.vocab_cards FOR SELECT USING (true);
CREATE POLICY "Allow anon insert/update vocab_cards" ON public.vocab_cards FOR ALL USING (true);

DROP POLICY IF EXISTS "Allow anon read ali_canvas_art" ON public.ali_canvas_art;
DROP POLICY IF EXISTS "Allow anon insert ali_canvas_art" ON public.ali_canvas_art;
CREATE POLICY "Allow anon read ali_canvas_art" ON public.ali_canvas_art FOR SELECT USING (true);
CREATE POLICY "Allow anon insert ali_canvas_art" ON public.ali_canvas_art FOR ALL USING (true);

DROP POLICY IF EXISTS "Allow anon read usage_logs" ON public.usage_logs;
DROP POLICY IF EXISTS "Allow anon insert usage_logs" ON public.usage_logs;
CREATE POLICY "Allow anon read usage_logs" ON public.usage_logs FOR SELECT USING (true);
CREATE POLICY "Allow anon insert usage_logs" ON public.usage_logs FOR ALL USING (true);

-- ==============================================================================
-- ENABLE SUPABASE REALTIME (Safe Publication Check)
-- ==============================================================================
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
        WHERE pubname = 'supabase_realtime' AND schemaname = 'public' AND tablename = 'categories'
    ) THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.categories;
    END IF;
END $$;

-- ==============================================================================
-- INITIAL SEED DATA (Lingkar Inti Kosa Kata Ali)
-- ==============================================================================
INSERT INTO public.categories (id, name, icon_name, sort_order) VALUES
('a0000001-0000-0000-0000-000000000001', 'Keluarga', 'people', 1),
('a0000001-0000-0000-0000-000000000002', 'Aktivitas', 'activity', 2),
('a0000001-0000-0000-0000-000000000003', 'Hewan', 'pet', 3),
('a0000001-0000-0000-0000-000000000004', 'Ekspresi', 'heart', 4),
('a0000001-0000-0000-0000-000000000005', 'Bantuan', 'hand', 5)
ON CONFLICT (name) DO NOTHING;

INSERT INTO public.vocab_cards (id, category_id, label, image_url, audio_url, created_by, sort_order, is_system) VALUES
('b0000001-0000-0000-0000-000000000001', 'a0000001-0000-0000-0000-000000000002', 'Main', 'https://ali.medixo.id/default_aac/main.jpg', NULL, 'system', 1, true),
('b0000001-0000-0000-0000-000000000002', 'a0000001-0000-0000-0000-000000000002', 'Mandi', 'https://ali.medixo.id/default_aac/mandi.jpg', NULL, 'system', 2, true),
('b0000001-0000-0000-0000-000000000003', 'a0000001-0000-0000-0000-000000000002', 'Tidur', 'https://ali.medixo.id/default_aac/tidur.jpg', NULL, 'system', 3, true),
('b0000001-0000-0000-0000-000000000004', 'a0000001-0000-0000-0000-000000000002', 'Belajar', 'https://ali.medixo.id/default_aac/belajar.jpg', NULL, 'system', 4, true),
('b0000001-0000-0000-0000-000000000005', 'a0000001-0000-0000-0000-000000000002', 'Jalan-jalan', 'https://ali.medixo.id/default_aac/jalan_jalan.jpg', NULL, 'system', 5, true),
('b0000001-0000-0000-0000-000000000006', 'a0000001-0000-0000-0000-000000000005', 'Tolong', 'https://ali.medixo.id/default_aac/tolong.jpg', NULL, 'system', 6, true),
('b0000001-0000-0000-0000-000000000007', 'a0000001-0000-0000-0000-000000000005', 'Buka', 'https://ali.medixo.id/catalog/aksi_aac/buka.jpg', NULL, 'system', 7, true),
('b0000001-0000-0000-0000-000000000008', 'a0000001-0000-0000-0000-000000000005', 'Selesai', 'https://ali.medixo.id/catalog/aksi_aac/terima_kasih.jpg', NULL, 'system', 8, true),
('b0000001-0000-0000-0000-000000000009', 'a0000001-0000-0000-0000-000000000004', 'Senang', 'https://ali.medixo.id/catalog/aksi_aac/senang.jpg', NULL, 'system', 9, true),
('b0000001-0000-0000-0000-000000000010', 'a0000001-0000-0000-0000-000000000004', 'Takut', 'https://ali.medixo.id/catalog/aksi_aac/takut.jpg', NULL, 'system', 10, true)
ON CONFLICT (id) DO NOTHING;

-- ==============================================================================
-- 6. Tabel Konten Belajar Menulis (Level 1 - 5)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS public.writing_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    level_type INT NOT NULL, -- 1: Angka, 2: Huruf Besar, 3: Huruf Kecil, 4: Kata Pendek, 5: Kosa Kata AAC
    target_text TEXT NOT NULL,
    hint_label TEXT,          -- Contoh: "Apel" untuk A, atau nama objek
    image_url TEXT,           -- Gambar pendukung (opsional)
    audio_url TEXT,           -- Audio pelafalan kata/huruf (opsional)
    is_custom BOOLEAN DEFAULT false,
    created_by TEXT DEFAULT 'abi',
    sort_order INT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.writing_items ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon read writing_items" ON public.writing_items;
DROP POLICY IF EXISTS "Allow anon insert/update writing_items" ON public.writing_items;
DROP POLICY IF EXISTS "Allow anon delete writing_items" ON public.writing_items;
CREATE POLICY "Allow anon read writing_items" ON public.writing_items FOR SELECT USING (true);
CREATE POLICY "Allow anon insert/update writing_items" ON public.writing_items FOR ALL USING (true);
CREATE POLICY "Allow anon delete writing_items" ON public.writing_items FOR DELETE USING (true);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_publication_tables 
        WHERE pubname = 'supabase_realtime' AND schemaname = 'public' AND tablename = 'writing_items'
    ) THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.writing_items;
    END IF;
END $$;

-- SEED DATA UNTUK LEVEL 4 (Kata Pendek) & LEVEL 5 (Kosa Kata AAC)
INSERT INTO public.writing_items (id, level_type, target_text, hint_label, sort_order, is_custom) VALUES
('c0000001-0000-0000-0000-000000000001', 4, 'ABI', 'Abi Tersayang', 1, false),
('c0000001-0000-0000-0000-000000000002', 4, 'IBU', 'Ibu Tercinta', 2, false),
('c0000001-0000-0000-0000-000000000003', 4, 'ALI', 'Namaku Ali', 3, false),
('c0000001-0000-0000-0000-000000000004', 4, 'TAS', 'Tas Sekolah', 4, false),
('c0000001-0000-0000-0000-000000000005', 4, 'AIR', 'Air Minum', 5, false),
('c0000001-0000-0000-0000-000000000006', 5, 'MAKAN', 'Waktunya Makan', 1, false),
('c0000001-0000-0000-0000-000000000007', 5, 'MINUM', 'Minum Air / Susu', 2, false),
('c0000001-0000-0000-0000-000000000008', 5, 'BOLA', 'Main Bola', 3, false),
('c0000001-0000-0000-0000-000000000009', 5, 'TIDUR', 'Tidur Nyenyak', 4, false),
('c0000001-0000-0000-0000-000000000010', 5, 'BUKU', 'Membaca Buku', 5, false)
-- ==============================================================================
-- 7. Tabel Pengaturan Aplikasi (App Settings - Global & Multi-Device Sync)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS public.app_settings (
    key TEXT PRIMARY KEY,
    value JSONB NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.app_settings ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon read app_settings" ON public.app_settings;
DROP POLICY IF EXISTS "Allow anon insert/update app_settings" ON public.app_settings;
CREATE POLICY "Allow anon read app_settings" ON public.app_settings FOR SELECT USING (true);
CREATE POLICY "Allow anon insert/update app_settings" ON public.app_settings FOR ALL USING (true);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_publication_tables 
        WHERE pubname = 'supabase_realtime' AND schemaname = 'public' AND tablename = 'app_settings'
    ) THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.app_settings;
    END IF;
END $$;

-- Default Settings: Bahasa Suara Indonesia (id-ID)
INSERT INTO public.app_settings (key, value) VALUES
('voice_language', '"id-ID"'),
('voice_bot', 'null')
ON CONFLICT (key) DO NOTHING;

