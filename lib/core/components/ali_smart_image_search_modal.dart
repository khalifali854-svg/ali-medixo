import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../theme/app_theme_tokens.dart';
import 'ali_modal.dart';

/// Modal Pencarian Foto Pintar (Google / Web / Ensiklopedia)
/// Digunakan bersama untuk Modul Katalog & Modul AAC Vocab Card.
class AliSmartImageSearchModal {
  static const Map<String, String> _dictIdEn = {
    'kucing': 'cat',
    'anjing': 'dog',
    'apel': 'apple',
    'pisang': 'banana',
    'jeruk': 'orange fruit',
    'mangga': 'mango fruit',
    'stroberi': 'strawberry',
    'semangka': 'watermelon',
    'nanas': 'pineapple',
    'anggur': 'grape',
    'mobil': 'car automobile',
    'sepeda': 'bicycle',
    'motor': 'motorcycle',
    'kereta': 'train railway',
    'pesawat': 'airplane flight',
    'kapal': 'ship boat',
    'bus': 'city bus',
    'truk': 'truck vehicle',
    'rumah': 'house home',
    'sekolah': 'school building',
    'buku': 'open book',
    'pensil': 'pencil drawing',
    'kursi': 'chair furniture',
    'meja': 'table desk',
    'sepatu': 'shoes footwear',
    'baju': 't-shirt clothing',
    'celana': 'trousers pants',
    'topi': 'baseball cap hat',
    'bola': 'soccer football ball',
    'pohon': 'green tree nature',
    'bunga': 'flower bloom',
    'matahari': 'sun sky sunshine',
    'bulan': 'moon night sky',
    'bintang': 'stars astronomy',
    'awan': 'white clouds blue sky',
    'air': 'water pouring drinking',
    'susu': 'glass of milk',
    'roti': 'bread loaf bakery',
    'nasi': 'cooked white rice',
    'ayam': 'rooster chicken bird',
    'ikan': 'swimming fish aquatic',
    'sapi': 'cow cattle dairy',
    'kambing': 'goat farm animal',
    'bebek': 'duck bird swimming',
    'gajah': 'elephant wild mammal',
    'singa': 'lion big cat predator',
    'harimau': 'tiger big cat',
    'kelinci': 'cute bunny rabbit',
    'kuda': 'horse running mammal',
    'monyet': 'monkey primate',
    'burung': 'flying bird nature',
    'buaya': 'crocodile',
    'ular': 'snake reptile',
    'katak': 'frog amphibian',
    'kura-kura': 'turtle tortoise',
    'jerapah': 'giraffe',
    'zebra': 'zebra animal',
    'beruang': 'bear mammal',
    'serigala': 'wolf animal',
    'rubah': 'fox animal',
    'paus': 'whale marine mammal',
    'lumba-lumba': 'dolphin marine',
    'hiu': 'shark fish marine',
    'gurita': 'octopus marine',
    'kepiting': 'crab crustacean',
    'udang': 'shrimp prawn',
    'semut': 'ant insect',
    'lebah': 'honeybee insect',
    'kupu-kupu': 'butterfly insect',
    'nyamuk': 'mosquito insect',
    'lalat': 'fly insect',
    'labah-labah': 'spider arachnid',
  };

  static void show({
    required BuildContext context,
    required String initialQuery,
    required Function(String imageUrl) onImageSelected,
  }) {
    final searchCtrl = TextEditingController(text: initialQuery);
    List<Map<String, String>> searchResults = [];
    bool isSearching = false;

    void executeSearch(String q, StateSetter modalSetState) async {
      final query = q.trim();
      if (query.isEmpty) return;

      modalSetState(() => isSearching = true);

      try {
        final List<Map<String, String>> list = [];
        final Set<String> seenUrls = {};
        final qLower = query.toLowerCase();

        // 1. Kamus bawaan atau terjemahan cepat
        String enTerm = _dictIdEn[qLower] ?? '';

        // 2. Query ID Wikipedia: Ambil foto artikel langsung + langlinks ke bahasa Inggris
        final idWikiUri = Uri.parse(
          'https://id.wikipedia.org/w/api.php?action=query&titles=${Uri.encodeComponent(query)}&prop=pageimages|langlinks&piprop=thumbnail&pithumbsize=600&lllang=en&format=json&origin=*',
        );

        // 3. Query Wikipedia search (generator=search) untuk topik yang cocok
        final idSearchUri = Uri.parse(
          'https://id.wikipedia.org/w/api.php?action=query&generator=search&gsrsearch=${Uri.encodeComponent(query)}&gsrlimit=10&prop=pageimages&piprop=thumbnail&pithumbsize=600&format=json&origin=*',
        );

        final responses = await Future.wait([
          http.get(idWikiUri).timeout(const Duration(seconds: 4), onTimeout: () => http.Response('{}', 408)),
          http.get(idSearchUri).timeout(const Duration(seconds: 4), onTimeout: () => http.Response('{}', 408)),
        ]);

        // Parse ID Wikipedia main article
        if (responses[0].statusCode == 200) {
          try {
            final data = jsonDecode(responses[0].body);
            final pages = data['query']?['pages'];
            if (pages is Map) {
              for (final p in pages.values) {
                final thumb = p['thumbnail']?['source'];
                if (thumb != null && !seenUrls.contains(thumb)) {
                  seenUrls.add(thumb.toString());
                  list.add({
                    'url': thumb.toString(),
                    'title': '${p['title']} (Foto Utama)',
                  });
                }
                final ll = p['langlinks'] as List?;
                if (ll != null && ll.isNotEmpty) {
                  final en = ll.first['*']?.toString();
                  if (en != null && en.isNotEmpty) {
                    enTerm = en;
                  }
                }
              }
            }
          } catch (_) {}
        }

        // Parse search results di Wikipedia Indonesia
        if (responses[1].statusCode == 200) {
          try {
            final data = jsonDecode(responses[1].body);
            final pages = data['query']?['pages'];
            if (pages is Map) {
              for (final p in pages.values) {
                final title = (p['title'] as String? ?? '').toLowerCase();
                // Filter nama tempat/daerah/kecamatan/kelurahan/tol/stasiun
                if (title.contains('kecamatan') ||
                    title.contains('kelurahan') ||
                    title.contains('kabupaten') ||
                    title.contains('timur') ||
                    title.contains('barat') ||
                    title.contains('stasiun') ||
                    title.contains('jalan') ||
                    title.contains('lubang buaya') ||
                    title.contains('rawa buaya')) {
                  continue;
                }
                final thumb = p['thumbnail']?['source'];
                if (thumb != null && !seenUrls.contains(thumb)) {
                  seenUrls.add(thumb.toString());
                  list.add({
                    'url': thumb.toString(),
                    'title': p['title'] ?? query,
                  });
                }
              }
            }
          } catch (_) {}
        }

        // 4. Jika ada istilah Inggris atau kamus, cari di English Wikipedia & Commons
        final searchTerm = enTerm.isNotEmpty ? enTerm : query;
        final enSearchUri = Uri.parse(
          'https://en.wikipedia.org/w/api.php?action=query&generator=search&gsrsearch=${Uri.encodeComponent('$searchTerm animal OR object')}&gsrlimit=10&prop=pageimages&piprop=thumbnail&pithumbsize=600&format=json&origin=*',
        );
        final commonsUri = Uri.parse(
          'https://commons.wikimedia.org/w/api.php?action=query&generator=search&gsrsearch=${Uri.encodeComponent('$searchTerm photo')}&gsrnamespace=6&gsrlimit=12&prop=imageinfo&iiprop=url&iiurlwidth=600&format=json&origin=*',
        );

        final extraResponses = await Future.wait([
          http.get(enSearchUri).timeout(const Duration(seconds: 4), onTimeout: () => http.Response('{}', 408)),
          http.get(commonsUri).timeout(const Duration(seconds: 4), onTimeout: () => http.Response('{}', 408)),
        ]);

        // Parse English Wikipedia results
        if (extraResponses[0].statusCode == 200) {
          try {
            final data = jsonDecode(extraResponses[0].body);
            final pages = data['query']?['pages'];
            if (pages is Map) {
              for (final p in pages.values) {
                final title = (p['title'] as String? ?? '').toLowerCase();
                if (title.contains('film') || title.contains('album') || title.contains('band') || title.contains('station')) {
                  continue;
                }
                final thumb = p['thumbnail']?['source'];
                if (thumb != null && !seenUrls.contains(thumb)) {
                  seenUrls.add(thumb.toString());
                  list.add({
                    'url': thumb.toString(),
                    'title': p['title'] ?? searchTerm,
                  });
                }
              }
            }
          } catch (_) {}
        }

        // Parse Commons results
        if (extraResponses[1].statusCode == 200) {
          try {
            final data = jsonDecode(extraResponses[1].body);
            final pages = data['query']?['pages'];
            if (pages is Map) {
              for (final p in pages.values) {
                final pageTitle = (p['title'] as String? ?? '').toLowerCase();
                if (pageTitle.contains('station') ||
                    pageTitle.contains('road') ||
                    pageTitle.contains('plaza') ||
                    pageTitle.contains('bridge') ||
                    pageTitle.contains('logo') ||
                    pageTitle.contains('map') ||
                    pageTitle.contains('building')) {
                  continue;
                }
                final info = (p['imageinfo'] as List?)?.firstOrNull;
                final thumbUrl = info?['thumburl'] ?? info?['url'];
                if (thumbUrl != null && !seenUrls.contains(thumbUrl) && !thumbUrl.toString().endsWith('.svg.png')) {
                  final cleanTitle = (p['title'] as String? ?? searchTerm)
                      .replaceFirst(RegExp(r'^File:', caseSensitive: false), '')
                      .replaceFirst(RegExp(r'\.[a-zA-Z0-9]+$'), '');
                  seenUrls.add(thumbUrl.toString());
                  list.add({
                    'url': thumbUrl.toString(),
                    'title': cleanTitle,
                  });
                }
              }
            }
          } catch (_) {}
        }

        modalSetState(() {
          searchResults = list;
          isSearching = false;
        });
      } catch (e) {
        debugPrint('Smart search error: $e');
        modalSetState(() => isSearching = false);
      }
    }

    AliModal.showDeckModal(
      context: context,
      title: 'Pencarian Foto Pintar (Google / Web)',
      subtitle: 'Foto asli beresolusi tinggi otomatis disimpan ke Cloudflare R2',
      isFullHeight: true,
      body: StatefulBuilder(
        builder: (ctx, modalSetState) {
          // Trigger search on first load if query provided
          if (searchResults.isEmpty && initialQuery.trim().isNotEmpty && !isSearching) {
            executeSearch(initialQuery, modalSetState);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Input Bar
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceInput,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(color: AppColors.borderCard, width: 1.2),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded, size: 20, color: AppColors.textMuted),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: searchCtrl,
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: 'Ketik nama benda, hewan, makanan (contoh: Kucing, Apel, Mobil)...',
                          hintStyle: TextStyle(fontSize: 13, color: AppColors.textMuted),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        onSubmitted: (v) => executeSearch(v, modalSetState),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_rounded, size: 20, color: AppColors.pureBlack),
                      onPressed: () => executeSearch(searchCtrl.text, modalSetState),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Status / Loading Indicator
              if (isSearching)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 36),
                    child: Column(
                      children: [
                        CircularProgressIndicator(color: AppColors.accentLemon),
                        SizedBox(height: 12),
                        Text(
                          'Mencari foto objek asli dari web & ensiklopedia...',
                          style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                )
              else if (searchResults.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        const Text('📸', style: TextStyle(fontSize: 44)),
                        const SizedBox(height: 10),
                        const Text(
                          'Ketik kata kunci untuk mencari foto asli',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Koleksi foto bebas hak cipta beresolusi tajam',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: searchResults.length,
                    itemBuilder: (context, idx) {
                      final item = searchResults[idx];
                      final url = item['url']!;

                      return InkWell(
                        onTap: () {
                          onImageSelected(url);
                          Navigator.pop(ctx);
                        },
                        borderRadius: BorderRadius.circular(AppRadius.r16),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppRadius.r16),
                            border: Border.all(color: AppColors.borderCard, width: 1.2),
                            boxShadow: AppShadows.cardShadow,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.r16),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (_, child, progress) {
                                    if (progress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accentLemon),
                                    );
                                  },
                                  errorBuilder: (_, __, ___) => const Center(
                                    child: Icon(Icons.broken_image_rounded, color: Colors.grey),
                                  ),
                                ),
                                Positioned(
                                  bottom: 6,
                                  right: 6,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.65),
                                      borderRadius: BorderRadius.circular(AppRadius.pill),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.check_circle_rounded, size: 12, color: AppColors.accentLemon),
                                        SizedBox(width: 4),
                                        Text('Pilih', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
