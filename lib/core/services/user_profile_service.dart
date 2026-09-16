import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'supabase_service.dart';

/// Service untuk mengelola profil anak, panggilan orang tua & saudara secara dinamis
class UserProfileService {
  // Nilai default
  static String childName = 'Ali';
  static String fatherCall = 'Abi';
  static String motherCall = 'Umma';
  static String siblingCall = 'Alesha';

  /// Notifier untuk auto-update UI di mana saja saat profil berubah
  static final ValueNotifier<String> childNameNotifier = ValueNotifier<String>('Ali');

  static bool _isLoaded = false;

  /// Inisialisasi dan ambil data dari cache lokal & Supabase
  static Future<void> initialize() async {
    if (_isLoaded) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final localChild = prefs.getString('profile_child_name');
      if (localChild != null && localChild.isNotEmpty) {
        childName = localChild;
        childNameNotifier.value = localChild;
      }
      final localFather = prefs.getString('profile_father_call');
      if (localFather != null && localFather.isNotEmpty) fatherCall = localFather;
      final localMother = prefs.getString('profile_mother_call');
      if (localMother != null && localMother.isNotEmpty) motherCall = localMother;
      final localSibling = prefs.getString('profile_sibling_call');
      if (localSibling != null && localSibling.isNotEmpty) siblingCall = localSibling;
      final savedChild = await SupabaseService.getAppSetting('profile_child_name');
      if (savedChild != null && savedChild.toString().isNotEmpty) {
        childName = savedChild.toString();
        childNameNotifier.value = childName;
      }

      final savedFather = await SupabaseService.getAppSetting('profile_father_call');
      if (savedFather != null && savedFather.toString().isNotEmpty) {
        fatherCall = savedFather.toString();
      }

      final savedMother = await SupabaseService.getAppSetting('profile_mother_call');
      if (savedMother != null && savedMother.toString().isNotEmpty) {
        motherCall = savedMother.toString();
      }

      final savedSibling = await SupabaseService.getAppSetting('profile_sibling_call');
      if (savedSibling != null && savedSibling.toString().isNotEmpty) {
        siblingCall = savedSibling.toString();
      }

      _isLoaded = true;

      // Dengarkan perubahan realtime dari Supabase dengan error handler aman
      SupabaseService.streamAppSettings().listen(
        (settings) {
          if (settings.containsKey('profile_child_name')) {
            final val = settings['profile_child_name']?.toString();
            if (val != null && val.isNotEmpty) {
              childName = val;
              childNameNotifier.value = val;
            }
          }
          if (settings.containsKey('profile_father_call')) {
            fatherCall = settings['profile_father_call']?.toString() ?? fatherCall;
          }
          if (settings.containsKey('profile_mother_call')) {
            motherCall = settings['profile_mother_call']?.toString() ?? motherCall;
          }
          if (settings.containsKey('profile_sibling_call')) {
            siblingCall = settings['profile_sibling_call']?.toString() ?? siblingCall;
          }
        },
        onError: (err) {
          debugPrint('streamAppSettings error (table may not exist yet): $err');
        },
      );
    } catch (e) {
      debugPrint('UserProfileService init error: $e');
    }
  }

  /// Simpan pembaruan profil ke Supabase & Local Cache SharedPreferences
  static Future<void> updateProfile({
    required String newChildName,
    required String newFatherCall,
    required String newMotherCall,
    required String newSiblingCall,
  }) async {
    childName = newChildName.trim().isNotEmpty ? newChildName.trim() : childName;
    childNameNotifier.value = childName;
    fatherCall = newFatherCall.trim().isNotEmpty ? newFatherCall.trim() : fatherCall;
    motherCall = newMotherCall.trim().isNotEmpty ? newMotherCall.trim() : motherCall;
    siblingCall = newSiblingCall.trim().isNotEmpty ? newSiblingCall.trim() : siblingCall;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_child_name', childName);
      await prefs.setString('profile_father_call', fatherCall);
      await prefs.setString('profile_mother_call', motherCall);
      await prefs.setString('profile_sibling_call', siblingCall);
    } catch (e) {
      debugPrint('Local prefs save note: $e');
    }

    try {
      await SupabaseService.setAppSetting('profile_child_name', childName);
      await SupabaseService.setAppSetting('profile_father_call', fatherCall);
      await SupabaseService.setAppSetting('profile_mother_call', motherCall);
      await SupabaseService.setAppSetting('profile_sibling_call', siblingCall);
    } catch (e) {
      debugPrint('Supabase profile save note: $e');
    }
  }
}
