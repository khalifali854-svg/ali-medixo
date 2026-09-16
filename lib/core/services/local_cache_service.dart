import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'dart:convert';
import '../../features/aac_board/domain/models/vocab_card_model.dart';
import '../../features/catalog/domain/models/catalog_category_model.dart';
import '../../features/catalog/domain/models/catalog_item_model.dart';

class LocalCacheService {
  static Database? _database;

  static Future<void> initialize() async {
    if (kIsWeb) return;
    try {
      final dbPath = await getDatabasesPath();
      final path = p.join(dbPath, 'ali_aac_local.db');

      _database = await openDatabase(
        path,
        version: 3,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE local_categories (
              id TEXT PRIMARY KEY,
              name TEXT,
              icon_name TEXT,
              sort_order INTEGER
            )
          ''');
          await db.execute('''
            CREATE TABLE local_vocab_cards (
              id TEXT PRIMARY KEY,
              category_id TEXT,
              label TEXT,
              image_url TEXT,
              audio_abi_url TEXT,
              audio_umma_url TEXT,
              is_favorite INTEGER,
              created_by TEXT,
              created_at TEXT
            )
          ''');
          await db.execute('''
            CREATE TABLE local_writing_items (
              id TEXT PRIMARY KEY,
              level_type INTEGER,
              target_text TEXT,
              hint_label TEXT,
              image_url TEXT,
              audio_url TEXT,
              is_custom INTEGER,
              created_by TEXT,
              sort_order INTEGER,
              created_at TEXT
            )
          ''');
          await db.execute('''
            CREATE TABLE local_catalog_categories (
              id TEXT PRIMARY KEY,
              name_id TEXT,
              name_en TEXT,
              icon_name TEXT,
              color_hex TEXT,
              sort_order INTEGER
            )
          ''');
          await db.execute('''
            CREATE TABLE local_catalog_items (
              id TEXT PRIMARY KEY,
              category_id TEXT,
              name TEXT,
              image_url TEXT,
              phonics TEXT,
              syllables TEXT,
              emoji TEXT,
              difficulty INTEGER,
              is_active INTEGER
            )
          ''');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            await db.execute('''
              CREATE TABLE IF NOT EXISTS local_writing_items (
                id TEXT PRIMARY KEY,
                level_type INTEGER,
                target_text TEXT,
                hint_label TEXT,
                image_url TEXT,
                audio_url TEXT,
                is_custom INTEGER,
                created_by TEXT,
                sort_order INTEGER,
                created_at TEXT
              )
            ''');
          }
          if (oldVersion < 3) {
            await db.execute('''
              CREATE TABLE IF NOT EXISTS local_catalog_categories (
                id TEXT PRIMARY KEY,
                name_id TEXT,
                name_en TEXT,
                icon_name TEXT,
                color_hex TEXT,
                sort_order INTEGER
              )
            ''');
            await db.execute('''
              CREATE TABLE IF NOT EXISTS local_catalog_items (
                id TEXT PRIMARY KEY,
                category_id TEXT,
                name TEXT,
                image_url TEXT,
                phonics TEXT,
                syllables TEXT,
                emoji TEXT,
                difficulty INTEGER,
                is_active INTEGER
              )
            ''');
          }
        },
      );
    } catch (e) {
      debugPrint('LocalCache SQLite init error: $e');
    }
  }

  // Cache Vocab Cards locally
  static Future<void> cacheVocabCards(List<VocabCardModel> cards) async {
    if (_database == null) return;
    final batch = _database!.batch();
    for (final card in cards) {
      batch.insert(
        'local_vocab_cards',
        {
          'id': card.id,
          'category_id': card.categoryId,
          'label': card.label,
          'image_url': card.imageUrl,
          'audio_abi_url': card.audioAbiUrl,
          'audio_umma_url': card.audioUmmaUrl,
          'is_favorite': card.isFavorite ? 1 : 0,
          'created_by': card.originalCardId != null && card.originalCardId!.isNotEmpty
              ? 'override:${card.originalCardId}'
              : card.createdBy,
          'created_at': card.createdAt.toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  // Retrieve cached Vocab Cards when offline
  static Future<List<VocabCardModel>> getCachedVocabCards() async {
    if (_database == null) return [];
    try {
      final List<Map<String, dynamic>> maps = await _database!.query('local_vocab_cards');
      return maps.map<VocabCardModel>((m) {
        final createdBy = m['created_by'] as String? ?? 'abi';
        String? origId;
        if (createdBy.startsWith('override:')) {
          origId = createdBy.substring('override:'.length);
        }
        final cardId = m['id'] as String;
        return VocabCardModel(
          id: cardId,
          categoryId: m['category_id'] as String,
          label: m['label'] as String,
          imageUrl: m['image_url'] as String,
          audioAbiUrl: m['audio_abi_url'] as String?,
          audioUmmaUrl: m['audio_umma_url'] as String?,
          isFavorite: (m['is_favorite'] as int) == 1,
          createdBy: createdBy,
          createdAt: DateTime.parse(m['created_at'] as String),
          originalCardId: origId,
          isSystem: origId == null && cardId.startsWith('b0000001-'),
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // Cache Writing Items locally
  static Future<void> cacheWritingItems(List<Map<String, dynamic>> items) async {
    if (_database == null) return;
    final batch = _database!.batch();
    for (final item in items) {
      batch.insert(
        'local_writing_items',
        {
          'id': item['id'],
          'level_type': item['level_type'] is int ? item['level_type'] : int.tryParse(item['level_type']?.toString() ?? '1') ?? 1,
          'target_text': item['target_text'],
          'hint_label': item['hint_label'],
          'image_url': item['image_url'],
          'audio_url': item['audio_url'],
          'is_custom': (item['is_custom'] == true || item['is_custom'] == 1) ? 1 : 0,
          'created_by': item['created_by'] ?? 'abi',
          'sort_order': item['sort_order'] ?? 0,
          'created_at': item['created_at']?.toString() ?? DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  // Retrieve cached Writing Items per Level
  static Future<List<Map<String, dynamic>>> getCachedWritingItems(int levelType) async {
    if (_database == null) return [];
    try {
      final List<Map<String, dynamic>> maps = await _database!.query(
        'local_writing_items',
        where: 'level_type = ?',
        whereArgs: [levelType],
        orderBy: 'sort_order ASC, created_at ASC',
      );
      return maps;
    } catch (e) {
      return [];
    }
  }

  // Cache Official Catalog Categories locally
  static Future<void> cacheCatalogCategories(List<CatalogCategoryModel> categories) async {
    if (_database == null) return;
    final batch = _database!.batch();
    for (final cat in categories) {
      batch.insert(
        'local_catalog_categories',
        cat.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  // Retrieve cached Official Catalog Categories
  static Future<List<CatalogCategoryModel>> getCachedCatalogCategories() async {
    if (_database == null) return [];
    try {
      final List<Map<String, dynamic>> maps = await _database!.query(
        'local_catalog_categories',
        orderBy: 'sort_order ASC',
      );
      return maps.map((m) => CatalogCategoryModel.fromJson(m)).toList();
    } catch (e) {
      return [];
    }
  }

  // Cache Official Catalog Items locally
  static Future<void> cacheCatalogItems(List<CatalogItemModel> items) async {
    if (_database == null) return;
    final batch = _database!.batch();
    for (final item in items) {
      batch.insert(
        'local_catalog_items',
        {
          'id': item.id,
          'category_id': item.categoryId,
          'name': item.name,
          'image_url': item.imageUrl,
          'phonics': item.phonics,
          'syllables': jsonEncode(item.syllables),
          'emoji': item.emoji,
          'difficulty': item.difficulty,
          'is_active': item.isActive ? 1 : 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  // Retrieve cached Official Catalog Items
  static Future<List<CatalogItemModel>> getCachedCatalogItems({String? categoryId}) async {
    if (_database == null) return [];
    try {
      final List<Map<String, dynamic>> maps = await _database!.query(
        'local_catalog_items',
        where: categoryId != null ? 'category_id = ?' : null,
        whereArgs: categoryId != null ? [categoryId] : null,
        orderBy: 'name ASC',
      );
      return maps.map((m) => CatalogItemModel.fromJson(m)).toList();
    } catch (e) {
      return [];
    }
  }

  // Update single catalog item image locally
  static Future<void> updateCatalogItemImage(String itemId, String imageUrl) async {
    if (_database == null) return;
    try {
      await _database!.update(
        'local_catalog_items',
        {'image_url': imageUrl},
        where: 'id = ?',
        whereArgs: [itemId],
      );
    } catch (e) {
      debugPrint('Error updating local cached catalog item image: $e');
    }
  }

  // Update complete catalog item locally
  static Future<void> updateCatalogItem(CatalogItemModel item) async {
    if (_database == null) return;
    try {
      await _database!.update(
        'local_catalog_items',
        {
          'category_id': item.categoryId,
          'name': item.name,
          'image_url': item.imageUrl,
          'phonics': item.phonics,
          'syllables': jsonEncode(item.syllables),
          'emoji': item.emoji,
          'difficulty': item.difficulty,
          'is_active': item.isActive ? 1 : 0,
        },
        where: 'id = ?',
        whereArgs: [item.id],
      );
    } catch (e) {
      debugPrint('Error updating local cached catalog item: $e');
    }
  }

  // Delete catalog item locally
  static Future<void> deleteCatalogItem(String itemId) async {
    if (_database == null) return;
    try {
      await _database!.delete(
        'local_catalog_items',
        where: 'id = ?',
        whereArgs: [itemId],
      );
    } catch (e) {
      debugPrint('Error deleting local cached catalog item: $e');
    }
  }

  // Load bundled catalog categories from assets (final offline fallback)
  static Future<List<CatalogCategoryModel>> loadBundledCatalogCategories() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/data/catalog_categories.json');
      final List<dynamic> list = jsonDecode(jsonStr) as List;
      return list.map((e) => CatalogCategoryModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    } catch (e) {
      debugPrint('Error loading bundled catalog categories: $e');
      return [];
    }
  }

  // Load bundled catalog items from assets (final offline fallback)
  static Future<List<CatalogItemModel>> loadBundledCatalogItems({String? categoryId}) async {
    try {
      final jsonStr = await rootBundle.loadString('assets/data/catalog_items.json');
      final List<dynamic> list = jsonDecode(jsonStr) as List;
      var items = list
          .map((e) => CatalogItemModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .where((i) => i.isActive)
          .toList();
      if (categoryId != null) {
        items = items.where((i) => i.categoryId == categoryId).toList();
      }
      return items;
    } catch (e) {
      debugPrint('Error loading bundled catalog items: $e');
      return [];
    }
  }
}

