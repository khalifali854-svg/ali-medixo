-- ==============================================================================
-- SKEMA DATABASE LENGKAP V2: MULTI-TENANT PER AKUN (USER_ID/PROFILE_ID)
-- Project Supabase: sagnmquiewnypuplhxhs (Aplikasi Ali)
--
-- Menjamin:
-- 1. Profiles (Tier: Free vs Pro Rp 99.000, Status, Child Profile, Baseline Data)
-- 2. Vocab Cards (Official System Cards vs Custom User Cards ber-user_id)
-- 3. Visual Schedule (Rutinitas ber-user_id dengan RLS per user)
-- 4. Choice Board (Opsi pilihan 2 & 4 kartu ber-user_id dengan RLS per user)
-- 5. Child Telemetry & Progress Logs (Pencatatan aktivitas AAC, STT, Tracing)
-- 6. Canvas Drawings (ali_canvas_art ber-user_id)
-- 7. App Settings per akun/user
-- ==============================================================================

-- 1. EXTENSIONS
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ==============================================================================
-- 2. TABEL PROFILES (Informasi Akun, Tier Berbayar, Profil Anak, & Telemetri)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  email TEXT UNIQUE,
  full_name TEXT,
  avatar_url TEXT,
  
  -- Status Berbayar / Subscription (Free vs Pro Rp 99.000 / bulan)
  subscription_tier TEXT DEFAULT 'free' CHECK (subscription_tier IN ('free', 'trial', 'pro')),
  subscription_status TEXT DEFAULT 'active' CHECK (subscription_status IN ('active', 'expired', 'canceled')),
  trial_ends_at TIMESTAMPTZ DEFAULT (NOW() + INTERVAL '7 days'),
  subscription_ends_at TIMESTAMPTZ,
  
  -- Data Anak & Personalisasi Keluarga
  child_name TEXT DEFAULT 'Ali',
  child_age_group TEXT DEFAULT 'toddler' CHECK (child_age_group IN ('toddler', 'child', 'teen')),
  father_call TEXT DEFAULT 'Abi',
  mother_call TEXT DEFAULT 'Umma',
  parent_pin TEXT, -- 4-digit PIN untuk Parental Gate
  
  -- Baseline Onboarding Assessment
  baseline_speech_level TEXT DEFAULT 'emerging',
  primary_focus TEXT DEFAULT 'communication',
  
  -- Push Notification Token
  fcm_token TEXT,
  fcm_platform TEXT CHECK (fcm_platform IN ('web', 'android', 'ios')),
  
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can view their own profile" ON public.profiles;
CREATE POLICY "Users can view their own profile"
  ON public.profiles FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

DROP POLICY IF EXISTS "Users can update their own profile" ON public.profiles;
CREATE POLICY "Users can update their own profile"
  ON public.profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- TRIGGER BARU: Saat user signup via Google/Apple/Email
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (
    id,
    email,
    full_name,
    avatar_url,
    child_name,
    subscription_tier,
    subscription_status
  )
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.raw_user_meta_data->>'name', 'Orang Tua Ali'),
    COALESCE(NEW.raw_user_meta_data->>'avatar_url', NEW.raw_user_meta_data->>'picture', ''),
    COALESCE(NEW.raw_user_meta_data->>'child_name', 'Ali'),
    'free',
    'active'
  )
  ON CONFLICT (id) DO UPDATE
  SET 
    full_name = EXCLUDED.full_name,
    avatar_url = EXCLUDED.avatar_url,
    updated_at = NOW();
    
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT OR UPDATE ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- ==============================================================================
-- 3. TABEL VOCAB CARDS (Support Sistem Global vs Custom Kartu Pribadi)
-- ==============================================================================
-- user_id NULL = Kartu resmi sistem (Bisa dibaca semua orang, Free max 10, Pro unlimited)
-- user_id NOT NULL = Kartu kustom milik akun tersebut (Hanya bisa dibaca & diubah oleh pemiliknya)
ALTER TABLE public.vocab_cards 
ADD COLUMN IF NOT EXISTS user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE;

ALTER TABLE public.vocab_cards 
ADD COLUMN IF NOT EXISTS is_system BOOLEAN DEFAULT false;

ALTER TABLE public.vocab_cards ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Read system cards or user own cards" ON public.vocab_cards;
CREATE POLICY "Read system cards or user own cards"
  ON public.vocab_cards FOR SELECT
  TO public
  USING (user_id IS NULL OR is_system = true OR auth.uid() = user_id);

DROP POLICY IF EXISTS "Insert own cards" ON public.vocab_cards;
CREATE POLICY "Insert own cards"
  ON public.vocab_cards FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Update own cards" ON public.vocab_cards;
CREATE POLICY "Update own cards"
  ON public.vocab_cards FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Delete own cards" ON public.vocab_cards;
CREATE POLICY "Delete own cards"
  ON public.vocab_cards FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- ==============================================================================
-- 4. TABEL SCHEDULE & ROUTINES PER AKUN
-- ==============================================================================
CREATE TABLE IF NOT EXISTS public.user_schedules (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  schedule_type TEXT NOT NULL CHECK (schedule_type IN ('first_then', 'daily_routine')),
  first_item JSONB,
  then_item JSONB,
  routine_items JSONB DEFAULT '[]'::JSONB,
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT user_schedule_unique UNIQUE (user_id, schedule_type)
);

ALTER TABLE public.user_schedules ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "User can select own schedule" ON public.user_schedules;
CREATE POLICY "User can select own schedule"
  ON public.user_schedules FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "User can upsert own schedule" ON public.user_schedules;
CREATE POLICY "User can upsert own schedule"
  ON public.user_schedules FOR ALL
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- ==============================================================================
-- 5. TABEL CHOICE BOARD PER AKUN
-- ==============================================================================
CREATE TABLE IF NOT EXISTS public.user_choice_boards (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  two_choices JSONB DEFAULT '[]'::JSONB,
  four_choices JSONB DEFAULT '[]'::JSONB,
  last_selected_id TEXT,
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT user_choice_board_unique UNIQUE (user_id)
);

ALTER TABLE public.user_choice_boards ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "User can select own choice board" ON public.user_choice_boards;
CREATE POLICY "User can select own choice board"
  ON public.user_choice_boards FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "User can upsert own choice board" ON public.user_choice_boards;
CREATE POLICY "User can upsert own choice board"
  ON public.user_choice_boards FOR ALL
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- ==============================================================================
-- 6. TABEL TELEMETRI & PROGRESS TRACKING ANAK (PROGRESS HUB)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS public.child_activity_logs (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  activity_type TEXT NOT NULL CHECK (activity_type IN ('aac_speech', 'choice_made', 'schedule_completed', 'guess_game_speech', 'writing_tracing', 'drawing_art')),
  target_label TEXT NOT NULL,
  category TEXT,
  success BOOLEAN DEFAULT true,
  latency_ms INT, -- Kecepatan respon anak dalam milidetik
  metadata JSONB DEFAULT '{}'::JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.child_activity_logs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "User can select own activity logs" ON public.child_activity_logs;
CREATE POLICY "User can select own activity logs"
  ON public.child_activity_logs FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "User can insert own activity logs" ON public.child_activity_logs;
CREATE POLICY "User can insert own activity logs"
  ON public.child_activity_logs FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- ==============================================================================
-- 7. TABEL KANVAS ART (ali_canvas_art) DENGAN RLS PER AKUN
-- ==============================================================================
ALTER TABLE public.ali_canvas_art 
ADD COLUMN IF NOT EXISTS user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE DEFAULT auth.uid();

ALTER TABLE public.ali_canvas_art ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "User can select own drawings" ON public.ali_canvas_art;
CREATE POLICY "User can select own drawings"
  ON public.ali_canvas_art FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "User can insert own drawings" ON public.ali_canvas_art;
CREATE POLICY "User can insert own drawings"
  ON public.ali_canvas_art FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "User can update own drawings" ON public.ali_canvas_art;
CREATE POLICY "User can update own drawings"
  ON public.ali_canvas_art FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "User can delete own drawings" ON public.ali_canvas_art;
CREATE POLICY "User can delete own drawings"
  ON public.ali_canvas_art FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- ==============================================================================
-- 8. TABEL MENULIS KUSTOM (writing_items) DENGAN USER_ID & RLS
-- ==============================================================================
ALTER TABLE public.writing_items 
ADD COLUMN IF NOT EXISTS user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE;

ALTER TABLE public.writing_items ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Read official or own writing items" ON public.writing_items;
CREATE POLICY "Read official or own writing items"
  ON public.writing_items FOR SELECT
  TO public
  USING (is_custom = false OR user_id IS NULL OR auth.uid() = user_id);

DROP POLICY IF EXISTS "Insert own writing items" ON public.writing_items;
CREATE POLICY "Insert own writing items"
  ON public.writing_items FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Delete own writing items" ON public.writing_items;
CREATE POLICY "Delete own writing items"
  ON public.writing_items FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- ==============================================================================
-- 9. TABEL USAGE LOGS DENGAN USER_ID & RLS
-- ==============================================================================
ALTER TABLE public.usage_logs 
ADD COLUMN IF NOT EXISTS user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE DEFAULT auth.uid();

ALTER TABLE public.usage_logs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Insert own usage logs" ON public.usage_logs;
CREATE POLICY "Insert own usage logs"
  ON public.usage_logs FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Select own usage logs" ON public.usage_logs;
CREATE POLICY "Select own usage logs"
  ON public.usage_logs FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

-- ==============================================================================
-- 10. TABEL APP SETTINGS DENGAN USER_ID & RLS (Setting Suara/Bahasa per Akun)
-- ==============================================================================
ALTER TABLE public.app_settings 
ADD COLUMN IF NOT EXISTS user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE DEFAULT auth.uid();

ALTER TABLE public.app_settings ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Read own app settings" ON public.app_settings;
CREATE POLICY "Read own app settings"
  ON public.app_settings FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Upsert own app settings" ON public.app_settings;
CREATE POLICY "Upsert own app settings"
  ON public.app_settings FOR ALL
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- ==============================================================================
-- 11. VIEW / HELPER FUNCTIONS
-- ==============================================================================
CREATE OR REPLACE FUNCTION public.is_user_pro(check_user_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
  tier TEXT;
  status TEXT;
  trial_end TIMESTAMPTZ;
  sub_end TIMESTAMPTZ;
BEGIN
  SELECT subscription_tier, subscription_status, trial_ends_at, subscription_ends_at
  INTO tier, status, trial_end, sub_end
  FROM public.profiles
  WHERE id = check_user_id;

  -- Jika status aktif dan merupakan pro
  IF status = 'active' AND tier = 'pro' AND (sub_end IS NULL OR sub_end > NOW()) THEN
    RETURN TRUE;
  END IF;

  -- Jika masih dalam masa trial 7 hari
  IF tier = 'trial' AND trial_end > NOW() THEN
    RETURN TRUE;
  END IF;

  RETURN FALSE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ==============================================================================
-- 12. MIGRASI & BACKFILL DATA LAMA (AGAR TIDAK NULL)
-- ==============================================================================
-- A. Untuk data bawaan sistem / official catalog:
-- Tandai kartu bawaan lama sebagai 'is_system = true' agar bisa diakses semua user
UPDATE public.vocab_cards
SET is_system = true
WHERE user_id IS NULL;

-- Tandai materi menulis bawaan lama sebagai bukan custom
UPDATE public.writing_items
SET is_custom = false
WHERE is_custom IS NULL;

-- B. Pasang default otomatis auth.uid() agar setiap insert baru otomatis terisi user_id:
ALTER TABLE public.vocab_cards ALTER COLUMN user_id SET DEFAULT auth.uid();
ALTER TABLE public.child_activity_logs ALTER COLUMN user_id SET DEFAULT auth.uid();
ALTER TABLE public.user_schedules ALTER COLUMN user_id SET DEFAULT auth.uid();
ALTER TABLE public.user_choice_boards ALTER COLUMN user_id SET DEFAULT auth.uid();
ALTER TABLE public.ali_canvas_art ALTER COLUMN user_id SET DEFAULT auth.uid();
ALTER TABLE public.writing_items ALTER COLUMN user_id SET DEFAULT auth.uid();
ALTER TABLE public.usage_logs ALTER COLUMN user_id SET DEFAULT auth.uid();
ALTER TABLE public.app_settings ALTER COLUMN user_id SET DEFAULT auth.uid();

-- C. (Opsional) Menghubungkan data lama yang sudah ada ke akun admin/owner Anda:
-- Jika Anda ingin semua data coretan kanvas/setting lama otomatis jadi milik akun Anda,
-- ganti 'PASTE_EMAIL_ANDA_DISINI@gmail.com' dengan email Anda lalu jalankan baris ini di SQL Editor:
--
-- DO $$
-- DECLARE
--   owner_id UUID;
-- BEGIN
--   SELECT id INTO owner_id FROM auth.users ORDER BY created_at ASC LIMIT 1;
--   IF owner_id IS NOT NULL THEN
--     UPDATE public.ali_canvas_art SET user_id = owner_id WHERE user_id IS NULL;
--     UPDATE public.writing_items SET user_id = owner_id WHERE user_id IS NULL AND is_custom = true;
--     UPDATE public.usage_logs SET user_id = owner_id WHERE user_id IS NULL;
--   END IF;
-- END $$;

