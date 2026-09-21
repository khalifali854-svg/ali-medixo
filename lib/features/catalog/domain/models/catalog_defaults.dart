import '../../../../core/services/audio_engine_service.dart';
import 'catalog_category_model.dart';
import 'catalog_item_model.dart';

class CatalogDefaults {
  static List<CatalogCategoryModel> get defaultCategories => [
    const CatalogCategoryModel(
      id: 'hijaiyah',
      nameId: 'Huruf Hijaiyah',
      nameEn: 'Hijaiyah Letters',
      iconName: 'menu_book',
      colorHex: '#10B981',
      sortOrder: 8,
    ),
    const CatalogCategoryModel(
      id: 'alfabet_angka',
      nameId: 'Huruf & Angka',
      nameEn: 'Letters & Numbers',
      iconName: 'spellcheck',
      colorHex: '#6366F1',
      sortOrder: 9,
    ),
  ];

  static List<CatalogItemModel> get hijaiyahItems {
    final hijaiyahData = [
      {'id': 'hij_alif', 'char': 'ا', 'name': 'Alif', 'arName': 'أَلِف'},
      {'id': 'hij_ba', 'char': 'ب', 'name': 'Ba', 'arName': 'بَاء'},
      {'id': 'hij_ta', 'char': 'ت', 'name': 'Ta', 'arName': 'تَاء'},
      {'id': 'hij_tsa', 'char': 'ث', 'name': 'Tsa', 'arName': 'ثَاء'},
      {'id': 'hij_jim', 'char': 'ج', 'name': 'Jim', 'arName': 'جِيم'},
      {'id': 'hij_ha', 'char': 'ح', 'name': 'Ha', 'arName': 'حَاء'},
      {'id': 'hij_kha', 'char': 'خ', 'name': 'Kha', 'arName': 'خَاء'},
      {'id': 'hij_dal', 'char': 'د', 'name': 'Dal', 'arName': 'دَال'},
      {'id': 'hij_dzal', 'char': 'ذ', 'name': 'Dzal', 'arName': 'ذَال'},
      {'id': 'hij_ra', 'char': 'ر', 'name': 'Ra', 'arName': 'رَاء'},
      {'id': 'hij_zai', 'char': 'ز', 'name': 'Zai', 'arName': 'زَاي'},
      {'id': 'hij_sin', 'char': 'س', 'name': 'Sin', 'arName': 'سِين'},
      {'id': 'hij_syin', 'char': 'ش', 'name': 'Syin', 'arName': 'شِين'},
      {'id': 'hij_shad', 'char': 'ص', 'name': 'Shad', 'arName': 'صَاد'},
      {'id': 'hij_dhad', 'char': 'ض', 'name': 'Dhad', 'arName': 'ضَاد'},
      {'id': 'hij_tha', 'char': 'ط', 'name': 'Tha', 'arName': 'طَاء'},
      {'id': 'hij_zha', 'char': 'ظ', 'name': 'Zha', 'arName': 'ظَاء'},
      {'id': 'hij_ain', 'char': 'ع', 'name': '\'Ain', 'arName': 'عَيْن'},
      {'id': 'hij_ghain', 'char': 'غ', 'name': 'Ghain', 'arName': 'غَيْن'},
      {'id': 'hij_fa', 'char': 'ف', 'name': 'Fa', 'arName': 'فَاء'},
      {'id': 'hij_qaf', 'char': 'ق', 'name': 'Qaf', 'arName': 'قَاف'},
      {'id': 'hij_kaf', 'char': 'ك', 'name': 'Kaf', 'arName': 'كَاف'},
      {'id': 'hij_lam', 'char': 'ل', 'name': 'Lam', 'arName': 'لَام'},
      {'id': 'hij_mim', 'char': 'م', 'name': 'Mim', 'arName': 'مِيم'},
      {'id': 'hij_nun', 'char': 'ن', 'name': 'Nun', 'arName': 'نُون'},
      {'id': 'hij_wawu', 'char': 'و', 'name': 'Wawu', 'arName': 'وَاو'},
      {'id': 'hij_ha_bulat', 'char': 'ه', 'name': 'Ha', 'arName': 'هَاء'},
      {'id': 'hij_lam_alif', 'char': 'لا', 'name': 'Lam Alif', 'arName': 'لَامْ أَلِفْ'},
      {'id': 'hij_hamzah', 'char': 'ء', 'name': 'Hamzah', 'arName': 'هَمْزَة'},
      {'id': 'hij_ya', 'char': 'ي', 'name': 'Ya', 'arName': 'يَاء'},
    ];

    return hijaiyahData.map((h) {
      final audioFile = AudioEngineService.getHijaiyahAssetAudio(h['char']!);
      return CatalogItemModel(
        id: h['id']!,
        categoryId: 'hijaiyah',
        name: '${h['char']} (${h['name']})',
        imageUrl: '',
        phonics: h['arName'],
        syllables: [h['name']!],
        emoji: h['char'],
        audioUrl: audioFile,
        difficulty: 1,
        isActive: true,
      );
    }).toList();
  }

  static List<CatalogItemModel> get alphaNumItems {
    final list = <CatalogItemModel>[];
    final numberWords = [
      'Satu', 'Dua', 'Tiga', 'Empat', 'Lima',
      'Enam', 'Tujuh', 'Delapan', 'Sembilan', 'Sepuluh'
    ];
    for (int i = 1; i <= 10; i++) {
      list.add(CatalogItemModel(
        id: 'num_$i',
        categoryId: 'alfabet_angka',
        name: 'Angka $i',
        imageUrl: '',
        phonics: numberWords[i - 1],
        syllables: [numberWords[i - 1]],
        emoji: '$i',
        difficulty: 1,
        isActive: true,
      ));
    }
    for (int i = 0; i < 26; i++) {
      final letter = String.fromCharCode(65 + i);
      list.add(CatalogItemModel(
        id: 'letter_$letter',
        categoryId: 'alfabet_angka',
        name: 'Huruf $letter',
        imageUrl: '',
        phonics: 'Huruf $letter',
        syllables: ['Hu', 'ruf', letter],
        emoji: letter,
        difficulty: 1,
        isActive: true,
      ));
    }
    return list;
  }

  static final List<String> _hijaiyahOrderIds = [
    'hij_alif', 'hij_ba', 'hij_ta', 'hij_tsa', 'hij_jim', 'hij_ha', 'hij_kha',
    'hij_dal', 'hij_dzal', 'hij_ra', 'hij_zai', 'hij_sin', 'hij_syin', 'hij_shad',
    'hij_dhad', 'hij_tha', 'hij_zha', 'hij_ain', 'hij_ghain', 'hij_fa', 'hij_qaf',
    'hij_kaf', 'hij_lam', 'hij_mim', 'hij_nun', 'hij_wawu', 'hij_ha_bulat',
    'hij_lam_alif', 'hij_hamzah', 'hij_ya'
  ];

  static final List<String> _hijaiyahChars = [
    'ا', 'ب', 'ت', 'ث', 'ج', 'ح', 'خ',
    'د', 'ذ', 'ر', 'ز', 'س', 'ش', 'ص',
    'ض', 'ط', 'ظ', 'ع', 'غ', 'ف', 'ق',
    'ك', 'ل', 'م', 'ن', 'و', 'ه',
    'لا', 'ء', 'ي'
  ];

  static int _getHijaiyahIndex(CatalogItemModel item) {
    // 1. Cek berdasarkan ID
    final idIndex = _hijaiyahOrderIds.indexOf(item.id);
    if (idIndex != -1) return idIndex;

    // 2. Cek berdasarkan emoji / char
    if (item.emoji != null && item.emoji!.isNotEmpty) {
      final charIndex = _hijaiyahChars.indexOf(item.emoji!);
      if (charIndex != -1) return charIndex;
    }

    // 3. Cek apakah nama mengandung huruf hijaiyah
    for (int i = 0; i < _hijaiyahChars.length; i++) {
      if (item.name.startsWith(_hijaiyahChars[i])) {
        return i;
      }
    }

    return 999;
  }

  /// Mengurutkan item katalog:
  /// - Kategori Hijaiyah: Urutan baku (Alif s/d Ya, Hamzah di urutan ke-29)
  /// - Kategori Huruf & Angka: Angka 1-10 lalu Huruf A-Z
  /// - Kategori lainnya: Alfabetis sesuai nama
  static List<CatalogItemModel> sortCatalogItems(List<CatalogItemModel> items) {
    final sorted = List<CatalogItemModel>.from(items);
    sorted.sort((a, b) {
      if (a.categoryId == 'hijaiyah' && b.categoryId == 'hijaiyah') {
        final orderA = _getHijaiyahIndex(a);
        final orderB = _getHijaiyahIndex(b);
        if (orderA != orderB) return orderA.compareTo(orderB);
        return a.name.compareTo(b.name);
      } else if (a.categoryId == 'alfabet_angka' && b.categoryId == 'alfabet_angka') {
        final isNumA = a.id.startsWith('num_');
        final isNumB = b.id.startsWith('num_');
        if (isNumA && !isNumB) return -1;
        if (!isNumA && isNumB) return 1;
        if (isNumA && isNumB) {
          final valA = int.tryParse(a.id.replaceFirst('num_', '')) ?? 0;
          final valB = int.tryParse(b.id.replaceFirst('num_', '')) ?? 0;
          return valA.compareTo(valB);
        }
        return a.name.compareTo(b.name);
      }
      return a.name.compareTo(b.name);
    });
    return sorted;
  }
}
