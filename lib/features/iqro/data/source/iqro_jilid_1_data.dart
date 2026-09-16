import '../../domain/models/iqro_models.dart';

class IqroJilid1Data {
  static List<IqroPage> getPages() {
    return [
      // Halaman 1: Huruf اَ بَ (A BA)
      const IqroPage(
        jilid: 1,
        pageNumber: 1,
        title: "Huruf اَ بَ (A BA)",
        instruction: "Bacaan langsung A Bacalah dengan suara pendek Ba dst: Tidak perlu diuraildieja",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "1_1_r1_1_0", arabic: "أَ", latin: "a", audioTtsText: "أَ"),
              IqroWordItem(id: "1_1_r1_1_1", arabic: "أَ", latin: "a", audioTtsText: "أَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_1_r2_1_0", arabic: "أَ بَ", latin: "a ba", audioTtsText: "أَ بَ"),
              IqroWordItem(id: "1_1_r2_2_1", arabic: "بَ اَ بَ", latin: "ba a ba", audioTtsText: "بَ اَ بَ"),
              IqroWordItem(id: "1_1_r2_3_2", arabic: "اَ بَ اَ", latin: "a ba a", audioTtsText: "اَ بَ اَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_1_r3_1_0", arabic: "بَ اَ اَ", latin: "ba a a", audioTtsText: "بَ اَ اَ"),
              IqroWordItem(id: "1_1_r3_2_1", arabic: "اَ اَ بَ", latin: "a a ba", audioTtsText: "اَ اَ بَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_1_r4_1_0", arabic: "بَ بَ اَ", latin: "ba ba a", audioTtsText: "بَ بَ اَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_1_r5_1_0", arabic: "اَ بَ بَ", latin: "a ba ba", audioTtsText: "اَ بَ بَ"),
              IqroWordItem(id: "1_1_r5_2_1", arabic: "بَ اَ بَ", latin: "ba a ba", audioTtsText: "بَ اَ بَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_1_r6_1_0", arabic: "اَ بَ اَ", latin: "a ba a", audioTtsText: "اَ بَ اَ"),
              IqroWordItem(id: "1_1_r6_2_1", arabic: "اَ اَ اَ", latin: "a a a", audioTtsText: "اَ اَ اَ"),
              IqroWordItem(id: "1_1_r6_3_2", arabic: "بَ بَ بَ", latin: "ba ba ba", audioTtsText: "بَ بَ بَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_1_r7_1_0", arabic: "اَ بَ", latin: "a ba", audioTtsText: "اَ بَ"),
              IqroWordItem(id: "1_1_r7_2_1", arabic: "اَ بَ", latin: "a ba", audioTtsText: "اَ بَ"),
            ],
          ),
        ],
      ),
      // Halaman 2: Huruf بَ تَ (BA TA)
      const IqroPage(
        jilid: 1,
        pageNumber: 2,
        title: "Huruf بَ تَ (BA TA)",
        instruction: "BACAAN LANGSUNG A - BA - TA Dst. DENGAN SUARA PENDEK-PENDEK",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "1_2_r1_1_0", arabic: "بَ", latin: "ba", audioTtsText: "بَ"),
              IqroWordItem(id: "1_2_r1_1_1", arabic: "تَ", latin: "ta", audioTtsText: "تَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_2_r2_1_0", arabic: "اَ تَ بَ", latin: "a ta ba", audioTtsText: "اَ تَ بَ"),
              IqroWordItem(id: "1_2_r2_2_1", arabic: "تَ بَ اَ", latin: "ta ba a", audioTtsText: "تَ بَ اَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_2_r3_1_0", arabic: "تَ اَ بَ", latin: "ta a ba", audioTtsText: "تَ اَ بَ"),
              IqroWordItem(id: "1_2_r3_2_1", arabic: "اَ بَ تَ", latin: "a ba ta", audioTtsText: "اَ بَ تَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_2_r4_1_0", arabic: "بَ تَ اَ", latin: "ba ta a", audioTtsText: "بَ تَ اَ"),
              IqroWordItem(id: "1_2_r4_2_1", arabic: "اَ تَ بَ", latin: "a ta ba", audioTtsText: "اَ تَ بَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_2_r5_1_0", arabic: "تَ اَ تَ", latin: "ta a ta", audioTtsText: "تَ اَ تَ"),
              IqroWordItem(id: "1_2_r5_2_1", arabic: "بَ اَ تَ", latin: "ba a ta", audioTtsText: "بَ اَ تَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_2_r6_1_0", arabic: "اَ تَ بَ", latin: "a ta ba", audioTtsText: "اَ تَ بَ"),
              IqroWordItem(id: "1_2_r6_2_1", arabic: "تَ تَ اَ", latin: "ta ta a", audioTtsText: "تَ تَ اَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_2_r7_1_0", arabic: "اَ بَ تَ", latin: "a ba ta", audioTtsText: "اَ بَ تَ"),
              IqroWordItem(id: "1_2_r7_2_1", arabic: "اَ بَ تَ", latin: "a ba ta", audioTtsText: "اَ بَ تَ"),
            ],
          ),
        ],
      ),
      // Halaman 3: Huruf بَ تَ ثَ (BA TA TSA)
      const IqroPage(
        jilid: 1,
        pageNumber: 3,
        title: "Huruf بَ تَ ثَ (BA TA TSA)",
        instruction: "Iqro Jilid 1 Halaman 3",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "1_3_r1_1_0", arabic: "بَ", latin: "ba", audioTtsText: "بَ"),
              IqroWordItem(id: "1_3_r1_1_1", arabic: "تَ", latin: "ta", audioTtsText: "تَ"),
              IqroWordItem(id: "1_3_r1_1_2", arabic: "ثَ", latin: "tsa", audioTtsText: "ثَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_3_r2_1_0", arabic: "بَ تَ بَ", latin: "ba ta ba", audioTtsText: "بَ تَ بَ"),
              IqroWordItem(id: "1_3_r2_2_1", arabic: "بَ اَ ثَ", latin: "ba a tsa", audioTtsText: "بَ اَ ثَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_3_r3_1_0", arabic: "اَ تَ بَ", latin: "a ta ba", audioTtsText: "اَ تَ بَ"),
              IqroWordItem(id: "1_3_r3_2_1", arabic: "ثَ بَ ثَ", latin: "tsa ba tsa", audioTtsText: "ثَ بَ ثَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_3_r4_1_0", arabic: "تَ بَ تَ", latin: "ta ba ta", audioTtsText: "تَ بَ تَ"),
              IqroWordItem(id: "1_3_r4_2_1", arabic: "اَ ثَ ثَ", latin: "a tsa tsa", audioTtsText: "اَ ثَ ثَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_3_r5_1_0", arabic: "اَ تَ تَ", latin: "a ta ta", audioTtsText: "اَ تَ تَ"),
              IqroWordItem(id: "1_3_r5_2_1", arabic: "بَ ثَ ثَ", latin: "ba tsa tsa", audioTtsText: "بَ ثَ ثَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_3_r6_1_0", arabic: "ثَ بَ تَ", latin: "tsa ba ta", audioTtsText: "ثَ بَ تَ"),
              IqroWordItem(id: "1_3_r6_2_1", arabic: "بَ تَ ثَ", latin: "ba ta tsa", audioTtsText: "بَ تَ ثَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_3_r7_1_0", arabic: "اَ بَ تَ ثَ", latin: "a ba ta tsa", audioTtsText: "اَ بَ تَ ثَ"),
              IqroWordItem(id: "1_3_r7_2_1", arabic: "اَ بَ تَ ثَ", latin: "a ba ta tsa", audioTtsText: "اَ بَ تَ ثَ"),
            ],
          ),
        ],
      ),
      // Halaman 4: Huruf جَ (JA)
      const IqroPage(
        jilid: 1,
        pageNumber: 4,
        title: "Huruf جَ (JA)",
        instruction: "Iqro Jilid 1 Halaman 4",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "1_4_r1_1_0", arabic: "جَ", latin: "ja", audioTtsText: "جَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_4_r2_1_0", arabic: "جَ تَ اَ", latin: "ja ta a", audioTtsText: "جَ تَ اَ"),
              IqroWordItem(id: "1_4_r2_2_1", arabic: "ثَ بَ جَ", latin: "tsa ba ja", audioTtsText: "ثَ بَ جَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_4_r3_1_0", arabic: "ثَ جَ بَ", latin: "tsa ja ba", audioTtsText: "ثَ جَ بَ"),
              IqroWordItem(id: "1_4_r3_2_1", arabic: "ثَ اَ جَ", latin: "tsa a ja", audioTtsText: "ثَ اَ جَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_4_r4_1_0", arabic: "بَ اَ جَ", latin: "ba a ja", audioTtsText: "بَ اَ جَ"),
              IqroWordItem(id: "1_4_r4_2_1", arabic: "جَ اَ ثَ", latin: "ja a tsa", audioTtsText: "جَ اَ ثَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_4_r5_1_0", arabic: "جَ اَ تَ", latin: "ja a ta", audioTtsText: "جَ اَ تَ"),
              IqroWordItem(id: "1_4_r5_2_1", arabic: "جَ جَ ثَ", latin: "ja ja tsa", audioTtsText: "جَ جَ ثَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_4_r6_1_0", arabic: "جَ اَ جَ", latin: "ja a ja", audioTtsText: "جَ اَ جَ"),
              IqroWordItem(id: "1_4_r6_2_1", arabic: "جَ ثَ ثَ", latin: "ja tsa tsa", audioTtsText: "جَ ثَ ثَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_4_r7_1_0", arabic: "اَ بَ تَ ثَ جَ", latin: "a ba ta tsa ja", audioTtsText: "اَ بَ تَ ثَ جَ"),
            ],
          ),
        ],
      ),
      // Halaman 5: Huruf جَ حَ (JA HA)
      const IqroPage(
        jilid: 1,
        pageNumber: 5,
        title: "Huruf جَ حَ (JA HA)",
        instruction: "Iqro Jilid 1 Halaman 5",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "1_5_r1_1_0", arabic: "جَ", latin: "ja", audioTtsText: "جَ"),
              IqroWordItem(id: "1_5_r1_1_1", arabic: "حَ", latin: "ha", audioTtsText: "حَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_5_r2_1_0", arabic: "حَ اَ جَ", latin: "ha a ja", audioTtsText: "حَ اَ جَ"),
              IqroWordItem(id: "1_5_r2_2_1", arabic: "جَ حَ ثَ", latin: "ja ha tsa", audioTtsText: "جَ حَ ثَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_5_r3_1_0", arabic: "تَ جَ حَ", latin: "ta ja ha", audioTtsText: "تَ جَ حَ"),
              IqroWordItem(id: "1_5_r3_2_1", arabic: "بَ حَ ثَ", latin: "ba ha tsa", audioTtsText: "بَ حَ ثَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_5_r4_1_0", arabic: "تَ حَ جَ", latin: "ta ha ja", audioTtsText: "تَ حَ جَ"),
              IqroWordItem(id: "1_5_r4_2_1", arabic: "اَ حَ بَ", latin: "a ha ba", audioTtsText: "اَ حَ بَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_5_r5_1_0", arabic: "ثَ اَ جَ", latin: "tsa a ja", audioTtsText: "ثَ اَ جَ"),
              IqroWordItem(id: "1_5_r5_2_1", arabic: "حَ بَ ثَ", latin: "ha ba tsa", audioTtsText: "حَ بَ ثَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_5_r6_1_0", arabic: "اَ جَ جَ", latin: "a ja ja", audioTtsText: "اَ جَ جَ"),
              IqroWordItem(id: "1_5_r6_2_1", arabic: "اَ حَ حَ", latin: "a ha ha", audioTtsText: "اَ حَ حَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_5_r7_1_0", arabic: "اَ بَ تَ ثَ جَ حَ", latin: "a ba ta tsa ja ha", audioTtsText: "اَ بَ تَ ثَ جَ حَ"),
            ],
          ),
        ],
      ),
      // Halaman 6: Huruf جَ حَ خَ (JA HA KHO)
      const IqroPage(
        jilid: 1,
        pageNumber: 6,
        title: "Huruf جَ حَ خَ (JA HA KHO)",
        instruction: "Iqro Jilid 1 Halaman 6",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "1_6_r1_1_0", arabic: "جَ", latin: "ja", audioTtsText: "جَ"),
              IqroWordItem(id: "1_6_r1_1_1", arabic: "حَ", latin: "ha", audioTtsText: "حَ"),
              IqroWordItem(id: "1_6_r1_1_2", arabic: "خَ", latin: "kho", audioTtsText: "خَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_6_r2_1_0", arabic: "خَ اَ حَ", latin: "kho a ha", audioTtsText: "خَ اَ حَ"),
              IqroWordItem(id: "1_6_r2_2_1", arabic: "خَ اَ جَ", latin: "kho a ja", audioTtsText: "خَ اَ جَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_6_r3_1_0", arabic: "خَ اَ ثَ", latin: "kho a tsa", audioTtsText: "خَ اَ ثَ"),
              IqroWordItem(id: "1_6_r3_2_1", arabic: "خَ تَ جَ", latin: "kho ta ja", audioTtsText: "خَ تَ جَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_6_r4_1_0", arabic: "جَ اَ حَ", latin: "ja a ha", audioTtsText: "جَ اَ حَ"),
              IqroWordItem(id: "1_6_r4_2_1", arabic: "بَ حَ ثَ", latin: "ba ha tsa", audioTtsText: "بَ حَ ثَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_6_r5_1_0", arabic: "ثَ اَ جَ", latin: "tsa a ja", audioTtsText: "ثَ اَ جَ"),
              IqroWordItem(id: "1_6_r5_2_1", arabic: "جَ حَ ثَ", latin: "ja ha tsa", audioTtsText: "جَ حَ ثَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_6_r6_1_0", arabic: "اَ خَ خَ", latin: "a kho kho", audioTtsText: "اَ خَ خَ"),
              IqroWordItem(id: "1_6_r6_2_1", arabic: "خَ حَ جَ", latin: "kho ha ja", audioTtsText: "خَ حَ جَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_6_r7_1_0", arabic: "اَ بَ تَ ثَ جَ حَ خَ", latin: "a ba ta tsa ja ha kho", audioTtsText: "اَ بَ تَ ثَ جَ حَ خَ"),
            ],
          ),
        ],
      ),
      // Halaman 7: Huruf دَ (DA)
      const IqroPage(
        jilid: 1,
        pageNumber: 7,
        title: "Huruf دَ (DA)",
        instruction: "Iqro Jilid 1 Halaman 7",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "1_7_r1_1_0", arabic: "دَ", latin: "da", audioTtsText: "دَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_7_r2_1_0", arabic: "خَ دَ حَ", latin: "kho da ha", audioTtsText: "خَ دَ حَ"),
              IqroWordItem(id: "1_7_r2_2_1", arabic: "حَ دَ خَ", latin: "ha da kho", audioTtsText: "حَ دَ خَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_7_r3_1_0", arabic: "ثَ دَ حَ", latin: "tsa da ha", audioTtsText: "ثَ دَ حَ"),
              IqroWordItem(id: "1_7_r3_2_1", arabic: "دَ حَ جَ", latin: "da ha ja", audioTtsText: "دَ حَ جَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_7_r4_1_0", arabic: "دَ تَ حَ", latin: "da ta ha", audioTtsText: "دَ تَ حَ"),
              IqroWordItem(id: "1_7_r4_2_1", arabic: "دَ جَ حَ", latin: "da ja ha", audioTtsText: "دَ جَ حَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_7_r5_1_0", arabic: "دَ بَ ثَ", latin: "da ba tsa", audioTtsText: "دَ بَ ثَ"),
              IqroWordItem(id: "1_7_r5_2_1", arabic: "جَ حَ حَ", latin: "ja ha ha", audioTtsText: "جَ حَ حَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_7_r6_1_0", arabic: "دَ بَ حَ", latin: "da ba ha", audioTtsText: "دَ بَ حَ"),
              IqroWordItem(id: "1_7_r6_2_1", arabic: "حَ دَ جَ", latin: "ha da ja", audioTtsText: "حَ دَ جَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_7_r7_1_0", arabic: "تَ جَ حَ", latin: "ta ja ha", audioTtsText: "تَ جَ حَ"),
              IqroWordItem(id: "1_7_r7_2_1", arabic: "دَ دَ خَ", latin: "da da kho", audioTtsText: "دَ دَ خَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_7_r8_1_0", arabic: "اَ بَ تَ ثَ جَ حَ خَ دَ", latin: "a ba ta tsa ja ha kho da", audioTtsText: "اَ بَ تَ ثَ جَ حَ خَ دَ"),
            ],
          ),
        ],
      ),
      // Halaman 8: Huruf دَ ذَ (DA DZA)
      const IqroPage(
        jilid: 1,
        pageNumber: 8,
        title: "Huruf دَ ذَ (DA DZA)",
        instruction: "Iqro Jilid 1 Halaman 8",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "1_8_r1_1_0", arabic: "دَ", latin: "da", audioTtsText: "دَ"),
              IqroWordItem(id: "1_8_r1_1_1", arabic: "ذَ", latin: "dza", audioTtsText: "ذَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_8_r2_1_0", arabic: "ذَ اَ دَ", latin: "dza a da", audioTtsText: "ذَ اَ دَ"),
              IqroWordItem(id: "1_8_r2_2_1", arabic: "حَ دَ ذَ", latin: "ha da dza", audioTtsText: "حَ دَ ذَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_8_r3_1_0", arabic: "دَ حَ اَ", latin: "da ha a", audioTtsText: "دَ حَ اَ"),
              IqroWordItem(id: "1_8_r3_2_1", arabic: "جَ حَ ذَ", latin: "ja ha dza", audioTtsText: "جَ حَ ذَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_8_r4_1_0", arabic: "دَ تَ خَ", latin: "da ta kho", audioTtsText: "دَ تَ خَ"),
              IqroWordItem(id: "1_8_r4_2_1", arabic: "ثَ اَ ذَ", latin: "tsa a dza", audioTtsText: "ثَ اَ ذَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_8_r5_1_0", arabic: "خَ حَ جَ", latin: "kho ha ja", audioTtsText: "خَ حَ جَ"),
              IqroWordItem(id: "1_8_r5_2_1", arabic: "ذَ بَ حَ", latin: "dza ba ha", audioTtsText: "ذَ بَ حَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_8_r6_1_0", arabic: "ثَ دَ حَ", latin: "tsa da ha", audioTtsText: "ثَ دَ حَ"),
              IqroWordItem(id: "1_8_r6_2_1", arabic: "اَ حَ ذَ", latin: "a ha dza", audioTtsText: "اَ حَ ذَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_8_r7_1_0", arabic: "ذَ اَ دَ", latin: "dza a da", audioTtsText: "ذَ اَ دَ"),
              IqroWordItem(id: "1_8_r7_2_1", arabic: "خَ دَ ذَ", latin: "kho da dza", audioTtsText: "خَ دَ ذَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_8_r8_1_0", arabic: "اَ بَ تَ ثَ جَ حَ خَ دَ ذَ", latin: "a ba ta tsa ja ha kho da dza", audioTtsText: "اَ بَ تَ ثَ جَ حَ خَ دَ ذَ"),
            ],
          ),
        ],
      ),
      // Halaman 9: Huruf رَ (RO)
      const IqroPage(
        jilid: 1,
        pageNumber: 9,
        title: "Huruf رَ (RO)",
        instruction: "Iqro Jilid 1 Halaman 9",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "1_9_r1_1_0", arabic: "رَ", latin: "ro", audioTtsText: "رَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_9_r2_1_0", arabic: "رَ ذَ دَ", latin: "ro dza da", audioTtsText: "رَ ذَ دَ"),
              IqroWordItem(id: "1_9_r2_2_1", arabic: "خَ ذَ رَ", latin: "kho dza ro", audioTtsText: "خَ ذَ رَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_9_r3_1_0", arabic: "دَ حَ رَ", latin: "da ha ro", audioTtsText: "دَ حَ رَ"),
              IqroWordItem(id: "1_9_r3_2_1", arabic: "جَ رَ ذَ", latin: "ja ro dza", audioTtsText: "جَ رَ ذَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_9_r4_1_0", arabic: "ثَ حَ رَ", latin: "tsa ha ro", audioTtsText: "ثَ حَ رَ"),
              IqroWordItem(id: "1_9_r4_2_1", arabic: "تَ ذَ رَ", latin: "ta dza ro", audioTtsText: "تَ ذَ رَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_9_r5_1_0", arabic: "دَ دَ بَ", latin: "da da ba", audioTtsText: "دَ دَ بَ"),
              IqroWordItem(id: "1_9_r5_2_1", arabic: "خَ دَ جَ", latin: "kho da ja", audioTtsText: "خَ دَ جَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_9_r6_1_0", arabic: "رَ ذَ حَ", latin: "ro dza ha", audioTtsText: "رَ ذَ حَ"),
              IqroWordItem(id: "1_9_r6_2_1", arabic: "بَ رَ تَ", latin: "ba ro ta", audioTtsText: "بَ رَ تَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_9_r7_1_0", arabic: "خَ حَ حَ", latin: "kho ha ha", audioTtsText: "خَ حَ حَ"),
              IqroWordItem(id: "1_9_r7_2_1", arabic: "حَ جَ رَ", latin: "ha ja ro", audioTtsText: "حَ جَ رَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_9_r8_1_0", arabic: "اَ بَ تَ ثَ جَ حَ خَ دَ ذَ رَ", latin: "a ba ta tsa ja ha kho da dza ro", audioTtsText: "اَ بَ تَ ثَ جَ حَ خَ دَ ذَ رَ"),
            ],
          ),
        ],
      ),
      // Halaman 10: Huruf رَ زَ (RO ZA)
      const IqroPage(
        jilid: 1,
        pageNumber: 10,
        title: "Huruf رَ زَ (RO ZA)",
        instruction: "Iqro Jilid 1 Halaman 10",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "1_10_r1_1_0", arabic: "رَ", latin: "ro", audioTtsText: "رَ"),
              IqroWordItem(id: "1_10_r1_1_1", arabic: "زَ", latin: "za", audioTtsText: "زَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_10_r2_1_0", arabic: "ذَ اَ رَ", latin: "dza a ro", audioTtsText: "ذَ اَ رَ"),
              IqroWordItem(id: "1_10_r2_2_1", arabic: "ذَ رَ زَ", latin: "dza ro za", audioTtsText: "ذَ رَ زَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_10_r3_1_0", arabic: "رَ دَ زَ", latin: "ro da za", audioTtsText: "رَ دَ زَ"),
              IqroWordItem(id: "1_10_r3_2_1", arabic: "زَ حَ ذَ", latin: "za ha dza", audioTtsText: "زَ حَ ذَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_10_r4_1_0", arabic: "دَ حَ زَ", latin: "da ha za", audioTtsText: "دَ حَ زَ"),
              IqroWordItem(id: "1_10_r4_2_1", arabic: "ثَ رَ زَ", latin: "tsa ro za", audioTtsText: "ثَ رَ زَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_10_r5_1_0", arabic: "جَ رَ حَ", latin: "ja ro ha", audioTtsText: "جَ رَ حَ"),
              IqroWordItem(id: "1_10_r5_2_1", arabic: "تَ زَ دَ", latin: "ta za da", audioTtsText: "تَ زَ دَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_10_r6_1_0", arabic: "رَ زَ بَ", latin: "ro za ba", audioTtsText: "رَ زَ بَ"),
              IqroWordItem(id: "1_10_r6_2_1", arabic: "ذَ حَ ثَ", latin: "dza ha tsa", audioTtsText: "ذَ حَ ثَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_10_r7_1_0", arabic: "خَ اَ جَ", latin: "kho a ja", audioTtsText: "خَ اَ جَ"),
              IqroWordItem(id: "1_10_r7_2_1", arabic: "زَ اَ زَ", latin: "za a za", audioTtsText: "زَ اَ زَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_10_r8_1_0", arabic: "اَ بَ تَ ثَ جَ حَ خَ دَ ذَ رَ زَ", latin: "a ba ta tsa ja ha kho da dza ro za", audioTtsText: "اَ بَ تَ ثَ جَ حَ خَ دَ ذَ رَ زَ"),
            ],
          ),
        ],
      ),
      // Halaman 11: Huruf سَ (SA)
      const IqroPage(
        jilid: 1,
        pageNumber: 11,
        title: "Huruf سَ (SA)",
        instruction: "Iqro Jilid 1 Halaman 11",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "1_11_r1_1_0", arabic: "سَ", latin: "sa", audioTtsText: "سَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_11_r2_1_0", arabic: "سَ اَ زَ", latin: "sa a za", audioTtsText: "سَ اَ زَ"),
              IqroWordItem(id: "1_11_r2_2_1", arabic: "زَ رَ سَ", latin: "za ro sa", audioTtsText: "زَ رَ سَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_11_r3_1_0", arabic: "ذَ خَ سَ", latin: "dza kho sa", audioTtsText: "ذَ خَ سَ"),
              IqroWordItem(id: "1_11_r3_2_1", arabic: "حَ سَ دَ", latin: "ha sa da", audioTtsText: "حَ سَ دَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_11_r4_1_0", arabic: "ثَ حَ سَ", latin: "tsa ha sa", audioTtsText: "ثَ حَ سَ"),
              IqroWordItem(id: "1_11_r4_2_1", arabic: "جَ زَ رَ", latin: "ja za ro", audioTtsText: "جَ زَ رَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_11_r5_1_0", arabic: "تَ بَ سَ", latin: "ta ba sa", audioTtsText: "تَ بَ سَ"),
              IqroWordItem(id: "1_11_r5_2_1", arabic: "ذَ رَ سَ", latin: "dza ro sa", audioTtsText: "ذَ رَ سَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_11_r6_1_0", arabic: "ذَ حَ سَ", latin: "dza ha sa", audioTtsText: "ذَ حَ سَ"),
              IqroWordItem(id: "1_11_r6_2_1", arabic: "زَ حَ دَ", latin: "za ha da", audioTtsText: "زَ حَ دَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_11_r7_1_0", arabic: "ثَ جَ سَ", latin: "tsa ja sa", audioTtsText: "ثَ جَ سَ"),
              IqroWordItem(id: "1_11_r7_2_1", arabic: "اَ بَ تَ", latin: "a ba ta", audioTtsText: "اَ بَ تَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_11_r8_1_0", arabic: "ثَ جَ حَ خَ دَ ذَ رَ زَ سَ", latin: "tsa ja ha kho da dza ro za sa", audioTtsText: "ثَ جَ حَ خَ دَ ذَ رَ زَ سَ"),
            ],
          ),
        ],
      ),
      // Halaman 12: Huruf سَ شَ (SA SYA)
      const IqroPage(
        jilid: 1,
        pageNumber: 12,
        title: "Huruf سَ شَ (SA SYA)",
        instruction: "Iqro Jilid 1 Halaman 12",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "1_12_r1_1_0", arabic: "سَ", latin: "sa", audioTtsText: "سَ"),
              IqroWordItem(id: "1_12_r1_1_1", arabic: "شَ", latin: "sya", audioTtsText: "شَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_12_r2_1_0", arabic: "شَ اَ سَ", latin: "sya a sa", audioTtsText: "شَ اَ سَ"),
              IqroWordItem(id: "1_12_r2_2_1", arabic: "شَ شَ سَ", latin: "sya sya sa", audioTtsText: "شَ شَ سَ"),
              IqroWordItem(id: "1_12_r2_3_2", arabic: "زَ تَ شَ", latin: "za ta sya", audioTtsText: "زَ تَ شَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_12_r3_1_0", arabic: "ثَ ذَ شَ", latin: "tsa dza sya", audioTtsText: "ثَ ذَ شَ"),
              IqroWordItem(id: "1_12_r3_2_1", arabic: "دَ رَ سَ", latin: "da ro sa", audioTtsText: "دَ رَ سَ"),
              IqroWordItem(id: "1_12_r3_3_2", arabic: "شَ تَ ذَ", latin: "sya ta dza", audioTtsText: "شَ تَ ذَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_12_r4_1_0", arabic: "ثَ حَ زَ", latin: "tsa ha za", audioTtsText: "ثَ حَ زَ"),
              IqroWordItem(id: "1_12_r4_2_1", arabic: "خَ شَ بَ", latin: "kho sya ba", audioTtsText: "خَ شَ بَ"),
              IqroWordItem(id: "1_12_r4_3_2", arabic: "جَ رَ سَ", latin: "ja ro sa", audioTtsText: "جَ رَ سَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_12_r5_1_0", arabic: "اَ شَ سَ", latin: "a sya sa", audioTtsText: "اَ شَ سَ"),
              IqroWordItem(id: "1_12_r5_2_1", arabic: "رَ شَ ذَ", latin: "ro sya dza", audioTtsText: "رَ شَ ذَ"),
              IqroWordItem(id: "1_12_r5_3_2", arabic: "حَ سَ دَ", latin: "ha sa da", audioTtsText: "حَ سَ دَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_12_r6_1_0", arabic: "زَ حَ ذَ", latin: "za ha dza", audioTtsText: "زَ حَ ذَ"),
              IqroWordItem(id: "1_12_r6_2_1", arabic: "اَ سَ شَ", latin: "a sa sya", audioTtsText: "اَ سَ شَ"),
              IqroWordItem(id: "1_12_r6_3_2", arabic: "شَ زَ رَ", latin: "sya za ro", audioTtsText: "شَ زَ رَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_12_r7_1_0", arabic: "اَ بَ تَ", latin: "a ba ta", audioTtsText: "اَ بَ تَ"),
              IqroWordItem(id: "1_12_r7_2_1", arabic: "شَ زَ جَ", latin: "sya za ja", audioTtsText: "شَ زَ جَ"),
              IqroWordItem(id: "1_12_r7_3_2", arabic: "حَ سَ دَ", latin: "ha sa da", audioTtsText: "حَ سَ دَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_12_r8_1_0", arabic: "ثَ جَ حَ خَ دَ ذَ رَ زَ سَ شَ", latin: "tsa ja ha kho da dza ro za sa sya", audioTtsText: "ثَ جَ حَ خَ دَ ذَ رَ زَ سَ شَ"),
            ],
          ),
        ],
      ),
      // Halaman 13: Huruf صَ (SHO)
      const IqroPage(
        jilid: 1,
        pageNumber: 13,
        title: "Huruf صَ (SHO)",
        instruction: "Iqro Jilid 1 Halaman 13",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "1_13_r1_1_0", arabic: "صَ", latin: "sho", audioTtsText: "صَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_13_r2_1_0", arabic: "شَ اَ صَ", latin: "sya a sho", audioTtsText: "شَ اَ صَ"),
              IqroWordItem(id: "1_13_r2_2_1", arabic: "صَ شَ زَ", latin: "sho sya za", audioTtsText: "صَ شَ زَ"),
              IqroWordItem(id: "1_13_r2_3_2", arabic: "سَ رَ صَ", latin: "sa ro sho", audioTtsText: "سَ رَ صَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_13_r3_1_0", arabic: "ذَ ثَ صَ", latin: "dza tsa sho", audioTtsText: "ذَ ثَ صَ"),
              IqroWordItem(id: "1_13_r3_2_1", arabic: "دَ سَ صَ", latin: "da sa sho", audioTtsText: "دَ سَ صَ"),
              IqroWordItem(id: "1_13_r3_3_2", arabic: "شَ رَ تَ", latin: "sya ro ta", audioTtsText: "شَ رَ تَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_13_r4_1_0", arabic: "سَ خَ صَ", latin: "sa kho sho", audioTtsText: "سَ خَ صَ"),
              IqroWordItem(id: "1_13_r4_2_1", arabic: "حَ صَ دَ", latin: "ha sho da", audioTtsText: "حَ صَ دَ"),
              IqroWordItem(id: "1_13_r4_3_2", arabic: "ذَ زَ صَ", latin: "dza za sho", audioTtsText: "ذَ زَ صَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_13_r5_1_0", arabic: "حَ ذَ رَ", latin: "ha dza ro", audioTtsText: "حَ ذَ رَ"),
              IqroWordItem(id: "1_13_r5_2_1", arabic: "شَ بَ صَ", latin: "sya ba sho", audioTtsText: "شَ بَ صَ"),
              IqroWordItem(id: "1_13_r5_3_2", arabic: "سَ جَ زَ", latin: "sa ja za", audioTtsText: "سَ جَ زَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_13_r6_1_0", arabic: "صَ دَ حَ", latin: "sho da ha", audioTtsText: "صَ دَ حَ"),
              IqroWordItem(id: "1_13_r6_2_1", arabic: "صَ جَ ذَ", latin: "sho ja dza", audioTtsText: "صَ جَ ذَ"),
              IqroWordItem(id: "1_13_r6_3_2", arabic: "شَ رَ زَ", latin: "sya ro za", audioTtsText: "شَ رَ زَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_13_r7_1_0", arabic: "ثَ حَ صَ", latin: "tsa ha sho", audioTtsText: "ثَ حَ صَ"),
              IqroWordItem(id: "1_13_r7_2_1", arabic: "اَ بَ تَ ثَ جَ حَ", latin: "a ba ta tsa ja ha", audioTtsText: "اَ بَ تَ ثَ جَ حَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_13_r8_1_0", arabic: "خَ دَ ذَ رَ زَ سَ شَ صَ", latin: "kho da dza ro za sa sya sho", audioTtsText: "خَ دَ ذَ رَ زَ سَ شَ صَ"),
            ],
          ),
        ],
      ),
      // Halaman 14: Huruf صَ ضَ (SHO DHO)
      const IqroPage(
        jilid: 1,
        pageNumber: 14,
        title: "Huruf صَ ضَ (SHO DHO)",
        instruction: "Iqro Jilid 1 Halaman 14",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "1_14_r1_1_0", arabic: "صَ", latin: "sho", audioTtsText: "صَ"),
              IqroWordItem(id: "1_14_r1_1_1", arabic: "ضَ", latin: "dho", audioTtsText: "ضَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_14_r2_1_0", arabic: "ضَ اَ صَ", latin: "dho a sho", audioTtsText: "ضَ اَ صَ"),
              IqroWordItem(id: "1_14_r2_2_1", arabic: "حَ ضَ رَ", latin: "ha dho ro", audioTtsText: "حَ ضَ رَ"),
              IqroWordItem(id: "1_14_r2_3_2", arabic: "اَ صَ ضَ", latin: "a sho dho", audioTtsText: "اَ صَ ضَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_14_r3_1_0", arabic: "ضَ اَ شَ", latin: "dho a sya", audioTtsText: "ضَ اَ شَ"),
              IqroWordItem(id: "1_14_r3_2_1", arabic: "شَ خَ زَ", latin: "sya kho za", audioTtsText: "شَ خَ زَ"),
              IqroWordItem(id: "1_14_r3_3_2", arabic: "ضَ رَ بَ", latin: "dho ro ba", audioTtsText: "ضَ رَ بَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_14_r4_1_0", arabic: "ثَ حَ صَ", latin: "tsa ha sho", audioTtsText: "ثَ حَ صَ"),
              IqroWordItem(id: "1_14_r4_2_1", arabic: "صَ دَ زَ", latin: "sho da za", audioTtsText: "صَ دَ زَ"),
              IqroWordItem(id: "1_14_r4_3_2", arabic: "دَ شَ ضَ", latin: "da sya dho", audioTtsText: "دَ شَ ضَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_14_r5_1_0", arabic: "سَ حَ ذَ", latin: "sa ha dza", audioTtsText: "سَ حَ ذَ"),
              IqroWordItem(id: "1_14_r5_2_1", arabic: "رَ صَ دَ", latin: "ro sho da", audioTtsText: "رَ صَ دَ"),
              IqroWordItem(id: "1_14_r5_3_2", arabic: "ضَ تَ ذَ", latin: "dho ta dza", audioTtsText: "ضَ تَ ذَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_14_r6_1_0", arabic: "سَ اَ شَ", latin: "sa a sya", audioTtsText: "سَ اَ شَ"),
              IqroWordItem(id: "1_14_r6_2_1", arabic: "ضَ جَ ذَ", latin: "dho ja dza", audioTtsText: "ضَ جَ ذَ"),
              IqroWordItem(id: "1_14_r6_3_2", arabic: "ثَ خَ زَ", latin: "tsa kho za", audioTtsText: "ثَ خَ زَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_14_r7_1_0", arabic: "صَ رَ ضَ", latin: "sho ro dho", audioTtsText: "صَ رَ ضَ"),
              IqroWordItem(id: "1_14_r7_2_1", arabic: "اَ بَ تَ ثَ جَ حَ", latin: "a ba ta tsa ja ha", audioTtsText: "اَ بَ تَ ثَ جَ حَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_14_r8_1_0", arabic: "دَ ذَ رَ زَ سَ شَ صَ ضَ", latin: "da dza ro za sa sya sho dho", audioTtsText: "دَ ذَ رَ زَ سَ شَ صَ ضَ"),
            ],
          ),
        ],
      ),
      // Halaman 15: Huruf طَ (THO)
      const IqroPage(
        jilid: 1,
        pageNumber: 15,
        title: "Huruf طَ (THO)",
        instruction: "Iqro Jilid 1 Halaman 15",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "1_15_r1_1_0", arabic: "طَ", latin: "tho", audioTtsText: "طَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_15_r2_1_0", arabic: "ضَ اَ طَ", latin: "dho a tho", audioTtsText: "ضَ اَ طَ"),
              IqroWordItem(id: "1_15_r2_2_1", arabic: "زَ طَ شَ", latin: "za tho sya", audioTtsText: "زَ طَ شَ"),
              IqroWordItem(id: "1_15_r2_3_2", arabic: "حَ جَ طَ", latin: "ha ja tho", audioTtsText: "حَ جَ طَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_15_r3_1_0", arabic: "ضَ رَ صَ تَ", latin: "dho ro sho ta", audioTtsText: "ضَ رَ صَ تَ"),
              IqroWordItem(id: "1_15_r3_2_1", arabic: "ذَ طَ سَ", latin: "dza tho sa", audioTtsText: "ذَ طَ سَ"),
              IqroWordItem(id: "1_15_r3_3_2", arabic: "زَ دَ طَ", latin: "za da tho", audioTtsText: "زَ دَ طَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_15_r4_1_0", arabic: "دَ ضَ صَ", latin: "da dho sho", audioTtsText: "دَ ضَ صَ"),
              IqroWordItem(id: "1_15_r4_2_1", arabic: "سَ رَ طَ", latin: "sa ro tho", audioTtsText: "سَ رَ طَ"),
              IqroWordItem(id: "1_15_r4_3_2", arabic: "شَ ضَ ثَ", latin: "sya dho tsa", audioTtsText: "شَ ضَ ثَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_15_r5_1_0", arabic: "شَ خَ طَ", latin: "sya kho tho", audioTtsText: "شَ خَ طَ"),
              IqroWordItem(id: "1_15_r5_2_1", arabic: "طَ حَ ذَ", latin: "tho ha dza", audioTtsText: "طَ حَ ذَ"),
              IqroWordItem(id: "1_15_r5_3_2", arabic: "بَ صَ ضَ", latin: "ba sho dho", audioTtsText: "بَ صَ ضَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_15_r6_1_0", arabic: "ذَ رَ طَ", latin: "dza ro tho", audioTtsText: "ذَ رَ طَ"),
              IqroWordItem(id: "1_15_r6_2_1", arabic: "جَ زَ ضَ", latin: "ja za dho", audioTtsText: "جَ زَ ضَ"),
              IqroWordItem(id: "1_15_r6_3_2", arabic: "ثَ اَ شَ", latin: "tsa a sya", audioTtsText: "ثَ اَ شَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_15_r7_1_0", arabic: "سَ خَ طَ", latin: "sa kho tho", audioTtsText: "سَ خَ طَ"),
              IqroWordItem(id: "1_15_r7_2_1", arabic: "اَ بَ تَ ثَ جَ حَ", latin: "a ba ta tsa ja ha", audioTtsText: "اَ بَ تَ ثَ جَ حَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_15_r8_1_0", arabic: "دَ ذَ رَ زَ سَ شَ صَ ضَ طَ", latin: "da dza ro za sa sya sho dho tho", audioTtsText: "دَ ذَ رَ زَ سَ شَ صَ ضَ طَ"),
            ],
          ),
        ],
      ),
      // Halaman 16: Huruf طَ ظَ (THO ZHO)
      const IqroPage(
        jilid: 1,
        pageNumber: 16,
        title: "Huruf طَ ظَ (THO ZHO)",
        instruction: "Iqro Jilid 1 Halaman 16",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "1_16_r1_1_0", arabic: "طَ", latin: "tho", audioTtsText: "طَ"),
              IqroWordItem(id: "1_16_r1_1_1", arabic: "ظَ", latin: "zho", audioTtsText: "ظَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_16_r2_1_0", arabic: "طَ اَ ظَ", latin: "tho a zho", audioTtsText: "طَ اَ ظَ"),
              IqroWordItem(id: "1_16_r2_2_1", arabic: "بَ طَ ظَ", latin: "ba tho zho", audioTtsText: "بَ طَ ظَ"),
              IqroWordItem(id: "1_16_r2_3_2", arabic: "ظَ حَ ذَ", latin: "zho ha dza", audioTtsText: "ظَ حَ ذَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_16_r3_1_0", arabic: "سَ ضَ ظَ", latin: "sa dho zho", audioTtsText: "سَ ضَ ظَ"),
              IqroWordItem(id: "1_16_r3_2_1", arabic: "دَ صَ ظَ", latin: "da sho zho", audioTtsText: "دَ صَ ظَ"),
              IqroWordItem(id: "1_16_r3_3_2", arabic: "طَ حَ ذَ", latin: "tho ha dza", audioTtsText: "طَ حَ ذَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_16_r4_1_0", arabic: "شَ اَ ظَ", latin: "sya a zho", audioTtsText: "شَ اَ ظَ"),
              IqroWordItem(id: "1_16_r4_2_1", arabic: "سَ رَ صَ", latin: "sa ro sho", audioTtsText: "سَ رَ صَ"),
              IqroWordItem(id: "1_16_r4_3_2", arabic: "زَ خَ طَ", latin: "za kho tho", audioTtsText: "زَ خَ طَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_16_r5_1_0", arabic: "ثَ رَ ضَ", latin: "tsa ro dho", audioTtsText: "ثَ رَ ضَ"),
              IqroWordItem(id: "1_16_r5_2_1", arabic: "زَ خَ ضَ", latin: "za kho dho", audioTtsText: "زَ خَ ضَ"),
              IqroWordItem(id: "1_16_r5_3_2", arabic: "تَ ضَ ظَ", latin: "ta dho zho", audioTtsText: "تَ ضَ ظَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_16_r6_1_0", arabic: "صَ دَ شَ", latin: "sho da sya", audioTtsText: "صَ دَ شَ"),
              IqroWordItem(id: "1_16_r6_2_1", arabic: "جَ طَ ضَ", latin: "ja tho dho", audioTtsText: "جَ طَ ضَ"),
              IqroWordItem(id: "1_16_r6_3_2", arabic: "شَ طَ ظَ", latin: "sya tho zho", audioTtsText: "شَ طَ ظَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_16_r7_1_0", arabic: "دَ ذَ", latin: "da dza", audioTtsText: "دَ ذَ"),
              IqroWordItem(id: "1_16_r7_2_1", arabic: "اَ بَ تَ ثَ جَ حَ خَ", latin: "a ba ta tsa ja ha kho", audioTtsText: "اَ بَ تَ ثَ جَ حَ خَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_16_r8_1_0", arabic: "رَ زَ سَ شَ صَ ضَ طَ ظَ", latin: "ro za sa sya sho dho tho zho", audioTtsText: "رَ زَ سَ شَ صَ ضَ طَ ظَ"),
            ],
          ),
        ],
      ),
      // Halaman 17: Huruf عَ ('A)
      const IqroPage(
        jilid: 1,
        pageNumber: 17,
        title: "Huruf عَ ('A)",
        instruction: "Iqro Jilid 1 Halaman 17",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "1_17_r1_1_0", arabic: "عَ", latin: "'a", audioTtsText: "عَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_17_r2_1_0", arabic: "ظَ اَ عَ", latin: "zho a 'a", audioTtsText: "ظَ اَ عَ"),
              IqroWordItem(id: "1_17_r2_2_1", arabic: "تَ عَ رَ", latin: "ta 'a ro", audioTtsText: "تَ عَ رَ"),
              IqroWordItem(id: "1_17_r2_3_2", arabic: "بَ عَ طَ", latin: "ba 'a tho", audioTtsText: "بَ عَ طَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_17_r3_1_0", arabic: "صَ عَ زَ", latin: "sho 'a za", audioTtsText: "صَ عَ زَ"),
              IqroWordItem(id: "1_17_r3_2_1", arabic: "صَ عَ ضَ", latin: "sho 'a dho", audioTtsText: "صَ عَ ضَ"),
              IqroWordItem(id: "1_17_r3_3_2", arabic: "دَ حَ ظَ", latin: "da ha zho", audioTtsText: "دَ حَ ظَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_17_r4_1_0", arabic: "بَ عَ ثَ", latin: "ba 'a tsa", audioTtsText: "بَ عَ ثَ"),
              IqroWordItem(id: "1_17_r4_2_1", arabic: "سَ عَ ظَ", latin: "sa 'a zho", audioTtsText: "سَ عَ ظَ"),
              IqroWordItem(id: "1_17_r4_3_2", arabic: "شَ طَ عَ", latin: "sya tho 'a", audioTtsText: "شَ طَ عَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_17_r5_1_0", arabic: "جَ حَ ذَ", latin: "ja ha dza", audioTtsText: "جَ حَ ذَ"),
              IqroWordItem(id: "1_17_r5_2_1", arabic: "ضَ عَ شَ", latin: "dho 'a sya", audioTtsText: "ضَ عَ شَ"),
              IqroWordItem(id: "1_17_r5_3_2", arabic: "زَ اَ ضَ", latin: "za a dho", audioTtsText: "زَ اَ ضَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_17_r6_1_0", arabic: "عَ جَ ظَ", latin: "'a ja zho", audioTtsText: "عَ جَ ظَ"),
              IqroWordItem(id: "1_17_r6_2_1", arabic: "دَ طَ ضَ", latin: "da tho dho", audioTtsText: "دَ طَ ضَ"),
              IqroWordItem(id: "1_17_r6_3_2", arabic: "طَ عَ طَ", latin: "tho 'a tho", audioTtsText: "طَ عَ طَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_17_r7_1_0", arabic: "دَ ذَ", latin: "da dza", audioTtsText: "دَ ذَ"),
              IqroWordItem(id: "1_17_r7_2_1", arabic: "اَ بَ تَ ثَ جَ حَ خَ", latin: "a ba ta tsa ja ha kho", audioTtsText: "اَ بَ تَ ثَ جَ حَ خَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_17_r8_1_0", arabic: "رَ زَ سَ شَ صَ ضَ طَ ظَ عَ", latin: "ro za sa sya sho dho tho zho 'a", audioTtsText: "رَ زَ سَ شَ صَ ضَ طَ ظَ عَ"),
            ],
          ),
        ],
      ),
      // Halaman 18: Huruf عَ غَ ('A GHO)
      const IqroPage(
        jilid: 1,
        pageNumber: 18,
        title: "Huruf عَ غَ ('A GHO)",
        instruction: "Iqro Jilid 1 Halaman 18",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "1_18_r1_1_0", arabic: "عَ", latin: "'a", audioTtsText: "عَ"),
              IqroWordItem(id: "1_18_r1_1_1", arabic: "غَ", latin: "gho", audioTtsText: "غَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_18_r2_1_0", arabic: "عَ اَ غَ", latin: "'a a gho", audioTtsText: "عَ اَ غَ"),
              IqroWordItem(id: "1_18_r2_2_1", arabic: "دَ عَ ظَ", latin: "da 'a zho", audioTtsText: "دَ عَ ظَ"),
              IqroWordItem(id: "1_18_r2_3_2", arabic: "عَ طَ غَ", latin: "'a tho gho", audioTtsText: "عَ طَ غَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_18_r3_1_0", arabic: "ثَ عَ ظَ", latin: "tsa 'a zho", audioTtsText: "ثَ عَ ظَ"),
              IqroWordItem(id: "1_18_r3_2_1", arabic: "جَ عَ ظَ", latin: "ja 'a zho", audioTtsText: "جَ عَ ظَ"),
              IqroWordItem(id: "1_18_r3_3_2", arabic: "سَ طَ عَ", latin: "sa tho 'a", audioTtsText: "سَ طَ عَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_18_r4_1_0", arabic: "حَ رَ ظَ", latin: "ha ro zho", audioTtsText: "حَ رَ ظَ"),
              IqroWordItem(id: "1_18_r4_2_1", arabic: "شَ عَ طَ", latin: "sya 'a tho", audioTtsText: "شَ عَ طَ"),
              IqroWordItem(id: "1_18_r4_3_2", arabic: "صَ رَ عَ", latin: "sho ro 'a", audioTtsText: "صَ رَ عَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_18_r5_1_0", arabic: "زَ خَ ظَ", latin: "za kho zho", audioTtsText: "زَ خَ ظَ"),
              IqroWordItem(id: "1_18_r5_2_1", arabic: "ضَ عَ ذَ", latin: "dho 'a dza", audioTtsText: "ضَ عَ ذَ"),
              IqroWordItem(id: "1_18_r5_3_2", arabic: "تَ عَ ضَ", latin: "ta 'a dho", audioTtsText: "تَ عَ ضَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_18_r6_1_0", arabic: "شَ رَ ظَ", latin: "sya ro zho", audioTtsText: "شَ رَ ظَ"),
              IqroWordItem(id: "1_18_r6_2_1", arabic: "طَ عَ ظَ", latin: "tho 'a zho", audioTtsText: "طَ عَ ظَ"),
              IqroWordItem(id: "1_18_r6_3_2", arabic: "بَ عَ صَ", latin: "ba 'a sho", audioTtsText: "بَ عَ صَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_18_r7_1_0", arabic: "دَ ذَ رَ زَ", latin: "da dza ro za", audioTtsText: "دَ ذَ رَ زَ"),
              IqroWordItem(id: "1_18_r7_2_1", arabic: "اَ بَ تَ ثَ جَ حَ", latin: "a ba ta tsa ja ha", audioTtsText: "اَ بَ تَ ثَ جَ حَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_18_r8_1_0", arabic: "سَ شَ صَ ضَ طَ ظَ عَ غَ", latin: "sa sya sho dho tho zho 'a gho", audioTtsText: "سَ شَ صَ ضَ طَ ظَ عَ غَ"),
            ],
          ),
        ],
      ),
      // Halaman 19: Huruf فَ (FA)
      const IqroPage(
        jilid: 1,
        pageNumber: 19,
        title: "Huruf فَ (FA)",
        instruction: "Iqro Jilid 1 Halaman 19",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "1_19_r1_1_0", arabic: "فَ", latin: "fa", audioTtsText: "فَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_19_r2_1_0", arabic: "غَ اَ فَ", latin: "gho a fa", audioTtsText: "غَ اَ فَ"),
              IqroWordItem(id: "1_19_r2_2_1", arabic: "فَ عَ ضَ", latin: "fa 'a dho", audioTtsText: "فَ عَ ضَ"),
              IqroWordItem(id: "1_19_r2_3_2", arabic: "غَ فَ صَ", latin: "gho fa sho", audioTtsText: "غَ فَ صَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_19_r3_1_0", arabic: "فَ تَ حَ", latin: "fa ta ha", audioTtsText: "فَ تَ حَ"),
              IqroWordItem(id: "1_19_r3_2_1", arabic: "غَ جَ زَ", latin: "gho ja za", audioTtsText: "غَ جَ زَ"),
              IqroWordItem(id: "1_19_r3_3_2", arabic: "حَ فَ ظَ", latin: "ha fa zho", audioTtsText: "حَ فَ ظَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_19_r4_1_0", arabic: "طَ عَ دَ", latin: "tho 'a da", audioTtsText: "طَ عَ دَ"),
              IqroWordItem(id: "1_19_r4_2_1", arabic: "صَ فَ غَ", latin: "sho fa gho", audioTtsText: "صَ فَ غَ"),
              IqroWordItem(id: "1_19_r4_3_2", arabic: "شَ خَ ضَ", latin: "sya kho dho", audioTtsText: "شَ خَ ضَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_19_r5_1_0", arabic: "سَ عَ ظَ", latin: "sa 'a zho", audioTtsText: "سَ عَ ظَ"),
              IqroWordItem(id: "1_19_r5_2_1", arabic: "خَ فَ ذَ", latin: "kho fa dza", audioTtsText: "خَ فَ ذَ"),
              IqroWordItem(id: "1_19_r5_3_2", arabic: "شَ عَ ضَ", latin: "sya 'a dho", audioTtsText: "شَ عَ ضَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_19_r6_1_0", arabic: "فَ زَ عَ", latin: "fa za 'a", audioTtsText: "فَ زَ عَ"),
              IqroWordItem(id: "1_19_r6_2_1", arabic: "ثَ عَ طَ", latin: "tsa 'a tho", audioTtsText: "ثَ عَ طَ"),
              IqroWordItem(id: "1_19_r6_3_2", arabic: "ظَ فَ رَ", latin: "zho fa ro", audioTtsText: "ظَ فَ رَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_19_r7_1_0", arabic: "دَ ذَ رَ زَ", latin: "da dza ro za", audioTtsText: "دَ ذَ رَ زَ"),
              IqroWordItem(id: "1_19_r7_2_1", arabic: "اَ بَ تَ ثَ جَ حَ", latin: "a ba ta tsa ja ha", audioTtsText: "اَ بَ تَ ثَ جَ حَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_19_r8_1_0", arabic: "سَ شَ صَ ضَ طَ ظَ عَ غَ فَ", latin: "sa sya sho dho tho zho 'a gho fa", audioTtsText: "سَ شَ صَ ضَ طَ ظَ عَ غَ فَ"),
            ],
          ),
        ],
      ),
      // Halaman 20: Huruf فَ قَ (FA QO)
      const IqroPage(
        jilid: 1,
        pageNumber: 20,
        title: "Huruf فَ قَ (FA QO)",
        instruction: "Iqro Jilid 1 Halaman 20",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "1_20_r1_1_0", arabic: "فَ", latin: "fa", audioTtsText: "فَ"),
              IqroWordItem(id: "1_20_r1_1_1", arabic: "قَ", latin: "qo", audioTtsText: "قَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_20_r2_1_0", arabic: "ضَ بَ قَ", latin: "dho ba qo", audioTtsText: "ضَ بَ قَ"),
              IqroWordItem(id: "1_20_r2_2_1", arabic: "قَ طَ فَ", latin: "qo tho fa", audioTtsText: "قَ طَ فَ"),
              IqroWordItem(id: "1_20_r2_3_2", arabic: "فَ رَ قَ", latin: "fa ro qo", audioTtsText: "فَ رَ قَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_20_r3_1_0", arabic: "ثَ عَ ظَ", latin: "tsa 'a zho", audioTtsText: "ثَ عَ ظَ"),
              IqroWordItem(id: "1_20_r3_2_1", arabic: "فَ قَ ظَ", latin: "fa qo zho", audioTtsText: "فَ قَ ظَ"),
              IqroWordItem(id: "1_20_r3_3_2", arabic: "سَ عَ فَ", latin: "sa 'a fa", audioTtsText: "سَ عَ فَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_20_r4_1_0", arabic: "حَ ذَ خَ", latin: "ha dza kho", audioTtsText: "حَ ذَ خَ"),
              IqroWordItem(id: "1_20_r4_2_1", arabic: "قَ فَ صَ", latin: "qo fa sho", audioTtsText: "قَ فَ صَ"),
              IqroWordItem(id: "1_20_r4_3_2", arabic: "عَ قَ دَ", latin: "'a qo da", audioTtsText: "عَ قَ دَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_20_r5_1_0", arabic: "ضَ عَ طَ", latin: "dho 'a tho", audioTtsText: "ضَ عَ طَ"),
              IqroWordItem(id: "1_20_r5_2_1", arabic: "شَ فَ عَ", latin: "sya fa 'a", audioTtsText: "شَ فَ عَ"),
              IqroWordItem(id: "1_20_r5_3_2", arabic: "زَ قَ قَ", latin: "za qo qo", audioTtsText: "زَ قَ قَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_20_r6_1_0", arabic: "دَ ذَ", latin: "da dza", audioTtsText: "دَ ذَ"),
              IqroWordItem(id: "1_20_r6_2_1", arabic: "اَ بَ تَ ثَ جَ حَ خَ", latin: "a ba ta tsa ja ha kho", audioTtsText: "اَ بَ تَ ثَ جَ حَ خَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_20_r7_1_0", arabic: "رَ زَ", latin: "ro za", audioTtsText: "رَ زَ"),
              IqroWordItem(id: "1_20_r7_2_1", arabic: "سَ شَ", latin: "sa sya", audioTtsText: "سَ شَ"),
              IqroWordItem(id: "1_20_r7_3_2", arabic: "صَ ضَ", latin: "sho dho", audioTtsText: "صَ ضَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_20_r8_1_0", arabic: "فَ قَ", latin: "fa qo", audioTtsText: "فَ قَ"),
              IqroWordItem(id: "1_20_r8_2_1", arabic: "عَ غَ", latin: "'a gho", audioTtsText: "عَ غَ"),
              IqroWordItem(id: "1_20_r8_3_2", arabic: "طَ ظَ", latin: "tho zho", audioTtsText: "طَ ظَ"),
            ],
          ),
        ],
      ),
      // Halaman 21: Huruf كَ (KA)
      const IqroPage(
        jilid: 1,
        pageNumber: 21,
        title: "Huruf كَ (KA)",
        instruction: "Iqro Jilid 1 Halaman 21",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "1_21_r1_1_0", arabic: "كَ", latin: "ka", audioTtsText: "كَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_21_r2_1_0", arabic: "كَ خَ قَ", latin: "ka kho qo", audioTtsText: "كَ خَ قَ"),
              IqroWordItem(id: "1_21_r2_2_1", arabic: "كَ قَ خَ", latin: "ka qo kho", audioTtsText: "كَ قَ خَ"),
              IqroWordItem(id: "1_21_r2_3_2", arabic: "كَ قَ", latin: "ka qo", audioTtsText: "كَ قَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_21_r3_1_0", arabic: "ضَ حَ كَ", latin: "dho ha ka", audioTtsText: "ضَ حَ كَ"),
              IqroWordItem(id: "1_21_r3_2_1", arabic: "عَ طَ فَ", latin: "'a tho fa", audioTtsText: "عَ طَ فَ"),
              IqroWordItem(id: "1_21_r3_3_2", arabic: "شَ كَ رَ", latin: "sya ka ro", audioTtsText: "شَ كَ رَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_21_r4_1_0", arabic: "جَ كَ تَ", latin: "ja ka ta", audioTtsText: "جَ كَ تَ"),
              IqroWordItem(id: "1_21_r4_2_1", arabic: "قَ كَ فَ", latin: "qo ka fa", audioTtsText: "قَ كَ فَ"),
              IqroWordItem(id: "1_21_r4_3_2", arabic: "ذَ غَ سَ", latin: "dza gho sa", audioTtsText: "ذَ غَ سَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_21_r5_1_0", arabic: "صَ دَ ثَ", latin: "sho da tsa", audioTtsText: "صَ دَ ثَ"),
              IqroWordItem(id: "1_21_r5_2_1", arabic: "غَ فَ كَ", latin: "gho fa ka", audioTtsText: "غَ فَ كَ"),
              IqroWordItem(id: "1_21_r5_3_2", arabic: "زَ كَ طَ", latin: "za ka tho", audioTtsText: "زَ كَ طَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_21_r6_1_0", arabic: "اَ بَ تَ ثَ", latin: "a ba ta tsa", audioTtsText: "اَ بَ تَ ثَ"),
              IqroWordItem(id: "1_21_r6_2_1", arabic: "جَ حَ خَ", latin: "ja ha kho", audioTtsText: "جَ حَ خَ"),
              IqroWordItem(id: "1_21_r6_3_2", arabic: "دَ ذَ", latin: "da dza", audioTtsText: "دَ ذَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_21_r7_1_0", arabic: "رَ زَ سَ شَ صَ ضَ طَ ظَ", latin: "ro za sa sya sho dho tho zho", audioTtsText: "رَ زَ سَ شَ صَ ضَ طَ ظَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_21_r8_1_0", arabic: "عَ غَ فَ قَ كَ", latin: "'a gho fa qo ka", audioTtsText: "عَ غَ فَ قَ كَ"),
            ],
          ),
        ],
      ),
      // Halaman 22: Huruf لَ (LA)
      const IqroPage(
        jilid: 1,
        pageNumber: 22,
        title: "Huruf لَ (LA)",
        instruction: "Iqro Jilid 1 Halaman 22",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "1_22_r1_1_0", arabic: "لَ", latin: "la", audioTtsText: "لَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_22_r2_1_0", arabic: "قَ لَ بَ", latin: "qo la ba", audioTtsText: "قَ لَ بَ"),
              IqroWordItem(id: "1_22_r2_2_1", arabic: "جَ عَ لَ", latin: "ja 'a la", audioTtsText: "جَ عَ لَ"),
              IqroWordItem(id: "1_22_r2_3_2", arabic: "خَ لَ طَ", latin: "kho la tho", audioTtsText: "خَ لَ طَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_22_r3_1_0", arabic: "ذَ كَ رَ", latin: "dza ka ro", audioTtsText: "ذَ كَ رَ"),
              IqroWordItem(id: "1_22_r3_2_1", arabic: "غَ لَ ظَ", latin: "gho la zho", audioTtsText: "غَ لَ ظَ"),
              IqroWordItem(id: "1_22_r3_3_2", arabic: "قَ فَ صَ", latin: "qo fa sho", audioTtsText: "قَ فَ صَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_22_r4_1_0", arabic: "حَ لَ فَ", latin: "ha la fa", audioTtsText: "حَ لَ فَ"),
              IqroWordItem(id: "1_22_r4_2_1", arabic: "دَ غَ سَ", latin: "da gho sa", audioTtsText: "دَ غَ سَ"),
              IqroWordItem(id: "1_22_r4_3_2", arabic: "شَ كَ لَ", latin: "sya ka la", audioTtsText: "شَ كَ لَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_22_r5_1_0", arabic: "ضَ رَ عَ", latin: "dho ro 'a", audioTtsText: "ضَ رَ عَ"),
              IqroWordItem(id: "1_22_r5_2_1", arabic: "زَ تَ ظَ", latin: "za ta zho", audioTtsText: "زَ تَ ظَ"),
              IqroWordItem(id: "1_22_r5_3_2", arabic: "كَ لَ لَ", latin: "ka la la", audioTtsText: "كَ لَ لَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_22_r6_1_0", arabic: "اَ بَ تَ ثَ", latin: "a ba ta tsa", audioTtsText: "اَ بَ تَ ثَ"),
              IqroWordItem(id: "1_22_r6_2_1", arabic: "جَ حَ خَ", latin: "ja ha kho", audioTtsText: "جَ حَ خَ"),
              IqroWordItem(id: "1_22_r6_3_2", arabic: "دَ ذَ", latin: "da dza", audioTtsText: "دَ ذَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_22_r7_1_0", arabic: "رَ زَ", latin: "ro za", audioTtsText: "رَ زَ"),
              IqroWordItem(id: "1_22_r7_2_1", arabic: "سَ شَ", latin: "sa sya", audioTtsText: "سَ شَ"),
              IqroWordItem(id: "1_22_r7_3_2", arabic: "صَ ضَ", latin: "sho dho", audioTtsText: "صَ ضَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_22_r8_1_0", arabic: "طَ ظَ عَ غَ فَ قَ كَ لَ", latin: "tho zho 'a gho fa qo ka la", audioTtsText: "طَ ظَ عَ غَ فَ قَ كَ لَ"),
            ],
          ),
        ],
      ),
      // Halaman 23: Huruf مَ (MA)
      const IqroPage(
        jilid: 1,
        pageNumber: 23,
        title: "Huruf مَ (MA)",
        instruction: "Iqro Jilid 1 Halaman 23",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "1_23_r1_1_0", arabic: "مَ", latin: "ma", audioTtsText: "مَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_23_r2_1_0", arabic: "غَ مَ ضَ", latin: "gho ma dho", audioTtsText: "غَ مَ ضَ"),
              IqroWordItem(id: "1_23_r2_2_1", arabic: "لَ مَ سَ", latin: "la ma sa", audioTtsText: "لَ مَ سَ"),
              IqroWordItem(id: "1_23_r2_3_2", arabic: "جَ مَ عَ", latin: "ja ma 'a", audioTtsText: "جَ مَ عَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_23_r3_1_0", arabic: "فَ رَ ضَ", latin: "fa ro dho", audioTtsText: "فَ رَ ضَ"),
              IqroWordItem(id: "1_23_r3_2_1", arabic: "كَ رَ مَ", latin: "ka ro ma", audioTtsText: "كَ رَ مَ"),
              IqroWordItem(id: "1_23_r3_3_2", arabic: "خَ لَ طَ", latin: "kho la tho", audioTtsText: "خَ لَ طَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_23_r4_1_0", arabic: "صَ مَ دَ", latin: "sho ma da", audioTtsText: "صَ مَ دَ"),
              IqroWordItem(id: "1_23_r4_2_1", arabic: "ظَ تَ ذَ", latin: "zho ta dza", audioTtsText: "ظَ تَ ذَ"),
              IqroWordItem(id: "1_23_r4_3_2", arabic: "مَ زَ قَ", latin: "ma za qo", audioTtsText: "مَ زَ قَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_23_r5_1_0", arabic: "شَ مَ لَ", latin: "sya ma la", audioTtsText: "شَ مَ لَ"),
              IqroWordItem(id: "1_23_r5_2_1", arabic: "فَ كَ حَ", latin: "fa ka ha", audioTtsText: "فَ كَ حَ"),
              IqroWordItem(id: "1_23_r5_3_2", arabic: "غَ مَ مَ", latin: "gho ma ma", audioTtsText: "غَ مَ مَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_23_r6_1_0", arabic: "اَ بَ تَ ثَ", latin: "a ba ta tsa", audioTtsText: "اَ بَ تَ ثَ"),
              IqroWordItem(id: "1_23_r6_2_1", arabic: "جَ حَ خَ", latin: "ja ha kho", audioTtsText: "جَ حَ خَ"),
              IqroWordItem(id: "1_23_r6_3_2", arabic: "دَ ذَ", latin: "da dza", audioTtsText: "دَ ذَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_23_r7_1_0", arabic: "رَ زَ سَ شَ صَ ضَ طَ ظَ", latin: "ro za sa sya sho dho tho zho", audioTtsText: "رَ زَ سَ شَ صَ ضَ طَ ظَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_23_r8_1_0", arabic: "عَ غَ فَ قَ كَ لَ مَ", latin: "'a gho fa qo ka la ma", audioTtsText: "عَ غَ فَ قَ كَ لَ مَ"),
            ],
          ),
        ],
      ),
      // Halaman 24: Huruf نَ (NA)
      const IqroPage(
        jilid: 1,
        pageNumber: 24,
        title: "Huruf نَ (NA)",
        instruction: "Iqro Jilid 1 Halaman 24",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "1_24_r1_1_0", arabic: "نَ", latin: "na", audioTtsText: "نَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_24_r2_1_0", arabic: "نَ ظَ فَ", latin: "na zho fa", audioTtsText: "نَ ظَ فَ"),
              IqroWordItem(id: "1_24_r2_2_1", arabic: "نَ غَ شَ", latin: "na gho sya", audioTtsText: "نَ غَ شَ"),
              IqroWordItem(id: "1_24_r2_3_2", arabic: "طَ عَ نَ", latin: "tho 'a na", audioTtsText: "طَ عَ نَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_24_r3_1_0", arabic: "صَ مَ ضَ", latin: "sho ma dho", audioTtsText: "صَ مَ ضَ"),
              IqroWordItem(id: "1_24_r3_2_1", arabic: "قَ رَ نَ", latin: "qo ro na", audioTtsText: "قَ رَ نَ"),
              IqroWordItem(id: "1_24_r3_3_2", arabic: "خَ لَ قَ", latin: "kho la qo", audioTtsText: "خَ لَ قَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_24_r4_1_0", arabic: "زَ مَ نَ", latin: "za ma na", audioTtsText: "زَ مَ نَ"),
              IqroWordItem(id: "1_24_r4_2_1", arabic: "كَ ذَ بَ", latin: "ka dza ba", audioTtsText: "كَ ذَ بَ"),
              IqroWordItem(id: "1_24_r4_3_2", arabic: "جَ نَ دَ", latin: "ja na da", audioTtsText: "جَ نَ دَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_24_r5_1_0", arabic: "كَ نَ سَ", latin: "ka na sa", audioTtsText: "كَ نَ سَ"),
              IqroWordItem(id: "1_24_r5_2_1", arabic: "لَ حَ ظَ", latin: "la ha zho", audioTtsText: "لَ حَ ظَ"),
              IqroWordItem(id: "1_24_r5_3_2", arabic: "مَ نَ نَ", latin: "ma na na", audioTtsText: "مَ نَ نَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_24_r6_1_0", arabic: "اَ بَ تَ ثَ", latin: "a ba ta tsa", audioTtsText: "اَ بَ تَ ثَ"),
              IqroWordItem(id: "1_24_r6_2_1", arabic: "جَ حَ خَ", latin: "ja ha kho", audioTtsText: "جَ حَ خَ"),
              IqroWordItem(id: "1_24_r6_3_2", arabic: "دَ ذَ", latin: "da dza", audioTtsText: "دَ ذَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_24_r7_1_0", arabic: "رَ زَ سَ شَ صَ ضَ طَ ظَ", latin: "ro za sa sya sho dho tho zho", audioTtsText: "رَ زَ سَ شَ صَ ضَ طَ ظَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_24_r8_1_0", arabic: "عَ غَ فَ قَ كَ لَ مَ نَ", latin: "'a gho fa qo ka la ma na", audioTtsText: "عَ غَ فَ قَ كَ لَ مَ نَ"),
            ],
          ),
        ],
      ),
      // Halaman 25: Huruf وَ (WA)
      const IqroPage(
        jilid: 1,
        pageNumber: 25,
        title: "Huruf وَ (WA)",
        instruction: "Iqro Jilid 1 Halaman 25",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "1_25_r1_1_0", arabic: "وَ", latin: "wa", audioTtsText: "وَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_25_r2_1_0", arabic: "وَ زَ رَ", latin: "wa za ro", audioTtsText: "وَ زَ رَ"),
              IqroWordItem(id: "1_25_r2_2_1", arabic: "وَ لَ غَ", latin: "wa la gho", audioTtsText: "وَ لَ غَ"),
              IqroWordItem(id: "1_25_r2_3_2", arabic: "دَ وَ مَ", latin: "da wa ma", audioTtsText: "دَ وَ مَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_25_r3_1_0", arabic: "فَ طَ نَ", latin: "fa tho na", audioTtsText: "فَ طَ نَ"),
              IqroWordItem(id: "1_25_r3_2_1", arabic: "قَ وَ مَ", latin: "qo wa ma", audioTtsText: "قَ وَ مَ"),
              IqroWordItem(id: "1_25_r3_3_2", arabic: "ظَ جَ عَ", latin: "zho ja 'a", audioTtsText: "ظَ جَ عَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_25_r4_1_0", arabic: "كَ وَ نَ", latin: "ka wa na", audioTtsText: "كَ وَ نَ"),
              IqroWordItem(id: "1_25_r4_2_1", arabic: "سَ كَ تَ", latin: "sa ka ta", audioTtsText: "سَ كَ تَ"),
              IqroWordItem(id: "1_25_r4_3_2", arabic: "خَ وَ صَ", latin: "kho wa sho", audioTtsText: "خَ وَ صَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_25_r5_1_0", arabic: "شَ وَ لَ", latin: "sya wa la", audioTtsText: "شَ وَ لَ"),
              IqroWordItem(id: "1_25_r5_2_1", arabic: "ذَ حَ ضَ", latin: "dza ha dho", audioTtsText: "ذَ حَ ضَ"),
              IqroWordItem(id: "1_25_r5_3_2", arabic: "وَ نَ وَ", latin: "wa na wa", audioTtsText: "وَ نَ وَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_25_r6_1_0", arabic: "اَ بَ تَ ثَ", latin: "a ba ta tsa", audioTtsText: "اَ بَ تَ ثَ"),
              IqroWordItem(id: "1_25_r6_2_1", arabic: "جَ حَ خَ", latin: "ja ha kho", audioTtsText: "جَ حَ خَ"),
              IqroWordItem(id: "1_25_r6_3_2", arabic: "دَ ذَ", latin: "da dza", audioTtsText: "دَ ذَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_25_r7_1_0", arabic: "رَ زَ سَ شَ صَ ضَ طَ ظَ", latin: "ro za sa sya sho dho tho zho", audioTtsText: "رَ زَ سَ شَ صَ ضَ طَ ظَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_25_r8_1_0", arabic: "عَ غَ فَ قَ كَ لَ مَ نَ وَ", latin: "'a gho fa qo ka la ma na wa", audioTtsText: "عَ غَ فَ قَ كَ لَ مَ نَ وَ"),
            ],
          ),
        ],
      ),
      // Halaman 26: Huruf هَ (HA)
      const IqroPage(
        jilid: 1,
        pageNumber: 26,
        title: "Huruf هَ (HA)",
        instruction: "Iqro Jilid 1 Halaman 26",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "1_26_r1_1_0", arabic: "هَ", latin: "ha", audioTtsText: "هَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_26_r2_1_0", arabic: "هَ مَ شَ", latin: "ha ma sya", audioTtsText: "هَ مَ شَ"),
              IqroWordItem(id: "1_26_r2_2_1", arabic: "جَ هَ دَ", latin: "ja ha da", audioTtsText: "جَ هَ دَ"),
              IqroWordItem(id: "1_26_r2_3_2", arabic: "دَ وَ مَ", latin: "da wa ma", audioTtsText: "دَ وَ مَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_26_r3_1_0", arabic: "فَ خَ عَ", latin: "fa kho 'a", audioTtsText: "فَ خَ عَ"),
              IqroWordItem(id: "1_26_r3_2_1", arabic: "طَ هَ رَ", latin: "tho ha ro", audioTtsText: "طَ هَ رَ"),
              IqroWordItem(id: "1_26_r3_3_2", arabic: "وَ ضَ حَ", latin: "wa dho ha", audioTtsText: "وَ ضَ حَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_26_r4_1_0", arabic: "وَ هَ ظَ", latin: "wa ha zho", audioTtsText: "وَ هَ ظَ"),
              IqroWordItem(id: "1_26_r4_2_1", arabic: "كَ مَ نَ", latin: "ka ma na", audioTtsText: "كَ مَ نَ"),
              IqroWordItem(id: "1_26_r4_3_2", arabic: "زَ هَ قَ", latin: "za ha qo", audioTtsText: "زَ هَ قَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_26_r5_1_0", arabic: "سَ هَ لَ", latin: "sa ha la", audioTtsText: "سَ هَ لَ"),
              IqroWordItem(id: "1_26_r5_2_1", arabic: "ذَ غَ صَ", latin: "dza gho sho", audioTtsText: "ذَ غَ صَ"),
              IqroWordItem(id: "1_26_r5_3_2", arabic: "جَ هَ هَ", latin: "ja ha ha", audioTtsText: "جَ هَ هَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_26_r6_1_0", arabic: "اَ بَ تَ ثَ", latin: "a ba ta tsa", audioTtsText: "اَ بَ تَ ثَ"),
              IqroWordItem(id: "1_26_r6_2_1", arabic: "جَ حَ خَ", latin: "ja ha kho", audioTtsText: "جَ حَ خَ"),
              IqroWordItem(id: "1_26_r6_3_2", arabic: "دَ ذَ", latin: "da dza", audioTtsText: "دَ ذَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_26_r7_1_0", arabic: "رَ زَ سَ شَ صَ ضَ طَ ظَ", latin: "ro za sa sya sho dho tho zho", audioTtsText: "رَ زَ سَ شَ صَ ضَ طَ ظَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_26_r8_1_0", arabic: "عَ غَ فَ قَ كَ لَ مَ نَ وَ هَ", latin: "'a gho fa qo ka la ma na wa ha", audioTtsText: "عَ غَ فَ قَ كَ لَ مَ نَ وَ هَ"),
            ],
          ),
        ],
      ),
      // Halaman 27: Huruf يَ (YA)
      const IqroPage(
        jilid: 1,
        pageNumber: 27,
        title: "Huruf يَ (YA)",
        instruction: "Iqro Jilid 1 Halaman 27",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "1_27_r1_1_0", arabic: "يَ", latin: "ya", audioTtsText: "يَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_27_r2_1_0", arabic: "ضَ يَ رَ", latin: "dho ya ro", audioTtsText: "ضَ يَ رَ"),
              IqroWordItem(id: "1_27_r2_2_1", arabic: "ضَ حَ يَ", latin: "dho ha ya", audioTtsText: "ضَ حَ يَ"),
              IqroWordItem(id: "1_27_r2_3_2", arabic: "زَ يَ نَ", latin: "za ya na", audioTtsText: "زَ يَ نَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_27_r3_1_0", arabic: "سَ يَ غَ", latin: "sa ya gho", audioTtsText: "سَ يَ غَ"),
              IqroWordItem(id: "1_27_r3_2_1", arabic: "وَ كَ لَ", latin: "wa ka la", audioTtsText: "وَ كَ لَ"),
              IqroWordItem(id: "1_27_r3_3_2", arabic: "هَ يَ خَ", latin: "ha ya kho", audioTtsText: "هَ يَ خَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_27_r4_1_0", arabic: "طَ هَ ظَ", latin: "tho ha zho", audioTtsText: "طَ هَ ظَ"),
              IqroWordItem(id: "1_27_r4_2_1", arabic: "شَ يَ عَ", latin: "sya ya 'a", audioTtsText: "شَ يَ عَ"),
              IqroWordItem(id: "1_27_r4_3_2", arabic: "وَ قَ فَ", latin: "wa qo fa", audioTtsText: "وَ قَ فَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_27_r5_1_0", arabic: "هَ يَ مَ", latin: "ha ya ma", audioTtsText: "هَ يَ مَ"),
              IqroWordItem(id: "1_27_r5_2_1", arabic: "جَ ذَ ثَ", latin: "ja dza tsa", audioTtsText: "جَ ذَ ثَ"),
              IqroWordItem(id: "1_27_r5_3_2", arabic: "يَ دَ يَ", latin: "ya da ya", audioTtsText: "يَ دَ يَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_27_r6_1_0", arabic: "اَ بَ تَ ثَ", latin: "a ba ta tsa", audioTtsText: "اَ بَ تَ ثَ"),
              IqroWordItem(id: "1_27_r6_2_1", arabic: "جَ حَ خَ", latin: "ja ha kho", audioTtsText: "جَ حَ خَ"),
              IqroWordItem(id: "1_27_r6_3_2", arabic: "دَ ذَ رَ زَ", latin: "da dza ro za", audioTtsText: "دَ ذَ رَ زَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_27_r7_1_0", arabic: "سَ شَ صَ ضَ طَ ظَ عَ غَ", latin: "sa sya sho dho tho zho 'a gho", audioTtsText: "سَ شَ صَ ضَ طَ ظَ عَ غَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_27_r8_1_0", arabic: "فَ قَ كَ لَ مَ نَ وَ هَ يَ", latin: "fa qo ka la ma na wa ha ya", audioTtsText: "فَ قَ كَ لَ مَ نَ وَ هَ يَ"),
            ],
          ),
        ],
      ),
      // Halaman 28: Huruf اَ = أَ = ءَ (A = A = A)
      const IqroPage(
        jilid: 1,
        pageNumber: 28,
        title: "Huruf اَ = أَ = ءَ (A = A = A)",
        instruction: "Iqro Jilid 1 Halaman 28",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "1_28_r1_1_0", arabic: "اَ", latin: "a", audioTtsText: "اَ"),
              IqroWordItem(id: "1_28_r1_1_1", arabic: "أَ", latin: "a", audioTtsText: "أَ"),
              IqroWordItem(id: "1_28_r1_1_2", arabic: "ءَ", latin: "a", audioTtsText: "ءَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_28_r2_1_0", arabic: "رَ = رَ", latin: "ro = ro", audioTtsText: "رَ رَ"),
              IqroWordItem(id: "1_28_r2_2_1", arabic: "مَ = مَ", latin: "ma = ma", audioTtsText: "مَ مَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_28_r3_1_0", arabic: "بَ رَ اَ", latin: "ba ro a", audioTtsText: "بَ رَ اَ"),
              IqroWordItem(id: "1_28_r3_2_1", arabic: "بَ رَ مَ", latin: "ba ro ma", audioTtsText: "بَ رَ مَ"),
              IqroWordItem(id: "1_28_r3_3_2", arabic: "قَ رَ اَ", latin: "qo ro a", audioTtsText: "قَ رَ اَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_28_r4_1_0", arabic: "اَ مَ مَ", latin: "a ma ma", audioTtsText: "اَ مَ مَ"),
              IqroWordItem(id: "1_28_r4_2_1", arabic: "جَ مَ رَ اَ", latin: "ja ma ro a", audioTtsText: "جَ مَ رَ اَ"),
              IqroWordItem(id: "1_28_r4_3_2", arabic: "سَ ءَ لَ", latin: "sa a la", audioTtsText: "سَ ءَ لَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_28_r5_1_0", arabic: "رَ نَ رَ قَ", latin: "ro na ro qo", audioTtsText: "رَ نَ رَ قَ"),
              IqroWordItem(id: "1_28_r5_2_1", arabic: "مَ دَ حَ", latin: "ma da ha", audioTtsText: "مَ دَ حَ"),
              IqroWordItem(id: "1_28_r5_3_2", arabic: "غَ مَ رَ مَ", latin: "gho ma ro ma", audioTtsText: "غَ مَ رَ مَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_28_r6_1_0", arabic: "لَ ءَ كَ", latin: "la a ka", audioTtsText: "لَ ءَ كَ"),
              IqroWordItem(id: "1_28_r6_2_1", arabic: "مَ رَ شَ ءَ", latin: "ma ro sya a", audioTtsText: "مَ رَ شَ ءَ"),
              IqroWordItem(id: "1_28_r6_3_2", arabic: "مَ دَ مَ", latin: "ma da ma", audioTtsText: "مَ دَ مَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_28_r7_1_0", arabic: "سَ يَ", latin: "sa ya", audioTtsText: "سَ يَ"),
              IqroWordItem(id: "1_28_r7_2_1", arabic: "جَ كَ", latin: "ja ka", audioTtsText: "جَ كَ"),
              IqroWordItem(id: "1_28_r7_3_2", arabic: "كَ يَ", latin: "ka ya", audioTtsText: "كَ يَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_28_r8_1_0", arabic: "قَ تَ", latin: "qo ta", audioTtsText: "قَ تَ"),
              IqroWordItem(id: "1_28_r8_2_1", arabic: "لَ مَ", latin: "la ma", audioTtsText: "لَ مَ"),
              IqroWordItem(id: "1_28_r8_3_2", arabic: "سَ نَ", latin: "sa na", audioTtsText: "سَ نَ"),
            ],
          ),
        ],
      ),
      // Halaman 29: Halaman 29
      const IqroPage(
        jilid: 1,
        pageNumber: 29,
        title: "Halaman 29",
        instruction: "Iqro Jilid 1 Halaman 29",
        rows: [
          IqroRow(
            type: IqroRowType.headerSample,
            items: [
              IqroWordItem(id: "1_29_r1_1_0", arabic: "ثَ", latin: "tsa", audioTtsText: "ثَ"),
              IqroWordItem(id: "1_29_r1_1_1", arabic: "بَ", latin: "ba", audioTtsText: "بَ"),
              IqroWordItem(id: "1_29_r1_1_2", arabic: "تَ", latin: "ta", audioTtsText: "تَ"),
              IqroWordItem(id: "1_29_r1_2_3", arabic: "جَ", latin: "ja", audioTtsText: "جَ"),
              IqroWordItem(id: "1_29_r1_2_4", arabic: "حَ", latin: "ha", audioTtsText: "حَ"),
              IqroWordItem(id: "1_29_r1_2_5", arabic: "خَ", latin: "kho", audioTtsText: "خَ"),
              IqroWordItem(id: "1_29_r1_3_6", arabic: "دَ", latin: "da", audioTtsText: "دَ"),
              IqroWordItem(id: "1_29_r1_3_7", arabic: "ذَ", latin: "dza", audioTtsText: "ذَ"),
              IqroWordItem(id: "1_29_r1_3_8", arabic: "رَ", latin: "ro", audioTtsText: "رَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_29_r2_1_0", arabic: "زَ سَ شَ", latin: "za sa sya", audioTtsText: "زَ سَ شَ"),
              IqroWordItem(id: "1_29_r2_2_1", arabic: "اَ صَ ظَ", latin: "a sho zho", audioTtsText: "اَ صَ ظَ"),
              IqroWordItem(id: "1_29_r2_3_2", arabic: "طَ ظَ عَ", latin: "tho zho 'a", audioTtsText: "طَ ظَ عَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_29_r3_1_0", arabic: "غَ فَ قَ", latin: "gho fa qo", audioTtsText: "غَ فَ قَ"),
              IqroWordItem(id: "1_29_r3_2_1", arabic: "كَ لَ مَ", latin: "ka la ma", audioTtsText: "كَ لَ مَ"),
              IqroWordItem(id: "1_29_r3_3_2", arabic: "نَ وَ هَ", latin: "na wa ha", audioTtsText: "نَ وَ هَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_29_r4_1_0", arabic: "حَ هَ لَ", latin: "ha ha la", audioTtsText: "حَ هَ لَ"),
              IqroWordItem(id: "1_29_r4_2_1", arabic: "بَ يَ نَ", latin: "ba ya na", audioTtsText: "بَ يَ نَ"),
              IqroWordItem(id: "1_29_r4_3_2", arabic: "ءَ اَ رَ", latin: "a a ro", audioTtsText: "ءَ اَ رَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_29_r5_1_0", arabic: "بَ عَ ثَ", latin: "ba 'a tsa", audioTtsText: "بَ عَ ثَ"),
              IqroWordItem(id: "1_29_r5_2_1", arabic: "جَ حَ خَ", latin: "ja ha kho", audioTtsText: "جَ حَ خَ"),
              IqroWordItem(id: "1_29_r5_3_2", arabic: "دَ ذَ رَ", latin: "da dza ro", audioTtsText: "دَ ذَ رَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_29_r6_1_0", arabic: "زَ سَ شَ", latin: "za sa sya", audioTtsText: "زَ سَ شَ"),
              IqroWordItem(id: "1_29_r6_2_1", arabic: "اَ صَ ضَ", latin: "a sho dho", audioTtsText: "اَ صَ ضَ"),
              IqroWordItem(id: "1_29_r6_3_2", arabic: "طَ ظَ عَ", latin: "tho zho 'a", audioTtsText: "طَ ظَ عَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_29_r7_1_0", arabic: "غَ فَ قَ", latin: "gho fa qo", audioTtsText: "غَ فَ قَ"),
              IqroWordItem(id: "1_29_r7_2_1", arabic: "كَ لَ مَ", latin: "ka la ma", audioTtsText: "كَ لَ مَ"),
              IqroWordItem(id: "1_29_r7_3_2", arabic: "نَ وَ هَ", latin: "na wa ha", audioTtsText: "نَ وَ هَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_29_r8_1_0", arabic: "هَ يَ تَ", latin: "ha ya ta", audioTtsText: "هَ يَ تَ"),
              IqroWordItem(id: "1_29_r8_2_1", arabic: "اَ كَ لَ", latin: "a ka la", audioTtsText: "اَ كَ لَ"),
              IqroWordItem(id: "1_29_r8_3_2", arabic: "مَ نَ وَ", latin: "ma na wa", audioTtsText: "مَ نَ وَ"),
            ],
          ),
        ],
      ),
      // Halaman 30: Halaman 30
      const IqroPage(
        jilid: 1,
        pageNumber: 30,
        title: "Halaman 30",
        instruction: "PENTING BEDAKAN DENGAN JELAS ANTARA",
        rows: [
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_30_r1_1_0", arabic: "اَ - عَ", latin: "a - 'a", audioTtsText: "اَ - عَ"),
              IqroWordItem(id: "1_30_r1_2_1", arabic: "ثَ - سَ", latin: "tsa - sa", audioTtsText: "ثَ - سَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_30_r2_1_0", arabic: "حَ - هَ", latin: "ha - ha", audioTtsText: "حَ - هَ"),
              IqroWordItem(id: "1_30_r2_2_1", arabic: "ثَ - شَ", latin: "tsa - sya", audioTtsText: "ثَ - شَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_30_r3_1_0", arabic: "جَ - زَ", latin: "ja - za", audioTtsText: "جَ - زَ"),
              IqroWordItem(id: "1_30_r3_2_1", arabic: "سَ - شَ", latin: "sa - sya", audioTtsText: "سَ - شَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_30_r4_1_0", arabic: "يَ - زَ", latin: "ya - za", audioTtsText: "يَ - زَ"),
              IqroWordItem(id: "1_30_r4_2_1", arabic: "سَ - صَ", latin: "sa - sho", audioTtsText: "سَ - صَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_30_r5_1_0", arabic: "خَ - غَ", latin: "kho - gho", audioTtsText: "خَ - غَ"),
              IqroWordItem(id: "1_30_r5_2_1", arabic: "تَ - طَ", latin: "ta - tho", audioTtsText: "تَ - طَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_30_r6_1_0", arabic: "خَ - قَ", latin: "kho - qo", audioTtsText: "خَ - قَ"),
              IqroWordItem(id: "1_30_r6_2_1", arabic: "ذَ - ظَ", latin: "dza - zho", audioTtsText: "ذَ - ظَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_30_r7_1_0", arabic: "غَ - قَ", latin: "gho - qo", audioTtsText: "غَ - قَ"),
              IqroWordItem(id: "1_30_r7_2_1", arabic: "ظَ - ضَ", latin: "zho - dho", audioTtsText: "ظَ - ضَ"),
            ],
          ),
        ],
      ),
      // Halaman 31: EBTA
      const IqroPage(
        jilid: 1,
        pageNumber: 31,
        title: "EBTA",
        instruction: "EBTA KHUSUS JILID 1 INI JIKA BELUM MENGUASAI ULANG-ULANGILAH ! BILA SUDAH LANCAR DAN BENAR BOLEH DINAIKKAN",
        rows: [
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_31_r1_1_0", arabic: "اَ بَ تَ ثَ جَ حَ خَ دَ ذَ رَ زَ", latin: "a ba ta tsa ja ha kho da dza ro za", audioTtsText: "اَ بَ تَ ثَ جَ حَ خَ دَ ذَ رَ زَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_31_r2_1_0", arabic: "سَ شَ صَ ضَ طَ ظَ عَ غَ", latin: "sa sya sho dho tho zho 'a gho", audioTtsText: "سَ شَ صَ ضَ طَ ظَ عَ غَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_31_r3_1_0", arabic: "فَ قَ كَ لَ مَ نَ وَ هَ ءَ يَ", latin: "fa qo ka la ma na wa ha a ya", audioTtsText: "فَ قَ كَ لَ مَ نَ وَ هَ ءَ يَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_31_r4_1_0", arabic: "يَ ءَ هَ وَ نَ مَ لَ كَ قَ فَ", latin: "ya a ha wa na ma la ka qo fa", audioTtsText: "يَ ءَ هَ وَ نَ مَ لَ كَ قَ فَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_31_r5_1_0", arabic: "غَ عَ ظَ طَ ضَ صَ شَ سَ", latin: "gho 'a zho tho dho sho sya sa", audioTtsText: "غَ عَ ظَ طَ ضَ صَ شَ سَ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_31_r6_1_0", arabic: "زَ رَ ذَ دَ خَ حَ جَ ثَ تَ بَ اَ", latin: "za ro dza da kho ha ja tsa ta ba a", audioTtsText: "زَ رَ ذَ دَ خَ حَ جَ ثَ تَ بَ اَ"),
            ],
          ),
        ],
      ),
      // Halaman 32: INDEKS - HURUF
      const IqroPage(
        jilid: 1,
        pageNumber: 32,
        title: "INDEKS - HURUF",
        instruction: "Ket. (Ba') (Ta') dst. adalah nama-nama huruf Halaman ini boleh digunakan, sekedar untuk membantu titian ingatan bacaan-bacaan yang khilaf. Bagi santri tidak ada halangan/boleh belajar mengenal sendiri nama-nama huruf hijaiyah, namun untuk huruf-huruf yang sulit, seperti ض / ظ / غ harus ditanyakan pada yang ahli.",
        rows: [
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_32_r1_1_0", arabic: "ق", latin: "qa (qaf)", audioTtsText: "ق"),
              IqroWordItem(id: "1_32_r1_2_1", arabic: "ز", latin: "za (zai)", audioTtsText: "ز"),
              IqroWordItem(id: "1_32_r1_3_2", arabic: "ا", latin: "alif", audioTtsText: "ا"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_32_r2_1_0", arabic: "ك", latin: "ka (kaf)", audioTtsText: "ك"),
              IqroWordItem(id: "1_32_r2_2_1", arabic: "س", latin: "sa (sin)", audioTtsText: "س"),
              IqroWordItem(id: "1_32_r2_3_2", arabic: "ب", latin: "ba (ba')", audioTtsText: "ب"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_32_r3_1_0", arabic: "ل", latin: "la (lam)", audioTtsText: "ل"),
              IqroWordItem(id: "1_32_r3_2_1", arabic: "ش", latin: "sya (syin)", audioTtsText: "ش"),
              IqroWordItem(id: "1_32_r3_3_2", arabic: "ت", latin: "ta (ta')", audioTtsText: "ت"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_32_r4_1_0", arabic: "م", latin: "ma (mim)", audioTtsText: "م"),
              IqroWordItem(id: "1_32_r4_2_1", arabic: "ص", latin: "ṣa (sad)", audioTtsText: "ص"),
              IqroWordItem(id: "1_32_r4_3_2", arabic: "ث", latin: "ṡa (sa')", audioTtsText: "ث"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_32_r5_1_0", arabic: "ن", latin: "na (nun)", audioTtsText: "ن"),
              IqroWordItem(id: "1_32_r5_2_1", arabic: "ض", latin: "ḍa (dad)", audioTtsText: "ض"),
              IqroWordItem(id: "1_32_r5_3_2", arabic: "ج", latin: "ja (jim)", audioTtsText: "ج"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_32_r6_1_0", arabic: "و", latin: "wa (wau)", audioTtsText: "و"),
              IqroWordItem(id: "1_32_r6_2_1", arabic: "ط", latin: "ṭa (ta')", audioTtsText: "ط"),
              IqroWordItem(id: "1_32_r6_3_2", arabic: "ح", latin: "ḥa (ḥa)", audioTtsText: "ح"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_32_r7_1_0", arabic: "ه", latin: "ha (ha)", audioTtsText: "ه"),
              IqroWordItem(id: "1_32_r7_2_1", arabic: "ظ", latin: "ẓa (za')", audioTtsText: "ظ"),
              IqroWordItem(id: "1_32_r7_3_2", arabic: "خ", latin: "kha (kha)", audioTtsText: "خ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_32_r8_1_0", arabic: "أ = ء", latin: "a (hamzah)", audioTtsText: "أ ء"),
              IqroWordItem(id: "1_32_r8_2_1", arabic: "ع", latin: "'a ('ain)", audioTtsText: "ع"),
              IqroWordItem(id: "1_32_r8_3_2", arabic: "د", latin: "da (dal)", audioTtsText: "د"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_32_r9_1_0", arabic: "ي", latin: "ya (ya)", audioTtsText: "ي"),
              IqroWordItem(id: "1_32_r9_2_1", arabic: "غ", latin: "ga (gain)", audioTtsText: "غ"),
              IqroWordItem(id: "1_32_r9_3_2", arabic: "ذ", latin: "ḋa (ḋal)", audioTtsText: "ذ"),
            ],
          ),
          IqroRow(
            type: IqroRowType.practice,
            items: [
              IqroWordItem(id: "1_32_r10_2_0", arabic: "ف", latin: "fa (fa')", audioTtsText: "ف"),
              IqroWordItem(id: "1_32_r10_3_1", arabic: "ر", latin: "ra (ra')", audioTtsText: "ر"),
            ],
          ),
        ],
      ),
    ];
  }
}
