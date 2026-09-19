-- Migration untuk memperbarui 10 Kartu AAC Default Ramah Anak Indonesia di Supabase
-- Menghapus kartu dummy awal (Abi, Umma, Alesha, Moli yang ber-id b0000001-...) dan mengganti dengan 10 Kartu Esensial Berkualitas Tinggi

-- 1. Pastikan kategori Bantuan ada
INSERT INTO public.categories (id, name, icon_name, sort_order) VALUES
('a0000001-0000-0000-0000-000000000005', 'Bantuan', 'hand', 5)
ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name, icon_name = EXCLUDED.icon_name;

-- 2. Hapus kartu default lama sistem yang ID-nya berawalan b0000001-0000-0000-0000-00000000000%
DELETE FROM public.vocab_cards WHERE id LIKE 'b0000001-0000-0000-0000-00000000000%' OR is_system = true;

-- 3. Masukkan 10 Kartu AAC Default Esensial Ramah Anak Indonesia (Foto Asli CDN R2)
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
ON CONFLICT (id) DO UPDATE SET
  category_id = EXCLUDED.category_id,
  label = EXCLUDED.label,
  image_url = EXCLUDED.image_url,
  sort_order = EXCLUDED.sort_order,
  is_system = EXCLUDED.is_system;
