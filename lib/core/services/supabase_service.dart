import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/app_config.dart';
import '../../features/aac_board/domain/models/category_model.dart';
import '../../features/aac_board/domain/models/vocab_card_model.dart';
import '../../features/catalog/domain/models/catalog_category_model.dart';
import '../../features/catalog/domain/models/catalog_item_model.dart';
import '../../features/catalog/domain/models/catalog_defaults.dart';
import 'local_cache_service.dart';
import 'r2_storage_service.dart';

class SupabaseService {
  static SupabaseClient? get client {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  static SupabaseClient? get _client => client;

  // Initialize Supabase in main()
  static Future<void> initialize() async {
    try {
      await Supabase.initialize(
        url: AppConfig.supabaseUrl,
        anonKey: AppConfig.supabaseAnonKey,
      );

      // Verify stored session validity; if refresh token is broken, clear local state cleanly
      final client = _client;
      if (client != null && client.auth.currentSession != null) {
        final session = client.auth.currentSession!;
        if (session.isExpired) {
          try {
            await client.auth.refreshSession();
          } catch (e) {
            debugPrint('Local session expired and cannot be refreshed, signing out locally: $e');
            await client.auth.signOut(scope: SignOutScope.local);
          }
        }
      }
    } catch (e) {
      debugPrint('Supabase initialize error or offline: $e');
    }
  }

  // Current logged in user
  static User? get currentUser => _client?.auth.currentUser;

  // Stream auth state changes
  static Stream<AuthState>? get authStateChanges => _client?.auth.onAuthStateChange;

  // Sign in with Google (Native Popup for Web / OAuth for Mobile)
  static Future<bool> signInWithGoogle() async {
    try {
      final client = _client;
      if (client == null) return false;

      // Di Web: Gunakan origin dinamis agar redirect kembali ke domain/port yang sedang aktif
      final redirectUrl = kIsWeb
          ? '${Uri.base.origin}/'
          : 'id.medixo.ali://login-callback/';

      await client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: redirectUrl,
        authScreenLaunchMode: LaunchMode.platformDefault,
      );
      return true;
    } catch (e) {
      debugPrint('Error signInWithGoogle: $e');
      return false;
    }
  }

  // Sign Out
  static Future<void> signOut() async {
    try {
      await _client?.auth.signOut();
    } catch (e) {
      debugPrint('Error signOut: $e');
    }
  }

  // Get current user profile from profiles table
  static Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    try {
      final client = _client;
      final user = client?.auth.currentUser;
      if (client == null || user == null) return null;

      final res = await client.from('profiles').select().eq('id', user.id).maybeSingle();
      return res != null ? Map<String, dynamic>.from(res) : null;
    } on AuthRetryableFetchException catch (_) {
      try {
        await _client?.auth.signOut(scope: SignOutScope.local);
      } catch (_) {}
      return null;
    } catch (e) {
      debugPrint('Error getting current user profile: $e');
      return null;
    }
  }

  // Update current user profile
  static Future<bool> updateCurrentUserProfile({
    String? fullName,
    String? childName,
    String? childAgeGroup,
    String? fatherCall,
    String? motherCall,
    String? siblingCall,
    String? parentPin,
    String? subscriptionTier,
    String? avatarUrl,
  }) async {
    try {
      final client = _client;
      final user = client?.auth.currentUser;
      if (client == null || user == null) return false;

      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      };
      if (fullName != null) updates['full_name'] = fullName;
      if (childName != null) updates['child_name'] = childName;
      if (childAgeGroup != null) updates['child_age_group'] = childAgeGroup;
      if (fatherCall != null) updates['father_call'] = fatherCall;
      if (motherCall != null) updates['mother_call'] = motherCall;
      if (siblingCall != null) updates['sibling_call'] = siblingCall;
      if (parentPin != null) updates['parent_pin'] = parentPin;
      if (subscriptionTier != null) updates['subscription_tier'] = subscriptionTier;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

      await client.from('profiles').update(updates).eq('id', user.id);
      return true;
    } catch (e) {
      debugPrint('Error updating user profile: $e');
      return false;
    }
  }

  // Cek apakah user saat ini berlangganan Pro (atau dalam masa Trial)
  static Future<bool> isCurrentUserPro() async {
    try {
      final client = _client;
      final user = client?.auth.currentUser;
      if (client == null || user == null) return false;

      final res = await client.rpc('is_user_pro', params: {'check_user_id': user.id});
      if (res is bool) return res;

      // Fallback manual check
      final profile = await getCurrentUserProfile();
      if (profile == null) return false;
      final tier = profile['subscription_tier']?.toString();
      final status = profile['subscription_status']?.toString();
      final trialEndsAtStr = profile['trial_ends_at']?.toString();
      if (status == 'active' && tier == 'pro') return true;
      if (tier == 'trial' && trialEndsAtStr != null) {
        final end = DateTime.tryParse(trialEndsAtStr);
        if (end != null && end.isAfter(DateTime.now())) return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error checking isCurrentUserPro: $e');
      return false;
    }
  }

  // Stream Categories with Realtime updates
  static Stream<List<CategoryModel>> streamCategories() {
    final client = _client;
    if (client == null) return const Stream.empty();
    return client
        .from('categories')
        .stream(primaryKey: ['id'])
        .order('sort_order', ascending: true)
        .map((maps) => maps.map((item) => CategoryModel.fromJson(item)).toList());
  }

  // Get Categories
  static Future<List<CategoryModel>> getCategories() async {
    try {
      final client = _client;
      if (client == null) return [];
      final res = await client.from('categories').select().order('sort_order', ascending: true);
      return (res as List).map((m) => CategoryModel.fromJson(Map<String, dynamic>.from(m as Map))).toList();
    } catch (e) {
      debugPrint('Error getting categories: $e');
      return [];
    }
  }

  // Insert Category with user_id & native UUID
  static Future<String?> insertCategory(String name) async {
    try {
      final client = _client;
      if (client == null) return null;
      final user = client.auth.currentUser;

      final res = await client.from('categories').insert({
        'name': name,
        'icon_name': 'grid_1',
        if (user != null) 'user_id': user.id,
      }).select('id').single();
      return res['id']?.toString();
    } catch (e) {
      debugPrint('Error inserting category: $e');
      return null;
    }
  }

  // Stream Vocab Cards with Realtime updates (Multi-tenant merged per user)
  static Stream<List<VocabCardModel>> streamVocabCards() {
    final client = _client;
    if (client == null) return const Stream.empty();
    final user = client.auth.currentUser;

    return client
        .from('vocab_cards')
        .stream(primaryKey: ['id'])
        .order('sort_order', ascending: true)
        .map((maps) {
          final allCards = maps.map((item) => VocabCardModel.fromJson(item)).toList();
          final systemCards = allCards.where((c) => c.isSystem || c.userId == null).toList();
          final userCards = user != null
              ? allCards.where((c) => c.userId == user.id && !c.isSystem).toList()
              : <VocabCardModel>[];
          return mergeVocabCards(systemCards: systemCards, userCards: userCards);
        });
  }

  /// Upload audio file exclusively to Cloudflare R2 CDN (https://ali.medixo.id)
  static Future<String?> uploadAudio({
    required Uint8List bytes,
    required String fileName,
  }) async {
    try {
      final r2Url = await R2StorageService.uploadFile(
        bytes: bytes,
        path: 'audio_voices/$fileName',
        contentType: 'audio/mp4',
      ).timeout(const Duration(seconds: 12));
      if (r2Url != null && r2Url.isNotEmpty) {
        debugPrint('Berhasil upload audio ke Cloudflare R2: $r2Url');
        return r2Url;
      }
    } catch (e) {
      debugPrint('Error upload audio ke Cloudflare R2: $e');
    }

    // Fallback darurat: Data URI base64 agar rekaman audio tidak hilang
    debugPrint('Menyimpan audio sebagai data URI base64');
    return 'data:audio/mp4;base64,${base64Encode(bytes)}';
  }

  /// Upload image file exclusively to Cloudflare R2 CDN (https://ali.medixo.id)
  static Future<String?> uploadImage({
    required Uint8List bytes,
    required String fileName,
  }) async {
    try {
      final r2Url = await R2StorageService.uploadFile(
        bytes: bytes,
        path: 'photos/$fileName',
        contentType: 'image/jpeg',
      ).timeout(const Duration(seconds: 12));
      if (r2Url != null && r2Url.isNotEmpty) {
        debugPrint('Berhasil upload foto ke Cloudflare R2: $r2Url');
        return r2Url;
      }
    } catch (e) {
      debugPrint('Error upload foto ke Cloudflare R2: $e');
    }

    // Fallback darurat: Data URI base64
    return 'data:image/jpeg;base64,${base64Encode(bytes)}';
  }

  /// Deterministic Merge: Kartu Sistem Default di-override oleh Kartu Pribadi Akun
  static List<VocabCardModel> mergeVocabCards({
    required List<VocabCardModel> systemCards,
    required List<VocabCardModel> userCards,
  }) {
    final Map<String, VocabCardModel> overrideMap = {};
    final List<VocabCardModel> customCards = [];

    for (final card in userCards) {
      if (card.isDeleted) continue;
      if (card.originalCardId != null && card.originalCardId!.isNotEmpty) {
        overrideMap[card.originalCardId!] = card;
      } else {
        customCards.add(card);
      }
    }

    final List<VocabCardModel> result = [];
    for (final sysCard in systemCards) {
      if (overrideMap.containsKey(sysCard.id)) {
        result.add(overrideMap[sysCard.id]!);
      } else {
        result.add(sysCard);
      }
    }

    result.addAll(customCards);
    result.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return result;
  }

  // Fetch Vocab Cards via direct REST query (reliable for Web initialization & Multi-Tenant)
  static Future<List<VocabCardModel>> getVocabCards() async {
    try {
      final client = _client;
      if (client == null) return [];
      final user = client.auth.currentUser;

      // 1. Fetch system default cards (is_system = true OR user_id IS NULL)
      final systemRes = await client
          .from('vocab_cards')
          .select()
          .or('is_system.eq.true,user_id.is.null')
          .order('sort_order', ascending: true);

      final systemCards = (systemRes as List)
          .map((item) => VocabCardModel.fromJson(Map<String, dynamic>.from(item as Map)))
          .where((c) => c.isSystem || c.userId == null)
          .toList();

      // If user is guest/unauthenticated, return default system cards directly
      if (user == null) {
        return systemCards;
      }

      // 2. Fetch cards belonging to this logged-in account
      final userRes = await client
          .from('vocab_cards')
          .select()
          .eq('user_id', user.id)
          .eq('is_system', false);

      final userCards = (userRes as List)
          .map((item) => VocabCardModel.fromJson(Map<String, dynamic>.from(item as Map)))
          .where((c) => c.userId == user.id && !c.isSystem)
          .toList();

      return mergeVocabCards(systemCards: systemCards, userCards: userCards);
    } catch (e) {
      debugPrint('Error getting vocab cards: $e');
      return [];
    }
  }

  // Add new Vocab Card with Dual Voice Sources & user_id linkage
  static Future<bool> insertVocabCard({
    required String categoryId,
    required String label,
    required String imageUrl,
    String? audioAbiUrl,
    String? audioUmmaUrl,
    String createdBy = 'abi',
  }) async {
    try {
      final client = _client;
      if (client == null) return false;
      final user = client.auth.currentUser;

      final baseData = <String, dynamic>{
        'category_id': categoryId,
        'label': label,
        'image_url': imageUrl,
        'audio_abi_url': audioAbiUrl,
        'audio_umma_url': audioUmmaUrl,
        'audio_url': audioAbiUrl ?? audioUmmaUrl,
        'created_by': createdBy,
        if (user != null) 'user_id': user.id,
        'is_system': false,
        'is_deleted': false,
      };

      try {
        await client.from('vocab_cards').insert(baseData);
        debugPrint('Berhasil insert custom vocab card ke Supabase');
        return true;
      } catch (insertErr) {
        debugPrint('Insert custom vocab card catatan: $insertErr. Mencoba fallback...');
        baseData.remove('is_deleted');
        await client.from('vocab_cards').insert(baseData);
        debugPrint('Berhasil insert custom vocab card (fallback) ke Supabase');
        return true;
      }
    } catch (e) {
      debugPrint('Error inserting vocab card: $e');
      return false;
    }
  }

  /// Simpan perubahan kartu kosa kata dengan pola Copy-on-Write (CoW).
  /// Kartu sistem bawaan TIDAK AKAN PERNAH ditimpa.
  /// Pengguna akan mendapatkan baris kustom tersendiri yang terisolasi dari pengguna lain.
  static Future<VocabCardModel?> saveCardModification({
    required VocabCardModel card,
    required String label,
    required String imageUrl,
    String? categoryId,
    String? audioAbiUrl,
    String? audioUmmaUrl,
  }) async {
    try {
      final client = _client;
      if (client == null) return null;
      final user = client.auth.currentUser;

      final targetCat = categoryId ?? card.categoryId;
      final effectiveAudioAbi = audioAbiUrl ?? card.audioAbiUrl;
      final effectiveAudioUmma = audioUmmaUrl ?? card.audioUmmaUrl;
      final effectiveAudioUrl = effectiveAudioAbi ?? effectiveAudioUmma;

      if (user != null) {
        // Cek apakah kartu ini kartu sistem bawaan
        final isSystemCard = card.isSystem || card.userId == null || card.userId != user.id;

        if (isSystemCard) {
          // 1. Copy-on-Write: Cek apakah user sudah punya override untuk kartu sistem ini
          String? existingOverrideId;
          try {
            final checkRes = await client
                .from('vocab_cards')
                .select('id')
                .eq('user_id', user.id)
                .eq('original_card_id', card.id)
                .maybeSingle();
            if (checkRes != null) {
              existingOverrideId = checkRes['id']?.toString();
            }
          } catch (_) {
            // Fallback jika kolom original_card_id belum ada di DB
            try {
              final checkRes = await client
                  .from('vocab_cards')
                  .select('id')
                  .eq('user_id', user.id)
                  .eq('created_by', 'override:${card.id}')
                  .maybeSingle();
              if (checkRes != null) {
                existingOverrideId = checkRes['id']?.toString();
              }
            } catch (_) {}
          }

          if (existingOverrideId != null) {
            // Update override yang sudah ada milik user
            final updateData = <String, dynamic>{
              'label': label,
              'image_url': imageUrl,
              'category_id': targetCat,
              'audio_abi_url': effectiveAudioAbi,
              'audio_umma_url': effectiveAudioUmma,
              'audio_url': effectiveAudioUrl,
              'is_deleted': false,
            };
            await client.from('vocab_cards').update(updateData).eq('id', existingOverrideId);
            debugPrint('Berhasil update existing override [$existingOverrideId] untuk kartu ${card.id}');
            return card.copyWith(
              id: existingOverrideId,
              label: label,
              imageUrl: imageUrl,
              categoryId: targetCat,
              audioAbiUrl: effectiveAudioAbi,
              audioUmmaUrl: effectiveAudioUmma,
              userId: user.id,
              isSystem: false,
              originalCardId: card.id,
              isDeleted: false,
            );
          } else {
            // Buat baris Copy-on-Write baru untuk akun ini
            final insertData = <String, dynamic>{
              'user_id': user.id,
              'is_system': false,
              'original_card_id': card.id,
              'category_id': targetCat,
              'label': label,
              'image_url': imageUrl,
              'audio_abi_url': effectiveAudioAbi,
              'audio_umma_url': effectiveAudioUmma,
              'audio_url': effectiveAudioUrl,
              'sort_order': card.sortOrder,
              'created_by': 'override:${card.id}',
              'is_favorite': card.isFavorite,
              'is_deleted': false,
            };

            Map<String, dynamic>? insertedRow;
            try {
              final res = await client.from('vocab_cards').insert(insertData).select().single();
              insertedRow = Map<String, dynamic>.from(res as Map);
            } catch (err) {
              debugPrint('Insert dengan original_card_id catatan: $err. Mencoba fallback...');
              insertData.remove('original_card_id');
              insertData.remove('is_deleted');
              final res = await client.from('vocab_cards').insert(insertData).select().single();
              insertedRow = Map<String, dynamic>.from(res as Map);
            }

            final newId = insertedRow['id']?.toString() ?? 'custom_${DateTime.now().millisecondsSinceEpoch}';
            debugPrint('Berhasil buat CoW override baru [$newId] untuk kartu bawaan [${card.id}]');
            return card.copyWith(
              id: newId,
              label: label,
              imageUrl: imageUrl,
              categoryId: targetCat,
              audioAbiUrl: effectiveAudioAbi,
              audioUmmaUrl: effectiveAudioUmma,
              userId: user.id,
              isSystem: false,
              originalCardId: card.id,
              isDeleted: false,
            );
          }
        } else {
          // Kartu ini sudah merupakan kartu kustom milik akun yang login
          final updateData = <String, dynamic>{
            'label': label,
            'image_url': imageUrl,
            'category_id': targetCat,
            'audio_abi_url': effectiveAudioAbi,
            'audio_umma_url': effectiveAudioUmma,
            'audio_url': effectiveAudioUrl,
          };
          await client.from('vocab_cards').update(updateData).eq('id', card.id);
          debugPrint('Berhasil update kartu milik user [${card.id}]');
          return card.copyWith(
            label: label,
            imageUrl: imageUrl,
            categoryId: targetCat,
            audioAbiUrl: effectiveAudioAbi,
            audioUmmaUrl: effectiveAudioUmma,
          );
        }
      } else {
        // Mode offline / guest: kembalikan kartu dengan mutasi in-memory
        return card.copyWith(
          label: label,
          imageUrl: imageUrl,
          categoryId: targetCat,
          audioAbiUrl: effectiveAudioAbi,
          audioUmmaUrl: effectiveAudioUmma,
        );
      }
    } catch (e) {
      debugPrint('Error saveCardModification: $e');
      return null;
    }
  }

  /// Kembalikan kartu yang telah dikustomisasi ke kartu bawaan sistem (Reset to Default)
  static Future<bool> resetCardToDefault(String overrideCardId) async {
    try {
      final client = _client;
      if (client == null) return false;
      final user = client.auth.currentUser;
      if (user == null) return false;

      await client
          .from('vocab_cards')
          .delete()
          .eq('id', overrideCardId)
          .eq('user_id', user.id);
      debugPrint('Berhasil reset override kartu [$overrideCardId] ke kartu default sistem');
      return true;
    } catch (e) {
      debugPrint('Error resetCardToDefault: $e');
      return false;
    }
  }

  /// Hapus kartu kosa kata buatan pengguna
  static Future<bool> deleteVocabCard(String cardId) async {
    try {
      final client = _client;
      if (client == null) return false;
      final user = client.auth.currentUser;
      if (user == null) return false;

      await client
          .from('vocab_cards')
          .delete()
          .eq('id', cardId)
          .eq('user_id', user.id);
      debugPrint('Berhasil menghapus kartu [$cardId]');
      return true;
    } catch (e) {
      debugPrint('Error deleteVocabCard: $e');
      return false;
    }
  }

  // Update existing Vocab Card (Backward compatibility wrapper)
  static Future<bool> updateVocabCard({
    required String cardId,
    required String label,
    required String imageUrl,
    String? categoryId,
    String? audioAbiUrl,
    String? audioUmmaUrl,
  }) async {
    try {
      final client = _client;
      if (client == null) return false;
      final updateData = <String, dynamic>{
        'label': label,
        'image_url': imageUrl,
      };
      if (categoryId != null) updateData['category_id'] = categoryId;
      if (audioAbiUrl != null) updateData['audio_abi_url'] = audioAbiUrl;
      if (audioUmmaUrl != null) updateData['audio_umma_url'] = audioUmmaUrl;
      if (audioAbiUrl != null || audioUmmaUrl != null) {
        updateData['audio_url'] = audioAbiUrl ?? audioUmmaUrl;
      }
      await client.from('vocab_cards').update(updateData).eq('id', cardId);
      debugPrint('Berhasil update vocab_cards di Supabase [ID: $cardId]');
      return true;
    } catch (e) {
      debugPrint('Error updating vocab card: $e');
      return false;
    }
  }

  // Log usage when Ali touches a card for Abi's emotional analytics
  static Future<void> logCardUsage(String cardId) async {
    try {
      final client = _client;
      if (client == null) return;
      final user = client.auth.currentUser;
      await client.from('usage_logs').insert({
        'card_id': cardId,
        if (user != null) 'user_id': user.id,
      });
    } catch (e) {
      debugPrint('Error logging usage: $e');
    }
  }

  // Stream Writing Items per Level (Realtime)
  static Stream<List<Map<String, dynamic>>> streamWritingItems(int levelType) {
    final client = _client;
    if (client == null) return const Stream.empty();
    return client
        .from('writing_items')
        .stream(primaryKey: ['id'])
        .eq('level_type', levelType)
        .order('sort_order', ascending: true);
  }

  // Insert Custom Writing Item (Level 4 & 5)
  static Future<bool> insertWritingItem({
    required int levelType,
    required String targetText,
    String? hintLabel,
    String? imageUrl,
    String? audioUrl,
    String createdBy = 'abi',
  }) async {
    try {
      final client = _client;
      if (client == null) return false;
      final user = client.auth.currentUser;
      await client.from('writing_items').insert({
        'level_type': levelType,
        'target_text': targetText.toUpperCase().trim(),
        'hint_label': hintLabel,
        'image_url': imageUrl,
        'audio_url': audioUrl,
        'is_custom': true,
        'created_by': createdBy,
        if (user != null) 'user_id': user.id,
      });
      return true;
    } catch (e) {
      debugPrint('Error inserting writing item: $e');
      return false;
    }
  }

  // Delete Custom Writing Item
  static Future<bool> deleteWritingItem(String id) async {
    try {
      final client = _client;
      if (client == null) return false;
      await client.from('writing_items').delete().eq('id', id);
      return true;
    } catch (e) {
      debugPrint('Error deleting writing item: $e');
      return false;
    }
  }

  // ============================================================================
  // App Settings (Supabase Persistence for Language & Voice Settings)
  // ============================================================================

  /// Ambil nilai setting dari Supabase berdasarkan key
  static Future<dynamic> getAppSetting(String key) async {
    try {
      final client = _client;
      if (client == null) return null;
      final user = currentUser;
      
      // Jika user belum login, jangan query baris global tanpa filter user_id
      // karena akan mengembalikan multiple rows dari user lain (error 406)
      if (user == null) {
        return null;
      }

      // Filter by user_id agar setting user A tidak bocor ke user B
      final res = await client
          .from('app_settings')
          .select('value')
          .eq('key', key)
          .eq('user_id', user.id)
          .limit(1);
      
      if (res.isNotEmpty && res.first['value'] != null) {
        return res.first['value'];
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching app setting ($key): $e');
      return null;
    }
  }

  /// Simpan atau perbarui nilai setting ke Supabase per-user (Upsert)
  static Future<bool> setAppSetting(String key, dynamic value) async {
    try {
      final client = _client;
      if (client == null) return false;
      final user = currentUser;
      if (user == null) return false; // Harus login untuk simpan setting
      await client.from('app_settings').upsert({
        'user_id': user.id,
        'key': key,
        'value': value,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }, onConflict: 'user_id,key'); // composite unique (user_id, key)
      return true;
    } catch (e) {
      debugPrint('Error saving app setting ($key): $e');
      return false;
    }
  }

  /// Stream perubahan setting realtime dari Supabase — hanya milik user ini
  static Stream<Map<String, dynamic>> streamAppSettings() {
    final client = _client;
    if (client == null) return const Stream.empty();
    final user = currentUser;
    if (user == null) return const Stream.empty();
    return client
        .from('app_settings')
        .stream(primaryKey: ['user_id', 'key'])
        .eq('user_id', user.id)
        .handleError((err) {
          debugPrint('app_settings stream error: $err');
        })
        .map((list) {
          final map = <String, dynamic>{};
          for (final item in list) {
            if (item['key'] != null) {
              map[item['key'].toString()] = item['value'];
            }
          }
          return map;
        });
  }

  // ================= OFFICIAL CATALOG SERVICE =================

  /// Stream Official Catalog Categories
  static Stream<List<CatalogCategoryModel>> streamCatalogCategories() {
    final client = _client;
    if (client == null) return const Stream.empty();
    return client
        .from('catalog_categories')
        .stream(primaryKey: ['id'])
        .order('sort_order', ascending: true)
        .map((maps) => maps.map((item) => CatalogCategoryModel.fromJson(item)).toList());
  }

  /// Get Catalog Categories with local fallback
  static Future<List<CatalogCategoryModel>> getCatalogCategories() async {
    try {
      final client = _client;
      if (client != null) {
        final res = await client
            .from('catalog_categories')
            .select()
            .order('sort_order', ascending: true);
        final list = (res as List)
            .map((item) => CatalogCategoryModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
        if (list.isNotEmpty) {
          await LocalCacheService.cacheCatalogCategories(list);
          return list;
        }
      }
    } catch (e) {
      debugPrint('Error getting catalog categories from Supabase: $e');
    }
    // Try SQLite cache first
    final cached = await LocalCacheService.getCachedCatalogCategories();
    if (cached.isNotEmpty) return cached;
    // Final fallback: bundled asset
    return LocalCacheService.loadBundledCatalogCategories();
  }

  /// Stream Official Catalog Items
  static Stream<List<CatalogItemModel>> streamCatalogItems({String? categoryId}) {
    final client = _client;
    if (client == null) return const Stream.empty();
    var query = client.from('catalog_items').stream(primaryKey: ['id']);
    return query.order('name', ascending: true).map((maps) {
      var list = maps.map((item) => CatalogItemModel.fromJson(item)).toList();
      if (categoryId != null) {
        list = list.where((i) => i.categoryId == categoryId).toList();
      }
      return CatalogDefaults.sortCatalogItems(list);
    });
  }

  /// Get Catalog Items by Category with local fallback
  static Future<List<CatalogItemModel>> getCatalogItems({String? categoryId}) async {
    try {
      final client = _client;
      if (client != null) {
        var query = client.from('catalog_items').select().eq('is_active', true);
        if (categoryId != null) {
          query = query.eq('category_id', categoryId);
        }
        final res = await query.order('name', ascending: true);
        final list = (res as List)
            .map((item) => CatalogItemModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
        if (list.isNotEmpty) {
          final sortedList = CatalogDefaults.sortCatalogItems(list);
          await LocalCacheService.cacheCatalogItems(sortedList);
          return sortedList;
        }
      }
    } catch (e) {
      debugPrint('Error getting catalog items from Supabase: $e');
    }
    // Try SQLite cache first
    final cached = await LocalCacheService.getCachedCatalogItems(categoryId: categoryId);
    if (cached.isNotEmpty) return CatalogDefaults.sortCatalogItems(cached);
    // Final fallback: bundled asset (always works offline / fresh install)
    final bundled = await LocalCacheService.loadBundledCatalogItems(categoryId: categoryId);
    return CatalogDefaults.sortCatalogItems(bundled);
  }

  /// Insert new Catalog Item (persists to Supabase & local cache)
  static Future<bool> insertCatalogItem({
    required String categoryId,
    required String name,
    required String imageUrl,
    String? phonics,
    List<String> syllables = const [],
    String? emoji,
    int difficulty = 1,
  }) async {
    try {
      final client = _client;
      final itemId = 'cat_${DateTime.now().millisecondsSinceEpoch}';
      final item = CatalogItemModel(
        id: itemId,
        categoryId: categoryId,
        name: name,
        imageUrl: imageUrl,
        phonics: phonics ?? syllables.join(' • '),
        syllables: syllables,
        emoji: emoji,
        difficulty: difficulty,
        isActive: true,
      );

      if (client != null) {
        await client.from('catalog_items').insert({
          'id': itemId,
          'category_id': categoryId,
          'name': name,
          'image_url': imageUrl,
          'phonics': item.phonics,
          'syllables': jsonEncode(syllables),
          'emoji': emoji,
          'difficulty': difficulty,
          'is_active': true,
        });
      }

      await LocalCacheService.cacheCatalogItems([item]);
      return true;
    } catch (e) {
      debugPrint('Error inserting catalog item: $e');
      return false;
    }
  }

  /// Update Full Catalog Item (name, category, image, syllables, phonics, etc.)
  static Future<bool> updateCatalogItem(CatalogItemModel item) async {
    try {
      final client = _client;
      if (client != null) {
        final updateData = <String, dynamic>{
          'id': item.id,
          'category_id': item.categoryId,
          'name': item.name,
          'image_url': item.imageUrl,
          'phonics': item.phonics,
          'syllables': jsonEncode(item.syllables),
          'emoji': item.emoji,
          'difficulty': item.difficulty,
          'is_active': item.isActive,
        };
        if (item.audioUrl != null && item.audioUrl!.isNotEmpty) {
          updateData['audio_url'] = item.audioUrl;
        }

        try {
          await client.from('catalog_items').upsert(updateData);
          debugPrint('Berhasil upsert catalog_items di Supabase: ${item.name} [audio: ${item.audioUrl != null}]');
        } catch (e) {
          debugPrint('Catatan upsert catalog_items dengan audio_url: $e');
          if (updateData.containsKey('audio_url')) {
            updateData.remove('audio_url');
            try {
              await client.from('catalog_items').upsert(updateData);
              debugPrint('Berhasil upsert catalog_items di Supabase tanpa kolom audio_url');
            } catch (_) {}
          }
        }
      }
      await LocalCacheService.updateCatalogItem(item);
      return true;
    } catch (e) {
      debugPrint('Error updating catalog item: $e');
      return false;
    }
  }

  /// Delete Catalog Item
  static Future<bool> deleteCatalogItem(String itemId) async {
    try {
      final client = _client;
      if (client != null) {
        await client.from('catalog_items').delete().eq('id', itemId);
      }
      await LocalCacheService.deleteCatalogItem(itemId);
      return true;
    } catch (e) {
      debugPrint('Error deleting catalog item: $e');
      return false;
    }
  }

  /// Save Drawing to Supabase (table: ali_canvas_art)
  /// Returns the saved/generated UUID String if successful, or null on failure.
  static Future<String?> saveDrawing({
    String? id,
    required String title,
    required dynamic strokeData,
    String? imageUrl,
  }) async {
    try {
      final client = _client;
      if (client == null) return null;

      final user = client.auth.currentUser;
      final data = <String, dynamic>{
        'label': title,
        'stroke_data': strokeData is String ? jsonDecode(strokeData) : strokeData,
        'image_url': imageUrl,
      };

      if (user != null) {
        data['user_id'] = user.id;
      }

      // If a valid 36-char UUID is provided, upsert with it
      final uuidRegex = RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$');
      if (id != null && uuidRegex.hasMatch(id)) {
        data['id'] = id;
        final res = await client.from('ali_canvas_art').upsert(data).select('id').single();
        return res['id']?.toString() ?? id;
      } else {
        // Let Supabase generate a new UUID
        final res = await client.from('ali_canvas_art').insert(data).select('id').single();
        return res['id']?.toString();
      }
    } catch (e) {
      debugPrint('Error saving drawing to Supabase: $e');
      return null;
    }
  }

  /// Get Saved Drawings from Supabase (table: ali_canvas_art)
  static Future<List<Map<String, dynamic>>> getSavedDrawings() async {
    try {
      final client = _client;
      if (client == null) return [];
      final res = await client
          .from('ali_canvas_art')
          .select()
          .order('created_at', ascending: false);
      return (res as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (e) {
      debugPrint('Error fetching saved drawings from Supabase: $e');
      return [];
    }
  }

  /// Delete Saved Drawing from Supabase (table: ali_canvas_art)
  static Future<bool> deleteSavedDrawing(String id) async {
    try {
      final client = _client;
      if (client == null) return false;

      // Only invoke Supabase delete if id is a valid UUID to prevent Postgres 22P02 error
      final uuidRegex = RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$');
      if (!uuidRegex.hasMatch(id)) {
        debugPrint('Skip Supabase delete: "$id" is not a valid UUID format (likely local-only draft).');
        return true;
      }

      await client.from('ali_canvas_art').delete().eq('id', id);
      return true;
    } catch (e) {
      debugPrint('Error deleting drawing from Supabase: $e');
      return false;
    }
  }

  // ============================================================================
  // USER SCHEDULE & ROUTINE CLOUD SYNC (PER AKUN)
  // ============================================================================
  static Future<bool> saveUserSchedule({
    required String scheduleType, // 'first_then' or 'daily_routine'
    dynamic firstItem,
    dynamic thenItem,
    List<dynamic>? routineItems,
  }) async {
    try {
      final client = _client;
      final user = client?.auth.currentUser;
      if (client == null || user == null) return false;

      await client.from('user_schedules').upsert({
        'user_id': user.id,
        'schedule_type': scheduleType,
        'first_item': firstItem,
        'then_item': thenItem,
        'routine_items': routineItems ?? [],
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }, onConflict: 'user_id, schedule_type');
      return true;
    } catch (e) {
      debugPrint('Error saving user schedule to Supabase: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getUserSchedule(String scheduleType) async {
    try {
      final client = _client;
      final user = client?.auth.currentUser;
      if (client == null || user == null) return null;

      final res = await client
          .from('user_schedules')
          .select()
          .eq('user_id', user.id)
          .eq('schedule_type', scheduleType)
          .maybeSingle();
      return res != null ? Map<String, dynamic>.from(res) : null;
    } catch (e) {
      debugPrint('Error getting user schedule from Supabase: $e');
      return null;
    }
  }

  // ============================================================================
  // USER CHOICE BOARD CLOUD SYNC (PER AKUN)
  // ============================================================================
  static Future<bool> saveUserChoiceBoard({
    required List<dynamic> twoChoices,
    required List<dynamic> fourChoices,
    String? lastSelectedId,
  }) async {
    try {
      final client = _client;
      final user = client?.auth.currentUser;
      if (client == null || user == null) return false;

      await client.from('user_choice_boards').upsert({
        'user_id': user.id,
        'two_choices': twoChoices,
        'four_choices': fourChoices,
        'last_selected_id': lastSelectedId,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }, onConflict: 'user_id');
      return true;
    } catch (e) {
      debugPrint('Error saving user choice board to Supabase: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getUserChoiceBoard() async {
    try {
      final client = _client;
      final user = client?.auth.currentUser;
      if (client == null || user == null) return null;

      final res = await client
          .from('user_choice_boards')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();
      return res != null ? Map<String, dynamic>.from(res) : null;
    } catch (e) {
      debugPrint('Error getting user choice board from Supabase: $e');
      return null;
    }
  }

  // ============================================================================
  // CHILD TELEMETRY & PROGRESS TRACKING
  // ============================================================================
  static Future<void> logChildActivity({
    required String activityType, // 'aac_speech', 'choice_made', 'schedule_completed', 'guess_game_speech', 'writing_tracing', 'drawing_art'
    required String targetLabel,
    String? category,
    bool success = true,
    int? latencyMs,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final client = _client;
      final user = client?.auth.currentUser;
      if (client == null || user == null) return;

      await client.from('child_activity_logs').insert({
        'user_id': user.id,
        'activity_type': activityType,
        'target_label': targetLabel,
        'category': category,
        'success': success,
        'latency_ms': latencyMs,
        'metadata': metadata ?? {},
      });
    } catch (e) {
      debugPrint('Error logging child activity: $e');
    }
  }

  /// Ambil riwayat aktivitas anak untuk Progress Dashboard
  static Future<List<Map<String, dynamic>>> getChildActivityLogs({int limit = 100}) async {
    try {
      final client = _client;
      final user = client?.auth.currentUser;
      if (client == null || user == null) return [];

      final res = await client
          .from('child_activity_logs')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false)
          .limit(limit);
      return (res as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } on AuthRetryableFetchException catch (e) {
      debugPrint('Supabase auth token expired or invalid, clearing stale session: $e');
      try {
        await _client?.auth.signOut(scope: SignOutScope.local);
      } catch (_) {}
      return [];
    } on AuthException catch (e) {
      debugPrint('Supabase auth session error: ${e.message}');
      return [];
    } catch (e) {
      debugPrint('Error getting child activity logs: $e');
      return [];
    }
  }
}


