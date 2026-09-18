-- ==============================================================================
-- MIGRASI 004: SUBSCRIPTION TRANSACTIONS & TIER EXPIRATION ENHANCEMENT
-- Project Supabase: sagnmquiewnypuplhxhs (Aplikasi Ali)
-- ==============================================================================

-- 1. Perbaiki constraint subscription_tier pada profiles agar mendukung 'yearly', 'monthly', 'pro', 'trial', 'free'
ALTER TABLE public.profiles 
DROP CONSTRAINT IF EXISTS profiles_subscription_tier_check;

ALTER TABLE public.profiles 
ADD CONSTRAINT profiles_subscription_tier_check 
CHECK (subscription_tier IN ('free', 'trial', 'pro', 'monthly', 'yearly'));

ALTER TABLE public.profiles 
ADD COLUMN IF NOT EXISTS subscription_tier TEXT DEFAULT 'free';

ALTER TABLE public.profiles 
ADD COLUMN IF NOT EXISTS subscription_status TEXT DEFAULT 'active';

ALTER TABLE public.profiles 
ADD COLUMN IF NOT EXISTS subscription_ends_at TIMESTAMPTZ;

-- 2. Buat tabel pencatatan transaksi pembayaran langganan (BCA / Manual Transfer / Admin Approval)
CREATE TABLE IF NOT EXISTS public.subscription_orders (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  package_name TEXT NOT NULL, -- 'Bulanan' atau 'Tahunan'
  quantity INTEGER DEFAULT 1, -- Jumlah bulan atau jumlah tahun (misal: 3 bulan, 2 tahun)
  amount INTEGER NOT NULL, -- Total pembayaran (misal: 99000 x quantity atau 1069000 x quantity)
  payment_method TEXT DEFAULT 'BCA Transfer',
  bank_account_dest TEXT DEFAULT '8690868653 an Gemmy Adyendra',
  proof_image_url TEXT,
  whatsapp_sender TEXT,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  approved_by UUID REFERENCES auth.users(id),
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Aktifkan RLS pada subscription_orders
ALTER TABLE public.subscription_orders ENABLE ROW LEVEL SECURITY;

-- User bisa melihat riwayat order miliknya sendiri
DROP POLICY IF EXISTS "Users can view own subscription orders" ON public.subscription_orders;
CREATE POLICY "Users can view own subscription orders"
  ON public.subscription_orders FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

-- User bisa membuat order langganan baru
DROP POLICY IF EXISTS "Users can insert own subscription orders" ON public.subscription_orders;
CREATE POLICY "Users can insert own subscription orders"
  ON public.subscription_orders FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- 3. Fungsi Helper SQL untuk Admin mengaktifkan langganan user dengan quantity bulan / tahun
-- Contoh:
-- SELECT activate_user_pro('USER_UUID', 'monthly', 3); -- Aktifkan 3 Bulan
-- SELECT activate_user_pro('USER_UUID', 'yearly', 2);  -- Aktifkan 2 Tahun
CREATE OR REPLACE FUNCTION public.activate_user_pro(
  target_user_id UUID, 
  plan_duration TEXT DEFAULT 'monthly',
  qty INTEGER DEFAULT 1
)
RETURNS VOID AS $$
DECLARE
  current_sub_end TIMESTAMPTZ;
  base_time TIMESTAMPTZ;
  new_expiration TIMESTAMPTZ;
  safe_qty INTEGER := GREATEST(qty, 1);
BEGIN
  -- Cek apakah user sudah punya masa aktif yang belum kedaluwarsa (perpanjangan akumulatif)
  SELECT subscription_ends_at INTO current_sub_end
  FROM public.profiles
  WHERE id = target_user_id;

  IF current_sub_end IS NOT NULL AND current_sub_end > NOW() THEN
    base_time := current_sub_end;
  ELSE
    base_time := NOW();
  END IF;

  IF plan_duration = 'yearly' THEN
    new_expiration := base_time + (safe_qty || ' years')::INTERVAL;
  ELSE
    new_expiration := base_time + (safe_qty * 30 || ' days')::INTERVAL;
  END IF;

  UPDATE public.profiles
  SET 
    subscription_tier = 'pro',
    subscription_status = 'active',
    subscription_ends_at = new_expiration,
    updated_at = NOW()
  WHERE id = target_user_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

