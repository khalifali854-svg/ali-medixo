-- ==============================================================================
-- OFFICIAL CATALOG SCHEMA & DATA MIGRATION (Restored from bundled JSON)
-- Total Categories: 7
-- Total Items: 265
-- ==============================================================================

CREATE TABLE IF NOT EXISTS public.catalog_categories (
    id TEXT PRIMARY KEY,
    name_id TEXT NOT NULL,
    name_en TEXT,
    icon_name TEXT,
    color_hex TEXT,
    sort_order INT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.catalog_items (
    id TEXT PRIMARY KEY,
    category_id TEXT NOT NULL REFERENCES public.catalog_categories(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    image_url TEXT NOT NULL,
    phonics TEXT,
    syllables JSONB DEFAULT '[]'::jsonb,
    emoji TEXT,
    difficulty INT DEFAULT 1,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_catalog_items_category ON public.catalog_items(category_id);
CREATE INDEX IF NOT EXISTS idx_catalog_items_name ON public.catalog_items(name);

ALTER TABLE public.catalog_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.catalog_items ENABLE ROW LEVEL SECURITY;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies WHERE tablename = 'catalog_categories' AND policyname = 'Allow public read catalog_categories'
    ) THEN
        CREATE POLICY "Allow public read catalog_categories" ON public.catalog_categories FOR SELECT USING (true);
    END IF;
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies WHERE tablename = 'catalog_items' AND policyname = 'Allow public read catalog_items'
    ) THEN
        CREATE POLICY "Allow public read catalog_items" ON public.catalog_items FOR SELECT USING (true);
    END IF;
END $$;

ALTER PUBLICATION supabase_realtime ADD TABLE public.catalog_categories;
ALTER PUBLICATION supabase_realtime ADD TABLE public.catalog_items;

-- Categories
INSERT INTO public.catalog_categories (id, name_id, name_en, icon_name, color_hex, sort_order)
VALUES ('hewan', 'Hewan', 'Animals', 'pets', '#FF7043', 1)
ON CONFLICT (id) DO UPDATE SET
    name_id = EXCLUDED.name_id,
    name_en = EXCLUDED.name_en,
    icon_name = EXCLUDED.icon_name,
    color_hex = EXCLUDED.color_hex,
    sort_order = EXCLUDED.sort_order;

INSERT INTO public.catalog_categories (id, name_id, name_en, icon_name, color_hex, sort_order)
VALUES ('buah_makanan', 'Buah & Makanan', 'Fruits & Food', 'restaurant', '#FFA726', 2)
ON CONFLICT (id) DO UPDATE SET
    name_id = EXCLUDED.name_id,
    name_en = EXCLUDED.name_en,
    icon_name = EXCLUDED.icon_name,
    color_hex = EXCLUDED.color_hex,
    sort_order = EXCLUDED.sort_order;

INSERT INTO public.catalog_categories (id, name_id, name_en, icon_name, color_hex, sort_order)
VALUES ('benda', 'Benda Sekitar', 'Everyday Objects', 'category', '#29B6F6', 3)
ON CONFLICT (id) DO UPDATE SET
    name_id = EXCLUDED.name_id,
    name_en = EXCLUDED.name_en,
    icon_name = EXCLUDED.icon_name,
    color_hex = EXCLUDED.color_hex,
    sort_order = EXCLUDED.sort_order;

INSERT INTO public.catalog_categories (id, name_id, name_en, icon_name, color_hex, sort_order)
VALUES ('aksi_aac', 'Aksi & Kebutuhan', 'Actions & Needs', 'touch_app', '#AB47BC', 4)
ON CONFLICT (id) DO UPDATE SET
    name_id = EXCLUDED.name_id,
    name_en = EXCLUDED.name_en,
    icon_name = EXCLUDED.icon_name,
    color_hex = EXCLUDED.color_hex,
    sort_order = EXCLUDED.sort_order;

INSERT INTO public.catalog_categories (id, name_id, name_en, icon_name, color_hex, sort_order)
VALUES ('kendaraan', 'Kendaraan', 'Vehicles', 'directions_car', '#26A69A', 5)
ON CONFLICT (id) DO UPDATE SET
    name_id = EXCLUDED.name_id,
    name_en = EXCLUDED.name_en,
    icon_name = EXCLUDED.icon_name,
    color_hex = EXCLUDED.color_hex,
    sort_order = EXCLUDED.sort_order;

INSERT INTO public.catalog_categories (id, name_id, name_en, icon_name, color_hex, sort_order)
VALUES ('tubuh', 'Bagian Tubuh', 'Body Parts', 'face', '#EC407A', 6)
ON CONFLICT (id) DO UPDATE SET
    name_id = EXCLUDED.name_id,
    name_en = EXCLUDED.name_en,
    icon_name = EXCLUDED.icon_name,
    color_hex = EXCLUDED.color_hex,
    sort_order = EXCLUDED.sort_order;

INSERT INTO public.catalog_categories (id, name_id, name_en, icon_name, color_hex, sort_order)
VALUES ('alam', 'Alam & Warna', 'Nature & Colors', 'nature', '#66BB6A', 7)
ON CONFLICT (id) DO UPDATE SET
    name_id = EXCLUDED.name_id,
    name_en = EXCLUDED.name_en,
    icon_name = EXCLUDED.icon_name,
    color_hex = EXCLUDED.color_hex,
    sort_order = EXCLUDED.sort_order;


-- Items
INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('kucing', 'hewan', 'Kucing', 'https://ali.medixo.id/catalog/hewan/kucing.jpg', 'ku-cing', '["ku","cing"]'::jsonb, '🐱', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('anjing', 'hewan', 'Anjing', 'https://ali.medixo.id/catalog/hewan/anjing.jpg', 'an-jing', '["an","jing"]'::jsonb, '🐶', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('ayam', 'hewan', 'Ayam', 'https://ali.medixo.id/catalog/hewan/ayam.jpg', 'a-yam', '["a","yam"]'::jsonb, '🐔', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('sapi', 'hewan', 'Sapi', 'https://ali.medixo.id/catalog/hewan/sapi.jpg', 'sa-pi', '["sa","pi"]'::jsonb, '🐮', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('kambing', 'hewan', 'Kambing', 'https://ali.medixo.id/catalog/hewan/kambing.jpg', 'kam-bing', '["kam","bing"]'::jsonb, '🐐', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('bebek', 'hewan', 'Bebek', 'https://ali.medixo.id/catalog/hewan/bebek.jpg', 'be-bek', '["be","bek"]'::jsonb, '🦆', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('kelinci', 'hewan', 'Kelinci', 'https://ali.medixo.id/catalog/hewan/kelinci.jpg', 'ke-lin-ci', '["ke","lin","ci"]'::jsonb, '🐰', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('burung', 'hewan', 'Burung', 'https://ali.medixo.id/catalog/hewan/burung.jpg', 'bu-rung', '["bu","rung"]'::jsonb, '🐦', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('ikan', 'hewan', 'Ikan', 'https://ali.medixo.id/catalog/hewan/ikan.jpg', 'i-kan', '["i","kan"]'::jsonb, '🐟', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('gajah', 'hewan', 'Gajah', 'https://ali.medixo.id/catalog/hewan/gajah.jpg', 'ga-jah', '["ga","jah"]'::jsonb, '🐘', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('singa', 'hewan', 'Singa', 'https://ali.medixo.id/catalog/hewan/singa.jpg', 'si-nga', '["si","nga"]'::jsonb, '🦁', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('harimau', 'hewan', 'Harimau', 'https://ali.medixo.id/catalog/hewan/harimau.jpg', 'ha-ri-mau', '["ha","ri","mau"]'::jsonb, '🐯', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('jerapah', 'hewan', 'Jerapah', 'https://ali.medixo.id/catalog/hewan/jerapah.jpg', 'je-ra-pah', '["je","ra","pah"]'::jsonb, '🦒', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('monyet', 'hewan', 'Monyet', 'https://ali.medixo.id/catalog/hewan/monyet.jpg', 'mo-nyet', '["mo","nyet"]'::jsonb, '🐵', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('kuda', 'hewan', 'Kuda', 'https://ali.medixo.id/catalog/hewan/kuda.jpg', 'ku-da', '["ku","da"]'::jsonb, '🐴', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('domba', 'hewan', 'Domba', 'https://ali.medixo.id/catalog/hewan/domba.jpg', 'dom-ba', '["dom","ba"]'::jsonb, '🐑', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('babi', 'hewan', 'Babi', 'https://ali.medixo.id/catalog/hewan/babi.jpg', 'ba-bi', '["ba","bi"]'::jsonb, '🐷', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('beruang', 'hewan', 'Beruang', 'https://ali.medixo.id/catalog/hewan/beruang.jpg', 'be-ru-ang', '["be","ru","ang"]'::jsonb, '🐻', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('panda', 'hewan', 'Panda', 'https://ali.medixo.id/catalog/hewan/panda.jpg', 'pan-da', '["pan","da"]'::jsonb, '🐼', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('serigala', 'hewan', 'Serigala', 'https://ali.medixo.id/catalog/hewan/serigala.jpg', 'se-ri-ga-la', '["se","ri","ga","la"]'::jsonb, '🐺', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('rubah', 'hewan', 'Rubah', 'https://ali.medixo.id/catalog/hewan/rubah.jpg', 'ru-bah', '["ru","bah"]'::jsonb, '🦊', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('zebra', 'hewan', 'Zebra', 'https://ali.medixo.id/catalog/hewan/zebra.jpg', 'ze-bra', '["ze","bra"]'::jsonb, '🦓', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('badak', 'hewan', 'Badak', 'https://ali.medixo.id/catalog/hewan/badak.jpg', 'ba-dak', '["ba","dak"]'::jsonb, '🦏', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('kudanil', 'hewan', 'Kudanil', 'https://ali.medixo.id/catalog/hewan/kudanil.jpg', 'ku-da-nil', '["ku","da","nil"]'::jsonb, '🦛', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('kura_kura', 'hewan', 'Kura-kura', 'https://ali.medixo.id/catalog/hewan/kura_kura.jpg', 'ku-ra ku-ra', '["ku","ra","ku","ra"]'::jsonb, '🐢', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('buaya', 'hewan', 'Buaya', 'https://ali.medixo.id/catalog/hewan/buaya.jpg', 'bu-a-ya', '["bu","a","ya"]'::jsonb, '🐊', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('ular', 'hewan', 'Ular', 'https://ali.medixo.id/catalog/hewan/ular.jpg', 'u-lar', '["u","lar"]'::jsonb, '🐍', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('kodok', 'hewan', 'Kodok', 'https://ali.medixo.id/catalog/hewan/kodok.jpg', 'ko-dok', '["ko","dok"]'::jsonb, '🐸', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('paus', 'hewan', 'Paus', 'https://ali.medixo.id/catalog/hewan/paus.jpg', 'pa-us', '["pa","us"]'::jsonb, '🐳', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('lumba_lumba', 'hewan', 'Lumba-lumba', 'https://ali.medixo.id/catalog/hewan/lumba_lumba.jpg', 'lum-ba lum-ba', '["lum","ba","lum","ba"]'::jsonb, '🐬', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('hiu', 'hewan', 'Hiu', 'https://ali.medixo.id/catalog/hewan/hiu.jpg', 'hi-u', '["hi","u"]'::jsonb, '🦈', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('kepiting', 'hewan', 'Kepiting', 'https://ali.medixo.id/catalog/hewan/kepiting.jpg', 'ke-pi-ting', '["ke","pi","ting"]'::jsonb, '🦀', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('udang', 'hewan', 'Udang', 'https://ali.medixo.id/catalog/hewan/udang.jpg', 'u-dang', '["u","dang"]'::jsonb, '🦐', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('cumi_cumi', 'hewan', 'Cumi-cumi', 'https://ali.medixo.id/catalog/hewan/cumi_cumi.jpg', 'cu-mi cu-mi', '["cu","mi","cu","mi"]'::jsonb, '🦑', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('gurita', 'hewan', 'Gurita', 'https://ali.medixo.id/catalog/hewan/gurita.jpg', 'gu-ri-ta', '["gu","ri","ta"]'::jsonb, '🐙', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('kupu_kupu', 'hewan', 'Kupu-kupu', 'https://ali.medixo.id/catalog/hewan/kupu_kupu.jpg', 'ku-pu ku-pu', '["ku","pu","ku","pu"]'::jsonb, '🦋', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('lebah', 'hewan', 'Lebah', 'https://ali.medixo.id/catalog/hewan/lebah.jpg', 'le-bah', '["le","bah"]'::jsonb, '🐝', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('semut', 'hewan', 'Semut', 'https://ali.medixo.id/catalog/hewan/semut.jpg', 'se-mut', '["se","mut"]'::jsonb, '🐜', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('nyamuk', 'hewan', 'Nyamuk', 'https://ali.medixo.id/catalog/hewan/nyamuk.jpg', 'nya-muk', '["nya","muk"]'::jsonb, '🦟', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('lalat', 'hewan', 'Lalat', 'https://ali.medixo.id/catalog/hewan/lalat.jpg', 'la-lat', '["la","lat"]'::jsonb, '🪰', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('laba_laba', 'hewan', 'Laba-laba', 'https://ali.medixo.id/catalog/hewan/laba_laba.jpg', 'la-ba la-ba', '["la","ba","la","ba"]'::jsonb, '🕷️', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('siput', 'hewan', 'Siput', 'https://ali.medixo.id/catalog/hewan/siput.jpg', 'si-put', '["si","put"]'::jsonb, '🐌', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('burung_hantu', 'hewan', 'Burung Hantu', 'https://ali.medixo.id/catalog/hewan/burung_hantu.jpg', 'bu-rung han-tu', '["bu","rung","han","tu"]'::jsonb, '🦉', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('elang', 'hewan', 'Elang', 'https://ali.medixo.id/catalog/hewan/elang.jpg', 'e-lang', '["e","lang"]'::jsonb, '🦅', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('pinguin', 'hewan', 'Pinguin', 'https://ali.medixo.id/catalog/hewan/pinguin.jpg', 'ping-u-in', '["ping","u","in"]'::jsonb, '🐧', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('koala', 'hewan', 'Koala', 'https://ali.medixo.id/catalog/hewan/koala.jpg', 'ko-a-la', '["ko","a","la"]'::jsonb, '🐨', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('kanguru', 'hewan', 'Kanguru', 'https://ali.medixo.id/catalog/hewan/kanguru.jpg', 'kang-u-ru', '["kang","u","ru"]'::jsonb, '🦘', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('unta', 'hewan', 'Unta', 'https://ali.medixo.id/catalog/hewan/unta.jpg', 'un-ta', '["un","ta"]'::jsonb, '🐪', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('kelelawar', 'hewan', 'Kelelawar', 'https://ali.medixo.id/catalog/hewan/kelelawar.jpg', 'ke-le-la-war', '["ke","le","la","war"]'::jsonb, '🦇', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('tupai', 'hewan', 'Tupai', 'https://ali.medixo.id/catalog/hewan/tupai.jpg', 'tu-pai', '["tu","pai"]'::jsonb, '🐿️', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('apel', 'buah_makanan', 'Apel', 'https://ali.medixo.id/catalog/buah_makanan/apel.jpg', 'a-pel', '["a","pel"]'::jsonb, '🍎', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('pisang', 'buah_makanan', 'Pisang', 'https://ali.medixo.id/catalog/buah_makanan/pisang.jpg', 'pi-sang', '["pi","sang"]'::jsonb, '🍌', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('jeruk', 'buah_makanan', 'Jeruk', 'https://ali.medixo.id/catalog/buah_makanan/jeruk.jpg', 'je-ruk', '["je","ruk"]'::jsonb, '🍊', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('mangga', 'buah_makanan', 'Mangga', 'https://ali.medixo.id/catalog/buah_makanan/mangga.jpg', 'mang-ga', '["mang","ga"]'::jsonb, '🥭', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('semangka', 'buah_makanan', 'Semangka', 'https://ali.medixo.id/catalog/buah_makanan/semangka.jpg', 'se-mang-ka', '["se","mang","ka"]'::jsonb, '🍉', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('melon', 'buah_makanan', 'Melon', 'https://ali.medixo.id/catalog/buah_makanan/melon.jpg', 'me-lon', '["me","lon"]'::jsonb, '🍈', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('anggur', 'buah_makanan', 'Anggur', 'https://ali.medixo.id/catalog/buah_makanan/anggur.jpg', 'ang-gur', '["ang","gur"]'::jsonb, '🍇', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('stroberi', 'buah_makanan', 'Stroberi', 'https://ali.medixo.id/catalog/buah_makanan/stroberi.jpg', 'stro-be-ri', '["stro","be","ri"]'::jsonb, '🍓', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('nanas', 'buah_makanan', 'Nanas', 'https://ali.medixo.id/catalog/buah_makanan/nanas.jpg', 'na-nas', '["na","nas"]'::jsonb, '🍍', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('pepaya', 'buah_makanan', 'Pepaya', 'https://ali.medixo.id/catalog/buah_makanan/pepaya.jpg', 'pe-pa-ya', '["pe","pa","ya"]'::jsonb, '🍈', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('alpukat', 'buah_makanan', 'Alpukat', 'https://ali.medixo.id/catalog/buah_makanan/alpukat.jpg', 'al-pu-kat', '["al","pu","kat"]'::jsonb, '🥑', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('durian', 'buah_makanan', 'Durian', 'https://ali.medixo.id/catalog/buah_makanan/durian.jpg', 'du-ri-an', '["du","ri","an"]'::jsonb, '🍈', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('kelapa', 'buah_makanan', 'Kelapa', 'https://ali.medixo.id/catalog/buah_makanan/kelapa.jpg', 'ke-la-pa', '["ke","la","pa"]'::jsonb, '🥥', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('lemon', 'buah_makanan', 'Lemon', 'https://ali.medixo.id/catalog/buah_makanan/lemon.jpg', 'le-mon', '["le","mon"]'::jsonb, '🍋', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('pir', 'buah_makanan', 'Pir', 'https://ali.medixo.id/catalog/buah_makanan/pir.jpg', 'pir', '["pir"]'::jsonb, '🍐', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('kiwi', 'buah_makanan', 'Kiwi', 'https://ali.medixo.id/catalog/buah_makanan/kiwi.jpg', 'ki-wi', '["ki","wi"]'::jsonb, '🥝', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('tomat', 'buah_makanan', 'Tomat', 'https://ali.medixo.id/catalog/buah_makanan/tomat.jpg', 'to-mat', '["to","mat"]'::jsonb, '🍅', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('wortel', 'buah_makanan', 'Wortel', 'https://ali.medixo.id/catalog/buah_makanan/wortel.jpg', 'wor-tel', '["wor","tel"]'::jsonb, '🥕', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('brokoli', 'buah_makanan', 'Brokoli', 'https://ali.medixo.id/catalog/buah_makanan/brokoli.jpg', 'bro-ko-li', '["bro","ko","li"]'::jsonb, '🥦', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('jagung', 'buah_makanan', 'Jagung', 'https://ali.medixo.id/catalog/buah_makanan/jagung.jpg', 'ja-gung', '["ja","gung"]'::jsonb, '🌽', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('kentang', 'buah_makanan', 'Kentang', 'https://ali.medixo.id/catalog/buah_makanan/kentang.jpg', 'ken-tang', '["ken","tang"]'::jsonb, '🥔', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('cabai', 'buah_makanan', 'Cabai', 'https://ali.medixo.id/catalog/buah_makanan/cabai.jpg', 'ca-bai', '["ca","bai"]'::jsonb, '🌶️', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('bawang', 'buah_makanan', 'Bawang', 'https://ali.medixo.id/catalog/buah_makanan/bawang.jpg', 'ba-wang', '["ba","wang"]'::jsonb, '🧅', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('bayam', 'buah_makanan', 'Bayam', 'https://ali.medixo.id/catalog/buah_makanan/bayam.jpg', 'ba-yam', '["ba","yam"]'::jsonb, '🥬', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('nasi', 'buah_makanan', 'Nasi', 'https://ali.medixo.id/catalog/buah_makanan/nasi.jpg', 'na-si', '["na","si"]'::jsonb, '🍚', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('roti', 'buah_makanan', 'Roti', 'https://ali.medixo.id/catalog/buah_makanan/roti.jpg', 'ro-ti', '["ro","ti"]'::jsonb, '🍞', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('mie', 'buah_makanan', 'Mie', 'https://ali.medixo.id/catalog/buah_makanan/mie.jpg', 'mie', '["mie"]'::jsonb, '🍜', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('telur', 'buah_makanan', 'Telur', 'https://ali.medixo.id/catalog/buah_makanan/telur.jpg', 'te-lur', '["te","lur"]'::jsonb, '🥚', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('daging', 'buah_makanan', 'Daging', 'https://ali.medixo.id/catalog/buah_makanan/daging.jpg', 'da-ging', '["da","ging"]'::jsonb, '🥩', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('ikan_goreng', 'buah_makanan', 'Ikan Goreng', 'https://ali.medixo.id/catalog/buah_makanan/ikan_goreng.jpg', 'i-kan go-reng', '["i","kan","go","reng"]'::jsonb, '🐟', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('ayam_goreng', 'buah_makanan', 'Ayam Goreng', 'https://ali.medixo.id/catalog/buah_makanan/ayam_goreng.jpg', 'a-yam go-reng', '["a","yam","go","reng"]'::jsonb, '🍗', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('sosis', 'buah_makanan', 'Sosis', 'https://ali.medixo.id/catalog/buah_makanan/sosis.jpg', 'so-sis', '["so","sis"]'::jsonb, '🌭', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('keju', 'buah_makanan', 'Keju', 'https://ali.medixo.id/catalog/buah_makanan/keju.jpg', 'ke-ju', '["ke","ju"]'::jsonb, '🧀', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('susu', 'buah_makanan', 'Susu', 'https://ali.medixo.id/catalog/buah_makanan/susu.jpg', 'su-su', '["su","su"]'::jsonb, '🥛', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('air', 'buah_makanan', 'Air', 'https://ali.medixo.id/catalog/buah_makanan/air.jpg', 'a-ir', '["a","ir"]'::jsonb, '💧', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('jus_jeruk', 'buah_makanan', 'Jus Jeruk', 'https://ali.medixo.id/catalog/buah_makanan/jus_jeruk.jpg', 'jus je-ruk', '["jus","je","ruk"]'::jsonb, '🧃', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('teh', 'buah_makanan', 'Teh', 'https://ali.medixo.id/catalog/buah_makanan/teh.jpg', 'teh', '["teh"]'::jsonb, '🍵', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('kopi', 'buah_makanan', 'Kopi', 'https://ali.medixo.id/catalog/buah_makanan/kopi.jpg', 'ko-pi', '["ko","pi"]'::jsonb, '☕', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('es_krim', 'buah_makanan', 'Es Krim', 'https://ali.medixo.id/catalog/buah_makanan/es_krim.jpg', 'es krim', '["es","krim"]'::jsonb, '🍦', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('kue', 'buah_makanan', 'Kue', 'https://ali.medixo.id/catalog/buah_makanan/kue.jpg', 'ku-e', '["ku","e"]'::jsonb, '🍰', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('biskuit', 'buah_makanan', 'Biskuit', 'https://ali.medixo.id/catalog/buah_makanan/biskuit.jpg', 'bis-ku-it', '["bis","ku","it"]'::jsonb, '🍪', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('cokelat', 'buah_makanan', 'Cokelat', 'https://ali.medixo.id/catalog/buah_makanan/cokelat.jpg', 'co-ke-lat', '["co","ke","lat"]'::jsonb, '🍫', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('madu', 'buah_makanan', 'Madu', 'https://ali.medixo.id/catalog/buah_makanan/madu.jpg', 'ma-du', '["ma","du"]'::jsonb, '🍯', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('selai', 'buah_makanan', 'Selai', 'https://ali.medixo.id/catalog/buah_makanan/selai.jpg', 'se-lai', '["se","lai"]'::jsonb, '🍓', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('pizza', 'buah_makanan', 'Pizza', 'https://ali.medixo.id/catalog/buah_makanan/pizza.jpg', 'piz-za', '["piz","za"]'::jsonb, '🍕', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('burger', 'buah_makanan', 'Burger', 'https://ali.medixo.id/catalog/buah_makanan/burger.jpg', 'bur-ger', '["bur","ger"]'::jsonb, '🍔', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('kentang_goreng', 'buah_makanan', 'Kentang Goreng', 'https://ali.medixo.id/catalog/buah_makanan/kentang_goreng.jpg', 'ken-tang go-reng', '["ken","tang","go","reng"]'::jsonb, '🍟', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('sup', 'buah_makanan', 'Sup', 'https://ali.medixo.id/catalog/buah_makanan/sup.jpg', 'sup', '["sup"]'::jsonb, '🍲', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('bubur', 'buah_makanan', 'Bubur', 'https://ali.medixo.id/catalog/buah_makanan/bubur.jpg', 'bu-bur', '["bu","bur"]'::jsonb, '🥣', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('donat', 'buah_makanan', 'Donat', 'https://ali.medixo.id/catalog/buah_makanan/donat.jpg', 'do-nat', '["do","nat"]'::jsonb, '🍩', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('meja', 'benda', 'Meja', 'https://ali.medixo.id/catalog/benda/meja.jpg', 'me-ja', '["me","ja"]'::jsonb, '🪵', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('kursi', 'benda', 'Kursi', 'https://ali.medixo.id/catalog/benda/kursi.jpg', 'kur-si', '["kur","si"]'::jsonb, '🪑', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('lemari', 'benda', 'Lemari', 'https://ali.medixo.id/catalog/benda/lemari.jpg', 'le-ma-ri', '["le","ma","ri"]'::jsonb, '🚪', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('tempat_tidur', 'benda', 'Tempat Tidur', 'https://ali.medixo.id/catalog/benda/tempat_tidur.jpg', 'tem-pat ti-dur', '["tem","pat","ti","dur"]'::jsonb, '🛏️', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('bantal', 'benda', 'Bantal', 'https://ali.medixo.id/catalog/benda/bantal.jpg', 'ban-tal', '["ban","tal"]'::jsonb, '🛏️', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('guling', 'benda', 'Guling', 'https://ali.medixo.id/catalog/benda/guling.jpg', 'gu-ling', '["gu","ling"]'::jsonb, '🛌', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('selimut', 'benda', 'Selimut', 'https://ali.medixo.id/catalog/benda/selimut.jpg', 'se-li-mut', '["se","li","mut"]'::jsonb, '🛋️', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('lampu', 'benda', 'Lampu', 'https://ali.medixo.id/catalog/benda/lampu.jpg', 'lam-pu', '["lam","pu"]'::jsonb, '💡', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('kipas_angin', 'benda', 'Kipas Angin', 'https://ali.medixo.id/catalog/benda/kipas_angin.jpg', 'ki-pas ang-in', '["ki","pas","ang","in"]'::jsonb, '💨', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('jam', 'benda', 'Jam', 'https://ali.medixo.id/catalog/benda/jam.jpg', 'jam', '["jam"]'::jsonb, '⏰', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('pintu', 'benda', 'Pintu', 'https://ali.medixo.id/catalog/benda/pintu.jpg', 'pin-tu', '["pin","tu"]'::jsonb, '🚪', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('jendela', 'benda', 'Jendela', 'https://ali.medixo.id/catalog/benda/jendela.jpg', 'jen-de-la', '["jen","de","la"]'::jsonb, '🪟', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('cermin', 'benda', 'Cermin', 'https://ali.medixo.id/catalog/benda/cermin.jpg', 'cer-min', '["cer","min"]'::jsonb, '🪞', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('handuk', 'benda', 'Handuk', 'https://ali.medixo.id/catalog/benda/handuk.jpg', 'han-duk', '["han","duk"]'::jsonb, '🛁', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('sabun', 'benda', 'Sabun', 'https://ali.medixo.id/catalog/benda/sabun.jpg', 'sa-bun', '["sa","bun"]'::jsonb, '🧼', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('sampo', 'benda', 'Sampo', 'https://ali.medixo.id/catalog/benda/sampo.jpg', 'sam-po', '["sam","po"]'::jsonb, '🧴', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('sikat_gigi', 'benda', 'Sikat Gigi', 'https://ali.medixo.id/catalog/benda/sikat_gigi.jpg', 'si-kat gi-gi', '["si","kat","gi","gi"]'::jsonb, '🪥', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('odol', 'benda', 'Odol', 'https://ali.medixo.id/catalog/benda/odol.jpg', 'o-dol', '["o","dol"]'::jsonb, '🦷', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('sisir', 'benda', 'Sisir', 'https://ali.medixo.id/catalog/benda/sisir.jpg', 'si-sir', '["si","sir"]'::jsonb, '🪮', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('piring', 'benda', 'Piring', 'https://ali.medixo.id/catalog/benda/piring.jpg', 'pi-ring', '["pi","ring"]'::jsonb, '🍽️', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('mangkok', 'benda', 'Mangkok', 'https://ali.medixo.id/catalog/benda/mangkok.jpg', 'mang-kok', '["mang","kok"]'::jsonb, '🥣', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('sendok', 'benda', 'Sendok', 'https://ali.medixo.id/catalog/benda/sendok.jpg', 'sen-dok', '["sen","dok"]'::jsonb, '🥄', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('garpu', 'benda', 'Garpu', 'https://ali.medixo.id/catalog/benda/garpu.jpg', 'gar-pu', '["gar","pu"]'::jsonb, '🍴', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('gelas', 'benda', 'Gelas', 'https://ali.medixo.id/catalog/benda/gelas.jpg', 'ge-las', '["ge","las"]'::jsonb, '🥛', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('cangkir', 'benda', 'Cangkir', 'https://ali.medixo.id/catalog/benda/cangkir.jpg', 'cang-kir', '["cang","kir"]'::jsonb, '☕', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('botol_minum', 'benda', 'Botol Minum', 'https://ali.medixo.id/catalog/benda/botol_minum.jpg', 'bo-tol mi-num', '["bo","tol","mi","num"]'::jsonb, '🍶', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('panci', 'benda', 'Panci', 'https://ali.medixo.id/catalog/benda/panci.jpg', 'pan-ci', '["pan","ci"]'::jsonb, '🍲', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('wajan', 'benda', 'Wajan', 'https://ali.medixo.id/catalog/benda/wajan.jpg', 'wa-jan', '["wa","jan"]'::jsonb, '🍳', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('pisau', 'benda', 'Pisau', 'https://ali.medixo.id/catalog/benda/pisau.jpg', 'pi-sau', '["pi","sau"]'::jsonb, '🔪', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('gunting', 'benda', 'Gunting', 'https://ali.medixo.id/catalog/benda/gunting.jpg', 'gun-ting', '["gun","ting"]'::jsonb, '✂️', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('buku', 'benda', 'Buku', 'https://ali.medixo.id/catalog/benda/buku.jpg', 'bu-ku', '["bu","ku"]'::jsonb, '📖', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('pensil', 'benda', 'Pensil', 'https://ali.medixo.id/catalog/benda/pensil.jpg', 'pen-sil', '["pen","sil"]'::jsonb, '✏️', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('pulpen', 'benda', 'Pulpen', 'https://ali.medixo.id/catalog/benda/pulpen.jpg', 'pul-pen', '["pul","pen"]'::jsonb, '🖊️', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('penghapus', 'benda', 'Penghapus', 'https://ali.medixo.id/catalog/benda/penghapus.jpg', 'peng-ha-pus', '["peng","ha","pus"]'::jsonb, '🧼', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('penggaris', 'benda', 'Penggaris', 'https://ali.medixo.id/catalog/benda/penggaris.jpg', 'peng-ga-ris', '["peng","ga","ris"]'::jsonb, '📏', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('tas', 'benda', 'Tas', 'https://ali.medixo.id/catalog/benda/tas.jpg', 'tas', '["tas"]'::jsonb, '🎒', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('buku_gambar', 'benda', 'Buku Gambar', 'https://ali.medixo.id/catalog/benda/buku_gambar.jpg', 'bu-ku gam-bar', '["bu","ku","gam","bar"]'::jsonb, '🎨', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('krayon', 'benda', 'Krayon', 'https://ali.medixo.id/catalog/benda/krayon.jpg', 'kra-yon', '["kra","yon"]'::jsonb, '🖍️', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('kertas', 'benda', 'Kertas', 'https://ali.medixo.id/catalog/benda/kertas.jpg', 'ker-tas', '["ker","tas"]'::jsonb, '📄', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('telepon', 'benda', 'Telepon', 'https://ali.medixo.id/catalog/benda/telepon.jpg', 'te-le-pon', '["te","le","pon"]'::jsonb, '📱', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('televisi', 'benda', 'Televisi', 'https://ali.medixo.id/catalog/benda/televisi.jpg', 'te-le-vi-si', '["te","le","vi","si"]'::jsonb, '📺', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('komputer', 'benda', 'Komputer', 'https://ali.medixo.id/catalog/benda/komputer.jpg', 'kom-pu-ter', '["kom","pu","ter"]'::jsonb, '🖥️', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('laptop', 'benda', 'Laptop', 'https://ali.medixo.id/catalog/benda/laptop.jpg', 'lap-top', '["lap","top"]'::jsonb, '💻', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('radio', 'benda', 'Radio', 'https://ali.medixo.id/catalog/benda/radio.jpg', 'ra-di-o', '["ra","di","o"]'::jsonb, '📻', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('payung', 'benda', 'Payung', 'https://ali.medixo.id/catalog/benda/payung.jpg', 'pa-yung', '["pa","yung"]'::jsonb, '☂️', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('topi', 'benda', 'Topi', 'https://ali.medixo.id/catalog/benda/topi.jpg', 'to-pi', '["to","pi"]'::jsonb, '🧢', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('kacamata', 'benda', 'Kacamata', 'https://ali.medixo.id/catalog/benda/kacamata.jpg', 'ka-ca-ma-ta', '["ka","ca","ma","ta"]'::jsonb, '👓', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('baju', 'benda', 'Baju', 'https://ali.medixo.id/catalog/benda/baju.jpg', 'ba-ju', '["ba","ju"]'::jsonb, '👕', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('celana', 'benda', 'Celana', 'https://ali.medixo.id/catalog/benda/celana.jpg', 'ce-la-na', '["ce","la","na"]'::jsonb, '👖', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('rok', 'benda', 'Rok', 'https://ali.medixo.id/catalog/benda/rok.jpg', 'rok', '["rok"]'::jsonb, '👗', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('jaket', 'benda', 'Jaket', 'https://ali.medixo.id/catalog/benda/jaket.jpg', 'ja-ket', '["ja","ket"]'::jsonb, '🧥', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('kaos_kaki', 'benda', 'Kaos Kaki', 'https://ali.medixo.id/catalog/benda/kaos_kaki.jpg', 'ka-os ka-ki', '["ka","os","ka","ki"]'::jsonb, '🧦', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('sepatu', 'benda', 'Sepatu', 'https://ali.medixo.id/catalog/benda/sepatu.jpg', 'se-pa-tu', '["se","pa","tu"]'::jsonb, '👟', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('sandal', 'benda', 'Sandal', 'https://ali.medixo.id/catalog/benda/sandal.jpg', 'san-dal', '["san","dal"]'::jsonb, '🩴', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('sabuk', 'benda', 'Sabuk', 'https://ali.medixo.id/catalog/benda/sabuk.jpg', 'sa-buk', '["sa","buk"]'::jsonb, '🥋', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('kunci', 'benda', 'Kunci', 'https://ali.medixo.id/catalog/benda/kunci.jpg', 'kun-ci', '["kun","ci"]'::jsonb, '🔑', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('dompet', 'benda', 'Dompet', 'https://ali.medixo.id/catalog/benda/dompet.jpg', 'dom-pet', '["dom","pet"]'::jsonb, '👛', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('bola', 'benda', 'Bola', 'https://ali.medixo.id/catalog/benda/bola.jpg', 'bo-la', '["bo","la"]'::jsonb, '⚽', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('boneka', 'benda', 'Boneka', 'https://ali.medixo.id/catalog/benda/boneka.jpg', 'bo-ne-ka', '["bo","ne","ka"]'::jsonb, '🧸', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('kotak', 'benda', 'Kotak', 'https://ali.medixo.id/catalog/benda/kotak.jpg', 'ko-tak', '["ko","tak"]'::jsonb, '📦', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('makan', 'aksi_aac', 'Makan', 'https://ali.medixo.id/catalog/aksi_aac/makan.jpg', 'ma-kan', '["ma","kan"]'::jsonb, '🍽️', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('minum', 'aksi_aac', 'Minum', 'https://ali.medixo.id/catalog/aksi_aac/minum.jpg', 'mi-num', '["mi","num"]'::jsonb, '🥤', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('tidur', 'aksi_aac', 'Tidur', 'https://ali.medixo.id/catalog/aksi_aac/tidur.jpg', 'ti-dur', '["ti","dur"]'::jsonb, '😴', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('mandi', 'aksi_aac', 'Mandi', 'https://ali.medixo.id/catalog/aksi_aac/mandi.jpg', 'man-di', '["man","di"]'::jsonb, '🚿', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('duduk', 'aksi_aac', 'Duduk', 'https://ali.medixo.id/catalog/aksi_aac/duduk.jpg', 'du-duk', '["du","duk"]'::jsonb, '🪑', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('berdiri', 'aksi_aac', 'Berdiri', 'https://ali.medixo.id/catalog/aksi_aac/berdiri.jpg', 'ber-di-ri', '["ber","di","ri"]'::jsonb, '🧍', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('jalan', 'aksi_aac', 'Jalan', 'https://ali.medixo.id/catalog/aksi_aac/jalan.jpg', 'ja-lan', '["ja","lan"]'::jsonb, '🚶', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('lari', 'aksi_aac', 'Lari', 'https://ali.medixo.id/catalog/aksi_aac/lari.jpg', 'la-ri', '["la","ri"]'::jsonb, '🏃', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('lompat', 'aksi_aac', 'Lompat', 'https://ali.medixo.id/catalog/aksi_aac/lompat.jpg', 'lom-pat', '["lom","pat"]'::jsonb, '🦘', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('baca', 'aksi_aac', 'Baca', 'https://ali.medixo.id/catalog/aksi_aac/baca.jpg', 'ba-ca', '["ba","ca"]'::jsonb, '📖', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('tulis', 'aksi_aac', 'Tulis', 'https://ali.medixo.id/catalog/aksi_aac/tulis.jpg', 'tu-lis', '["tu","lis"]'::jsonb, '✍️', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('gambar', 'aksi_aac', 'Gambar', 'https://ali.medixo.id/catalog/aksi_aac/gambar.jpg', 'gam-bar', '["gam","bar"]'::jsonb, '🎨', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('main', 'aksi_aac', 'Main', 'https://ali.medixo.id/catalog/aksi_aac/main.jpg', 'ma-in', '["ma","in"]'::jsonb, '🎮', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('dengar', 'aksi_aac', 'Dengar', 'https://ali.medixo.id/catalog/aksi_aac/dengar.jpg', 'de-ngar', '["de","ngar"]'::jsonb, '🎧', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('lihat', 'aksi_aac', 'Lihat', 'https://ali.medixo.id/catalog/aksi_aac/lihat.jpg', 'li-hat', '["li","hat"]'::jsonb, '👀', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('bicara', 'aksi_aac', 'Bicara', 'https://ali.medixo.id/catalog/aksi_aac/bicara.jpg', 'bi-ca-ra', '["bi","ca","ra"]'::jsonb, '🗣️', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('tolong', 'aksi_aac', 'Tolong', 'https://ali.medixo.id/catalog/aksi_aac/tolong.jpg', 'to-long', '["to","long"]'::jsonb, '🤝', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('terima_kasih', 'aksi_aac', 'Terima Kasih', 'https://ali.medixo.id/catalog/aksi_aac/terima_kasih.jpg', 'te-ri-ma ka-sih', '["te","ri","ma","ka","sih"]'::jsonb, '🙏', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('mau', 'aksi_aac', 'Mau', 'https://ali.medixo.id/catalog/aksi_aac/mau.jpg', 'ma-u', '["ma","u"]'::jsonb, '👍', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('tidak_mau', 'aksi_aac', 'Tidak Mau', 'https://ali.medixo.id/catalog/aksi_aac/tidak_mau.jpg', 'ti-dak ma-u', '["ti","dak","ma","u"]'::jsonb, '🛑', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('suka', 'aksi_aac', 'Suka', 'https://ali.medixo.id/catalog/aksi_aac/suka.jpg', 'su-ka', '["su","ka"]'::jsonb, '❤️', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('tidak_suka', 'aksi_aac', 'Tidak Suka', 'https://ali.medixo.id/catalog/aksi_aac/tidak_suka.jpg', 'ti-dak su-ka', '["ti","dak","su","ka"]'::jsonb, '👎', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('senang', 'aksi_aac', 'Senang', 'https://ali.medixo.id/catalog/aksi_aac/senang.jpg', 'se-nang', '["se","nang"]'::jsonb, '😊', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('sedih', 'aksi_aac', 'Sedih', 'https://ali.medixo.id/catalog/aksi_aac/sedih.jpg', 'se-dih', '["se","dih"]'::jsonb, '😢', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('marah', 'aksi_aac', 'Marah', 'https://ali.medixo.id/catalog/aksi_aac/marah.jpg', 'ma-rah', '["ma","rah"]'::jsonb, '😠', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('takut', 'aksi_aac', 'Takut', 'https://ali.medixo.id/catalog/aksi_aac/takut.jpg', 'ta-kut', '["ta","kut"]'::jsonb, '😨', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('sakit', 'aksi_aac', 'Sakit', 'https://ali.medixo.id/catalog/aksi_aac/sakit.jpg', 'sa-kit', '["sa","kit"]'::jsonb, '🤒', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('lelah', 'aksi_aac', 'Lelah', 'https://ali.medixo.id/catalog/aksi_aac/lelah.jpg', 'le-lah', '["le","lah"]'::jsonb, '🥱', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('peluk', 'aksi_aac', 'Peluk', 'https://ali.medixo.id/catalog/aksi_aac/peluk.jpg', 'pe-luk', '["pe","luk"]'::jsonb, '🫂', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('cium', 'aksi_aac', 'Cium', 'https://ali.medixo.id/catalog/aksi_aac/cium.jpg', 'ci-um', '["ci","um"]'::jsonb, '😘', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('buka', 'aksi_aac', 'Buka', 'https://ali.medixo.id/catalog/aksi_aac/buka.jpg', 'bu-ka', '["bu","ka"]'::jsonb, '🔓', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('tutup', 'aksi_aac', 'Tutup', 'https://ali.medixo.id/catalog/aksi_aac/tutup.jpg', 'tu-tup', '["tu","tup"]'::jsonb, '🔒', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('cuci_tangan', 'aksi_aac', 'Cuci Tangan', 'https://ali.medixo.id/catalog/aksi_aac/cuci_tangan.jpg', 'cu-ci tang-an', '["cu","ci","tang","an"]'::jsonb, '🧼', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('sikat_gigi_aksi', 'aksi_aac', 'Sikat Gigi', 'https://ali.medixo.id/catalog/aksi_aac/sikat_gigi_aksi.jpg', 'si-kat gi-gi', '["si","kat","gi","gi"]'::jsonb, '🪥', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('pulang', 'aksi_aac', 'Pulang', 'https://ali.medixo.id/catalog/aksi_aac/pulang.jpg', 'pu-lang', '["pu","lang"]'::jsonb, '🏡', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('mobil', 'kendaraan', 'Mobil', 'https://ali.medixo.id/catalog/kendaraan/mobil.jpg', 'mo-bil', '["mo","bil"]'::jsonb, '🚗', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('motor', 'kendaraan', 'Motor', 'https://ali.medixo.id/catalog/kendaraan/motor.jpg', 'mo-tor', '["mo","tor"]'::jsonb, '🛵', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('sepeda', 'kendaraan', 'Sepeda', 'https://ali.medixo.id/catalog/kendaraan/sepeda.jpg', 'se-pe-da', '["se","pe","da"]'::jsonb, '🚲', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('bus', 'kendaraan', 'Bus', 'https://ali.medixo.id/catalog/kendaraan/bus.jpg', 'bus', '["bus"]'::jsonb, '🚌', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('truk', 'kendaraan', 'Truk', 'https://ali.medixo.id/catalog/kendaraan/truk.jpg', 'truk', '["truk"]'::jsonb, '🚛', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('kereta_api', 'kendaraan', 'Kereta Api', 'https://ali.medixo.id/catalog/kendaraan/kereta_api.jpg', 'ke-re-ta a-pi', '["ke","re","ta","a","pi"]'::jsonb, '🚆', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('pesawat', 'kendaraan', 'Pesawat', 'https://ali.medixo.id/catalog/kendaraan/pesawat.jpg', 'pe-sa-wat', '["pe","sa","wat"]'::jsonb, '✈️', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('helikopter', 'kendaraan', 'Helikopter', 'https://ali.medixo.id/catalog/kendaraan/helikopter.jpg', 'he-li-kop-ter', '["he","li","kop","ter"]'::jsonb, '🚁', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('kapal_laut', 'kendaraan', 'Kapal Laut', 'https://ali.medixo.id/catalog/kendaraan/kapal_laut.jpg', 'ka-pal la-ut', '["ka","pal","la","ut"]'::jsonb, '🚢', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('perahu', 'kendaraan', 'Perahu', 'https://ali.medixo.id/catalog/kendaraan/perahu.jpg', 'pe-ra-hu', '["pe","ra","hu"]'::jsonb, '🛶', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('ambulans', 'kendaraan', 'Ambulans', 'https://ali.medixo.id/catalog/kendaraan/ambulans.jpg', 'am-bu-lans', '["am","bu","lans"]'::jsonb, '🚑', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('pemadam_kebakaran', 'kendaraan', 'Pemadam Kebakaran', 'https://ali.medixo.id/catalog/kendaraan/pemadam_kebakaran.jpg', 'pe-ma-dam ke-ba-ka-ran', '["pe","ma","dam","ke","ba","ka","ran"]'::jsonb, '🚒', 3, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('mobil_polisi', 'kendaraan', 'Mobil Polisi', 'https://ali.medixo.id/catalog/kendaraan/mobil_polisi.jpg', 'mo-bil po-li-si', '["mo","bil","po","li","si"]'::jsonb, '🚓', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('taksi', 'kendaraan', 'Taksi', 'https://ali.medixo.id/catalog/kendaraan/taksi.jpg', 'tak-si', '["tak","si"]'::jsonb, '🚕', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('bajaj', 'kendaraan', 'Bajaj', 'https://ali.medixo.id/catalog/kendaraan/bajaj.jpg', 'ba-jaj', '["ba","jaj"]'::jsonb, '🛺', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('becak', 'kendaraan', 'Becak', 'https://ali.medixo.id/catalog/kendaraan/becak.jpg', 'be-cak', '["be","cak"]'::jsonb, '🚲', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('traktor', 'kendaraan', 'Traktor', 'https://ali.medixo.id/catalog/kendaraan/traktor.jpg', 'trak-tor', '["trak","tor"]'::jsonb, '🚜', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('ekskavator', 'kendaraan', 'Ekskavator', 'https://ali.medixo.id/catalog/kendaraan/ekskavator.jpg', 'eks-ka-va-tor', '["eks","ka","va","tor"]'::jsonb, '🚜', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('kapal_selam', 'kendaraan', 'Kapal Selam', 'https://ali.medixo.id/catalog/kendaraan/kapal_selam.jpg', 'ka-pal se-lam', '["ka","pal","se","lam"]'::jsonb, '🤿', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('balon_udara', 'kendaraan', 'Balon Udara', 'https://ali.medixo.id/catalog/kendaraan/balon_udara.jpg', 'ba-lon u-da-ra', '["ba","lon","u","da","ra"]'::jsonb, '🎈', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('roket', 'kendaraan', 'Roket', 'https://ali.medixo.id/catalog/kendaraan/roket.jpg', 'ro-ket', '["ro","ket"]'::jsonb, '🚀', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('sekuter', 'kendaraan', 'Sekuter', 'https://ali.medixo.id/catalog/kendaraan/sekuter.jpg', 'se-ku-ter', '["se","ku","ter"]'::jsonb, '🛴', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('truk_sampah', 'kendaraan', 'Truk Sampah', 'https://ali.medixo.id/catalog/kendaraan/truk_sampah.jpg', 'truk sam-pah', '["truk","sam","pah"]'::jsonb, '🚛', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('mobil_balap', 'kendaraan', 'Mobil Balap', 'https://ali.medixo.id/catalog/kendaraan/mobil_balap.jpg', 'mo-bil ba-lap', '["mo","bil","ba","lap"]'::jsonb, '🏎️', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('gerobak', 'kendaraan', 'Gerobak', 'https://ali.medixo.id/catalog/kendaraan/gerobak.jpg', 'ge-ro-bak', '["ge","ro","bak"]'::jsonb, '🛒', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('mata', 'tubuh', 'Mata', 'https://ali.medixo.id/catalog/tubuh/mata.jpg', 'ma-ta', '["ma","ta"]'::jsonb, '👁️', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('hidung', 'tubuh', 'Hidung', 'https://ali.medixo.id/catalog/tubuh/hidung.jpg', 'hi-dung', '["hi","dung"]'::jsonb, '👃', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('mulut', 'tubuh', 'Mulut', 'https://ali.medixo.id/catalog/tubuh/mulut.jpg', 'mu-lut', '["mu","lut"]'::jsonb, '👄', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('telinga', 'tubuh', 'Telinga', 'https://ali.medixo.id/catalog/tubuh/telinga.jpg', 'te-li-nga', '["te","li","nga"]'::jsonb, '👂', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('rambut', 'tubuh', 'Rambut', 'https://ali.medixo.id/catalog/tubuh/rambut.jpg', 'ram-but', '["ram","but"]'::jsonb, '💇', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('kepala', 'tubuh', 'Kepala', 'https://ali.medixo.id/catalog/tubuh/kepala.jpg', 'ke-pa-la', '["ke","pa","la"]'::jsonb, '🗣️', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('gigi', 'tubuh', 'Gigi', 'https://ali.medixo.id/catalog/tubuh/gigi.jpg', 'gi-gi', '["gi","gi"]'::jsonb, '🦷', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('lidah', 'tubuh', 'Lidah', 'https://ali.medixo.id/catalog/tubuh/lidah.jpg', 'li-dah', '["li","dah"]'::jsonb, '👅', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('tangan', 'tubuh', 'Tangan', 'https://ali.medixo.id/catalog/tubuh/tangan.jpg', 'tang-an', '["tang","an"]'::jsonb, '✋', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('kaki', 'tubuh', 'Kaki', 'https://ali.medixo.id/catalog/tubuh/kaki.jpg', 'ka-ki', '["ka","ki"]'::jsonb, '🦶', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('jari', 'tubuh', 'Jari', 'https://ali.medixo.id/catalog/tubuh/jari.jpg', 'ja-ri', '["ja","ri"]'::jsonb, '🖐️', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('pipi', 'tubuh', 'Pipi', 'https://ali.medixo.id/catalog/tubuh/pipi.jpg', 'pi-pi', '["pi","pi"]'::jsonb, '😊', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('dagu', 'tubuh', 'Dagu', 'https://ali.medixo.id/catalog/tubuh/dagu.jpg', 'da-gu', '["da","gu"]'::jsonb, '🧔', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('leher', 'tubuh', 'Leher', 'https://ali.medixo.id/catalog/tubuh/leher.jpg', 'le-her', '["le","her"]'::jsonb, '🧣', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('pundak', 'tubuh', 'Pundak', 'https://ali.medixo.id/catalog/tubuh/pundak.jpg', 'pun-dak', '["pun","dak"]'::jsonb, '💪', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('perut', 'tubuh', 'Perut', 'https://ali.medixo.id/catalog/tubuh/perut.jpg', 'pe-rut', '["pe","rut"]'::jsonb, '🤰', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('punggung', 'tubuh', 'Punggung', 'https://ali.medixo.id/catalog/tubuh/punggung.jpg', 'pung-gung', '["pung","gung"]'::jsonb, '🚶', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('lutut', 'tubuh', 'Lutut', 'https://ali.medixo.id/catalog/tubuh/lutut.jpg', 'lu-tut', '["lu","tut"]'::jsonb, '🦵', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('siku', 'tubuh', 'Siku', 'https://ali.medixo.id/catalog/tubuh/siku.jpg', 'si-ku', '["si","ku"]'::jsonb, '💪', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('kuku', 'tubuh', 'Kuku', 'https://ali.medixo.id/catalog/tubuh/kuku.jpg', 'ku-ku', '["ku","ku"]'::jsonb, '💅', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('matahari', 'alam', 'Matahari', 'https://ali.medixo.id/catalog/alam/matahari.jpg', 'ma-ta-ha-ri', '["ma","ta","ha","ri"]'::jsonb, '☀️', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('bulan', 'alam', 'Bulan', 'https://ali.medixo.id/catalog/alam/bulan.jpg', 'bu-lan', '["bu","lan"]'::jsonb, '🌕', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('bintang', 'alam', 'Bintang', 'https://ali.medixo.id/catalog/alam/bintang.jpg', 'bin-tang', '["bin","tang"]'::jsonb, '⭐', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('awan', 'alam', 'Awan', 'https://ali.medixo.id/catalog/alam/awan.jpg', 'a-wan', '["a","wan"]'::jsonb, '☁️', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('hujan', 'alam', 'Hujan', 'https://ali.medixo.id/catalog/alam/hujan.jpg', 'hu-jan', '["hu","jan"]'::jsonb, '🌧️', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('pelangi', 'alam', 'Pelangi', 'https://ali.medixo.id/catalog/alam/pelangi.jpg', 'pe-lang-i', '["pe","lang","i"]'::jsonb, '🌈', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('langit', 'alam', 'Langit', 'https://ali.medixo.id/catalog/alam/langit.jpg', 'lang-it', '["lang","it"]'::jsonb, '🌌', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('gunung', 'alam', 'Gunung', 'https://ali.medixo.id/catalog/alam/gunung.jpg', 'gu-nung', '["gu","nung"]'::jsonb, '⛰️', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('laut', 'alam', 'Laut', 'https://ali.medixo.id/catalog/alam/laut.jpg', 'la-ut', '["la","ut"]'::jsonb, '🌊', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('pantai', 'alam', 'Pantai', 'https://ali.medixo.id/catalog/alam/pantai.jpg', 'pan-tai', '["pan","tai"]'::jsonb, '🏖️', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('sungai', 'alam', 'Sungai', 'https://ali.medixo.id/catalog/alam/sungai.jpg', 'su-ngai', '["su","ngai"]'::jsonb, '🏞️', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('pohon', 'alam', 'Pohon', 'https://ali.medixo.id/catalog/alam/pohon.jpg', 'po-hon', '["po","hon"]'::jsonb, '🌳', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('bunga', 'alam', 'Bunga', 'https://ali.medixo.id/catalog/alam/bunga.jpg', 'bu-nga', '["bu","nga"]'::jsonb, '🌸', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('rumput', 'alam', 'Rumput', 'https://ali.medixo.id/catalog/alam/rumput.jpg', 'rum-put', '["rum","put"]'::jsonb, '🌱', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('batu', 'alam', 'Batu', 'https://ali.medixo.id/catalog/alam/batu.jpg', 'ba-tu', '["ba","tu"]'::jsonb, '🪨', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('tanah', 'alam', 'Tanah', 'https://ali.medixo.id/catalog/alam/tanah.jpg', 'ta-nah', '["ta","nah"]'::jsonb, '🪴', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('pasir', 'alam', 'Pasir', 'https://ali.medixo.id/catalog/alam/pasir.jpg', 'pa-sir', '["pa","sir"]'::jsonb, '🏖️', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('daun', 'alam', 'Daun', 'https://ali.medixo.id/catalog/alam/daun.jpg', 'da-un', '["da","un"]'::jsonb, '🍃', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('api', 'alam', 'Api', 'https://ali.medixo.id/catalog/alam/api.jpg', 'a-pi', '["a","pi"]'::jsonb, '🔥', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('angin', 'alam', 'Angin', 'https://ali.medixo.id/catalog/alam/angin.jpg', 'ang-in', '["ang","in"]'::jsonb, '💨', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('air_terjun', 'alam', 'Air Terjun', 'https://ali.medixo.id/catalog/alam/air_terjun.jpg', 'a-ir ter-jun', '["a","ir","ter","jun"]'::jsonb, '🌊', 2, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('hutan', 'alam', 'Hutan', 'https://ali.medixo.id/catalog/alam/hutan.jpg', 'hu-tan', '["hu","tan"]'::jsonb, '🌲', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('merah', 'alam', 'Merah', 'https://ali.medixo.id/catalog/alam/merah.jpg', 'me-rah', '["me","rah"]'::jsonb, '🔴', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('kuning', 'alam', 'Kuning', 'https://ali.medixo.id/catalog/alam/kuning.jpg', 'ku-ning', '["ku","ning"]'::jsonb, '🟡', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

INSERT INTO public.catalog_items (id, category_id, name, image_url, phonics, syllables, emoji, difficulty, is_active)
VALUES ('biru', 'alam', 'Biru', 'https://ali.medixo.id/catalog/alam/biru.jpg', 'bi-ru', '["bi","ru"]'::jsonb, '🔵', 1, true)
ON CONFLICT (id) DO UPDATE SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    image_url = EXCLUDED.image_url,
    phonics = EXCLUDED.phonics,
    syllables = EXCLUDED.syllables,
    emoji = EXCLUDED.emoji,
    difficulty = EXCLUDED.difficulty,
    is_active = EXCLUDED.is_active;

