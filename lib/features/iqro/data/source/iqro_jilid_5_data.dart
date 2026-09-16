import '../../domain/models/iqro_models.dart';

class IqroJilid5Data {
  static List<IqroPage> getPages() {
    return [
      // Halaman 1: Huruf بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ (BISMILLAAHIRROHMAANIRROHIIM)
      const IqroPage(
        jilid: 5,
        pageNumber: 1,
        title: "Huruf بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ (BISMILLAAHIRROHMAANIRROHIIM)",
        instruction: "Alif dianggap tidak ada",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "5_1_r1_1_0", arabic: "الحَمدُ", latin: "alhamdu", audioTtsText: "الحَمدُ"),
              IqroWordItem(id: "5_1_r1_2_1", arabic: "وَالحَمدُ", latin: "walhamdu", audioTtsText: "وَالحَمدُ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_1_r2_1_0", arabic: "مَعَ الحَمدِ", latin: "ma'a alhamdi", audioTtsText: "مَعَ الحَمدِ"),
              IqroWordItem(id: "5_1_r2_2_1", arabic: "بِالحَمدِ", latin: "bilhamdi", audioTtsText: "بِالحَمدِ"),
              IqroWordItem(id: "5_1_r2_3_2", arabic: "لَكَ الحَمدُ", latin: "laka alhamdu", audioTtsText: "لَكَ الحَمدُ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_1_r3_1_0", arabic: "وَالعَصرِ", latin: "wal'ashri", audioTtsText: "وَالعَصرِ"),
              IqroWordItem(id: "5_1_r3_2_1", arabic: "وَالفَجرِ", latin: "walfajri", audioTtsText: "وَالفَجرِ"),
              IqroWordItem(id: "5_1_r3_3_2", arabic: "بِالفَاتِحَةِ", latin: "bilfaatihahti", audioTtsText: "بِالفَاتِحَةِ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_1_r4_1_0", arabic: "فِي الكُتُبِ", latin: "fii alkutubi", audioTtsText: "فِي الكُتُبِ"),
              IqroWordItem(id: "5_1_r4_2_1", arabic: "بِالإِسلَامِ", latin: "bilislaami", audioTtsText: "بِالإِسلَامِ"),
              IqroWordItem(id: "5_1_r4_3_2", arabic: "وَالإِيمَانِ", latin: "waliimaani", audioTtsText: "وَالإِيمَانِ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_1_r5_1_0", arabic: "وَأَمرَأَتُهُ", latin: "wa'amro'atuhu", audioTtsText: "وَأَمرَأَتُهُ"),
              IqroWordItem(id: "5_1_r5_2_1", arabic: "وَاستَغفَرَهُ", latin: "wastaghforohu", audioTtsText: "وَاستَغفَرَهُ"),
              IqroWordItem(id: "5_1_r5_3_2", arabic: "وَاقتَرِب", latin: "waqtarib", audioTtsText: "وَاقتَرِب"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_1_r6_1_0", arabic: "بِاسمِكَ", latin: "bismika", audioTtsText: "بِاسمِكَ"),
              IqroWordItem(id: "5_1_r6_2_1", arabic: "مَا القَارِعَةُ", latin: "maa alqoori'atu", audioTtsText: "مَا القَارِعَةُ"),
              IqroWordItem(id: "5_1_r6_3_2", arabic: "وَالعَادِيَاتِ", latin: "wal'aadiyaati", audioTtsText: "وَالعَادِيَاتِ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_1_r7_1_0", arabic: "بِالرَّحمَةِ", latin: "birrohmati", audioTtsText: "بِالرَّحمَةِ"),
              IqroWordItem(id: "5_1_r7_2_1", arabic: "فِي الأَرضِ", latin: "fii alardhi", audioTtsText: "فِي الأَرضِ"),
              IqroWordItem(id: "5_1_r7_3_2", arabic: "عَلَى الأَفئِدَةِ", latin: "'alaa alaf'idati", audioTtsText: "عَلَى الأَفئِدَةِ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_1_r8_1_0", arabic: "فِي الجَحِيمِ", latin: "fii aljahiimi", audioTtsText: "فِي الجَحِيمِ"),
              IqroWordItem(id: "5_1_r8_2_1", arabic: "لِلكَافِرِينَ", latin: "lilkaafirina", audioTtsText: "لِلكَافِرِينَ"),
              IqroWordItem(id: "5_1_r8_3_2", arabic: "وَالمِسكِينِ", latin: "walmaskiini", audioTtsText: "وَالمِسكِينِ"),
            ],
          ),
        ],
      ),
      // Halaman 2: Halaman 2
      const IqroPage(
        jilid: 5,
        pageNumber: 2,
        title: "Halaman 2",
        instruction: "INGAT! Banyak huruf Alief dianggap tidak ada",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "5_2_r1_1_0", arabic: "مَا اكتَسَبَت", latin: "maa aktasabat", audioTtsText: "مَا اكتَسَبَت"),
              IqroWordItem(id: "5_2_r1_2_1", arabic: "مَا اقتَتَلُوا", latin: "maa aqtataluu", audioTtsText: "مَا اقتَتَلُوا"),
              IqroWordItem(id: "5_2_r1_3_2", arabic: "فِي الأَرضِ", latin: "fii alardhi", audioTtsText: "فِي الأَرضِ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_2_r2_1_0", arabic: "سَيُبطِلُهُ", latin: "sayubthiluhu", audioTtsText: "سَيُبطِلُهُ"),
              IqroWordItem(id: "5_2_r2_2_1", arabic: "وَمَقَامِي", latin: "wamaqoomii", audioTtsText: "وَمَقَامِي"),
              IqroWordItem(id: "5_2_r2_3_2", arabic: "وَبِالآخِرَةِ", latin: "wabilaakhiroti", audioTtsText: "وَبِالآخِرَةِ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_2_r3_1_0", arabic: "مِنَ الغَيظِ", latin: "mina alghoizhi", audioTtsText: "مِنَ الغَيظِ"),
              IqroWordItem(id: "5_2_r3_2_1", arabic: "وَالأَفئِدَةِ", latin: "walaf'idati", audioTtsText: "وَالأَفئِدَةِ"),
              IqroWordItem(id: "5_2_r3_3_2", arabic: "مُدَّعِينَ", latin: "mudda'iina", audioTtsText: "مُدَّعِينَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_2_r4_1_0", arabic: "غِشَاوَةٌ", latin: "ghisyaawatun", audioTtsText: "غِشَاوَةٌ"),
              IqroWordItem(id: "5_2_r4_2_1", arabic: "مُعجِزِينَ", latin: "mu'jiziina", audioTtsText: "مُعجِزِينَ"),
              IqroWordItem(id: "5_2_r4_3_2", arabic: "مِنَ المُشرِكِينَ", latin: "mina almusyrikiina", audioTtsText: "مِنَ المُشرِكِينَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_2_r5_1_0", arabic: "وَمَا أَطعَمَهُم", latin: "wamaa ath'amahum", audioTtsText: "وَمَا أَطعَمَهُم"),
              IqroWordItem(id: "5_2_r5_2_1", arabic: "بِالمُؤمِنِينَ", latin: "bilmu'miniina", audioTtsText: "بِالمُؤمِنِينَ"),
              IqroWordItem(id: "5_2_r5_3_2", arabic: "وَمَوعِظَةً", latin: "wamau'izhotan", audioTtsText: "وَمَوعِظَةً"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_2_r6_1_0", arabic: "فِي طُغيَانِهِم", latin: "fii thughyaanihim", audioTtsText: "فِي طُغيَانِهِم"),
              IqroWordItem(id: "5_2_r6_2_1", arabic: "وَالآصَالِ", latin: "walaashaali", audioTtsText: "وَالآصَالِ"),
              IqroWordItem(id: "5_2_r6_3_2", arabic: "كَمِشكَاةٍ", latin: "kamisykaatin", audioTtsText: "كَمِشكَاةٍ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_2_r7_1_0", arabic: "فِيهَا اسمُهُ", latin: "fiihaa ismuhu", audioTtsText: "فِيهَا اسمُهُ"),
              IqroWordItem(id: "5_2_r7_2_1", arabic: "لَا تُؤَاخِذنَا", latin: "laa tu'aakhidznaa", audioTtsText: "لَا تُؤَاخِذنَا"),
              IqroWordItem(id: "5_2_r7_3_2", arabic: "غُفرَانَكَ", latin: "ghufroonaka", audioTtsText: "غُفرَانَكَ"),
            ],
          ),
        ],
      ),
      // Halaman 3: Halaman 3
      const IqroPage(
        jilid: 5,
        pageNumber: 3,
        title: "Halaman 3",
        instruction: "Bila waqof/berhenti huruf terakhir dibaca sukun mati. Contoh: AMINA dibaca AMIN.",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "5_3_r1_1_0", arabic: "نَستَعِين ○ ...", latin: "nasta'iinu ○ ...", audioTtsText: "نَستَعِين ○ ..."),
              IqroWordItem(id: "5_3_r1_2_1", arabic: "مُهتَدِين ○ ...", latin: "muhtadiina ○ ...", audioTtsText: "مُهتَدِين ○ ..."),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_3_r2_1_0", arabic: "عَينَ اليَقِين ○ ...", latin: "'aina alyaqiini ○ ...", audioTtsText: "عَينَ اليَقِين ○ ..."),
              IqroWordItem(id: "5_3_r2_2_1", arabic: "وَطُورِ سِينِين ○ ...", latin: "wathuuri siiniina ○ ...", audioTtsText: "وَطُورِ سِينِين ○ ..."),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_3_r3_1_0", arabic: "يَكذِبُون ○ ...", latin: "yukadzdzibuuna ○ ...", audioTtsText: "يَكذِبُون ○ ..."),
              IqroWordItem(id: "5_3_r3_2_1", arabic: "مُستَهزِءُون ○ ...", latin: "mustahzi'uuna ○ ...", audioTtsText: "مُستَهزِءُون ○ ..."),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_3_r4_1_0", arabic: "مُعرِضُون ○ ...", latin: "mu'ridhuuna ○ ...", audioTtsText: "مُعرِضُون ○ ..."),
              IqroWordItem(id: "5_3_r4_2_1", arabic: "مُصلِحُون ○ ...", latin: "mushlihuuna ○ ...", audioTtsText: "مُصلِحُون ○ ..."),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_3_r5_1_0", arabic: "فِي العُقد ○ ...", latin: "fii aluqodi ○ ...", audioTtsText: "فِي العُقد ○ ..."),
              IqroWordItem(id: "5_3_r5_2_1", arabic: "إِذَا حسَد ○ ...", latin: "idzaa hasada ○ ...", audioTtsText: "إِذَا حسَد ○ ..."),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_3_r6_1_0", arabic: "فِي تَضلِيل ○ ...", latin: "fii tadhliilin ○ ...", audioTtsText: "فِي تَضلِيل ○ ..."),
              IqroWordItem(id: "5_3_r6_2_1", arabic: "أَصحَاب الفِيل ○ ...", latin: "ashhaaba alfiili ○ ...", audioTtsText: "أَصحَاب الفِيل ○ ..."),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_3_r7_1_0", arabic: "يَختَلِفُون ○ ...", latin: "yakhtalifuuna ○ ...", audioTtsText: "يَختَلِفُون ○ ..."),
              IqroWordItem(id: "5_3_r7_2_1", arabic: "مِنَ المُمتَرِين ○ ...", latin: "mina almumtariina ○ ...", audioTtsText: "مِنَ المُمتَرِين ○ ..."),
            ],
          ),
        ],
      ),
      // Halaman 4: Halaman 4
      const IqroPage(
        jilid: 5,
        pageNumber: 4,
        title: "Halaman 4",
        instruction: "Iqro Jilid 5 Halaman 4",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "5_4_r1_1_0", arabic: "وَقَومَهُمَا لَنَا عَابِدُون ○", latin: "waqoumahumaa lanaa 'aabiduuna ○", audioTtsText: "وَقَومَهُمَا لَنَا عَابِدُون ○"),
              IqroWordItem(id: "5_4_r1_2_1", arabic: "وَمَا بَينَهُمَا لَعِبِين ○", latin: "wamaa bainahumaa la'ibiina ○", audioTtsText: "وَمَا بَينَهُمَا لَعِبِين ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_4_r2_1_0", arabic: "ذَلِكَ الفَوزُ العَظِيم ○", latin: "dzaalika alfauzu al'azhiimu ○", audioTtsText: "ذَلِكَ الفَوزُ العَظِيم ○"),
              IqroWordItem(id: "5_4_r2_2_1", arabic: "كَذَلِكَ نَجزِي المُحسِنِين ○", latin: "kadzaalika najzii almuhsiniina ○", audioTtsText: "كَذَلِكَ نَجزِي المُحسِنِين ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_4_r3_1_0", arabic: "وَهُم لَا يَشعُرُون ○", latin: "wahum laa yasy'uruuna ○", audioTtsText: "وَهُم لَا يَشعُرُون ○"),
              IqroWordItem(id: "5_4_r3_2_1", arabic: "هُم فِيهَا خَالِدُون ○", latin: "hum fiihaa khooliduuna ○", audioTtsText: "هُم فِيهَا خَالِدُون ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_4_r4_1_0", arabic: "فِي العَذَابِ مُشترِكُون ○", latin: "fii al'adzaabi musytarikuuna ○", audioTtsText: "فِي العَذَابِ مُشترِكُون ○"),
              IqroWordItem(id: "5_4_r4_2_1", arabic: "مَا لَكُم لَا تَنَاصَرُون ○", latin: "maa lakum laa tanaashoruuna ○", audioTtsText: "مَا لَكُم لَا تَنَاصَرُون ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_4_r5_1_0", arabic: "وَأَكثَرُهُم الفَاسِقُون ○", latin: "wa'aktsaruhum alfaasiquuna ○", audioTtsText: "وَأَكثَرُهُم الفَاسِقُون ○"),
              IqroWordItem(id: "5_4_r5_2_1", arabic: "فَمَا لَهُم لَا يُؤمِنُون ○", latin: "famaa lahum laa yu'minuuna ○", audioTtsText: "فَمَا لَهُم لَا يُؤمِنُون ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_4_r6_1_0", arabic: "اعلَمُوا مَا لَا تَعلَمُون ○", latin: "a'lamuu maa laa ta'lamuuna ○", audioTtsText: "اعلَمُوا مَا لَا تَعلَمُون ○"),
              IqroWordItem(id: "5_4_r6_2_1", arabic: "مِن حَيثُ لَا يَشعُرُون ○", latin: "min haitsu laa yasy'uruuna ○", audioTtsText: "مِن حَيثُ لَا يَشعُرُون ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_4_r7_1_0", arabic: "ذُو الجَلَالِ وَالإِكرَام ○", latin: "dzuu aljalaali walikroomi ○", audioTtsText: "ذُو الجَلَالِ وَالإِكرَام ○"),
              IqroWordItem(id: "5_4_r7_2_1", arabic: "وَتَوَاصَوا بِالمَرحَمَة ○", latin: "watawaashou bilmarhamati ○", audioTtsText: "وَتَوَاصَوا بِالمَرحَمَة ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_4_r8_1_0", arabic: "إِرَمَ ذَاتَ العِمَاد ○", latin: "iroma dzaata al'imaadi ○", audioTtsText: "إِرَمَ ذَاتَ العِمَاد ○"),
              IqroWordItem(id: "5_4_r8_2_1", arabic: "وَفِرعَونَ ذِي الأَوتَاد ○", latin: "wafir'auna dzii alautaadi ○", audioTtsText: "وَفِرعَونَ ذِي الأَوتَاد ○"),
            ],
          ),
        ],
      ),
      // Halaman 5: Halaman 5
      const IqroPage(
        jilid: 5,
        pageNumber: 5,
        title: "Halaman 5",
        instruction: "Iqro Jilid 5 Halaman 5",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "5_5_r1_1_0", arabic: "فِي الفُلكِ المَشحُون ○", latin: "fii alfulki almasyhuuni ○", audioTtsText: "فِي الفُلكِ المَشحُون ○"),
              IqroWordItem(id: "5_5_r1_2_1", arabic: "وَنَحنُ لَهُ مُسلِمُون ○", latin: "wanahnu lahu muslimuuna ○", audioTtsText: "وَنَحنُ لَهُ مُسلِمُون ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_5_r2_1_0", arabic: "فَمَا لَكُم كَيفَ تَحكُمُون ○", latin: "famaa lakum kaifa tahkumuuna ○", audioTtsText: "فَمَا لَكُم كَيفَ تَحكُمُون ○"),
              IqroWordItem(id: "5_5_r2_2_1", arabic: "وَمَا كَانُوا مُهتَدِين ○", latin: "wamaa kaanuu muhtadiina ○", audioTtsText: "وَمَا كَانُوا مُهتَدِين ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_5_r3_1_0", arabic: "لَا يُفلِحُ الكَافِرُون ○", latin: "laa yuflihu alkaafiruuna ○", audioTtsText: "لَا يُفلِحُ الكَافِرُون ○"),
              IqroWordItem(id: "5_5_r3_2_1", arabic: "هُوَ الخَسرَانُ المُبِين ○", latin: "huwa alkhosroonu almubiinu ○", audioTtsText: "هُوَ الخَسرَانُ المُبِين ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_5_r4_1_0", arabic: "بِالآخِرَةِ هُم يُوقِنُون ○", latin: "bilaakhiroti hum yuuqinuuna ○", audioTtsText: "بِالآخِرَةِ هُم يُوقِنُون ○"),
              IqroWordItem(id: "5_5_r4_2_1", arabic: "وَهُم لَا يَشعُرُون ○", latin: "wahum laa yasy'uruuna ○", audioTtsText: "وَهُم لَا يَشعُرُون ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_5_r5_1_0", arabic: "بَل عَجِبتَ وَيَسخَرُون ○", latin: "bal 'ajibta wayaskhoruuna ○", audioTtsText: "بَل عَجِبتَ وَيَسخَرُون ○"),
              IqroWordItem(id: "5_5_r5_2_1", arabic: "كَذَلِكَ نَفعَلُ بِالمُجرمِين ○", latin: "kadzaalika naf'alu bilmujrimiina ○", audioTtsText: "كَذَلِكَ نَفعَلُ بِالمُجرمِين ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_5_r6_1_0", arabic: "سَنَسِمُهُ عَلَى الخُرطُوم ○", latin: "sanasimuhu 'alaa alkhurthuumi ○", audioTtsText: "سَنَسِمُهُ عَلَى الخُرطُوم ○"),
              IqroWordItem(id: "5_5_r6_2_1", arabic: "وَهَذَا البَلَدِ الأَمِين ○", latin: "wahadzaa albaladi alamiini ○", audioTtsText: "وَهَذَا البَلَدِ الأَمِين ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_5_r7_1_0", arabic: "مَا كَانُوا بِهِ يَستَمتِعُون ○", latin: "maa kaanuu bihi yastamti'uuna ○", audioTtsText: "مَا كَانُوا بِهِ يَستَمتِعُون ○"),
              IqroWordItem(id: "5_5_r7_2_1", arabic: "وَمَا كَانَ مِنَ المُشرِكِين ○", latin: "wamaa kaana mina almusyrikiina ○", audioTtsText: "وَمَا كَانَ مِنَ المُشرِكِين ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_5_r8_1_0", arabic: "هُم اليَومَ مُستَسلِمُون ○", latin: "hum alyauma mustaslimuuna ○", audioTtsText: "هُم اليَومَ مُستَسلِمُون ○"),
              IqroWordItem(id: "5_5_r8_2_1", arabic: "صِرَاطَكَ المُستَقِيم ○", latin: "shiroothoqa almustaqiima ○", audioTtsText: "صِرَاطَكَ المُستَقِيم ○"),
            ],
          ),
        ],
      ),
      // Halaman 6: Halaman 6
      const IqroPage(
        jilid: 5,
        pageNumber: 6,
        title: "Halaman 6",
        instruction: "Bila waqof/berhenti tanwin (fathah) dihilangkan dan dibaca panjang. Contoh: ABADAN dibaca ABADAA.",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "5_6_r1_1_0", arabic: "يَومَ القِيَمَةِ وَزنًا ○", latin: "yauwa alqiyaamati waznan ○", audioTtsText: "يَومَ القِيَمَةِ وَزنًا ○"),
              IqroWordItem(id: "5_6_r1_2_1", arabic: "وَالعَدِيَتِ ضَبحًا ○", latin: "wal'aadiyaati dhabhan ○", audioTtsText: "وَالعَدِيَتِ ضَبحًا ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_6_r2_1_0", arabic: "فَالمُورِيَتِ قَدحًا ○", latin: "falmuuriyaati qodhan ○", audioTtsText: "فَالمُورِيَتِ قَدحًا ○"),
              IqroWordItem(id: "5_6_r2_2_1", arabic: "فَالمُغِيرَتِ صُبحًا ○", latin: "falmughiirooti shubhan ○", audioTtsText: "فَالمُغِيرَتِ صُبحًا ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_6_r3_1_0", arabic: "فَأَثَرنَ بِهِ نَقعًا ○", latin: "fa'atsarna bihi naq'an ○", audioTtsText: "فَأَثَرنَ بِهِ نَقعًا ○"),
              IqroWordItem(id: "5_6_r3_2_1", arabic: "فَوَسَطنَ بِهِ جَمعًا ○", latin: "fawasathna bihi jam'an ○", audioTtsText: "فَوَسَطنَ بِهِ جَمعًا ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_6_r4_1_0", arabic: "وَخَلَقنَاكُم أَزوَاجًا ○", latin: "wakholaqnaakum azwaajan ○", audioTtsText: "وَخَلَقنَاكُم أَزوَاجًا ○"),
              IqroWordItem(id: "5_6_r4_2_1", arabic: "وَجَعَلنَا نَومَكُم سُبَاتًا ○", latin: "waja'alnaa naumakum subaatan ○", audioTtsText: "وَجَعَلنَا نَومَكُم سُبَاتًا ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_6_r5_1_0", arabic: "بِالأَخسَرِينَ أَعمَالًا ○", latin: "bilakhsariina a'maalan ○", audioTtsText: "بِالأَخسَرِينَ أَعمَالًا ○"),
              IqroWordItem(id: "5_6_r5_2_1", arabic: "يُحسِنُونَ صُنعًا ○", latin: "yuhsinuuna shun'an ○", audioTtsText: "يُحسِنُونَ صُنعًا ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_6_r6_1_0", arabic: "كَانُوا مِن أَيَاتِنَا عَجَبًا ○", latin: "kaanuu min aayaatinaa 'ajaban ○", audioTtsText: "كَانُوا مِن أَيَاتِنَا عَجَبًا ○"),
              IqroWordItem(id: "5_6_r6_2_1", arabic: "وَزِدنَاهُم هُدًى ○", latin: "wazidnaahum hudan ○", audioTtsText: "وَزِدنَاهُم هُدًى ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_6_r7_1_0", arabic: "فَسَوفَ يَدعُوا ثُبُورًا ○", latin: "fasaufa yad'uu tsubuuron ○", audioTtsText: "فَسَوفَ يَدعُوا ثُبُورًا ○"),
              IqroWordItem(id: "5_6_r7_2_1", arabic: "وَيَصلَى سَعِيرًا ○", latin: "wayashlaa sa'iiron ○", audioTtsText: "وَيَصلَى سَعِيرًا ○"),
            ],
          ),
        ],
      ),
      // Halaman 7: Halaman 7
      const IqroPage(
        jilid: 5,
        pageNumber: 7,
        title: "Halaman 7",
        instruction: "Bila waqof/berhenti (ta marbutah) berobah menjadi ha sukun/mati. Contoh: ANIYATIN dibaca ANIYAH.",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "5_7_r1_1_0", arabic: "تَصلَى نَارًا حَامِيَة ○", latin: "tashlaa naaron haamiyatan ○", audioTtsText: "تَصلَى نَارًا حَامِيَة ○"),
              IqroWordItem(id: "5_7_r1_2_1", arabic: "تُسقَى مِن عَينٍ أَنِيَة ○", latin: "tusqoo min 'ainin aaniyatin ○", audioTtsText: "تُسقَى مِن عَينٍ أَنِيَة ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_7_r2_1_0", arabic: "لَسَعيُهَا رَاضِيَة ○", latin: "lasa'yuhaa roodhiyatun ○", audioTtsText: "لَسَعيُهَا رَاضِيَة ○"),
              IqroWordItem(id: "5_7_r2_2_1", arabic: "لَا تَسمَعُ فِيهَا لَاغِيَة ○", latin: "laa tasma'u fiihaa laaghiyatan ○", audioTtsText: "لَا تَسمَعُ فِيهَا لَاغِيَة ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_7_r3_1_0", arabic: "مَا لَهُم بِهِ خَبرًا ○", latin: "maa lahum bihi khabaron ○", audioTtsText: "مَا لَهُم بِهِ خَبرًا ○"),
              IqroWordItem(id: "5_7_r3_2_1", arabic: "بِهَذَا الحَدِيثِ أَسَفًا ○", latin: "bihaadzaa alhadiitsi asafan ○", audioTtsText: "بِهَذَا الحَدِيثِ أَسَفًا ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_7_r4_1_0", arabic: "مَا نَحنُ بِمُستَيقِنِين ○", latin: "maa nahnu bimustaiqiniina ○", audioTtsText: "مَا نَحنُ بِمُستَيقِنِين ○"),
              IqroWordItem(id: "5_7_r4_2_1", arabic: "وَهُوَ خَيرُ الحَكِمِين ○", latin: "wahuwa khoiru alhaakimiina ○", audioTtsText: "وَهُوَ خَيرُ الحَكِمِين ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_7_r5_1_0", arabic: "هَل أَتَاكَ حَدِيثُ الجُنُود ○", latin: "hal ata aka hadiitsu aljunuudi ○", audioTtsText: "هَل أَتَاكَ حَدِيثُ الجُنُود ○"),
              IqroWordItem(id: "5_7_r5_2_1", arabic: "فِرعَونَ وَثَمُود ○", latin: "fir'auna watsamuuda ○", audioTtsText: "فِرعَونَ وَثَمُود ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_7_r6_1_0", arabic: "إِذَا وَقَعَتِ الوَاقِعَة ○", latin: "idzaa waqo'oti alwaaqi'atu ○", audioTtsText: "إِذَا وَقَعَتِ الوَاقِعَة ○"),
              IqroWordItem(id: "5_7_r6_2_1", arabic: "لَيسَ لِوَقعَتِهَا كَاذِبَة ○", latin: "laisa liwaq'otihaa kaadzibatun ○", audioTtsText: "لَيسَ لِوَقعَتِهَا كَاذِبَة ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_7_r7_1_0", arabic: "وَالقَمَرِ إِذَا تَلَاهَا ○", latin: "walqomari idzaa talaahaa ○", audioTtsText: "وَالقَمَرِ إِذَا تَلَاهَا ○"),
              IqroWordItem(id: "5_7_r7_2_1", arabic: "وَالأَرضِ وَمَا طَحَاهَا ○", latin: "walardhi wamaa thohaahaa ○", audioTtsText: "وَالأَرضِ وَمَا طَحَاهَا ○"),
            ],
          ),
        ],
      ),
      // Halaman 8: Halaman 8
      const IqroPage(
        jilid: 5,
        pageNumber: 8,
        title: "Halaman 8",
        instruction: "Iqro Jilid 5 Halaman 8",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "5_8_r1_1_0", arabic: "وَالقَمَرِ بِحُسبَانٍ ○", latin: "walqomari bihusbaanin ○", audioTtsText: "وَالقَمَرِ بِحُسبَانٍ ○"),
              IqroWordItem(id: "5_8_r1_2_1", arabic: "وَوَضَعَ المِيزَانَ ○", latin: "wawadho'a almiizaana ○", audioTtsText: "وَوَضَعَ المِيزَانَ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_8_r2_1_0", arabic: "فَأَكثَرُوا فِيهَا الفَسَادَ ○", latin: "fa'aktsaruu fiihaa alfasaada ○", audioTtsText: "فَأَكثَرُوا فِيهَا الفَسَادَ ○"),
              IqroWordItem(id: "5_8_r2_2_1", arabic: "يُضَعَّف لَهُمُ العَذَابُ ○", latin: "yudho''afu lahumu al'adzaabu ○", audioTtsText: "يُضَعَّف لَهُمُ العَذَابُ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_8_r3_1_0", arabic: "وَتَضحَكُونَ وَلَا تَبكُونَ ○", latin: "watadhhakuuna walaa tabkuuna ○", audioTtsText: "وَتَضحَكُونَ وَلَا تَبكُونَ ○"),
              IqroWordItem(id: "5_8_r3_2_1", arabic: "ذَلِكَ الخِزيُ العَظِيمُ ○", latin: "dzaalika alkhizyu al'azhiimu ○", audioTtsText: "ذَلِكَ الخِزيُ العَظِيمُ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_8_r4_1_0", arabic: "مَاكِثِينَ فِيهِ أَبَدًا ○", latin: "maakitsiina fiihi abadan ○", audioTtsText: "مَاكِثِينَ فِيهِ أَبَدًا ○"),
              IqroWordItem(id: "5_8_r4_2_1", arabic: "هَل يَستَوِينَ مَثَلًا ○", latin: "hal yastawiina matsalan ○", audioTtsText: "هَل يَستَوِينَ مَثَلًا ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_8_r5_1_0", arabic: "وَهُوَ بِالأُفُقِ الأَعلَى ○", latin: "wahuwa bilufuqi ala'laa ○", audioTtsText: "وَهُوَ بِالأُفُقِ الأَعلَى ○"),
              IqroWordItem(id: "5_8_r5_2_1", arabic: "فَحَشرَ فَنَادَى ○", latin: "fahasyaro fanaadaa ○", audioTtsText: "فَحَشرَ فَنَادَى ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_8_r6_1_0", arabic: "أَلَم يَأتِكُم نَذِيرٌ ○", latin: "alam ya'tikum nadziirun ○", audioTtsText: "أَلَم يَأتِكُم نَذِيرٌ ○"),
              IqroWordItem(id: "5_8_r6_2_1", arabic: "وَهُوَ الحَكِيمُ الخَبِيرُ ○", latin: "wahuwa alhakiimu alkhobiiru ○", audioTtsText: "وَهُوَ الحَكِيمُ الخَبِيرُ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_8_r7_1_0", arabic: "فَارتَقِبهُم وَاصطَبِر ○", latin: "fartaqibhum washthabir ○", audioTtsText: "فَارتَقِبهُم وَاصطَبِر ○"),
              IqroWordItem(id: "5_8_r7_2_1", arabic: "كَهشِيمِ المُحتَظِرِ ○", latin: "kahasyiimi almuhtazhiri ○", audioTtsText: "كَهشِيمِ المُحتَظِرِ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_8_r8_1_0", arabic: "وَنَمَارِقُ مَصفُوفَةٌ ○", latin: "wanamaariqu mashfuufatun ○", audioTtsText: "وَنَمَارِقُ مَصفُوفَةٌ ○"),
              IqroWordItem(id: "5_8_r8_2_1", arabic: "وَتَوَاصَوا بِالمَرحَمَةِ ○", latin: "watawaashou bilmarhamati ○", audioTtsText: "وَتَوَاصَوا بِالمَرحَمَةِ ○"),
            ],
          ),
        ],
      ),
      // Halaman 9: Huruf لَا أَعبُدُ - أُولَئِكَ (LAA A'BUDU - UULAA'IKA)
      const IqroPage(
        jilid: 5,
        pageNumber: 9,
        title: "Huruf لَا أَعبُدُ - أُولَئِكَ (LAA A'BUDU - UULAA'IKA)",
        instruction: "Dibaca panjang 5 harokat. Huruf و dianggap tidak ada.",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "5_9_r1_1_0", arabic: "لَا أَعبُدُ مَا تَعبُدُون ○", latin: "laa a'budu maa ta'buduuna ○", audioTtsText: "لَا أَعبُدُ مَا تَعبُدُون ○"),
              IqroWordItem(id: "5_9_r1_2_1", arabic: "أُولَئِكَ هُمُ المُفلِحُون ○", latin: "uulaa'ika humu almuflihuuna ○", audioTtsText: "أُولَئِكَ هُمُ المُفلِحُون ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_9_r2_1_0", arabic: "عَلَى أَثَارِهِم يَهرَعُون ○", latin: "'alaa aatsaarihim yahro'uuna ○", audioTtsText: "عَلَى أَثَارِهِم يَهرَعُون ○"),
              IqroWordItem(id: "5_9_r2_2_1", arabic: "وَسَلَامٌ عَلَى المُرسَلِين ○", latin: "wasalaamun 'alaa almursaliina ○", audioTtsText: "وَسَلَامٌ عَلَى المُرسَلِين ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_9_r3_1_0", arabic: "أُولَئِكَ عَلَى هُدًى ○", latin: "uulaa'ika 'alaa hudan ○", audioTtsText: "أُولَئِكَ عَلَى هُدًى ○"),
              IqroWordItem(id: "5_9_r3_2_1", arabic: "مَاكِثِينَ فِيهِ أَبَدًا ○", latin: "maakitsiina fiihi abadan ○", audioTtsText: "مَاكِثِينَ فِيهِ أَبَدًا ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_9_r4_1_0", arabic: "أَلَم نَجعَلِ الأَرضَ مِهَادًا ○", latin: "alam naj'ali alardho mihaadan ○", audioTtsText: "أَلَم نَجعَلِ الأَرضَ مِهَادًا ○"),
              IqroWordItem(id: "5_9_r4_2_1", arabic: "بِهَذَا الحَدِيثِ أَسَفًا ○", latin: "bihaadzaa alhadiitsi asafan ○", audioTtsText: "بِهَذَا الحَدِيثِ أَسَفًا ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_9_r5_1_0", arabic: "مِن أَولِيَاءَ ○", latin: "min auliyaa'a ○", audioTtsText: "مِن أَولِيَاءَ ○"),
              IqroWordItem(id: "5_9_r5_2_1", arabic: "أُولَئِكَ هُمُ الكَفَرَةُ الفَجَرَةُ ○", latin: "uulaa'ika humu alkafarotu alfajarotu ○", audioTtsText: "أُولَئِكَ هُمُ الكَفَرَةُ الفَجَرَةُ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_9_r6_1_0", arabic: "لَا إِلَى هَؤُلَاءِ وَلَا إِلَى هَؤُلَاءِ ○", latin: "laa ilaa haa'ulaa'i walaa ilaa haa'ulaa'i ○", audioTtsText: "لَا إِلَى هَؤُلَاءِ وَلَا إِلَى هَؤُلَاءِ ○"),
            ],
          ),
        ],
      ),
      // Halaman 10: Huruf إِنَّ = إِنَّ (INNA = INNA)
      const IqroPage(
        jilid: 5,
        pageNumber: 10,
        title: "Huruf إِنَّ = إِنَّ (INNA = INNA)",
        instruction: "Setiap bacaan yang menghadap tasydid (syaddah) suara ditekan, ditahan 2 harokat dan berdengung.",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "5_10_r1_1_0", arabic: "أَنَّ", latin: "anna", audioTtsText: "أَنَّ"),
              IqroWordItem(id: "5_10_r1_2_1", arabic: "عَمَّ", latin: "'amma", audioTtsText: "عَمَّ"),
              IqroWordItem(id: "5_10_r1_3_2", arabic: "أَنَّ", latin: "anna", audioTtsText: "أَنَّ"),
              IqroWordItem(id: "5_10_r1_4_3", arabic: "عَمَّ", latin: "'amma", audioTtsText: "عَمَّ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_10_r2_1_0", arabic: "إِنَّهُ - إِنَّهَا", latin: "innahu - innahaa", audioTtsText: "إِنَّهُ - إِنَّهَا"),
              IqroWordItem(id: "5_10_r2_2_1", arabic: "أُمَّهُ - أُمَّهَا", latin: "ummahu - ummahaa", audioTtsText: "أُمَّهُ - أُمَّهَا"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_10_r3_1_0", arabic: "إِنَّهُم كَانُوا مُجرمِين ○", latin: "innahum kaanuu mujrimiina ○", audioTtsText: "إِنَّهُم كَانُوا مُجرمِين ○"),
              IqroWordItem(id: "5_10_r3_2_1", arabic: "وَإِنَّا إِلَيهِ رَاجِعُون ○", latin: "wa'innaa ilaihi rooji'uuna ○", audioTtsText: "وَإِنَّا إِلَيهِ رَاجِعُون ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_10_r4_1_0", arabic: "ثُمَّ أَدبَرَ يَسعَى ○", latin: "tsumma adbaro yas'aa ○", audioTtsText: "ثُمَّ أَدبَرَ يَسعَى ○"),
              IqroWordItem(id: "5_10_r4_2_1", arabic: "فَإِنَّ الجَحِيمَ هِيَ المَأوَى ○", latin: "fa'inna aljahiima hiya alma'waa ○", audioTtsText: "فَإِنَّ الجَحِيمَ هِيَ المَأوَى ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_10_r5_1_0", arabic: "لَبِثِينَ فِيهَا أَحقَابًا ○", latin: "laabitsiina fiihaa ahqooban ○", audioTtsText: "لَبِثِينَ فِيهَا أَحقَابًا ○"),
              IqroWordItem(id: "5_10_r5_2_1", arabic: "حَدَائِقَ وَأَعنَابًا ○", latin: "hadaaa'iqo wa'a'naaban ○", audioTtsText: "حَدَائِقَ وَأَعنَابًا ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_10_r6_1_0", arabic: "إِنَّ هَذِهِ تَذكِرَةٌ ○", latin: "inna haadzihi tadzkhirotun ○", audioTtsText: "إِنَّ هَذِهِ تَذكِرَةٌ ○"),
              IqroWordItem(id: "5_10_r6_2_1", arabic: "ثُمَّ أَمَاتَهُ فَأَقبَرَهُ ○", latin: "tsumma amaatahu fa'aqborohu ○", audioTtsText: "ثُمَّ أَمَاتَهُ فَأَقبَرَهُ ○"),
            ],
          ),
        ],
      ),
      // Halaman 11: نْ ← ن/م
      const IqroPage(
        jilid: 5,
        pageNumber: 11,
        title: "نْ ← ن/م",
        instruction: "Masuk dengan suara dengung.",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "5_11_r1_1_0", arabic: "خَيرٌ - نِسَاء ○", latin: "khoirun - nisaa'a ○", audioTtsText: "خَيرٌ - نِسَاء ○"),
              IqroWordItem(id: "5_11_r1_2_1", arabic: "مِن - مَّاء ○", latin: "min - mmaa'a ○", audioTtsText: "مِن - مَّاء ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_11_r2_1_0", arabic: "وَمَا لَهُم مِّن نَّصِيرِين ○", latin: "wamaa lahum min nashiiriina ○", audioTtsText: "وَمَا لَهُم مِّن نَّصِيرِين ○"),
              IqroWordItem(id: "5_11_r2_2_1", arabic: "هُوَ فِي ضَلَالٍ مُّبِين ○", latin: "huwa fii dholaalin mubiinin ○", audioTtsText: "هُوَ فِي ضَلَالٍ مُّبِين ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_11_r3_1_0", arabic: "عَلَى صِرَاطٍ مُّستَقِيم ○", latin: "'alaa shiroothin mustaqiimin ○", audioTtsText: "عَلَى صِرَاطٍ مُّستَقِيم ○"),
              IqroWordItem(id: "5_11_r3_2_1", arabic: "ثُمَّ دَمَّرنَا الآخَرِين ○", latin: "tsumma dammarnaalaakhoriina ○", audioTtsText: "ثُمَّ دَمَّرنَا الآخَرِين ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_11_r4_1_0", arabic: "قَلِيلًا مَّا تَشكُرُون ○", latin: "qoliilan mmaa tasykuruuna ○", audioTtsText: "قَلِيلًا مَّا تَشكُرُون ○"),
              IqroWordItem(id: "5_11_r4_2_1", arabic: "قَالَ إِنَّكُم مَّاكِثُون ○", latin: "qoola innakum mmaakitsuuna ○", audioTtsText: "قَالَ إِنَّكُم مَّاكِثُون ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_11_r5_1_0", arabic: "لِيَقضِيَ أَجَلٌ مُّسَمًّى ○", latin: "liyaqdhiya ajalun musamman ○", audioTtsText: "لِيَقضِيَ أَجَلٌ مُّسَمًّى ○"),
              IqroWordItem(id: "5_11_r5_2_1", arabic: "إِنَّ كَيدِي مَتِينٌ ○", latin: "inna kaidii matiinun ○", audioTtsText: "إِنَّ كَيدِي مَتِينٌ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_11_r6_1_0", arabic: "وَلَن نُّعجِزَهُ هَرَبًا ○", latin: "walan nu'jizahu haroban ○", audioTtsText: "وَلَن نُّعجِزَهُ هَرَبًا ○"),
              IqroWordItem(id: "5_11_r6_2_1", arabic: "فَكُلُوا هَنِيئًا مَّرِيئًا ○", latin: "fakuluu hanii'an marii'an ○", audioTtsText: "فَكُلُوا هَنِيئًا مَّرِيئًا ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_11_r7_1_0", arabic: "عَامِلَةٌ نَّاصِبَةٌ ○", latin: "'aamilatun naashibatun ○", audioTtsText: "عَامِلَةٌ نَّاصِبَةٌ ○"),
              IqroWordItem(id: "5_11_r7_2_1", arabic: "خُشُبٌ مُّسَنَّدَةٌ ○", latin: "khusyubun musannadatun ○", audioTtsText: "خُشُبٌ مُّسَنَّدَةٌ ○"),
            ],
          ),
        ],
      ),
      // Halaman 12: ال...
      const IqroPage(
        jilid: 5,
        pageNumber: 12,
        title: "ال...",
        instruction: "Al (Alief Lam) dianggap tidak ada.",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "5_12_r1_1_0", arabic: "وَالنَّهَارِ", latin: "wannahaari", audioTtsText: "وَالنَّهَارِ"),
              IqroWordItem(id: "5_12_r1_2_1", arabic: "وَالنَّاسِ", latin: "wannasi", audioTtsText: "وَالنَّاسِ"),
              IqroWordItem(id: "5_12_r1_3_2", arabic: "بِالنُّذُرِ", latin: "binnudzuri", audioTtsText: "بِالنُّذُرِ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_12_r2_1_0", arabic: "فِي صُدُورِ النَّاسِ ○", latin: "fii shuduuri annasi ○", audioTtsText: "فِي صُدُورِ النَّاسِ ○"),
              IqroWordItem(id: "5_12_r2_2_1", arabic: "الوَسوَاسِ الخَنَّاسِ ○", latin: "alwaswaasi alkhonnaasi ○", audioTtsText: "الوَسوَاسِ الخَنَّاسِ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_12_r3_1_0", arabic: "وَالنَّازِعَاتِ غَرقًا ○", latin: "wanna azi'aati ghorqon ○", audioTtsText: "وَالنَّازِعَاتِ غَرقًا ○"),
              IqroWordItem(id: "5_12_r3_2_1", arabic: "وَالنَّاشِطَاتِ نَشطًا ○", latin: "wannasyithooti nasython ○", audioTtsText: "وَالنَّاشِطَاتِ نَشطًا ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_12_r4_1_0", arabic: "وَكُنَّا نَخوضُ مَعَ الخَائِضِينَ ○", latin: "wakunnaa nakhuudhu ma'a alkhoaidhiina ○", audioTtsText: "وَكُنَّا نَخوضُ مَعَ الخَائِضِينَ ○"),
              IqroWordItem(id: "5_12_r4_2_1", arabic: "أَم كَانَ مِنَ الغَائِبِينَ ○", latin: "am kaana mina alghoo'ibiina ○", audioTtsText: "أَم كَانَ مِنَ الغَائِبِينَ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_12_r5_1_0", arabic: "إِنِّي لَكُم نَذِيرٌ مُّبِينٌ ○", latin: "innii lakum nadziirun mubiinun ○", audioTtsText: "إِنِّي لَكُم نَذِيرٌ مُّبِينٌ ○"),
              IqroWordItem(id: "5_12_r5_2_1", arabic: "وَمَا لَكُم مِّن نَّاصِرِينَ ○", latin: "wamaa lakum min naashiriina ○", audioTtsText: "وَمَا لَكُم مِّن نَّاصِرِينَ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_12_r6_1_0", arabic: "عَمَّ يَتَسَاءَلُونَ ○", latin: "'amma yatasaa'aluuna ○", audioTtsText: "عَمَّ يَتَسَاءَلُونَ ○"),
              IqroWordItem(id: "5_12_r6_2_1", arabic: "عَنِ النَّبَإِ العَظِيمِ ○", latin: "'ani annaba'i al'azhiimi ○", audioTtsText: "عَنِ النَّبَإِ العَظِيمِ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_12_r7_1_0", arabic: "إِذَا كُنَّا عِظَامًا نَّخِرَةً ○", latin: "idzaa kunnaa 'izhooman nakhirotan ○", audioTtsText: "إِذَا كُنَّا عِظَامًا نَّخِرَةً ○"),
              IqroWordItem(id: "5_12_r7_2_1", arabic: "أُولَئِكَ أَصحَابُ الجَنَّةِ ○", latin: "uulaa'ika ashhaabu aljannati ○", audioTtsText: "أُولَئِكَ أَصحَابُ الجَنَّةِ ○"),
            ],
          ),
        ],
      ),
      // Halaman 13: Halaman 13
      const IqroPage(
        jilid: 5,
        pageNumber: 13,
        title: "Halaman 13",
        instruction: "Iqro Jilid 5 Halaman 13",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "5_13_r1_1_0", arabic: "النَّارِ ذَاتَ الوَقُودِ ○", latin: "annaari dzaata alwaquudi ○", audioTtsText: "النَّارِ ذَاتَ الوَقُودِ ○"),
              IqroWordItem(id: "5_13_r1_2_1", arabic: "إِذ هُم عَلَيهَا قُعُودٌ ○", latin: "idz hum 'alaihaa qu'uudun ○", audioTtsText: "إِذ هُم عَلَيهَا قُعُودٌ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_13_r2_1_0", arabic: "إِنَّ جَهَنَّمَ كَانَت مِرصَادًا ○", latin: "inna jahannama kaanat mirshoodan ○", audioTtsText: "إِنَّ جَهَنَّمَ كَانَت مِرصَادًا ○"),
              IqroWordItem(id: "5_13_r2_2_1", arabic: "لِلطَّاغِينَ مَأبًا ○", latin: "liththooghiina ma'aban ○", audioTtsText: "لِلطَّاغِينَ مَأبًا ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_13_r3_1_0", arabic: "إِنَّهُ لَمِنَ الكَاذِبِينَ ○", latin: "innahu lamina alkaadzibiina ○", audioTtsText: "إِنَّهُ لَمِنَ الكَاذِبِينَ ○"),
              IqroWordItem(id: "5_13_r3_2_1", arabic: "ثُمَّ أَغرَقنَا الآخَرِينَ ○", latin: "tsumma aghroqnaalaakhoriina ○", audioTtsText: "ثُمَّ أَغرَقنَا الآخَرِينَ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_13_r4_1_0", arabic: "وَلَا تُبطِلُوا أَعمَالَكُم ○", latin: "walaa tubthiluu a'maalakum ○", audioTtsText: "وَلَا تُبطِلُوا أَعمَالَكُم ○"),
              IqroWordItem(id: "5_13_r4_2_1", arabic: "ثُمَّ قَضَى أَجَلًا ○", latin: "tsumma qodhoo ajalan ○", audioTtsText: "ثُمَّ قَضَى أَجَلًا ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_13_r5_1_0", arabic: "فِيهَا سُرُرٌ مَّرفُوعَةٌ ○", latin: "fiihaa sururun marfuu'atun ○", audioTtsText: "فِيهَا سُرُرٌ مَّرفُوعَةٌ ○"),
              IqroWordItem(id: "5_13_r5_2_1", arabic: "وَأَكوَابٌ مَّوضُوعَةٌ ○", latin: "wa'akwaabun mawdhuu'atun ○", audioTtsText: "وَأَكوَابٌ مَّوضُوعَةٌ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_13_r6_1_0", arabic: "إِنَّ هَذَا لَشَيءٌ عَجِيبٌ ○", latin: "inna haadzaa lasyai'un 'ajiibun ○", audioTtsText: "إِنَّ هَذَا لَشَيءٌ عَجِيبٌ ○"),
              IqroWordItem(id: "5_13_r6_2_1", arabic: "إِنَّهُ حَمِيدٌ مَّجِيدٌ ○", latin: "innahu hamiidun majiidun ○", audioTtsText: "إِنَّهُ حَمِيدٌ مَّجِيدٌ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_13_r7_1_0", arabic: "إِنَّ إِلَينَا إِيَابَهُم ○", latin: "inna ilainaa iyaabahum ○", audioTtsText: "إِنَّ إِلَينَا إِيَابَهُم ○"),
              IqroWordItem(id: "5_13_r7_2_1", arabic: "ثُمَّ إِنَّ عَلَينَا حِسَابَهُم ○", latin: "tsumma inna 'alainaa hisaabahum ○", audioTtsText: "ثُمَّ إِنَّ عَلَينَا حِسَابَهُم ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_13_r8_1_0", arabic: "فَادخُلِي فِي عِبَادِي ○", latin: "fadkhulii fii 'ibaadii ○", audioTtsText: "فَادخُلِي فِي عِبَادِي ○"),
              IqroWordItem(id: "5_13_r8_2_1", arabic: "وَادخُلِي جَنَّتِي ○", latin: "wadkhulii jannatii ○", audioTtsText: "وَادخُلِي جَنَّتِي ○"),
            ],
          ),
        ],
      ),
      // Halaman 14: Halaman 14
      const IqroPage(
        jilid: 5,
        pageNumber: 14,
        title: "Halaman 14",
        instruction: "Setiap bacaan yang menghadap tasydid agar ditekan dan ditahan 2 harokat.",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "5_14_r1_1_0", arabic: "كَبَّرَ", latin: "kabbaro", audioTtsText: "كَبَّرَ"),
              IqroWordItem(id: "5_14_r1_2_1", arabic: "يُكَبِّرُ", latin: "yukabbiru", audioTtsText: "يُكَبِّرُ"),
              IqroWordItem(id: "5_14_r1_3_2", arabic: "رَتَّلَ", latin: "rottala", audioTtsText: "رَتَّلَ"),
              IqroWordItem(id: "5_14_r1_4_3", arabic: "يُرَتِّلُ", latin: "yurottilu", audioTtsText: "يُرَتِّلُ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_14_r2_1_0", arabic: "أَثَّرَ", latin: "atstsaro", audioTtsText: "أَثَّرَ"),
              IqroWordItem(id: "5_14_r2_2_1", arabic: "يُؤَثِّرُ", latin: "yu'tstsiru", audioTtsText: "يُؤَثِّرُ"),
              IqroWordItem(id: "5_14_r2_3_2", arabic: "عَجَّلَ", latin: "'ajjala", audioTtsText: "عَجَّلَ"),
              IqroWordItem(id: "5_14_r2_4_3", arabic: "يُعَجِّلُ", latin: "yu'ajjilu", audioTtsText: "يُعَجِّلُ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_14_r3_1_0", arabic: "لَحَّنَ", latin: "lahhana", audioTtsText: "لَحَّنَ"),
              IqroWordItem(id: "5_14_r3_2_1", arabic: "يُلَحِّنُ", latin: "yulahhinu", audioTtsText: "يُلَحِّنُ"),
              IqroWordItem(id: "5_14_r3_3_2", arabic: "سَخَّرَ", latin: "sakhkhoro", audioTtsText: "سَخَّرَ"),
              IqroWordItem(id: "5_14_r3_4_3", arabic: "يُسَخِّرُ", latin: "yusakhkhiru", audioTtsText: "يُسَخِّرُ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_14_r4_1_0", arabic: "رَبِّ زِدنِي عِلمًا ○", latin: "robbi zidnii 'ilman ○", audioTtsText: "رَبِّ زِدنِي عِلمًا ○"),
              IqroWordItem(id: "5_14_r4_2_1", arabic: "وَارزُقنِي فَهمًا ○", latin: "warzuqnii fahman ○", audioTtsText: "وَارزُقنِي فَهمًا ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_14_r5_1_0", arabic: "أَلهَاكُمُ التَّكَاثُرُ ○", latin: "alhaakumu attakaatsuru ○", audioTtsText: "أَلهَاكُمُ التَّكَاثُرُ ○"),
              IqroWordItem(id: "5_14_r5_2_1", arabic: "حَتَّى زُرتُمُ المَقَابِرَ ○", latin: "hattaa zurtumu almaqoobiro ○", audioTtsText: "حَتَّى زُرتُمُ المَقَابِرَ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_14_r6_1_0", arabic: "إِنَّ الأَبرَارَ لَفِي نَعِيمٍ ○", latin: "inna alabrooro lafii na'iimin ○", audioTtsText: "إِنَّ الأَبرَارَ لَفِي نَعِيمٍ ○"),
              IqroWordItem(id: "5_14_r6_2_1", arabic: "وَإِنَّ الفُجَّارَ لَفِي جَحِيمٍ ○", latin: "wa'inna alfujjaaro lafii jahiimin ○", audioTtsText: "وَإِنَّ الفُجَّارَ لَفِي جَحِيمٍ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_14_r7_1_0", arabic: "سُبحَانَ الَّذِي سَخَّرَ لَنَا هَذَا ○", latin: "subhaana alladzii sakhkhoro lanaa haadzaa ○", audioTtsText: "سُبحَانَ الَّذِي سَخَّرَ لَنَا هَذَا ○"),
              IqroWordItem(id: "5_14_r7_2_1", arabic: "وَمَا كُنَّا لَهُ مُقرِنِينَ ○", latin: "wamaa kunnaa lahu muqriniina ○", audioTtsText: "وَمَا كُنَّا لَهُ مُقرِنِينَ ○"),
            ],
          ),
        ],
      ),
      // Halaman 15: Halaman 15
      const IqroPage(
        jilid: 5,
        pageNumber: 15,
        title: "Halaman 15",
        instruction: "Iqro Jilid 5 Halaman 15",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "5_15_r1_1_0", arabic: "بَدَّلَ", latin: "baddala", audioTtsText: "بَدَّلَ"),
              IqroWordItem(id: "5_15_r1_2_1", arabic: "يُبَدِّلُ", latin: "yubaddilu", audioTtsText: "يُبَدِّلُ"),
              IqroWordItem(id: "5_15_r1_3_2", arabic: "أَذَّنَ", latin: "adzdzana", audioTtsText: "أَذَّنَ"),
              IqroWordItem(id: "5_15_r1_4_3", arabic: "يُؤَذِّنُ", latin: "yu'adzdzinu", audioTtsText: "يُؤَذِّنُ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_15_r2_1_0", arabic: "كَرَّمَ", latin: "karroma", audioTtsText: "كَرَّمَ"),
              IqroWordItem(id: "5_15_r2_2_1", arabic: "يُكَرِّمُ", latin: "yukarrimu", audioTtsText: "يُكَرِّمُ"),
              IqroWordItem(id: "5_15_r2_3_2", arabic: "وَذَّرَ", latin: "wadzdzaro", audioTtsText: "وَذَّرَ"),
              IqroWordItem(id: "5_15_r2_4_3", arabic: "يُوذَّرُ", latin: "yuuwadzdzaru", audioTtsText: "يُوذَّرُ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_15_r3_1_0", arabic: "فَسَّرَ", latin: "fassaro", audioTtsText: "فَسَّرَ"),
              IqroWordItem(id: "5_15_r3_2_1", arabic: "يُفَسِّرُ", latin: "yufassiru", audioTtsText: "يُفَسِّرُ"),
              IqroWordItem(id: "5_15_r3_3_2", arabic: "بَشَّرَ", latin: "basysyaro", audioTtsText: "بَشَّرَ"),
              IqroWordItem(id: "5_15_r3_4_3", arabic: "يُبَشِّرُ", latin: "yubasysyiru", audioTtsText: "يُبَشِّرُ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_15_r4_1_0", arabic: "وَاثَرَ الحَيَاةَ الدُّنيَا ○", latin: "waatsaro alhayaata addunyaa ○", audioTtsText: "وَاثَرَ الحَيَاةَ الدُّنيَا ○"),
              IqroWordItem(id: "5_15_r4_2_1", arabic: "وَكَذَّبَ بِالحُسنَى ○", latin: "wakadzdzaba bilhusnaa ○", audioTtsText: "وَكَذَّبَ بِالحُسنَى ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_15_r5_1_0", arabic: "وَالمَلَكُ عَلَى أَرجَائِهَا ○", latin: "walmalaku 'alaa arjaaa'ihaa ○", audioTtsText: "وَالمَلَكُ عَلَى أَرجَائِهَا ○"),
              IqroWordItem(id: "5_15_r5_2_1", arabic: "فَكَذَّبُوهُ فَعَقَرُوهَا ○", latin: "fakadzdzabuuhu fa'aqoruuhaa ○", audioTtsText: "فَكَذَّبُوهُ فَعَقَرُوهَا ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_15_r6_1_0", arabic: "فِي صُحُفٍ مُّكَرَّمَةٍ ○", latin: "fii shuhufin mukarromatin ○", audioTtsText: "فِي صُحُفٍ مُّكَرَّمَةٍ ○"),
              IqroWordItem(id: "5_15_r6_2_1", arabic: "مَّرفُوعَةٍ مُّطَهَّرَةٍ ○", latin: "marfuu'atin muthohharotin ○", audioTtsText: "مَّرفُوعَةٍ مُّطَهَّرَةٍ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_15_r7_1_0", arabic: "مَا أَوحَى إِلَيكَ ○", latin: "maa auwhaa ilaika ○", audioTtsText: "مَا أَوحَى إِلَيكَ ○"),
              IqroWordItem(id: "5_15_r7_2_1", arabic: "سَنَدعُ الزَّبَانِيَةَ ○", latin: "sanad'u azzabaaniyata ○", audioTtsText: "سَنَدعُ الزَّبَانِيَةَ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_15_r8_1_0", arabic: "وَهُوَ السَّمِيعُ العَلِيمُ ○", latin: "wahuwa assamii'u al'aliimu ○", audioTtsText: "وَهُوَ السَّمِيعُ العَلِيمُ ○"),
              IqroWordItem(id: "5_15_r8_2_1", arabic: "لَنَكُونَنَّ مِنَ الشَّاكِرِينَ ○", latin: "lanakuunanna mina asysyaakiriina ○", audioTtsText: "لَنَكُونَنَّ مِنَ الشَّاكِرِينَ ○"),
            ],
          ),
        ],
      ),
      // Halaman 16: Halaman 16
      const IqroPage(
        jilid: 5,
        pageNumber: 16,
        title: "Halaman 16",
        instruction: "Iqro Jilid 5 Halaman 16",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "5_16_r1_1_0", arabic: "نَصَّحَ", latin: "nashshoha", audioTtsText: "نَصَّحَ"),
              IqroWordItem(id: "5_16_r1_2_1", arabic: "يُنَصِّحُ", latin: "yunashshihu", audioTtsText: "يُنَصِّحُ"),
              IqroWordItem(id: "5_16_r1_3_2", arabic: "فَضَّلَ", latin: "fadhdhala", audioTtsText: "فَضَّلَ"),
              IqroWordItem(id: "5_16_r1_4_3", arabic: "يُفَضِّلُ", latin: "yufadhdhilu", audioTtsText: "يُفَضِّلُ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_16_r2_1_0", arabic: "خَطَّأَ", latin: "khaththo'a", audioTtsText: "خَطَّأَ"),
              IqroWordItem(id: "5_16_r2_2_1", arabic: "يُخَطِّئُ", latin: "yukhaththi'u", audioTtsText: "يُخَطِّئُ"),
              IqroWordItem(id: "5_16_r2_3_2", arabic: "نَظَّفَ", latin: "nazhzhafa", audioTtsText: "نَظَّفَ"),
              IqroWordItem(id: "5_16_r2_4_3", arabic: "يُنَظِّفُ", latin: "yunazhzhifu", audioTtsText: "يُنَظِّفُ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_16_r3_1_0", arabic: "صَعَّبَ", latin: "sho''aba", audioTtsText: "صَعَّبَ"),
              IqroWordItem(id: "5_16_r3_2_1", arabic: "يُصَعِّبُ", latin: "yusho''ibu", audioTtsText: "يُصَعِّبُ"),
              IqroWordItem(id: "5_16_r3_3_2", arabic: "صَغَّرَ", latin: "shoghghoro", audioTtsText: "صَغَّرَ"),
              IqroWordItem(id: "5_16_r3_4_3", arabic: "يُصَغِّرُ", latin: "yushoghghiru", audioTtsText: "يُصَغِّرُ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_16_r4_1_0", arabic: "وَالسَّمَاءِ وَالطَّارِقِ ○", latin: "wassamaa'i waththooriqi ○", audioTtsText: "وَالسَّمَاءِ وَالطَّارِقِ ○"),
              IqroWordItem(id: "5_16_r4_2_1", arabic: "وَمَا أَدرَاكَ مَا الطَّارِقُ ○", latin: "wamaa adrooka maaththooriqu ○", audioTtsText: "وَمَا أَدرَاكَ مَا الطَّارِقُ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_16_r5_1_0", arabic: "وَإِذَا الجَحِيمُ سُعِّرَت ○", latin: "wa'idzaa aljahiimu su''irot ○", audioTtsText: "وَإِذَا الجَحِيمُ سُعِّرَت ○"),
              IqroWordItem(id: "5_16_r5_2_1", arabic: "وَإِذَا الجَنَّةُ أُزلِفَت ○", latin: "wa'idzaa aljannatu uzlifat ○", audioTtsText: "وَإِذَا الجَنَّةُ أُزلِفَت ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_16_r6_1_0", arabic: "وَمَا هُم عَنهَا بِغَائِبِينَ ○", latin: "wamaa hum 'anhaa bighoo'ibiina ○", audioTtsText: "وَمَا هُم عَنهَا بِغَائِبِينَ ○"),
              IqroWordItem(id: "5_16_r6_2_1", arabic: "إِنَّ الَّذِينَ يَغُضُّونَ أَصوَاتَهُم ○", latin: "inna alladziina yaghudhdhuuna ashwaatahum ○", audioTtsText: "إِنَّ الَّذِينَ يَغُضُّونَ أَصوَاتَهُم ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_16_r7_1_0", arabic: "وَالحَقُّنِي بِالصَّالِحِينَ ○", latin: "walhaqqnii bishshoolihiina ○", audioTtsText: "وَالحَقُّنِي بِالصَّالِحِينَ ○"),
              IqroWordItem(id: "5_16_r7_2_1", arabic: "وَإِنَّهُ لَمِنَ الصَّادِقِينَ ○", latin: "wa'innahu lamina ashshaadiqiina ○", audioTtsText: "وَإِنَّهُ لَمِنَ الصَّادِقِينَ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_16_r8_1_0", arabic: "وَبِئسَ مَثوَى الظَّالِمِينَ ○", latin: "wabi'sa matswaa azhzhoolimiina ○", audioTtsText: "وَبِئسَ مَثوَى الظَّالِمِينَ ○"),
              IqroWordItem(id: "5_16_r8_2_1", arabic: "وَالسَّوءُ عَلَى الكَافِرِينَ ○", latin: "wassau'u 'alaa alkaafirina ○", audioTtsText: "وَالسَّوءُ عَلَى الكَافِرِينَ ○"),
            ],
          ),
        ],
      ),
      // Halaman 17: Halaman 17
      const IqroPage(
        jilid: 5,
        pageNumber: 17,
        title: "Halaman 17",
        instruction: "Iqro Jilid 5 Halaman 17",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "5_17_r1_1_0", arabic: "خَفَّفَ", latin: "khoffafa", audioTtsText: "خَفَّفَ"),
              IqroWordItem(id: "5_17_r1_2_1", arabic: "يُخَفِّفُ", latin: "yukhoffifu", audioTtsText: "يُخَفِّفُ"),
              IqroWordItem(id: "5_17_r1_3_2", arabic: "وَقَّظَ", latin: "waqqozho", audioTtsText: "وَقَّظَ"),
              IqroWordItem(id: "5_17_r1_4_3", arabic: "يُوَقِّظُ", latin: "yuwaqqizhu", audioTtsText: "يُوَقِّظُ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_17_r2_1_0", arabic: "سَكَّنَ", latin: "sakkana", audioTtsText: "سَكَّنَ"),
              IqroWordItem(id: "5_17_r2_2_1", arabic: "يُسَكِّنُ", latin: "yusakkinu", audioTtsText: "يُسَكِّنُ"),
              IqroWordItem(id: "5_17_r2_3_2", arabic: "عَلَّمَ", latin: "'allama", audioTtsText: "عَلَّمَ"),
              IqroWordItem(id: "5_17_r2_4_3", arabic: "يُعَلِّمُ", latin: "yu'allimu", audioTtsText: "يُعَلِّمُ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_17_r3_1_0", arabic: "أَمَّنَ", latin: "ammana", audioTtsText: "أَمَّنَ"),
              IqroWordItem(id: "5_17_r3_2_1", arabic: "يُؤَمِّنُ", latin: "yu'amminu", audioTtsText: "يُؤَمِّنُ"),
              IqroWordItem(id: "5_17_r3_3_2", arabic: "مَنَّعَ", latin: "manna'a", audioTtsText: "مَنَّعَ"),
              IqroWordItem(id: "5_17_r3_4_3", arabic: "يُمَنِّعُ", latin: "yumanni'u", audioTtsText: "يُمَنِّعُ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_17_r4_1_0", arabic: "كَأَنَّهُم لُؤلُؤٌ مَّكنُونٌ ○", latin: "ka'annahum lu'lu'un maknuunun ○", audioTtsText: "كَأَنَّهُم لُؤلُؤٌ مَّكنُونٌ ○"),
              IqroWordItem(id: "5_17_r4_2_1", arabic: "عَلَى سُرُرٍ مُّتَقَابِلِينَ ○", latin: "'alaa sururin mutaqoobiliina ○", audioTtsText: "عَلَى سُرُرٍ مُّتَقَابِلِينَ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_17_r5_1_0", arabic: "وَلَقَد مَكَّنَّاهُم فِيمَا ○", latin: "walaqod makkanna ahum fiimaa ○", audioTtsText: "وَلَقَد مَكَّنَّاهُم فِيمَا ○"),
              IqroWordItem(id: "5_17_r5_2_1", arabic: "إِن مَّكَّنَّاكُم فِيهِ ○", latin: "in makkanna akum fiihi ○", audioTtsText: "إِن مَّكَّنَّاكُم فِيهِ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_17_r6_1_0", arabic: "أَرَءَيتَ الَّذِي يَنهَى ○", latin: "aro'aita alladzii yanhaa ○", audioTtsText: "أَرَءَيتَ الَّذِي يَنهَى ○"),
              IqroWordItem(id: "5_17_r6_2_1", arabic: "عَبدًا إِذَا صَلَّى ○", latin: "'abdan idzaa shollaa ○", audioTtsText: "عَبدًا إِذَا صَلَّى ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_17_r7_1_0", arabic: "حَقًّا عَلَى المُحسِنِينَ ○", latin: "haqqon 'alaa almuhsiniina ○", audioTtsText: "حَقًّا عَلَى المُحسِنِينَ ○"),
              IqroWordItem(id: "5_17_r7_2_1", arabic: "وَإِلَّا تَغفِرلِي وَتَرحَمنِي ○", latin: "wa'illaa taghfirlii watarhamnii ○", audioTtsText: "وَإِلَّا تَغفِرلِي وَتَرحَمنِي ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_17_r8_1_0", arabic: "مِن عَسَلٍ مُّصَفًّى ○", latin: "min 'asalin mushoffan ○", audioTtsText: "مِن عَسَلٍ مُّصَفًّى ○"),
              IqroWordItem(id: "5_17_r8_2_1", arabic: "وَاتَّبَعَ هَوَاهُ فَتَردَى ○", latin: "wattaba'a hawaahu fatarodaa ○", audioTtsText: "وَاتَّبَعَ هَوَاهُ فَتَردَى ○"),
            ],
          ),
        ],
      ),
      // Halaman 18: Halaman 18
      const IqroPage(
        jilid: 5,
        pageNumber: 18,
        title: "Halaman 18",
        instruction: "Iqro Jilid 5 Halaman 18",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "5_18_r1_1_0", arabic: "وَالشَّمسِ وَضُحَاهَا ○", latin: "wasysyamsi wadhuhaahaa ○", audioTtsText: "وَالشَّمسِ وَضُحَاهَا ○"),
              IqroWordItem(id: "5_18_r1_2_1", arabic: "وَالقَمَرِ إِذَا تَلَاهَا ○", latin: "walqomari idzaa talaahaa ○", audioTtsText: "وَالقَمَرِ إِذَا تَلَاهَا ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_18_r2_1_0", arabic: "الَّذِي خَلَقَ فَسَوَّى ○", latin: "alladzii kholaqo fasawwaa ○", audioTtsText: "الَّذِي خَلَقَ فَسَوَّى ○"),
              IqroWordItem(id: "5_18_r2_2_1", arabic: "وَالَّذِي قَدَّرَ فَهَدَى ○", latin: "walladzii qoddaro fahadaa ○", audioTtsText: "وَالَّذِي قَدَّرَ فَهَدَى ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_18_r3_1_0", arabic: "وَإِبرَاهِيمَ الَّذِي وَفَّى ○", latin: "wa'ibroohiima alladzii waffaa ○", audioTtsText: "وَإِبرَاهِيمَ الَّذِي وَفَّى ○"),
              IqroWordItem(id: "5_18_r3_2_1", arabic: "أَفَرَءَيتَ اللَّاتَ وَالعُزَّى ○", latin: "afaro'aita allaata wal'uzzaa ○", audioTtsText: "أَفَرَءَيتَ اللَّاتَ وَالعُزَّى ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_18_r4_1_0", arabic: "وَالنَّجمِ إِذَا هَوَى ○", latin: "wannajmi idzaa hawaa ○", audioTtsText: "وَالنَّجمِ إِذَا هَوَى ○"),
              IqroWordItem(id: "5_18_r4_2_1", arabic: "مَا ضَلَّ صَاحِبُكُم وَمَا غَوَى ○", latin: "maa dholla shoohibukum wamaa ghowaa ○", audioTtsText: "مَا ضَلَّ صَاحِبُكُم وَمَا غَوَى ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_18_r5_1_0", arabic: "وَإِذَا الأَرضُ مُدَّت ○", latin: "wa'idzaa alardhu muddat ○", audioTtsText: "وَإِذَا الأَرضُ مُدَّت ○"),
              IqroWordItem(id: "5_18_r5_2_1", arabic: "وَأَلقَت مَا فِيهَا وَتَخَلَّت ○", latin: "wa'alqot maa fiihaa takhollat ○", audioTtsText: "وَأَلقَت مَا فِيهَا وَتَخَلَّت ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_18_r6_1_0", arabic: "إِنَّهُ عَلَى رَجعِهِ لَقَادِرٌ ○", latin: "innahu 'alaa roj'ihi laqoodirun ○", audioTtsText: "إِنَّهُ عَلَى رَجعِهِ لَقَادِرٌ ○"),
              IqroWordItem(id: "5_18_r6_2_1", arabic: "يَومَ تُبلَى السَّرَائِرُ ○", latin: "yauma tublaa assaroo'iru ○", audioTtsText: "يَومَ تُبلَى السَّرَائِرُ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_18_r7_1_0", arabic: "وَفَاكِهَةٍ مِّمَّا يَتَخَيَّرُونَ ○", latin: "wafaakihatin mimmaa yatakhoyyaruuna ○", audioTtsText: "وَفَاكِهَةٍ مِّمَّا يَتَخَيَّرُونَ ○"),
              IqroWordItem(id: "5_18_r7_2_1", arabic: "وَلَحمِ طَيرٍ مِّمَّا يَشتَهُونَ ○", latin: "walahmi thoirin mimmaa yasytahuuna ○", audioTtsText: "وَلَحمِ طَيرٍ مِّمَّا يَشتَهُونَ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_18_r8_1_0", arabic: "وَرَبُّ أَبَائِكُمُ الأَوَّلِينَ ○", latin: "warobbu aabaaa'ikumu alawwaliina ○", audioTtsText: "وَرَبُّ أَبَائِكُمُ الأَوَّلِينَ ○"),
              IqroWordItem(id: "5_18_r8_2_1", arabic: "هُوَ التَّوَّابُ الرَّحِيمُ ○", latin: "huwa attawwaabu arrohiimu ○", audioTtsText: "هُوَ التَّوَّابُ الرَّحِيمُ ○"),
            ],
          ),
        ],
      ),
      // Halaman 19: Huruf أَكفَرتُم بَعدَ إِيمَانِكُم (AKFARTUM BA'DA IIMAANIKUM)
      const IqroPage(
        jilid: 5,
        pageNumber: 19,
        title: "Huruf أَكفَرتُم بَعدَ إِيمَانِكُم (AKFARTUM BA'DA IIMAANIKUM)",
        instruction: "Nun sukun/tanwin ketemu ba dibaca dengung.",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "5_19_r1_1_0", arabic: "فَبَشِّرهُم بِعَذَابٍ أَلِيمٍ ○", latin: "fabasysyirhum bi'adzaabin aliimin ○", audioTtsText: "فَبَشِّرهُم بِعَذَابٍ أَلِيمٍ ○"),
              IqroWordItem(id: "5_19_r1_2_1", arabic: "وَزَوَّجنَهُم بِحُورٍ عِينٍ ○", latin: "wazawwajnaahum bihuurin 'iinin ○", audioTtsText: "وَزَوَّجنَهُم بِحُورٍ عِينٍ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_19_r2_1_0", arabic: "نَوَّرَ - يُنَوِّرُ", latin: "nawwaro - yunawwiru", audioTtsText: "نَوَّرَ - يُنَوِّرُ"),
              IqroWordItem(id: "5_19_r2_2_1", arabic: "سَهَّلَ - يُسَهِّلُ", latin: "sahhala - yusahhilu", audioTtsText: "سَهَّلَ - يُسَهِّلُ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_19_r3_1_0", arabic: "بَيَّنَ - يُبَيِّنُ", latin: "bayyana - yubayyinu", audioTtsText: "بَيَّنَ - يُبَيِّنُ"),
              IqroWordItem(id: "5_19_r3_2_1", arabic: "نَبَّأَ - يُنَبِّئُ", latin: "nabba'a - yunabbi'u", audioTtsText: "نَبَّأَ - يُنَبِّئُ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_19_r4_1_0", arabic: "إِلَّا أَسَاطِيرُ الأَوَّلِينَ ○", latin: "illaa asaathiiru alawwaliina ○", audioTtsText: "إِلَّا أَسَاطِيرُ الأَوَّلِينَ ○"),
              IqroWordItem(id: "5_19_r4_2_1", arabic: "كَأَنَّهُنَّ بَيضٌ مَّكنُونٌ ○", latin: "ka'annahunna baidhun maknuunun ○", audioTtsText: "كَأَنَّهُنَّ بَيضٌ مَّكنُونٌ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_19_r5_1_0", arabic: "عَلَيهِم بِالإِثمِ وَالعُدوَانِ ○", latin: "'alaihim bilitsmi wal'udwaani ○", audioTtsText: "عَلَيهِم بِالإِثمِ وَالعُدوَانِ ○"),
              IqroWordItem(id: "5_19_r5_2_1", arabic: "وَهُوَ خَيرُ الرَّازِقِينَ ○", latin: "wahuwa khoiru arroozi qiina ○", audioTtsText: "وَهُوَ خَيرُ الرَّازِقِينَ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_19_r6_1_0", arabic: "وَيُطَهِّرَكُم تَطهيرًا ○", latin: "wayuthohhirukum tathhiiron ○", audioTtsText: "وَيُطَهِّرَكُم تَطهيرًا ○"),
              IqroWordItem(id: "5_19_r6_2_1", arabic: "وَإِنَّكَ لَمِنَ المُرسَلِينَ ○", latin: "wa'innaka lamina almursaliina ○", audioTtsText: "وَإِنَّكَ لَمِنَ المُرسَلِينَ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_19_r7_1_0", arabic: "وَكَفَّرَ عَنهُم سَيِّئَاتِهِم ○", latin: "wakaffaro 'anhum sayyi'aatihim ○", audioTtsText: "وَكَفَّرَ عَنهُم سَيِّئَاتِهِم ○"),
              IqroWordItem(id: "5_19_r7_2_1", arabic: "وَتَوَفَّنَا مَعَ الأَبرَارِ ○", latin: "watawaffanaa ma'a alabroori ○", audioTtsText: "وَتَوَفَّنَا مَعَ الأَبرَارِ ○"),
            ],
          ),
        ],
      ),
      // Halaman 20: Halaman 20
      const IqroPage(
        jilid: 5,
        pageNumber: 20,
        title: "Halaman 20",
        instruction: "Iqro Jilid 5 Halaman 20",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "5_20_r1_1_0", arabic: "لَا يُكَلِّفُ", latin: "laa yukallifu", audioTtsText: "لَا يُكَلِّفُ"),
              IqroWordItem(id: "5_20_r1_2_1", arabic: "وَلَا تُحَمِّلنَا", latin: "walaa tuhammilnaa", audioTtsText: "وَلَا تُحَمِّلنَا"),
              IqroWordItem(id: "5_20_r1_3_2", arabic: "رَبَّنَا اطمِس", latin: "robbanaa athmis", audioTtsText: "رَبَّنَا اطمِس"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_20_r2_1_0", arabic: "إِلَّا ذُرِّيَّةً", latin: "illaa dzurriyyatan", audioTtsText: "إِلَّا ذُرِّيَّةً"),
              IqroWordItem(id: "5_20_r2_2_1", arabic: "فِي شَكٍّ", latin: "fii syakkin", audioTtsText: "فِي شَكٍّ"),
              IqroWordItem(id: "5_20_r2_3_2", arabic: "فَالمُدَّثِّرُ", latin: "falmuddatstsiru", audioTtsText: "فَالمُدَّثِّرُ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_20_r3_1_0", arabic: "يَفِرُّ المَرءُ", latin: "yafirru almar'u", audioTtsText: "يَفِرُّ المَرءُ"),
              IqroWordItem(id: "5_20_r3_2_1", arabic: "هُوَ الطَّاغُوتُ", latin: "huwa aththooghuutu", audioTtsText: "هُوَ الطَّاغُوتُ"),
              IqroWordItem(id: "5_20_r3_3_2", arabic: "مِنَ الشَّيطَانِ", latin: "mina asysyaithooni", audioTtsText: "مِنَ الشَّيطَانِ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_20_r4_1_0", arabic: "الضَّلَالَةَ", latin: "adhdholaalata", audioTtsText: "الضَّلَالَةَ"),
              IqroWordItem(id: "5_20_r4_2_1", arabic: "بِالغُدُوِّ", latin: "bilghuduwwi", audioTtsText: "بِالغُدُوِّ"),
              IqroWordItem(id: "5_20_r4_3_2", arabic: "أَمِنَ السُّفَهَاءُ", latin: "amina assufahaa'u", audioTtsText: "أَمِنَ السُّفَهَاءُ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_20_r5_1_0", arabic: "جُيُوبِهِنَّ", latin: "juyuubihinna", audioTtsText: "جُيُوبِهِنَّ"),
              IqroWordItem(id: "5_20_r5_2_1", arabic: "أَو أَبَائِهِنَّ", latin: "au aabaaa'ihinna", audioTtsText: "أَو أَبَائِهِنَّ"),
              IqroWordItem(id: "5_20_r5_3_2", arabic: "أَوِ التَّابِعِينَ", latin: "awi attaabi'iina", audioTtsText: "أَوِ التَّابِعِينَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_20_r6_1_0", arabic: "لَا شَرقِيَّةٍ", latin: "laa syarqiyyatin", audioTtsText: "لَا شَرقِيَّةٍ"),
              IqroWordItem(id: "5_20_r6_2_1", arabic: "لِلمُتَّقِينَ", latin: "lilmuttaqiina", audioTtsText: "لِلمُتَّقِينَ"),
              IqroWordItem(id: "5_20_r6_3_2", arabic: "الَّذِينَ اشتَرَوُا", latin: "alladziina asytarou", audioTtsText: "الَّذِينَ اشتَرَوُا"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_20_r7_1_0", arabic: "ثُمَّ اقضُوا", latin: "tsumma aqdhoo", audioTtsText: "ثُمَّ اقضُوا"),
              IqroWordItem(id: "5_20_r7_2_1", arabic: "وَمَلَائِكَتِهِ", latin: "wamalaaa'ikatihi", audioTtsText: "وَمَلَائِكَتِهِ"),
              IqroWordItem(id: "5_20_r7_3_2", arabic: "فِي السَّرَّاءِ", latin: "fiissarroo'i", audioTtsText: "فِي السَّرَّاءِ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_20_r8_1_0", arabic: "وَالضَّرَّاءِ", latin: "wadhdhorroo'i", audioTtsText: "وَالضَّرَّاءِ"),
              IqroWordItem(id: "5_20_r8_2_1", arabic: "أُولَئِكَ هُمُ", latin: "uulaa'ika humu", audioTtsText: "أُولَئِكَ هُمُ"),
            ],
          ),
        ],
      ),
      // Halaman 21: Halaman 21
      const IqroPage(
        jilid: 5,
        pageNumber: 21,
        title: "Halaman 21",
        instruction: "Iqro Jilid 5 Halaman 21",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "5_21_r1_1_0", arabic: "قَد أَفلَحَ المُؤمِنُونَ ① الَّذِينَ هُم فِي صَلَاتِهِم خَاشِعُونَ", latin: "qod aflaha almu'minuuna 1 alladziina hum fii sholaatihim khoosyi'uuna", audioTtsText: "قَد أَفلَحَ المُؤمِنُونَ ① الَّذِينَ هُم فِي صَلَاتِهِم خَاشِعُونَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_21_r2_1_0", arabic: "وَالَّذِينَ هُم عَنِ اللَّغوِ مُعرِضُونَ ② وَالَّذِينَ هُم", latin: "walladziina hum 'ani allaghwi mu'ridhuuna 2 walladziina hum", audioTtsText: "وَالَّذِينَ هُم عَنِ اللَّغوِ مُعرِضُونَ ② وَالَّذِينَ هُم"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_21_r3_1_0", arabic: "لِلزَّكَاةِ فَاعِلُونَ ④ وَالَّذِينَ هُم لِفُرُوجِهِم حَافِظُونَ ⑤", latin: "lizzakaati faa'iluuna 4 walladziina hum lifuruujihim haafizhuuna 5", audioTtsText: "لِلزَّكَاةِ فَاعِلُونَ ④ وَالَّذِينَ هُم لِفُرُوجِهِم حَافِظُونَ ⑤"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_21_r4_1_0", arabic: "إِلَّا عَلَى أَزوَاجِهِم أَو مَا مَلَكَت أَيمَانُهُم فَإِنَّهُم", latin: "illaa 'alaa azwaajihim au maa malakat aimaanuhum fa'innahum", audioTtsText: "إِلَّا عَلَى أَزوَاجِهِم أَو مَا مَلَكَت أَيمَانُهُم فَإِنَّهُم"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_21_r5_1_0", arabic: "غَيرُ مَلُومِينَ ⑥ فَمَنِ ابتَغَى وَرَاءَ ذَلِكَ فَأُولَئِكَ هُمُ", latin: "ghoiru maluumiina 6 famani ibtaghoo waroo'a dzaalika fa'uulaa'ika humu", audioTtsText: "غَيرُ مَلُومِينَ ⑥ فَمَنِ ابتَغَى وَرَاءَ ذَلِكَ فَأُولَئِكَ هُمُ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_21_r6_1_0", arabic: "العَادُونَ ⑦ وَالَّذِينَ هُم لِأَمَانَاتِهِم وَعَهدِهِم رَاعُونَ ⑧", latin: "al'aaduuna 7 walladziina hum li'amaanaatihim wa'ahdihim roo'uuna 8", audioTtsText: "العَادُونَ ⑦ وَالَّذِينَ هُم لِأَمَانَاتِهِم وَعَهدِهِم رَاعُونَ ⑧"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_21_r7_1_0", arabic: "وَالَّذِينَ هُم عَلَى صَلَوَاتِهِم يُحَافِظُونَ ⑨ أُولَئِكَ هُمُ", latin: "walladziina hum 'alaa sholawaatihim yuhaafizhuuna 9 uulaa'ika humu", audioTtsText: "وَالَّذِينَ هُم عَلَى صَلَوَاتِهِم يُحَافِظُونَ ⑨ أُولَئِكَ هُمُ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_21_r8_1_0", arabic: "الوَارِثُونَ ⑩ الَّذِينَ يَرِثُونَ الفِردَوسَ هُم فِيهَا خَالِدُونَ ⑪", latin: "alwaaritsuuna 10 alladziina yaritsuuna alfirdusa hum fiihaa khooliduuna 11", audioTtsText: "الوَارِثُونَ ⑩ الَّذِينَ يَرِثُونَ الفِردَوسَ هُم فِيهَا خَالِدُونَ ⑪"),
            ],
          ),
        ],
      ),
      // Halaman 22: Halaman 22
      const IqroPage(
        jilid: 5,
        pageNumber: 22,
        title: "Halaman 22",
        instruction: "Bila sebelumnya berharokat A atau U maka dibaca LOH. Contoh: WALLOHU - ROSULULLOHI.",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "5_22_r1_1_0", arabic: "قُل هُوَ اللهُ أَحَدٌ ○", latin: "qul huwa allohu ahadun ○", audioTtsText: "قُل هُوَ اللهُ أَحَدٌ ○"),
              IqroWordItem(id: "5_22_r1_2_1", arabic: "اللهُ الصَّمَدُ ○", latin: "allohu ashshomadu ○", audioTtsText: "اللهُ الصَّمَدُ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_22_r2_1_0", arabic: "الَّذِينَ طَغَوا فِي البِلَادِ ○", latin: "alladziina thoghou filbilaadi ○", audioTtsText: "الَّذِينَ طَغَوا فِي البِلَادِ ○"),
              IqroWordItem(id: "5_22_r2_2_1", arabic: "فَأَكثَرُوا فِيهَا الفَسَادَ ○", latin: "fa'aktsaruu fiihaa alfasaada ○", audioTtsText: "فَأَكثَرُوا فِيهَا الفَسَادَ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_22_r3_1_0", arabic: "تِلكَ أَيَاتُ اللهِ ○", latin: "tilka aayaatullohi ○", audioTtsText: "تِلكَ أَيَاتُ اللهِ ○"),
              IqroWordItem(id: "5_22_r3_2_1", arabic: "فَإِذَا هُم بِالسَّاهِرَةِ ○", latin: "fa'idzaa hum bissaahiroti ○", audioTtsText: "فَإِذَا هُم بِالسَّاهِرَةِ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_22_r4_1_0", arabic: "يَصلَونَهَا يَومَ الدِّينِ ○", latin: "yashlounahaa yauma addiini ○", audioTtsText: "يَصلَونَهَا يَومَ الدِّينِ ○"),
              IqroWordItem(id: "5_22_r4_2_1", arabic: "فَضَّلَ اللهُ المُجَاهِدِينَ ○", latin: "fadhdhalallohu almujaahidiina ○", audioTtsText: "فَضَّلَ اللهُ المُجَاهِدِينَ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_22_r5_1_0", arabic: "وَاللهُ وَلِيُّ المُؤمِنِينَ ○", latin: "wallohu waliyyu almu'miniina ○", audioTtsText: "وَاللهُ وَلِيُّ المُؤمِنِينَ ○"),
              IqroWordItem(id: "5_22_r5_2_1", arabic: "وَرَبُّ العَرشِ العَظِيمِ ○", latin: "warobbu al'arsyi al'azhiimi ○", audioTtsText: "وَرَبُّ العَرشِ العَظِيمِ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_22_r6_1_0", arabic: "تِلكَ حُدُودُ اللهِ ○", latin: "tilka huduudullohi ○", audioTtsText: "تِلكَ حُدُودُ اللهِ ○"),
              IqroWordItem(id: "5_22_r6_2_1", arabic: "يُبَيِّنُ اللهُ أَيَاتِهِ ○", latin: "yubayyinullohu aayaatihi ○", audioTtsText: "يُبَيِّنُ اللهُ أَيَاتِهِ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_22_r7_1_0", arabic: "وَاتَّقُوا اللهَ الَّذِي تَسَاءَلُونَ بِهِ وَالأَرحَامَ ○", latin: "wattaquulloha alladzii tasaa'aluuna bihi walarhaama ○", audioTtsText: "وَاتَّقُوا اللهَ الَّذِي تَسَاءَلُونَ بِهِ وَالأَرحَامَ ○"),
            ],
          ),
        ],
      ),
      // Halaman 23: Halaman 23
      const IqroPage(
        jilid: 5,
        pageNumber: 23,
        title: "Halaman 23",
        instruction: "Bila sebelumnya berharokat i maka dibaca LAH. Contoh: LILLAHI - BILLAHI.",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "5_23_r1_1_0", arabic: "بِسمِ اللهِ", latin: "bismillaahi", audioTtsText: "بِسمِ اللهِ"),
              IqroWordItem(id: "5_23_r1_2_1", arabic: "وَالحَمدُ لِلهِ", latin: "walhamdu lillaahi", audioTtsText: "وَالحَمدُ لِلهِ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_23_r2_1_0", arabic: "لَا قُوَّةَ إِلَّا بِاللهِ ○", latin: "laa quwwata illaa billaahi ○", audioTtsText: "لَا قُوَّةَ إِلَّا بِاللهِ ○"),
              IqroWordItem(id: "5_23_r2_2_1", arabic: "خَلَقَ المَوتَ وَالحَيَاةَ ○", latin: "kholaqo almauta walhayaata ○", audioTtsText: "خَلَقَ المَوتَ وَالحَيَاةَ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_23_r3_1_0", arabic: "أَفَأَمِنُوا مَكرَ اللهِ ○", latin: "afa'aminuu makro allohi ○", audioTtsText: "أَفَأَمِنُوا مَكرَ اللهِ ○"),
              IqroWordItem(id: "5_23_r3_2_1", arabic: "وَيُرسِلُ عَلَيكُم حَفَظَةً ○", latin: "wayursilu 'alaikum hafazhotan ○", audioTtsText: "وَيُرسِلُ عَلَيكُم حَفَظَةً ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_23_r4_1_0", arabic: "وَهُوَ بِكُلِّ شَيءٍ عَلِيمٌ ○", latin: "wahuwa bikulli syai'in 'aliimun ○", audioTtsText: "وَهُوَ بِكُلِّ شَيءٍ عَلِيمٌ ○"),
              IqroWordItem(id: "5_23_r4_2_1", arabic: "وَهُوَ العَلِيُّ العَظِيمُ ○", latin: "wahuwa al'aliyyu al'azhiimu ○", audioTtsText: "وَهُوَ العَلِيُّ العَظِيمُ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_23_r5_1_0", arabic: "يُحَاسِبكُم بِهِ اللهُ ○", latin: "yuhaasibkum bihi allahu ○", audioTtsText: "يُحَاسِبكُم بِهِ اللهُ ○"),
              IqroWordItem(id: "5_23_r5_2_1", arabic: "وَاللهُ بِمَا تَعمَلُونَ عَلِيمٌ ○", latin: "wallohu bimaa ta'maluuna 'aliimun ○", audioTtsText: "وَاللهُ بِمَا تَعمَلُونَ عَلِيمٌ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_23_r6_1_0", arabic: "قُلِ اللهُ أَسرَعُ مَكرًا ○", latin: "qulillahu asro'u makron ○", audioTtsText: "قُلِ اللهُ أَسرَعُ مَكرًا ○"),
              IqroWordItem(id: "5_23_r6_2_1", arabic: "وَكَفَى بِاللهِ شَهِيدًا ○", latin: "wakafaa billahi syahiidan ○", audioTtsText: "وَكَفَى بِاللهِ شَهِيدًا ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_23_r7_1_0", arabic: "وَالَّذِي أَخرَجَ المَرعَى ○", latin: "walladzii akhroja almar'aa ○", audioTtsText: "وَالَّذِي أَخرَجَ المَرعَى ○"),
              IqroWordItem(id: "5_23_r7_2_1", arabic: "فَجَعَلَهُ غُثَاءً أَحوَى ○", latin: "faja'alahu ghutsaa'an ahwaa ○", audioTtsText: "فَجَعَلَهُ غُثَاءً أَحوَى ○"),
            ],
          ),
        ],
      ),
      // Halaman 24: نْ ← ل
      const IqroPage(
        jilid: 5,
        pageNumber: 24,
        title: "نْ ← ل",
        instruction: "Masuk dengan suara tak dengung. Jadi suara nun/tanwin, hilang.",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "5_24_r1_1_0", arabic: "مِن - رَّأَى", latin: "min - ro'aa", audioTtsText: "مِن - رَّأَى"),
              IqroWordItem(id: "5_24_r1_2_1", arabic: "مِن - رِّزقٍ", latin: "min - rizqin", audioTtsText: "مِن - رِّزقٍ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_24_r2_1_0", arabic: "مِن - رَّبِّهِم", latin: "min - robbihim", audioTtsText: "مِن - رَّبِّهِم"),
              IqroWordItem(id: "5_24_r2_2_1", arabic: "مِن - رَّسُولِهِ", latin: "min - rosuulihi", audioTtsText: "مِن - رَّسُولِهِ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_24_r3_1_0", arabic: "وَاللهُ غَفُورٌ رَّحِيمٌ ○", latin: "wallohu ghofuurun rohiimun ○", audioTtsText: "وَاللهُ غَفُورٌ رَّحِيمٌ ○"),
              IqroWordItem(id: "5_24_r3_2_1", arabic: "وَاللهُ غَفُورٌ حَلِيمٌ ○", latin: "wallohu ghofuurun haliimun ○", audioTtsText: "وَاللهُ غَفُورٌ حَلِيمٌ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_24_r4_1_0", arabic: "أَن رَّآهُ استَغنَى ○", latin: "an ro'aahu istaghnaa ○", audioTtsText: "أَن رَّآهُ استَغنَى ○"),
              IqroWordItem(id: "5_24_r4_2_1", arabic: "إِنَّ إِلَى رَبِّكَ الرُّجعَى ○", latin: "inna ilaa robbika arruj'aa ○", audioTtsText: "إِنَّ إِلَى رَبِّكَ الرُّجعَى ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_24_r5_1_0", arabic: "لَهُ شِهَابٌ ثَاقِبٌ ○", latin: "lahu syihaabun tsaaqibun ○", audioTtsText: "لَهُ شِهَابٌ ثَاقِبٌ ○"),
              IqroWordItem(id: "5_24_r5_2_1", arabic: "فَلِلَّهِ الآخِرَةُ وَالأُولَى ○", latin: "fallillaahi alaakhirotu waluulaa ○", audioTtsText: "فَلِلَّهِ الآخِرَةُ وَالأُولَى ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_24_r6_1_0", arabic: "عَلَى اللهِ تَوَكَّلنَا ○", latin: "'alaa allohi tawakkalnaa ○", audioTtsText: "عَلَى اللهِ تَوَكَّلنَا ○"),
              IqroWordItem(id: "5_24_r6_2_1", arabic: "وَاللهِ الأَسمَاءُ الحُسنَى ○", latin: "wallohi alasmaa'u alhusnaa ○", audioTtsText: "وَاللهِ الأَسمَاءُ الحُسنَى ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_24_r7_1_0", arabic: "فِي عِيشَةٍ رَّاضِيَةٍ ○", latin: "fii 'iisyatin roodhiyatin ○", audioTtsText: "فِي عِيشَةٍ رَّاضِيَةٍ ○"),
              IqroWordItem(id: "5_24_r7_2_1", arabic: "فَهَزَمُوهُم بِإِذنِ اللهِ ○", latin: "fahazamuuhum bi'idznillaahi ○", audioTtsText: "فَهَزَمُوهُم بِإِذنِ اللهِ ○"),
            ],
          ),
        ],
      ),
      // Halaman 25: نْ ← ل
      const IqroPage(
        jilid: 5,
        pageNumber: 25,
        title: "نْ ← ل",
        instruction: "Masuk dengan suara tak dengung. Jadi suara nun/tanwin, hilang.",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "5_25_r1_1_0", arabic: "وَمِن - لَّم", latin: "wamin - llam", audioTtsText: "وَمِن - لَّم"),
              IqroWordItem(id: "5_25_r1_2_1", arabic: "خَيرٌ - لَّكُم", latin: "khoirun - llakum", audioTtsText: "خَيرٌ - لَّكُم"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_25_r2_1_0", arabic: "ذِكرٌ لِّلْعَالَمِينَ ○", latin: "dzikrun lil'aalamiina ○", audioTtsText: "ذِكرٌ لِّلْعَالَمِينَ ○"),
              IqroWordItem(id: "5_25_r2_2_1", arabic: "إِنَّهُ بِهِم رَءُوفٌ رَّحِيمٌ ○", latin: "innahu bihim ro'uufun rohiimun ○", audioTtsText: "إِنَّهُ بِهِم رَءُوفٌ رَّحِيمٌ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_25_r3_1_0", arabic: "يَومَئِذٍ لِّلمُكَذِّبِينَ ○", latin: "yauwama'idzin lilmukadzdzibiina ○", audioTtsText: "يَومَئِذٍ لِّلمُكَذِّبِينَ ○"),
              IqroWordItem(id: "5_25_r3_2_1", arabic: "وَاللهُ غَنِيٌّ حَلِيمٌ ○", latin: "wallohu ghoniyyun haliimun ○", audioTtsText: "وَاللهُ غَنِيٌّ حَلِيمٌ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_25_r4_1_0", arabic: "فَمَن لَّم يَجِد فَصِيَامُ ثَلَاثَةِ أَيَّامٍ ○", latin: "faman llam yajid fashiyaamu tsalaatsati ayyaamin ○", audioTtsText: "فَمَن لَّم يَجِد فَصِيَامُ ثَلَاثَةِ أَيَّامٍ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_25_r5_1_0", arabic: "فَإِن لَّم يَكُن لَّهُ وَلَدٌ ○", latin: "fa'in llam yakun llahu waladun ○", audioTtsText: "فَإِن لَّم يَكُن لَّهُ وَلَدٌ ○"),
              IqroWordItem(id: "5_25_r5_2_1", arabic: "فَرِيضَةً مِّنَ اللهِ ○", latin: "fariidhotan mminallohi ○", audioTtsText: "فَرِيضَةً مِّنَ اللهِ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_25_r6_1_0", arabic: "وَلَكِن لَّا تَشعُرُونَ ○", latin: "walaakin llaa tasy'uruuna ○", audioTtsText: "وَلَكِن لَّا تَشعُرُونَ ○"),
              IqroWordItem(id: "5_25_r6_2_1", arabic: "مِن مَّغرَمٍ مُّثقَلُونَ ○", latin: "min mmaghromin mmutsqoluuna ○", audioTtsText: "مِن مَّغرَمٍ مُّثقَلُونَ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_25_r7_1_0", arabic: "خَيرٌ لَّكَ مِنَ الأُولَى ○", latin: "khoirun llaka mina aluulaa ○", audioTtsText: "خَيرٌ لَّكَ مِنَ الأُولَى ○"),
              IqroWordItem(id: "5_25_r7_2_1", arabic: "يَعلَمُ السِّرَّ وَأَخفَى ○", latin: "ya'lamu assirro wa'akhfaa ○", audioTtsText: "يَعلَمُ السِّرَّ وَأَخفَى ○"),
            ],
          ),
        ],
      ),
      // Halaman 26: Halaman 26
      const IqroPage(
        jilid: 5,
        pageNumber: 26,
        title: "Halaman 26",
        instruction: "Iqro Jilid 5 Halaman 26",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "5_26_r1_1_0", arabic: "أَلَم نَجعَل لَّهُ عَينَينِ ○", latin: "alam naj'al llahu 'ainaini ○", audioTtsText: "أَلَم نَجعَل لَّهُ عَينَينِ ○"),
              IqroWordItem(id: "5_26_r1_2_1", arabic: "وَهَدَينَهُ النَّجدَينِ ○", latin: "wahadainaahu annajdaini ○", audioTtsText: "وَهَدَينَهُ النَّجدَينِ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_26_r2_1_0", arabic: "طَائِفَةٌ مِّنَ المُؤمِنِينَ ○", latin: "thoo'ifatun mmina almu'miniina ○", audioTtsText: "طَائِفَةٌ مِّنَ المُؤمِنِينَ ○"),
              IqroWordItem(id: "5_26_r2_2_1", arabic: "وَإِنَّ عَلَيكُم لَحَافِظِينَ ○", latin: "wa'inna 'alaikum lahaafizhiina ○", audioTtsText: "وَإِنَّ عَلَيكُم لَحَافِظِينَ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_26_r3_1_0", arabic: "يُوبِلْنَا إِنَّا كُنَّا طَاغِينَ ○", latin: "yuubilnaa innaa kunnaa thaaghiina ○", audioTtsText: "يُوبِلْنَا إِنَّا كُنَّا طَاغِينَ ○"),
              IqroWordItem(id: "5_26_r3_2_1", arabic: "تُوصُونَ بِهَا أَو دِينٍ ○", latin: "tuushuuna bihaa au diinin ○", audioTtsText: "تُوصُونَ بِهَا أَو دِينٍ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_26_r4_1_0", arabic: "وَهُوَ خَيرُ الرَّازِقِينَ ○", latin: "wahuwa khoiru arroozi qiina ○", audioTtsText: "وَهُوَ خَيرُ الرَّازِقِينَ ○"),
              IqroWordItem(id: "5_26_r4_2_1", arabic: "إِنَّا إِلَى اللهِ رَاغِبُونَ ○", latin: "innaa ilallohi rooghibuuna ○", audioTtsText: "إِنَّا إِلَى اللهِ رَاغِبُونَ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_26_r5_1_0", arabic: "بَعدَ القَومِ لَا يُؤمِنُونَ ○", latin: "ba'da alqouwmi laa yu'minuuna ○", audioTtsText: "بَعدَ القَومِ لَا يُؤمِنُونَ ○"),
              IqroWordItem(id: "5_26_r5_2_1", arabic: "فَاتَّقُوا اللهَ وَأَطِيعُونِ ○", latin: "fattaqulloha wa'athii'uuni ○", audioTtsText: "فَاتَّقُوا اللهَ وَأَطِيعُونِ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_26_r6_1_0", arabic: "وَمَا مَسَّنَا مِن لُّغُوبٍ ○", latin: "wamaa massanaa min lughuubin ○", audioTtsText: "وَمَا مَسَّنَا مِن لُّغُوبٍ ○"),
              IqroWordItem(id: "5_26_r6_2_1", arabic: "قُتِلَ أَصحَابُ الأُخدُودِ ○", latin: "qutila ashhaabu alukhduudi ○", audioTtsText: "قُتِلَ أَصحَابُ الأُخدُودِ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_26_r7_1_0", arabic: "مِن أَيِّ شَيءٍ خَلَقَهُ ○", latin: "min ayyi syai'in kholaqohu ○", audioTtsText: "مِن أَيِّ شَيءٍ خَلَقَهُ ○"),
              IqroWordItem(id: "5_26_r7_2_1", arabic: "إِلَّا مَن رَّحِمَ اللهُ ○", latin: "illaa man rrohima allohu ○", audioTtsText: "إِلَّا مَن رَّحِمَ اللهُ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_26_r8_1_0", arabic: "سَيَقُولُونَ لِلهِ ○", latin: "sayaquuluuna lillaahi ○", audioTtsText: "سَيَقُولُونَ لِلهِ ○"),
              IqroWordItem(id: "5_26_r8_2_1", arabic: "يُؤتِي مَالَهُ يَتَزَكَّى ○", latin: "yu'tii maalahu yatazakkaa ○", audioTtsText: "يُؤتِي مَالَهُ يَتَزَكَّى ○"),
            ],
          ),
        ],
      ),
      // Halaman 27: Huruf وَلَا الضَّالِّينَ (WALAA ADDHOOLLIINA)
      const IqroPage(
        jilid: 5,
        pageNumber: 27,
        title: "Huruf وَلَا الضَّالِّينَ (WALAA ADDHOOLLIINA)",
        instruction: "Bacaan harus panjang 6 harokat baru diikuti dengan tasydid.",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "5_27_r1_1_0", arabic: "جَاءَتِ الطَّامَّةُ الكُبرَى ○", latin: "jaaa'ati aththoommatu alkubroo ○", audioTtsText: "جَاءَتِ الطَّامَّةُ الكُبرَى ○"),
              IqroWordItem(id: "5_27_r1_2_1", arabic: "إِنَّ مَعَ العُسرِ يُسرًا ○", latin: "inna ma'a al'usri yusron ○", audioTtsText: "إِنَّ مَعَ العُسرِ يُسرًا ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_27_r2_1_0", arabic: "وَلَم يَكُن لَّهُ كُفُوًا أَحَدٌ ○", latin: "walam yakun llahu kufuwan ahadun ○", audioTtsText: "وَلَم يَكُن لَّهُ كُفُوًا أَحَدٌ ○"),
              IqroWordItem(id: "5_27_r2_2_1", arabic: "وَاللهُ غَنِيٌّ حَمِيدٌ ○", latin: "wallohu ghoniyyun hamiidun ○", audioTtsText: "وَاللهُ غَنِيٌّ حَمِيدٌ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_27_r3_1_0", arabic: "فَإِذَا جَاءَتِ الصَّاخَّةُ ○", latin: "fa'idzaa jaaa'ati ashshookhkhotu ○", audioTtsText: "فَإِذَا جَاءَتِ الصَّاخَّةُ ○"),
              IqroWordItem(id: "5_27_r3_2_1", arabic: "وَالأَمرُ يَومَئِذٍ لِلهِ ○", latin: "walamru yauwama'idzin lillaahi ○", audioTtsText: "وَالأَمرُ يَومَئِذٍ لِلهِ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_27_r4_1_0", arabic: "وَكُلُوا مِن رِّزقِهِ ○", latin: "wakuluu min rizqihi ○", audioTtsText: "وَكُلُوا مِن رِّزقِهِ ○"),
              IqroWordItem(id: "5_27_r4_2_1", arabic: "إِنَّ اللهَ بَالِغُ أَمرِهِ ○", latin: "innalloha baalighu amrihi ○", audioTtsText: "إِنَّ اللهَ بَالِغُ أَمرِهِ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_27_r5_1_0", arabic: "بَل هُوَ خَيرٌ لَّكُم ○", latin: "bal huwa khoirun llakum ○", audioTtsText: "بَل هُوَ خَيرٌ لَّكُم ○"),
              IqroWordItem(id: "5_27_r5_2_1", arabic: "الشَّيطَانُ سَوَّلَ لَهُم ○", latin: "asysyaithoonu sawwala lahum ○", audioTtsText: "الشَّيطَانُ سَوَّلَ لَهُم ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_27_r6_1_0", arabic: "وَإِنَّا لَنَحنُ الصَّافُّونَ ○", latin: "wa'innaa lanahnu ashshaaffuuna ○", audioTtsText: "وَإِنَّا لَنَحنُ الصَّافُّونَ ○"),
              IqroWordItem(id: "5_27_r6_2_1", arabic: "وَاللهُ وَلِيُّ المُتَّقِينَ ○", latin: "wallohu waliyyu almuttaqiina ○", audioTtsText: "وَاللهُ وَلِيُّ المُتَّقِينَ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_27_r7_1_0", arabic: "الَّذِي يَدُعُّ اليَتِيمَ ○", latin: "alladzii yadu''u alyatiima ○", audioTtsText: "الَّذِي يَدُعُّ اليَتِيمَ ○"),
              IqroWordItem(id: "5_27_r7_2_1", arabic: "إِنَّهُ كَانَ مِنَ الضَّالِّينَ ○", latin: "innahu kaana mina addhoolliina ○", audioTtsText: "إِنَّهُ كَانَ مِنَ الضَّالِّينَ ○"),
            ],
          ),
        ],
      ),
      // Halaman 28: Halaman 28
      const IqroPage(
        jilid: 5,
        pageNumber: 28,
        title: "Halaman 28",
        instruction: "Iqro Jilid 5 Halaman 28",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "5_28_r1_1_0", arabic: "إِن أَرَدنَا إِلَّا الحُسنَى ○", latin: "in arodnaa illalhusnaa ○", audioTtsText: "إِن أَرَدنَا إِلَّا الحُسنَى ○"),
              IqroWordItem(id: "5_28_r1_2_1", arabic: "إِنَّ إِلَى رَبِّكَ الرُّجعَى ○", latin: "inna ilaa robbika arruj'aa ○", audioTtsText: "إِنَّ إِلَى رَبِّكَ الرُّجعَى ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_28_r2_1_0", arabic: "وَالصَّافَّاتِ صَفًّا ○", latin: "washshooffaati shoffan ○", audioTtsText: "وَالصَّافَّاتِ صَفًّا ○"),
              IqroWordItem(id: "5_28_r2_2_1", arabic: "فَالزَّاجِرَاتِ زَجرًا ○", latin: "fazzaajirooti zajron ○", audioTtsText: "فَالزَّاجِرَاتِ زَجرًا ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_28_r3_1_0", arabic: "وَكَفَى بِاللهِ شَهِيدًا ○", latin: "wakafaa billahi syahiidan ○", audioTtsText: "وَكَفَى بِاللهِ شَهِيدًا ○"),
              IqroWordItem(id: "5_28_r3_2_1", arabic: "وَالمُؤتَفِكَةَ أَهوَى ○", latin: "walmu'tafikata ahwaa ○", audioTtsText: "وَالمُؤتَفِكَةَ أَهوَى ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_28_r4_1_0", arabic: "نِسَاؤُكُم حَرثٌ لَّكُم ○", latin: "nisaaa'ukum hartsun llakum ○", audioTtsText: "نِسَاؤُكُم حَرثٌ لَّكُم ○"),
              IqroWordItem(id: "5_28_r4_2_1", arabic: "مَتَاعًا لَّكُم وَلِأَنعَامِكُم ○", latin: "mataa'an llakum wali'an'aamikum ○", audioTtsText: "مَتَاعًا لَّكُم وَلِأَنعَامِكُم ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_28_r5_1_0", arabic: "فُضِّلُوا بِرَادِّي رِزقِهِم ○", latin: "fudhdhiluu birooddii rizqihim ○", audioTtsText: "فُضِّلُوا بِرَادِّي رِزقِهِم ○"),
              IqroWordItem(id: "5_28_r5_2_1", arabic: "أَلَا إِنَّهَا قُربَةٌ لَّهُم ○", latin: "alaaa innahaa qurbatun llahum ○", audioTtsText: "أَلَا إِنَّهَا قُربَةٌ لَّهُم ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_28_r6_1_0", arabic: "وَقُومُوا لِلهِ قَانِتِينَ ○", latin: "waquumuu lillaahi qoonitiina ○", audioTtsText: "وَقُومُوا لِلهِ قَانِتِينَ ○"),
              IqroWordItem(id: "5_28_r6_2_1", arabic: "إِنَّ اللهَ مَعَ الصَّابِرِينَ ○", latin: "innalloha ma'a ashshoobiriina ○", audioTtsText: "إِنَّ اللهَ مَعَ الصَّابِرِينَ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_28_r7_1_0", arabic: "إِنَّ اللهَ سَمِيعٌ عَلِيمٌ ○", latin: "innalloha samii'un 'aliimun ○", audioTtsText: "إِنَّ اللهَ سَمِيعٌ عَلِيمٌ ○"),
              IqroWordItem(id: "5_28_r7_2_1", arabic: "وَأَنَّ اللهَ تَوَّابٌ حَكِيمٌ ○", latin: "wa'annalloha tawwabbun hakiimun ○", audioTtsText: "وَأَنَّ اللهَ تَوَّابٌ حَكِيمٌ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_28_r8_1_0", arabic: "حَتَّى تَأتِيَهُمُ البَيِّنَةُ ○", latin: "hattaa ta'tiihimu albayyinatu ○", audioTtsText: "حَتَّى تَأتِيَهُمُ البَيِّنَةُ ○"),
              IqroWordItem(id: "5_28_r8_2_1", arabic: "خَافِضَةٌ رَّافِعَةٌ ○", latin: "khoofidhotun roofi'atun ○", audioTtsText: "خَافِضَةٌ رَّافِعَةٌ ○"),
            ],
          ),
        ],
      ),
      // Halaman 29: Halaman 29
      const IqroPage(
        jilid: 5,
        pageNumber: 29,
        title: "Halaman 29",
        instruction: "EBTA. Bila telah benar semuanya walaupun pelan pembacanya boleh dinaikkan ke jilid 6.",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "5_29_r1_1_0", arabic: "لَا إِلَهَ إِلَّا اللهُ ○", latin: "laa ilaaha illallohu ○", audioTtsText: "لَا إِلَهَ إِلَّا اللهُ ○"),
              IqroWordItem(id: "5_29_r1_2_1", arabic: "مُحَمَّدٌ رَّسُولُ اللهِ ○", latin: "muhammadun rosuulullohi ○", audioTtsText: "مُحَمَّدٌ رَّسُولُ اللهِ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_29_r2_1_0", arabic: "الَّذِينَ يُؤمِنُونَ بِالغَيبِ ○", latin: "alladziina yu'minuuna bilghoibi ○", audioTtsText: "الَّذِينَ يُؤمِنُونَ بِالغَيبِ ○"),
              IqroWordItem(id: "5_29_r2_2_1", arabic: "وَيُقِيمُونَ الصَّلَاةَ ○", latin: "wayuqiimuuna ashsholaata ○", audioTtsText: "وَيُقِيمُونَ الصَّلَاةَ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_29_r3_1_0", arabic: "وَيُؤتُونَ الزَّكَاةَ ○", latin: "wayu'tuuna azzakaata ○", audioTtsText: "وَيُؤتُونَ الزَّكَاةَ ○"),
              IqroWordItem(id: "5_29_r3_2_1", arabic: "إِنَّ الفَضلَ بِيَدِ اللهِ ○", latin: "innalfadhla biyadillaahi ○", audioTtsText: "إِنَّ الفَضلَ بِيَدِ اللهِ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_29_r4_1_0", arabic: "لِكُلِّ أَوَّابٍ حَفِيظٍ ○", latin: "likulli awwabin hafiizhin ○", audioTtsText: "لِكُلِّ أَوَّابٍ حَفِيظٍ ○"),
              IqroWordItem(id: "5_29_r4_2_1", arabic: "وَهُوَ اللَّطِيفُ الخَبِيرُ ○", latin: "wahuwa allathiifu alkhobiiru ○", audioTtsText: "وَهُوَ اللَّطِيفُ الخَبِيرُ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_29_r5_1_0", arabic: "إِن هُم إِلَّا يَظُنُّونَ ○", latin: "in hum illaa yazhunnuuna ○", audioTtsText: "إِن هُم إِلَّا يَظُنُّونَ ○"),
              IqroWordItem(id: "5_29_r5_2_1", arabic: "فَرَاهُ فِي سَوَاءِ الجَحِيمِ ○", latin: "faro'aahu fii sawaaa'i aljahiimi ○", audioTtsText: "فَرَاهُ فِي سَوَاءِ الجَحِيمِ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_29_r6_1_0", arabic: "وَيلٌ لِّكُلِّ هُمَزَةٍ لُّمَزَةٍ ○", latin: "wailun llikulli humazatin lumazatin ○", audioTtsText: "وَيلٌ لِّكُلِّ هُمَزَةٍ لُّمَزَةٍ ○"),
              IqroWordItem(id: "5_29_r6_2_1", arabic: "هُم أَصحَابُ المَشأَمَةِ ○", latin: "hum ashhaabu almasy'amati ○", audioTtsText: "هُم أَصحَابُ المَشأَمَةِ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_29_r7_1_0", arabic: "نَارُ اللهِ المُوقَدَةُ ○", latin: "naarullohilmuuqodatu ○", audioTtsText: "نَارُ اللهِ المُوقَدَةُ ○"),
              IqroWordItem(id: "5_29_r7_2_1", arabic: "الَّتِي تَطَّلِعُ عَلَى الأَفئِدَةِ ○", latin: "allatii taththoli'u 'alaa alaf'idati ○", audioTtsText: "الَّتِي تَطَّلِعُ عَلَى الأَفئِدَةِ ○"),
            ],
          ),
        ],
      ),
      // Halaman 30: Halaman 30
      const IqroPage(
        jilid: 5,
        pageNumber: 30,
        title: "Halaman 30",
        instruction: "MAAF! Bila belum benar semuanya sebaiknya tak segan mengulang.",
        rows: [
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_30_r1_1_0", arabic: "وَإِن لَّم تَغفِر لَنَا وَتَرحَمنَا لَنَكُونَنَّ مِنَ الخَاسِرِينَ ○", latin: "wa'in llam taghfir lanaa watarhamnaa lanakuunanna mina alkhoosiriina ○", audioTtsText: "وَإِن لَّم تَغفِر لَنَا وَتَرحَمنَا لَنَكُونَنَّ مِنَ الخَاسِرِينَ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_30_r2_1_0", arabic: "فَطَافَ عَلَيهِم طَائِفٌ مِّن رَّبِّكَ وَهُم نَائِمُونَ ○", latin: "fathoofa 'alaihim thoo'ifun mmin robbika wahum naaa'imuuna ○", audioTtsText: "فَطَافَ عَلَيهِم طَائِفٌ مِّن رَّبِّكَ وَهُم نَائِمُونَ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_30_r3_1_0", arabic: "وَإِذَا رَأَوهُم قَالُوا إِنَّ هَؤُلَاءِ لَضَالُّونَ ○", latin: "wa'idzaa ro'auwhum qooluu inna haa'ulaaa'i ladhoolluuna ○", audioTtsText: "وَإِذَا رَأَوهُم قَالُوا إِنَّ هَؤُلَاءِ لَضَالُّونَ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_30_r4_1_0", arabic: "وَلَا نُكَذِّبُ بِأَيَاتِ رَبِّنَا وَنَكُونَ مِنَ المُؤمِنِينَ ○", latin: "walaa nukadzdzibu bi'aayaati robbinaa wanakuuna mina almu'miniina ○", audioTtsText: "وَلَا نُكَذِّبُ بِأَيَاتِ رَبِّنَا وَنَكُونَ مِنَ المُؤمِنِينَ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_30_r5_1_0", arabic: "فَلَمَّا جَاءَهُم بِآيَاتِنَا إِذَا هُم مِّنهَا يَضحَكُونَ ○", latin: "falammaa jaaa'ahum bi'aayaatinaa idzaa hum mminhaa yadhhakuuna ○", audioTtsText: "فَلَمَّا جَاءَهُم بِآيَاتِنَا إِذَا هُم مِّنهَا يَضحَكُونَ ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_30_r6_1_0", arabic: "وَرَأَيتَ النَّاسَ يَدخُلُونَ فِي دِينِ اللهِ أَفوَاجًا ○", latin: "waro'aita annaasa yadkhuluuna fii diinillaahi afwaajan ○", audioTtsText: "وَرَأَيتَ النَّاسَ يَدخُلُونَ فِي دِينِ اللهِ أَفوَاجًا ○"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "5_30_r7_1_0", arabic: "فَسَبِّح بِحَمدِ رَبِّكَ وَاستَغفِرهُ إِنَّهُ كَانَ تَوَّابًا ○", latin: "fasabbih bihamdi robbika wastaghfirhu innahu kaana tawwabban ○", audioTtsText: "فَسَبِّح بِحَمدِ رَبِّكَ وَاستَغفِرهُ إِنَّهُ كَانَ تَوَّابًا ○"),
            ],
          ),
        ],
      ),
    ];
  }
}
