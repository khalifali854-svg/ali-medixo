import 'package:flutter_test/flutter_test.dart';
import 'package:khalif_ali/features/aac_board/domain/models/vocab_card_model.dart';
import 'package:khalif_ali/core/services/supabase_service.dart';

void main() {
  test('mergeVocabCards correctly isolates user overrides and preserves defaults', () {
    final sys1 = VocabCardModel(
      id: 'sys_1',
      categoryId: 'c1',
      label: 'Abi Default',
      imageUrl: 'sys_abi.jpg',
      isSystem: true,
      sortOrder: 1,
      createdAt: DateTime.now(),
    );

    final sys2 = VocabCardModel(
      id: 'sys_2',
      categoryId: 'c1',
      label: 'Makan Default',
      imageUrl: 'sys_makan.jpg',
      isSystem: true,
      sortOrder: 2,
      createdAt: DateTime.now(),
    );

    final systemCards = [sys1, sys2];

    // User A overrides Abi with personal dad photo
    final userACustomAbi = VocabCardModel(
      id: 'userA_override_1',
      categoryId: 'c1',
      label: 'Abi User A (Foto Ayah)',
      imageUrl: 'ayah_a.jpg',
      userId: 'user_A',
      originalCardId: 'sys_1',
      sortOrder: 1,
      createdAt: DateTime.now(),
    );

    final mergedA = SupabaseService.mergeVocabCards(
      systemCards: systemCards,
      userCards: [userACustomAbi],
    );

    expect(mergedA.length, 2);
    expect(mergedA[0].id, 'userA_override_1');
    expect(mergedA[0].label, 'Abi User A (Foto Ayah)');
    expect(mergedA[1].id, 'sys_2');
    expect(mergedA[1].label, 'Makan Default');

    // User B opens the app without any personal overrides
    final mergedB = SupabaseService.mergeVocabCards(
      systemCards: systemCards,
      userCards: [],
    );

    expect(mergedB.length, 2);
    expect(mergedB[0].id, 'sys_1');
    expect(mergedB[0].label, 'Abi Default');
    expect(mergedB[1].id, 'sys_2');
    expect(mergedB[1].label, 'Makan Default');

    // User C adds a brand new card (not an override)
    final userCNewCard = VocabCardModel(
      id: 'userC_custom_1',
      categoryId: 'c1',
      label: 'Sepeda Balap',
      imageUrl: 'sepeda.jpg',
      userId: 'user_C',
      sortOrder: 3,
      createdAt: DateTime.now(),
    );

    final mergedC = SupabaseService.mergeVocabCards(
      systemCards: systemCards,
      userCards: [userCNewCard],
    );

    expect(mergedC.length, 3);
    expect(mergedC[0].label, 'Abi Default');
    expect(mergedC[1].label, 'Makan Default');
    expect(mergedC[2].label, 'Sepeda Balap');
  });
}
