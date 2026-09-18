import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'supabase_service.dart';

class SubscriptionService {
  static const String _prefKeyIsPro = 'ali_is_pro_active';
  static const String _prefKeyTier = 'ali_subscription_tier';
  static const String _prefKeyExpiration = 'ali_pro_expiration';

  // Bank & Contact Info
  static const String bankName = 'BCA';
  static const String bankAccountNumber = '8690868653';
  static const String bankAccountHolder = 'Gemmy Adyendra';
  static const String contactWhatsApp = '081339765775';
  static const String contactWhatsAppFormatted = '+62 813-3976-5775';

  // Pricing
  static const int priceMonthly = 99000;
  // Tahunan: 99.000 x 12 = 1.188.000 - Diskon 10% (118.800) = 1.069.200 (dibulatkan 1.069.000)
  static const int priceYearly = 1069000;
  static const int originalPriceYearly = 1188000;

  // Reactive State Notifier for UI
  static final ValueNotifier<bool> isProNotifier = ValueNotifier<bool>(false);

  /// Inisialisasi awal saat aplikasi dijalankan
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final localPro = prefs.getBool(_prefKeyIsPro) ?? false;
    isProNotifier.value = localPro;

    // Cross-check dengan Supabase jika user sedang login
    try {
      final user = SupabaseService.currentUser;
      if (user != null) {
        final profile = await SupabaseService.getCurrentUserProfile();
        final tier = profile?['subscription_tier']?.toString().toLowerCase();
        final endsAtStr = profile?['subscription_ends_at']?.toString();
        
        bool isExpired = false;
        if (endsAtStr != null && endsAtStr.isNotEmpty) {
          final endsAt = DateTime.tryParse(endsAtStr);
          if (endsAt != null && endsAt.isBefore(DateTime.now())) {
            isExpired = true;
          }
        }

        if (!isExpired && (tier == 'pro' || tier == 'yearly' || tier == 'monthly')) {
          await setProStatus(true, tier: tier ?? 'pro');
        } else if (isExpired || tier == 'free') {
          await setProStatus(false, tier: 'free');
        }
      }
    } catch (_) {}
  }

  static bool get isPro => isProNotifier.value;

  /// Set status pro (misal setelah aktivasi kode atau konfirmasi bayar)
  static Future<void> setProStatus(bool active, {String tier = 'pro'}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKeyIsPro, active);
    await prefs.setString(_prefKeyTier, tier);
    isProNotifier.value = active;

    // Update profil di Supabase jika login
    try {
      if (SupabaseService.currentUser != null) {
        await SupabaseService.updateCurrentUserProfile(
          subscriptionTier: active ? tier : 'free',
        );
      }
    } catch (_) {}
  }

  /// Verifikasi kode aktivasi / voucher manual dari admin
  static Future<bool> redeemCode(String code) async {
    final clean = code.trim().toUpperCase();
    // Master voucher codes for instant offline / admin activation
    if (clean == 'ALIPRO2026' || clean == 'ALIBLESSING' || clean == 'GEMMYPRO') {
      await setProStatus(true, tier: 'pro');
      return true;
    }
    return false;
  }

  /// Format URL WhatsApp dengan template pesan rapi
  static String generateWhatsAppUrl({
    required String packageName,
    required int price,
    int quantity = 1,
    String? childName,
  }) {
    final name = (childName != null && childName.isNotEmpty) ? childName : 'Anak';
    final unitLabel = packageName.toLowerCase().contains('tahun') ? 'Tahun' : 'Bulan';
    final durationText = quantity > 1 ? '$quantity $unitLabel' : packageName;
    final totalAmount = price * quantity;

    final text = Uri.encodeComponent(
      'Halo Kak Gemmy, saya ingin konfirmasi pembayaran *Ali Pro ($durationText - Total Rp ${formatRupiah(totalAmount)})*.\n\n'
      '• Nama Anak: $name\n'
      '• Paket: $packageName ($quantity $unitLabel)\n'
      '• Pembayaran ke: BCA 8690868653 an Gemmy Adyendra\n\n'
      'Berikut saya lampirkan bukti transfernya. Mohon bantuannya untuk aktivasi akun Ali Pro. Terima kasih! 🙏✨',
    );
    return 'https://wa.me/6281339765775?text=$text';
  }

  static String formatRupiah(int amount) {
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}
