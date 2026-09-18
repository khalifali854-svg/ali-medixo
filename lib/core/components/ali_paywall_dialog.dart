import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:khalif_ali/core/theme/app_theme_tokens.dart';
import 'package:khalif_ali/core/services/subscription_service.dart';
import 'package:khalif_ali/core/services/user_profile_service.dart';
import 'package:khalif_ali/core/services/audio_engine_service.dart';

class AliPaywallDialog extends StatefulWidget {
  final String featureName;
  final String featureDescription;

  const AliPaywallDialog({
    super.key,
    required this.featureName,
    this.featureDescription = 'Buka akses tanpa batas untuk mendampingi tumbuh kembang ananda tercinta.',
  });

  static Future<bool?> show(
    BuildContext context, {
    required String featureName,
    String featureDescription = 'Buka akses tanpa batas untuk mendampingi tumbuh kembang ananda tercinta.',
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AliPaywallDialog(
        featureName: featureName,
        featureDescription: featureDescription,
      ),
    );
  }

  @override
  State<AliPaywallDialog> createState() => _AliPaywallDialogState();
}

class _AliPaywallDialogState extends State<AliPaywallDialog> {
  int _selectedPlanIndex = 1; // Default to Yearly (Best Value)
  int _quantity = 1; // Jumlah bulan atau tahun
  bool _isRedeeming = false;
  final TextEditingController _voucherController = TextEditingController();

  final List<Map<String, dynamic>> _plans = [
    {
      'name': 'Bulanan',
      'unit': 'Bulan',
      'price': SubscriptionService.priceMonthly,
      'duration': 'per bulan',
      'badge': null,
      'originalPrice': null,
      'note': 'Fleksibel bayar tiap bulan',
    },
    {
      'name': 'Tahunan',
      'unit': 'Tahun',
      'price': SubscriptionService.priceYearly,
      'duration': 'per tahun (12 bulan)',
      'badge': '⭐ DISKON 10%',
      'originalPrice': SubscriptionService.originalPriceYearly,
      'note': 'Hemat 10% (Rp 89.000/bln)',
    },
  ];

  @override
  void dispose() {
    _voucherController.dispose();
    super.dispose();
  }

  void _copyAccountNumber() {
    Clipboard.setData(const ClipboardData(text: SubscriptionService.bankAccountNumber));
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✓ Nomor rekening BCA berhasil disalin!'),
        backgroundColor: Color(0xFF15803D),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _openWhatsAppConfirmation() async {
    HapticFeedback.heavyImpact();
    final plan = _plans[_selectedPlanIndex];
    final childName = UserProfileService.childNameNotifier.value;
    final url = SubscriptionService.generateWhatsAppUrl(
      packageName: plan['name'] as String,
      price: plan['price'] as int,
      quantity: _quantity,
      childName: childName,
    );

    final uri = Uri.parse(url);
    bool launched = false;

    try {
      if (await canLaunchUrl(uri)) {
        launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        launched = await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
        );
      }
    } catch (e) {
      debugPrint('Error launching WhatsApp: $e');
    }

    if (!launched && mounted) {
      // Fallback salin nomor jika WhatsApp gagal dibuka langsung
      Clipboard.setData(const ClipboardData(text: SubscriptionService.contactWhatsApp));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nomor WhatsApp ${SubscriptionService.contactWhatsAppFormatted} disalin. Silakan buka aplikasi WhatsApp.'),
          backgroundColor: const Color(0xFF0F172A),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Membuka WhatsApp ke ${SubscriptionService.contactWhatsAppFormatted}...'),
          backgroundColor: const Color(0xFF0F172A),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _redeemCode() async {
    final code = _voucherController.text.trim();
    if (code.isEmpty) return;

    setState(() => _isRedeeming = true);
    final ok = await SubscriptionService.redeemCode(code);
    if (!mounted) return;
    setState(() => _isRedeeming = false);

    if (ok) {
      HapticFeedback.heavyImpact();
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 Selamat! Akun Ali Pro berhasil diaktifkan!'),
          backgroundColor: Color(0xFF15803D),
          behavior: SnackBarBehavior.floating,
        ),
      );
      try {
        AudioEngineService.speakText('Selamat! Akun Ali Pro Anda sudah aktif!');
      } catch (_) {}
    } else {
      HapticFeedback.vibrate();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kode voucher tidak ditemukan atau salah. Silakan periksa kembali.'),
          backgroundColor: Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = _plans[_selectedPlanIndex];

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.92,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          // Drag Handle
          const SizedBox(height: 12),
          Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 12),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Hero Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFACC15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.star_rounded, size: 14, color: Colors.black),
                                  SizedBox(width: 4),
                                  Text(
                                    'AKSES PENUH',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Text(
                              '🔒 FITUR TERKUNCI',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Buka Fitur: ${widget.featureName} ⭐',
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.featureDescription,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFFCBD5E1),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Free vs Pro Notice (Iqro 100% Free guarantee)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFBBF7D0)),
                    ),
                    child: const Row(
                      children: [
                        Text('💚', style: TextStyle(fontSize: 18)),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Modul Belajar Iqro' (Jilid 1 - 6) tetap 100% GRATIS selamanya sebagai amal jariyah.",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF166534),
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Pilih Paket Section
                  const Text(
                    'Pilih Paket Langganan Ali:',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Package Cards List
                  Column(
                    children: List.generate(_plans.length, (idx) {
                      final plan = _plans[idx];
                      final isSelected = idx == _selectedPlanIndex;
                      final badge = plan['badge'] as String?;
                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() {
                            _selectedPlanIndex = idx;
                            _quantity = 1; // reset saat ganti plan
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFFEFCE8) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? const Color(0xFFEAB308) : const Color(0xFFE2E8F0),
                              width: isSelected ? 2.0 : 1.2,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFFEAB308).withOpacity(0.18),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                    color: isSelected ? const Color(0xFFCA8A04) : const Color(0xFF94A3B8),
                                    size: 22,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              plan['name'] as String,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w900,
                                                color: isSelected ? const Color(0xFF854D0E) : const Color(0xFF1E293B),
                                              ),
                                            ),
                                            if (badge != null) ...[
                                              const SizedBox(width: 8),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFEAB308),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                  badge,
                                                  style: const TextStyle(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          plan['note'] as String,
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w500,
                                            color: isSelected ? const Color(0xFFA16207) : const Color(0xFF64748B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Rp ${SubscriptionService.formatRupiah(plan['price'] as int)}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                          color: isSelected ? const Color(0xFF854D0E) : const Color(0xFF0F172A),
                                        ),
                                      ),
                                      Text(
                                        plan['duration'] as String,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Color(0xFF94A3B8),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // Stepper muncul di dalam card saat dipilih
                              AnimatedSize(
                                duration: const Duration(milliseconds: 220),
                                curve: Curves.easeInOut,
                                child: isSelected
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 12),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Berapa ${plan['unit']}?',
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w700,
                                                          color: Color(0xFF92400E),
                                                        ),
                                                      ),
                                                      Text(
                                                        'Total: Rp ${SubscriptionService.formatRupiah((plan['price'] as int) * _quantity)}',
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w900,
                                                          color: Color(0xFF15803D),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(12),
                                                    border: Border.all(color: const Color(0xFFD97706).withOpacity(0.4)),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      IconButton(
                                                        icon: const Icon(Icons.remove, size: 16, color: Color(0xFF92400E)),
                                                        onPressed: _quantity > 1
                                                            ? () {
                                                                HapticFeedback.selectionClick();
                                                                setState(() => _quantity--);
                                                              }
                                                            : null,
                                                        padding: const EdgeInsets.all(6),
                                                        constraints: const BoxConstraints(),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                                        child: Text(
                                                          '$_quantity ${plan['unit']}',
                                                          style: const TextStyle(
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w900,
                                                            color: Color(0xFF78350F),
                                                          ),
                                                        ),
                                                      ),
                                                      IconButton(
                                                        icon: const Icon(Icons.add, size: 16, color: Color(0xFF92400E)),
                                                        onPressed: () {
                                                          HapticFeedback.selectionClick();
                                                          setState(() => _quantity++);
                                                        },
                                                        padding: const EdgeInsets.all(6),
                                                        constraints: const BoxConstraints(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // Smart suggestion: switch ke tahunan saat pilih 12 bulan
                                            AnimatedSize(
                                              duration: const Duration(milliseconds: 250),
                                              curve: Curves.easeInOut,
                                              child: (plan['unit'] == 'Bulan' && _quantity == 12)
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        HapticFeedback.mediumImpact();
                                                        setState(() {
                                                          _selectedPlanIndex = 1; // switch ke Tahunan
                                                          _quantity = 1;
                                                        });
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets.only(top: 10),
                                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                        decoration: BoxDecoration(
                                                          gradient: const LinearGradient(
                                                            colors: [Color(0xFFFEF9C3), Color(0xFFFEF3C7)],
                                                          ),
                                                          borderRadius: BorderRadius.circular(12),
                                                          border: Border.all(color: const Color(0xFFEAB308), width: 1.5),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            const Text('💡', style: TextStyle(fontSize: 14)),
                                                            const SizedBox(width: 8),
                                                            Expanded(
                                                              child: RichText(
                                                                text: TextSpan(
                                                                  style: const TextStyle(fontSize: 12, color: Color(0xFF78350F)),
                                                                  children: [
                                                                    const TextSpan(text: 'Hemat '),
                                                                    TextSpan(
                                                                      text: 'Rp ${SubscriptionService.formatRupiah(SubscriptionService.originalPriceYearly - SubscriptionService.priceYearly)}',
                                                                      style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF15803D)),
                                                                    ),
                                                                    const TextSpan(text: ' dengan Tahunan! '),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            const Text(
                                                              'Ganti →',
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w900,
                                                                color: Color(0xFFCA8A04),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : const SizedBox.shrink(),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),

                  // Bank Payment Details Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Rekening Pembayaran Resmi:',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF334155),
                              ),
                            ),
                            Text(
                              'Bank BCA',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1D4ED8),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  SubscriptionService.bankAccountNumber,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.5,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'a.n. ${SubscriptionService.bankAccountHolder}',
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: _copyAccountNumber,
                              icon: const Icon(Icons.copy_rounded, size: 14),
                              label: const Text('Salin'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0F172A),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Voucher / Activation Code Input
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _voucherController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                            hintText: 'Punya Kode Voucher / Aktivasi?',
                            hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            filled: true,
                            fillColor: const Color(0xFFF1F5F9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _isRedeeming ? null : _redeemCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF475569),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: _isRedeeming
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('Pakai', style: TextStyle(fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Bottom Action Bar: WhatsApp Confirmation Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFF1F5F9), width: 1.5)),
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _openWhatsAppConfirmation,
                  icon: const Icon(Icons.chat_bubble_rounded, size: 20, color: Colors.white),
                  label: Text(
                    'Kirim Bukti Pembayaran (${_quantity > 1 ? "$_quantity ${selected['unit']} - " : ""}Rp ${SubscriptionService.formatRupiah((selected['price'] as int) * _quantity)})',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF22C55E), // WhatsApp Green
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    elevation: 3,
                    shadowColor: const Color(0xFF22C55E).withOpacity(0.4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
