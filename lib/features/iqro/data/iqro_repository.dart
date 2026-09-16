import 'package:shared_preferences/shared_preferences.dart';
import '../domain/models/iqro_models.dart';
import 'source/iqro_jilid_1_data.dart';
import 'source/iqro_jilid_2_data.dart';
import 'source/iqro_jilid_3_data.dart';
import 'source/iqro_jilid_4_data.dart';
import 'source/iqro_jilid_5_data.dart';
import 'source/iqro_jilid_6_data.dart';

class IqroRepository {
  static const String _prefKeyLastJilid = 'iqro_last_jilid';
  static const String _prefKeyLastPage = 'iqro_last_page';

  static List<IqroLevel> getLevels() {
    return IqroLevel.allLevels;
  }

  static IqroLevel getLevel(int jilid) {
    return IqroLevel.allLevels.firstWhere(
      (l) => l.jilid == jilid,
      orElse: () => IqroLevel.allLevels.first,
    );
  }

  static List<IqroPage> getPagesForJilid(int jilid) {
    switch (jilid) {
      case 1:
        return IqroJilid1Data.getPages();
      case 2:
        return IqroJilid2Data.getPages();
      case 3:
        return IqroJilid3Data.getPages();
      case 4:
        return IqroJilid4Data.getPages();
      case 5:
        return IqroJilid5Data.getPages();
      case 6:
      default:
        return IqroJilid6Data.getPages();
    }
  }

  static Future<void> saveProgress(int jilid, int page) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKeyLastJilid, jilid);
    await prefs.setInt(_prefKeyLastPage, page);
  }

  static Future<({int jilid, int page})> getLastProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final jilid = prefs.getInt(_prefKeyLastJilid) ?? 1;
    final page = prefs.getInt(_prefKeyLastPage) ?? 1;
    return (jilid: jilid, page: page);
  }
}
