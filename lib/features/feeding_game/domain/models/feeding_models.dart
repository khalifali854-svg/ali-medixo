import 'package:flutter/material.dart';

enum AnimalType {
  cat,
  chicken,
  panda,
  rabbit,
  fish,
}

class FoodItem {
  final String id;
  final String name;
  final String emoji;
  final String subtitle;
  final Color cardBg;
  final String chewSoundType; // 'crunch', 'gulp', 'nibble'

  const FoodItem({
    required this.id,
    required this.name,
    required this.emoji,
    required this.subtitle,
    required this.cardBg,
    this.chewSoundType = 'crunch',
  });
}

class AnimalProfile {
  final AnimalType type;
  final String name;
  final String title;
  final String avatarEmoji;
  final Color primaryColor;
  final Color lightBgColor;
  final String soundCall; // Onboarding voice / greeting
  final String habitatName;
  final List<String> favoriteFoodIds;
  final Map<String, String> specialReactions; // foodId -> funny voice lines

  const AnimalProfile({
    required this.type,
    required this.name,
    required this.title,
    required this.avatarEmoji,
    required this.primaryColor,
    required this.lightBgColor,
    required this.soundCall,
    required this.habitatName,
    required this.favoriteFoodIds,
    this.specialReactions = const {},
  });

  bool isFavorite(String foodId) => favoriteFoodIds.contains(foodId);
}

class FeedingGameRepository {
  // Master Food List
  static const List<FoodItem> allFoods = [
    FoodItem(
      id: 'fish',
      name: 'Ikan Segar',
      emoji: '🐟',
      subtitle: 'Gurih & bergizi',
      cardBg: Color(0xFFE0F2FE),
      chewSoundType: 'nibble',
    ),
    FoodItem(
      id: 'chicken_meat',
      name: 'Daging Ayam',
      emoji: '🍗',
      subtitle: 'Enak dan empuk',
      cardBg: Color(0xFFFEF3C7),
      chewSoundType: 'crunch',
    ),
    FoodItem(
      id: 'milk',
      name: 'Semangkok Susu',
      emoji: '🥛',
      subtitle: 'Segar dan manis',
      cardBg: Color(0xFFF1F5F9),
      chewSoundType: 'gulp',
    ),
    FoodItem(
      id: 'corn',
      name: 'Biji Jagung',
      emoji: '🌽',
      subtitle: 'Kuning dan manis',
      cardBg: Color(0xFFFEF08A),
      chewSoundType: 'nibble',
    ),
    FoodItem(
      id: 'worm',
      name: 'Cacing Tanah',
      emoji: '🪱',
      subtitle: 'Kenyal di tanah',
      cardBg: Color(0xFFFCE7F3),
      chewSoundType: 'nibble',
    ),
    FoodItem(
      id: 'grain',
      name: 'Biji Padi',
      emoji: '🌾',
      subtitle: 'Butiran renyah',
      cardBg: Color(0xFFFEF9C3),
      chewSoundType: 'nibble',
    ),
    FoodItem(
      id: 'bamboo',
      name: 'Batang Bambu',
      emoji: '🎋',
      subtitle: 'Hijau dan renyah',
      cardBg: Color(0xFFDCFCE7),
      chewSoundType: 'crunch',
    ),
    FoodItem(
      id: 'apple',
      name: 'Apel Manis',
      emoji: '🍎',
      subtitle: 'Segar berair',
      cardBg: Color(0xFFFFE4E6),
      chewSoundType: 'crunch',
    ),
    FoodItem(
      id: 'carrot',
      name: 'Wortel Renyah',
      emoji: '🥕',
      subtitle: 'Kaya vitamin A',
      cardBg: Color(0xFFFFEDD5),
      chewSoundType: 'crunch',
    ),
    FoodItem(
      id: 'lettuce',
      name: 'Daun Selada',
      emoji: '🥬',
      subtitle: 'Hijau menyehatkan',
      cardBg: Color(0xFFDCFCE7),
      chewSoundType: 'crunch',
    ),
    FoodItem(
      id: 'pellet',
      name: 'Pelet Ikan',
      emoji: '🫧',
      subtitle: 'Makanan butir koki',
      cardBg: Color(0xFFE0E7FF),
      chewSoundType: 'nibble',
    ),
    FoodItem(
      id: 'bread_crumbs',
      name: 'Remahan Roti',
      emoji: '🍞',
      subtitle: 'Empuk terapung',
      cardBg: Color(0xFFFFFBEB),
      chewSoundType: 'nibble',
    ),
    // Challengers (funny wrong foods)
    FoodItem(
      id: 'chili',
      name: 'Cabai Merah',
      emoji: '🌶️',
      subtitle: 'Hati-hati pedas!',
      cardBg: Color(0xFFFEE2E2),
      chewSoundType: 'crunch',
    ),
  ];

  static const List<AnimalProfile> animals = [
    AnimalProfile(
      type: AnimalType.cat,
      name: 'Si Meong',
      title: 'Kucing Abu & Putih',
      avatarEmoji: '🐱',
      primaryColor: Color(0xFF64748B),
      lightBgColor: Color(0xFFF8FAFC),
      soundCall: 'Meoww! Meong lapar nih, mau makan yang gurih-gurih!',
      habitatName: 'Karpet Rumah Lembut',
      favoriteFoodIds: ['fish', 'chicken_meat', 'milk'],
      specialReactions: {
        'carrot': 'Hee? Meong kan bukan kelinci! Meong mau ikan renyah!',
        'corn': 'Kok dikasih jagung? Meong ga bisa makan biji-bijian!',
        'chili': 'Haaah haaah! Pedaaaasss! Kuping Meong berasap, tolong susu dingin meoong!',
        'bamboo': 'Aduh keras banget, gigi Meong copot nanti!',
      },
    ),
    AnimalProfile(
      type: AnimalType.chicken,
      name: 'Si Jago',
      title: 'Ayam Jantan',
      avatarEmoji: '🐔',
      primaryColor: Color(0xFFEF4444),
      lightBgColor: Color(0xFFFEF2F2),
      soundCall: 'Kukuruyuuuk! Ada biji-biji lezat buat Si Jago?',
      habitatName: 'Halaman Berumput',
      favoriteFoodIds: ['corn', 'grain', 'worm'],
      specialReactions: {
        'fish': 'Wah ikannya terlalu besar, paruh Si Jago ga muat!',
        'milk': 'Kocok-kocok airnya kecipratan! Ayam sukanya makan biji!',
        'chili': 'Petok petok petook! Haaah pedaas berasap paruh Si Jago terbakar!',
        'bamboo': 'Ini mah kayu bukan makanan ayam!',
      },
    ),
    AnimalProfile(
      type: AnimalType.panda,
      name: 'Si Gembul',
      title: 'Panda Lucu',
      avatarEmoji: '🐼',
      primaryColor: Color(0xFF10B981),
      lightBgColor: Color(0xFFF0FDF4),
      soundCall: 'Gembul mau bambu hijau segar yang kres-kres!',
      habitatName: 'Hutan Bambu Rindang',
      favoriteFoodIds: ['bamboo', 'apple', 'carrot'],
      specialReactions: {
        'fish': 'Uweeek! Bau amis, Panda kan sukanya bambu manis!',
        'worm': 'Ih ada cacing geli! Jauhin dari Panda!',
        'chili': 'Haaaah pedass panas! Pipi Panda merah berasap! Haaatsyii!',
        'pellet': 'Kecil banget, ga bikin perut gembul kenyang!',
      },
    ),
    AnimalProfile(
      type: AnimalType.rabbit,
      name: 'Si Fluffy',
      title: 'Kelinci Putih',
      avatarEmoji: '🐰',
      primaryColor: Color(0xFFEC4899),
      lightBgColor: Color(0xFFFDF2F8),
      soundCall: 'Kelinci suka sayuran renyah yang kriuk-kriuk!',
      habitatName: 'Kebun Wortel Ceria',
      favoriteFoodIds: ['carrot', 'lettuce', 'apple'],
      specialReactions: {
        'fish': 'Telinga Kelinci langsung turun, ini bukan sayur!',
        'chicken_meat': 'Kelinci cuma makan tanaman segar ya teman!',
        'worm': 'Ih geli! Kelinci maunya wortel oranye!',
        'chili': 'Waaaah pedaasss! Telinga Kelinci keluar asap kebakaran!',
      },
    ),
    AnimalProfile(
      type: AnimalType.fish,
      name: 'Si Mas Koki',
      title: 'Ikan Mas Ceria',
      avatarEmoji: '🐠',
      primaryColor: Color(0xFF0284C7),
      lightBgColor: Color(0xFFF0F9FF),
      soundCall: 'Blubuk blubuk! Ayo tabur butiran makanan ke akuarium!',
      habitatName: 'Akuarium Berbuih Bening',
      favoriteFoodIds: ['pellet', 'bread_crumbs', 'worm'],
      specialReactions: {
        'carrot': 'Kedebuk! Wortelnya tenggelam keberatan di dasar!',
        'bamboo': 'Ini pohon ya? Ga muat di mulut ikan kecil!',
        'chicken_meat': 'Airnya jadi berminyak! Mau pelet kecil aja blubuk-blubuk!',
        'chili': 'Blubuk blubuk haaah! Airnya mendidih pedas keluar gelembung uap!',
      },
    ),
  ];

  static FoodItem getFoodById(String id) {
    return allFoods.firstWhere(
      (f) => f.id == id,
      orElse: () => allFoods.first,
    );
  }
}
