-- ==============================================================================
-- SKEMA DATABASE LENGKAP: AUTH, USER PROFILES, SUBSCRIPTION, PUSH NOTIF, & RLS
-- Project Supabase: sagnmquiewnypuplhxhs (Aplikasi Ali)
-- ==============================================================================

-- 1. TABEL PROFILES (Informasi Akun, Tier Berbayar / Subscription, & Push Token)
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  email TEXT UNIQUE,
  full_name TEXT,
  avatar_url TEXT,
  
  -- Status Berbayar / Subscription
  subscription_tier TEXT DEFAULT 'free' CHECK (subscription_tier IN ('free', 'trial', 'premium')),
  subscription_status TEXT DEFAULT 'active' CHECK (subscription_status IN ('active', 'expired', 'canceled')),
  trial_ends_at TIMESTAMPTZ DEFAULT (NOW() + INTERVAL '7 days'), -- Free trial 7 hari
  subscription_ends_at TIMESTAMPTZ,
  
  -- Push Notification Token (FCM Token untuk Web, Android, iOS)
  fcm_token TEXT,
  fcm_platform TEXT CHECK (fcm_platform IN ('web', 'android', 'ios')),
  
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Aktifkan Row Level Security untuk tabel profiles
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

-- ------------------------------------------------------------------------------
-- 2. TRIGGER OTOMATIS: Buat Profil Baru Saat User Pertama Kali Login Google
-- ------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name, avatar_url)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.raw_user_meta_data->>'name', 'Pengguna Ali'),
    COALESCE(NEW.raw_user_meta_data->>'avatar_url', NEW.raw_user_meta_data->>'picture', '')
  )
  ON CONFLICT (id) DO UPDATE
  SET 
    full_name = EXCLUDED.full_name,
    avatar_url = EXCLUDED.avatar_url,
    updated_at = NOW();
    
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Pasang trigger pada auth.users
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT OR UPDATE ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- ------------------------------------------------------------------------------
-- 3. UPDATE TABEL KANVAS ART (ali_canvas_art) DENGAN USER_ID & RLS
-- ------------------------------------------------------------------------------
-- Tambahkan kolom user_id jika belum ada
ALTER TABLE public.ali_canvas_art 
ADD COLUMN IF NOT EXISTS user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE DEFAULT auth.uid();

-- Aktifkan Row Level Security
ALTER TABLE public.ali_canvas_art ENABLE ROW LEVEL SECURITY;

-- Policy: User HANYA bisa membaca karyanya sendiri
DROP POLICY IF EXISTS "User can select own drawings" ON public.ali_canvas_art;
CREATE POLICY "User can select own drawings"
  ON public.ali_canvas_art FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

-- Policy: User HANYA bisa menyimpan gambar miliknya sendiri
DROP POLICY IF EXISTS "User can insert own drawings" ON public.ali_canvas_art;
CREATE POLICY "User can insert own drawings"
  ON public.ali_canvas_art FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Policy: User HANYA bisa mengupdate gambarnya sendiri
DROP POLICY IF EXISTS "User can update own drawings" ON public.ali_canvas_art;
CREATE POLICY "User can update own drawings"
  ON public.ali_canvas_art FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Policy: User HANYA bisa menghapus gambarnya sendiri
DROP POLICY IF EXISTS "User can delete own drawings" ON public.ali_canvas_art;
CREATE POLICY "User can delete own drawings"
  ON public.ali_canvas_art FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- ------------------------------------------------------------------------------
-- 4. VIEW/FUNCTION HELPER: Cek Status Langganan Pengguna
-- ------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.is_user_subscribed(check_user_id UUID)
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

  -- Jika status aktif dan merupakan premium
  IF status = 'active' AND tier = 'premium' AND (sub_end IS NULL OR sub_end > NOW()) THEN
    RETURN TRUE;
  END IF;

  -- Jika masih dalam masa trial 7 hari
  IF tier = 'trial' AND trial_end > NOW() THEN
    RETURN TRUE;
  END IF;

  RETURN FALSE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
