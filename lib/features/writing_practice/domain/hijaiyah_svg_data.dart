// Generated from vecteezy_set-of-arabic-alphabet-vector_8787321.svg
// Real, professional Hijaiyah calligraphy vector paths
import 'dart:ui';

class HijaiyahSvgData {

  /// Build normalized calligraphy path for the character scaled to fittedRect
  static Path? getCalligraphyPath(String char, Rect rect) {
    final clean = char.replaceAll(RegExp(r'[\u0640\s]'), '');
    final builder = _pathBuilders[char] ?? _pathBuilders[clean];
    if (builder == null) return null;
    return builder(rect);
  }

  static bool hasCalligraphy(String char) {
    final clean = char.replaceAll(RegExp(r'[\u0640\s]'), '');
    return _pathBuilders.containsKey(char) || _pathBuilders.containsKey(clean);
  }

  static final Map<String, Path Function(Rect rect)> _pathBuilders = {
    'ا': (Rect r) {
      final p = Path();
      final l = r.left, t = r.top, w = r.width, h = r.height;
      p.moveTo(l + 0.4345 * w, t + 0.1562 * h);
      p.cubicTo(l + 0.463 * w, t + 0.3155 * h, l + 0.477 * w, t + 0.4769 * h, l + 0.4784 * w, t + 0.6387 * h);
      p.cubicTo(l + 0.4794 * w, t + 0.7541 * h, l + 0.4771 * w, t + 0.8759 * h, l + 0.4461 * w, t + 0.9878 * h);
      p.cubicTo(l + 0.4427 * w, t + 1.0 * h, l + 0.4586 * w, t + 0.981 * h, l + 0.4567 * w, t + 0.9834 * h);
      p.cubicTo(l + 0.4681 * w, t + 0.9695 * h, l + 0.4778 * w, t + 0.954 * h, l + 0.4872 * w, t + 0.9388 * h);
      p.cubicTo(l + 0.5061 * w, t + 0.9081 * h, l + 0.5274 * w, t + 0.8747 * h, l + 0.5372 * w, t + 0.8396 * h);
      p.cubicTo(l + 0.5683 * w, t + 0.7273 * h, l + 0.5697 * w, t + 0.6062 * h, l + 0.5695 * w, t + 0.4905 * h);
      p.cubicTo(l + 0.5693 * w, t + 0.3263 * h, l + 0.5536 * w, t + 0.1616 * h, l + 0.5247 * w, t + 0.0 * h);
      p.cubicTo(l + 0.5255 * w, t + 0.0041 * h, l + 0.4763 * w, t + 0.0659 * h, l + 0.4718 * w, t + 0.0736 * h);
      p.cubicTo(l + 0.461 * w, t + 0.0923 * h, l + 0.4303 * w, t + 0.1327 * h, l + 0.4345 * w, t + 0.1562 * h);
      p.lineTo(l + 0.4345 * w, t + 0.1562 * h);
      return p;
    },
    'ب': (Rect r) {
      final p = Path();
      final l = r.left, t = r.top, w = r.width, h = r.height;
      p.moveTo(l + 0.1918 * w, t + 0.1009 * h);
      p.cubicTo(l + 0.1544 * w, t + 0.1203 * h, l + 0.1265 * w, t + 0.1557 * h, l + 0.1039 * w, t + 0.1902 * h);
      p.cubicTo(l + 0.0636 * w, t + 0.2516 * h, l + 0.0 * w, t + 0.3391 * h, l + 0.0128 * w, t + 0.4181 * h);
      p.cubicTo(l + 0.0457 * w, t + 0.6215 * h, l + 0.2974 * w, t + 0.6578 * h, l + 0.465 * w, t + 0.6471 * h);
      p.cubicTo(l + 0.6417 * w, t + 0.6359 * h, l + 0.8223 * w, t + 0.577 * h, l + 0.918 * w, t + 0.4212 * h);
      p.cubicTo(l + 0.9551 * w, t + 0.3608 * h, l + 1.0 * w, t + 0.2923 * h, l + 0.9923 * w, t + 0.2185 * h);
      p.cubicTo(l + 0.9865 * w, t + 0.1632 * h, l + 0.9429 * w, t + 0.1124 * h, l + 0.898 * w, t + 0.0824 * h);
      p.cubicTo(l + 0.8892 * w, t + 0.0765 * h, l + 0.7853 * w, t + 0.2403 * h, l + 0.8008 * w, t + 0.2507 * h);
      p.cubicTo(l + 0.8257 * w, t + 0.2674 * h, l + 0.8464 * w, t + 0.2893 * h, l + 0.8644 * w, t + 0.313 * h);
      p.cubicTo(l + 0.8825 * w, t + 0.3367 * h, l + 0.8927 * w, t + 0.365 * h, l + 0.8958 * w, t + 0.3945 * h);
      p.cubicTo(l + 0.8969 * w, t + 0.4052 * h, l + 0.8951 * w, t + 0.4163 * h, l + 0.8932 * w, t + 0.4268 * h);
      p.cubicTo(l + 0.8845 * w, t + 0.4764 * h, l + 0.9797 * w, t + 0.3071 * h, l + 0.9337 * w, t + 0.3512 * h);
      p.cubicTo(l + 0.8368 * w, t + 0.4442 * h, l + 0.67 * w, t + 0.472 * h, l + 0.5418 * w, t + 0.4801 * h);
      p.cubicTo(l + 0.4193 * w, t + 0.4879 * h, l + 0.2835 * w, t + 0.4661 * h, l + 0.1863 * w, t + 0.3865 * h);
      p.cubicTo(l + 0.139 * w, t + 0.3478 * h, l + 0.1077 * w, t + 0.2864 * h, l + 0.1101 * w, t + 0.225 * h);
      p.cubicTo(l + 0.1182 * w, t + 0.1801 * h, l + 0.1022 * w, t + 0.2037 * h, l + 0.0622 * w, t + 0.2957 * h);
      p.cubicTo(l + 0.0682 * w, t + 0.2896 * h, l + 0.0751 * w, t + 0.2843 * h, l + 0.0819 * w, t + 0.279 * h);
      p.cubicTo(l + 0.0883 * w, t + 0.274 * h, l + 0.0953 * w, t + 0.2695 * h, l + 0.1025 * w, t + 0.2658 * h);
      p.cubicTo(l + 0.1305 * w, t + 0.2513 * h, l + 0.1542 * w, t + 0.1915 * h, l + 0.1682 * w, t + 0.1656 * h);
      p.cubicTo(l + 0.1713 * w, t + 0.1599 * h, l + 0.2018 * w, t + 0.0957 * h, l + 0.1918 * w, t + 0.1009 * h);
      p.lineTo(l + 0.1918 * w, t + 0.1009 * h);
      p.moveTo(l + 0.4869 * w, t + 0.9132 * h);
      p.cubicTo(l + 0.4766 * w, t + 0.9235 * h, l + 0.4601 * w, t + 0.9235 * h, l + 0.4498 * w, t + 0.9132 * h);
      p.lineTo(l + 0.3865 * w, t + 0.8499 * h);
      p.cubicTo(l + 0.3762 * w, t + 0.8397 * h, l + 0.3762 * w, t + 0.8231 * h, l + 0.3865 * w, t + 0.8128 * h);
      p.lineTo(l + 0.4498 * w, t + 0.7495 * h);
      p.cubicTo(l + 0.4601 * w, t + 0.7392 * h, l + 0.4766 * w, t + 0.7392 * h, l + 0.4869 * w, t + 0.7495 * h);
      p.lineTo(l + 0.5502 * w, t + 0.8128 * h);
      p.cubicTo(l + 0.5605 * w, t + 0.8231 * h, l + 0.5605 * w, t + 0.8397 * h, l + 0.5502 * w, t + 0.8499 * h);
      p.lineTo(l + 0.4869 * w, t + 0.9132 * h);
      return p;
    },
    'ت': (Rect r) {
      final p = Path();
      final l = r.left, t = r.top, w = r.width, h = r.height;
      p.moveTo(l + 0.1918 * w, t + 0.2374 * h);
      p.cubicTo(l + 0.1544 * w, t + 0.2568 * h, l + 0.1265 * w, t + 0.2922 * h, l + 0.1039 * w, t + 0.3267 * h);
      p.cubicTo(l + 0.0637 * w, t + 0.388 * h, l + 0.0 * w, t + 0.4756 * h, l + 0.0128 * w, t + 0.5546 * h);
      p.cubicTo(l + 0.0457 * w, t + 0.758 * h, l + 0.2974 * w, t + 0.7942 * h, l + 0.465 * w, t + 0.7836 * h);
      p.cubicTo(l + 0.6417 * w, t + 0.7724 * h, l + 0.8223 * w, t + 0.7135 * h, l + 0.9181 * w, t + 0.5576 * h);
      p.cubicTo(l + 0.9551 * w, t + 0.4973 * h, l + 1.0 * w, t + 0.4288 * h, l + 0.9923 * w, t + 0.355 * h);
      p.cubicTo(l + 0.9865 * w, t + 0.2997 * h, l + 0.9428 * w, t + 0.2489 * h, l + 0.898 * w, t + 0.2189 * h);
      p.cubicTo(l + 0.8892 * w, t + 0.2131 * h, l + 0.7853 * w, t + 0.3768 * h, l + 0.8008 * w, t + 0.3872 * h);
      p.cubicTo(l + 0.8257 * w, t + 0.4039 * h, l + 0.8464 * w, t + 0.4258 * h, l + 0.8644 * w, t + 0.4495 * h);
      p.cubicTo(l + 0.8824 * w, t + 0.4732 * h, l + 0.8927 * w, t + 0.5015 * h, l + 0.8958 * w, t + 0.531 * h);
      p.cubicTo(l + 0.8969 * w, t + 0.5417 * h, l + 0.8951 * w, t + 0.5527 * h, l + 0.8932 * w, t + 0.5633 * h);
      p.cubicTo(l + 0.8845 * w, t + 0.6129 * h, l + 0.9797 * w, t + 0.4436 * h, l + 0.9337 * w, t + 0.4877 * h);
      p.cubicTo(l + 0.8368 * w, t + 0.5807 * h, l + 0.67 * w, t + 0.6084 * h, l + 0.5418 * w, t + 0.6166 * h);
      p.cubicTo(l + 0.4193 * w, t + 0.6244 * h, l + 0.2835 * w, t + 0.6026 * h, l + 0.1863 * w, t + 0.523 * h);
      p.cubicTo(l + 0.139 * w, t + 0.4843 * h, l + 0.1076 * w, t + 0.4229 * h, l + 0.1101 * w, t + 0.3615 * h);
      p.cubicTo(l + 0.1182 * w, t + 0.3166 * h, l + 0.1022 * w, t + 0.3402 * h, l + 0.0623 * w, t + 0.4322 * h);
      p.cubicTo(l + 0.0683 * w, t + 0.4261 * h, l + 0.0751 * w, t + 0.4208 * h, l + 0.0819 * w, t + 0.4155 * h);
      p.cubicTo(l + 0.0883 * w, t + 0.4105 * h, l + 0.0953 * w, t + 0.406 * h, l + 0.1026 * w, t + 0.4023 * h);
      p.cubicTo(l + 0.1305 * w, t + 0.3878 * h, l + 0.1542 * w, t + 0.328 * h, l + 0.1682 * w, t + 0.3021 * h);
      p.cubicTo(l + 0.1713 * w, t + 0.2964 * h, l + 0.2018 * w, t + 0.2322 * h, l + 0.1918 * w, t + 0.2374 * h);
      p.lineTo(l + 0.1918 * w, t + 0.2374 * h);
      p.moveTo(l + 0.4224 * w, t + 0.3747 * h);
      p.cubicTo(l + 0.4136 * w, t + 0.3835 * h, l + 0.3993 * w, t + 0.3835 * h, l + 0.3904 * w, t + 0.3747 * h);
      p.lineTo(l + 0.3357 * w, t + 0.32 * h);
      p.cubicTo(l + 0.3269 * w, t + 0.3112 * h, l + 0.3269 * w, t + 0.2968 * h, l + 0.3357 * w, t + 0.288 * h);
      p.lineTo(l + 0.3904 * w, t + 0.2333 * h);
      p.cubicTo(l + 0.3993 * w, t + 0.2244 * h, l + 0.4136 * w, t + 0.2244 * h, l + 0.4224 * w, t + 0.2333 * h);
      p.lineTo(l + 0.4772 * w, t + 0.288 * h);
      p.cubicTo(l + 0.486 * w, t + 0.2968 * h, l + 0.486 * w, t + 0.3112 * h, l + 0.4771 * w, t + 0.32 * h);
      p.lineTo(l + 0.4224 * w, t + 0.3747 * h);
      p.moveTo(l + 0.6314 * w, t + 0.3561 * h);
      p.cubicTo(l + 0.6225 * w, t + 0.3649 * h, l + 0.6081 * w, t + 0.3649 * h, l + 0.5993 * w, t + 0.3561 * h);
      p.lineTo(l + 0.5446 * w, t + 0.3013 * h);
      p.cubicTo(l + 0.5358 * w, t + 0.2925 * h, l + 0.5358 * w, t + 0.2782 * h, l + 0.5446 * w, t + 0.2693 * h);
      p.lineTo(l + 0.5993 * w, t + 0.2146 * h);
      p.cubicTo(l + 0.6081 * w, t + 0.2058 * h, l + 0.6225 * w, t + 0.2058 * h, l + 0.6314 * w, t + 0.2146 * h);
      p.lineTo(l + 0.686 * w, t + 0.2693 * h);
      p.cubicTo(l + 0.6949 * w, t + 0.2782 * h, l + 0.6949 * w, t + 0.2925 * h, l + 0.686 * w, t + 0.3013 * h);
      p.lineTo(l + 0.6314 * w, t + 0.3561 * h);
      return p;
    },
    'ث': (Rect r) {
      final p = Path();
      final l = r.left, t = r.top, w = r.width, h = r.height;
      p.moveTo(l + 0.1918 * w, t + 0.312 * h);
      p.cubicTo(l + 0.1544 * w, t + 0.3314 * h, l + 0.1265 * w, t + 0.3668 * h, l + 0.1039 * w, t + 0.4013 * h);
      p.cubicTo(l + 0.0637 * w, t + 0.4627 * h, l + 0.0 * w, t + 0.5502 * h, l + 0.0128 * w, t + 0.6292 * h);
      p.cubicTo(l + 0.0457 * w, t + 0.8326 * h, l + 0.2974 * w, t + 0.8689 * h, l + 0.465 * w, t + 0.8582 * h);
      p.cubicTo(l + 0.6417 * w, t + 0.8471 * h, l + 0.8223 * w, t + 0.7881 * h, l + 0.9181 * w, t + 0.6323 * h);
      p.cubicTo(l + 0.9552 * w, t + 0.572 * h, l + 1.0 * w, t + 0.5034 * h, l + 0.9923 * w, t + 0.4296 * h);
      p.cubicTo(l + 0.9866 * w, t + 0.3743 * h, l + 0.9429 * w, t + 0.3235 * h, l + 0.898 * w, t + 0.2935 * h);
      p.cubicTo(l + 0.8893 * w, t + 0.2876 * h, l + 0.7853 * w, t + 0.4514 * h, l + 0.8008 * w, t + 0.4618 * h);
      p.cubicTo(l + 0.8257 * w, t + 0.4785 * h, l + 0.8464 * w, t + 0.5004 * h, l + 0.8645 * w, t + 0.5241 * h);
      p.cubicTo(l + 0.8825 * w, t + 0.5478 * h, l + 0.8927 * w, t + 0.5761 * h, l + 0.8958 * w, t + 0.6056 * h);
      p.cubicTo(l + 0.8969 * w, t + 0.6163 * h, l + 0.8951 * w, t + 0.6274 * h, l + 0.8932 * w, t + 0.6379 * h);
      p.cubicTo(l + 0.8845 * w, t + 0.6875 * h, l + 0.9798 * w, t + 0.5182 * h, l + 0.9338 * w, t + 0.5623 * h);
      p.cubicTo(l + 0.8369 * w, t + 0.6553 * h, l + 0.67 * w, t + 0.6831 * h, l + 0.5418 * w, t + 0.6912 * h);
      p.cubicTo(l + 0.4193 * w, t + 0.699 * h, l + 0.2835 * w, t + 0.6772 * h, l + 0.1863 * w, t + 0.5976 * h);
      p.cubicTo(l + 0.139 * w, t + 0.5589 * h, l + 0.1077 * w, t + 0.4975 * h, l + 0.1101 * w, t + 0.4362 * h);
      p.cubicTo(l + 0.1182 * w, t + 0.3912 * h, l + 0.1022 * w, t + 0.4148 * h, l + 0.0623 * w, t + 0.5068 * h);
      p.cubicTo(l + 0.0683 * w, t + 0.5007 * h, l + 0.0751 * w, t + 0.4954 * h, l + 0.0819 * w, t + 0.4901 * h);
      p.cubicTo(l + 0.0883 * w, t + 0.4851 * h, l + 0.0953 * w, t + 0.4806 * h, l + 0.1026 * w, t + 0.4769 * h);
      p.cubicTo(l + 0.1305 * w, t + 0.4624 * h, l + 0.1542 * w, t + 0.4026 * h, l + 0.1682 * w, t + 0.3767 * h);
      p.cubicTo(l + 0.1713 * w, t + 0.371 * h, l + 0.2018 * w, t + 0.3068 * h, l + 0.1918 * w, t + 0.312 * h);
      p.lineTo(l + 0.1918 * w, t + 0.312 * h);
      p.moveTo(l + 0.4262 * w, t + 0.4269 * h);
      p.cubicTo(l + 0.4173 * w, t + 0.4358 * h, l + 0.403 * w, t + 0.4358 * h, l + 0.3941 * w, t + 0.4269 * h);
      p.lineTo(l + 0.3394 * w, t + 0.3722 * h);
      p.cubicTo(l + 0.3306 * w, t + 0.3634 * h, l + 0.3306 * w, t + 0.349 * h, l + 0.3394 * w, t + 0.3402 * h);
      p.lineTo(l + 0.3941 * w, t + 0.2855 * h);
      p.cubicTo(l + 0.403 * w, t + 0.2766 * h, l + 0.4173 * w, t + 0.2766 * h, l + 0.4262 * w, t + 0.2855 * h);
      p.lineTo(l + 0.4809 * w, t + 0.3402 * h);
      p.cubicTo(l + 0.4897 * w, t + 0.349 * h, l + 0.4897 * w, t + 0.3634 * h, l + 0.4809 * w, t + 0.3722 * h);
      p.lineTo(l + 0.4262 * w, t + 0.4269 * h);
      p.moveTo(l + 0.6351 * w, t + 0.4083 * h);
      p.cubicTo(l + 0.6262 * w, t + 0.4171 * h, l + 0.6119 * w, t + 0.4171 * h, l + 0.6031 * w, t + 0.4083 * h);
      p.lineTo(l + 0.5484 * w, t + 0.3536 * h);
      p.cubicTo(l + 0.5395 * w, t + 0.3447 * h, l + 0.5395 * w, t + 0.3304 * h, l + 0.5484 * w, t + 0.3215 * h);
      p.lineTo(l + 0.6031 * w, t + 0.2668 * h);
      p.cubicTo(l + 0.6119 * w, t + 0.258 * h, l + 0.6262 * w, t + 0.258 * h, l + 0.6351 * w, t + 0.2668 * h);
      p.lineTo(l + 0.6898 * w, t + 0.3215 * h);
      p.cubicTo(l + 0.6986 * w, t + 0.3304 * h, l + 0.6986 * w, t + 0.3447 * h, l + 0.6898 * w, t + 0.3536 * h);
      p.lineTo(l + 0.6351 * w, t + 0.4083 * h);
      p.moveTo(l + 0.5269 * w, t + 0.2814 * h);
      p.cubicTo(l + 0.5181 * w, t + 0.2903 * h, l + 0.5037 * w, t + 0.2903 * h, l + 0.4949 * w, t + 0.2814 * h);
      p.lineTo(l + 0.4402 * w, t + 0.2267 * h);
      p.cubicTo(l + 0.4313 * w, t + 0.2179 * h, l + 0.4313 * w, t + 0.2035 * h, l + 0.4402 * w, t + 0.1947 * h);
      p.lineTo(l + 0.4949 * w, t + 0.14 * h);
      p.cubicTo(l + 0.5037 * w, t + 0.1311 * h, l + 0.5181 * w, t + 0.1311 * h, l + 0.5269 * w, t + 0.14 * h);
      p.lineTo(l + 0.5816 * w, t + 0.1947 * h);
      p.cubicTo(l + 0.5905 * w, t + 0.2035 * h, l + 0.5905 * w, t + 0.2179 * h, l + 0.5816 * w, t + 0.2267 * h);
      p.lineTo(l + 0.5269 * w, t + 0.2814 * h);
      return p;
    },
    'ج': (Rect r) {
      final p = Path();
      final l = r.left, t = r.top, w = r.width, h = r.height;

      // Badan Jim (alis + perut kaligrafi presisi)
      p.moveTo(l + 0.2449 * w, t + 0.2805 * h);
      p.cubicTo(l + 0.3832 * w, t + 0.2430 * h, l + 0.5346 * w, t + 0.2414 * h, l + 0.6770 * w, t + 0.2512 * h);
      p.cubicTo(l + 0.7036 * w, t + 0.2050 * h, l + 0.7303 * w, t + 0.1588 * h, l + 0.7570 * w, t + 0.1126 * h);
      p.cubicTo(l + 0.5891 * w, t + 0.1465 * h, l + 0.4455 * w, t + 0.2421 * h, l + 0.3560 * w, t + 0.3880 * h);
      p.cubicTo(l + 0.2891 * w, t + 0.4969 * h, l + 0.2304 * w, t + 0.6329 * h, l + 0.3118 * w, t + 0.7508 * h);
      p.cubicTo(l + 0.4025 * w, t + 0.8820 * h, l + 0.5896 * w, t + 0.8392 * h, l + 0.6882 * w, t + 0.7485 * h);
      p.cubicTo(l + 0.7115 * w, t + 0.7271 * h, l + 0.7275 * w, t + 0.6933 * h, l + 0.7423 * w, t + 0.6660 * h);
      p.cubicTo(l + 0.7498 * w, t + 0.6521 * h, l + 0.7575 * w, t + 0.6377 * h, l + 0.7630 * w, t + 0.6228 * h);
      p.cubicTo(l + 0.7624 * w, t + 0.6244 * h, l + 0.7696 * w, t + 0.6054 * h, l + 0.7617 * w, t + 0.6127 * h);
      p.cubicTo(l + 0.6693 * w, t + 0.6978 * h, l + 0.5565 * w, t + 0.7204 * h, l + 0.4449 * w, t + 0.6593 * h);
      p.cubicTo(l + 0.3977 * w, t + 0.6335 * h, l + 0.3703 * w, t + 0.5862 * h, l + 0.3572 * w, t + 0.5356 * h);
      p.cubicTo(l + 0.3501 * w, t + 0.5083 * h, l + 0.3513 * w, t + 0.4798 * h, l + 0.3543 * w, t + 0.4521 * h);
      p.cubicTo(l + 0.3560 * w, t + 0.4368 * h, l + 0.3601 * w, t + 0.4216 * h, l + 0.3648 * w, t + 0.4069 * h);
      p.cubicTo(l + 0.3789 * w, t + 0.3633 * h, l + 0.3260 * w, t + 0.4598 * h, l + 0.3549 * w, t + 0.4246 * h);
      p.cubicTo(l + 0.4307 * w, t + 0.3325 * h, l + 0.5618 * w, t + 0.2745 * h, l + 0.6770 * w, t + 0.2512 * h);
      p.cubicTo(l + 0.6953 * w, t + 0.2475 * h, l + 0.7159 * w, t + 0.1997 * h, l + 0.7239 * w, t + 0.1859 * h);
      p.cubicTo(l + 0.7259 * w, t + 0.1823 * h, l + 0.7608 * w, t + 0.1128 * h, l + 0.7570 * w, t + 0.1126 * h);
      p.cubicTo(l + 0.6146 * w, t + 0.1028 * h, l + 0.4632 * w, t + 0.1044 * h, l + 0.3249 * w, t + 0.1419 * h);
      p.cubicTo(l + 0.3058 * w, t + 0.1471 * h, l + 0.2867 * w, t + 0.1922 * h, l + 0.2780 * w, t + 0.2072 * h);
      p.cubicTo(l + 0.2747 * w, t + 0.2129 * h, l + 0.2468 * w, t + 0.2800 * h, l + 0.2449 * w, t + 0.2805 * h);
      p.lineTo(l + 0.2449 * w, t + 0.2805 * h);

      // Titik Jim di tengah perut (berpusat di 0.52, 0.52)
      p.moveTo(l + 0.5354 * w, t + 0.5872 * h);
      p.cubicTo(l + 0.5270 * w, t + 0.5957 * h, l + 0.5133 * w, t + 0.5957 * h, l + 0.5049 * w, t + 0.5873 * h);
      p.lineTo(l + 0.4528 * w, t + 0.5351 * h);
      p.cubicTo(l + 0.4443 * w, t + 0.5267 * h, l + 0.4443 * w, t + 0.5130 * h, l + 0.4528 * w, t + 0.5046 * h);
      p.lineTo(l + 0.5049 * w, t + 0.4524 * h);
      p.cubicTo(l + 0.5133 * w, t + 0.4440 * h, l + 0.5270 * w, t + 0.4440 * h, l + 0.5354 * w, t + 0.4524 * h);
      p.lineTo(l + 0.5876 * w, t + 0.5046 * h);
      p.cubicTo(l + 0.5960 * w, t + 0.5130 * h, l + 0.5960 * w, t + 0.5267 * h, l + 0.5876 * w, t + 0.5351 * h);
      p.lineTo(l + 0.5354 * w, t + 0.5872 * h);

      return p;
    },

    'ح': (Rect r) {
      final p = Path();
      final l = r.left, t = r.top, w = r.width, h = r.height;
      p.moveTo(l + 0.1726 * w, t + 0.2281 * h);
      p.cubicTo(l + 0.3501 * w, t + 0.1799 * h, l + 0.5444 * w, t + 0.1779 * h, l + 0.7271 * w, t + 0.1904 * h);
      p.cubicTo(l + 0.7613 * w, t + 0.1311 * h, l + 0.7955 * w, t + 0.0718 * h, l + 0.8298 * w, t + 0.0126 * h);
      p.cubicTo(l + 0.6143 * w, t + 0.0561 * h, l + 0.43 * w, t + 0.1788 * h, l + 0.3151 * w, t + 0.366 * h);
      p.cubicTo(l + 0.2293 * w, t + 0.5058 * h, l + 0.154 * w, t + 0.6803 * h, l + 0.2585 * w, t + 0.8316 * h);
      p.cubicTo(l + 0.3748 * w, t + 1.0 * h, l + 0.615 * w, t + 0.9451 * h, l + 0.7416 * w, t + 0.8286 * h);
      p.cubicTo(l + 0.7714 * w, t + 0.8012 * h, l + 0.7919 * w, t + 0.7579 * h, l + 0.8109 * w, t + 0.7228 * h);
      p.cubicTo(l + 0.8206 * w, t + 0.7049 * h, l + 0.8304 * w, t + 0.6865 * h, l + 0.8375 * w, t + 0.6673 * h);
      p.cubicTo(l + 0.8367 * w, t + 0.6694 * h, l + 0.846 * w, t + 0.645 * h, l + 0.8358 * w, t + 0.6544 * h);
      p.cubicTo(l + 0.7173 * w, t + 0.7635 * h, l + 0.5725 * w, t + 0.7926 * h, l + 0.4293 * w, t + 0.7142 * h);
      p.cubicTo(l + 0.3688 * w, t + 0.6811 * h, l + 0.3336 * w, t + 0.6203 * h, l + 0.3168 * w, t + 0.5554 * h);
      p.cubicTo(l + 0.3077 * w, t + 0.5204 * h, l + 0.3091 * w, t + 0.4838 * h, l + 0.313 * w, t + 0.4483 * h);
      p.cubicTo(l + 0.3151 * w, t + 0.4286 * h, l + 0.3204 * w, t + 0.4091 * h, l + 0.3264 * w, t + 0.3903 * h);
      p.cubicTo(l + 0.3445 * w, t + 0.3344 * h, l + 0.2766 * w, t + 0.4581 * h, l + 0.3138 * w, t + 0.413 * h);
      p.cubicTo(l + 0.411 * w, t + 0.2948 * h, l + 0.5793 * w, t + 0.2203 * h, l + 0.7271 * w, t + 0.1904 * h);
      p.cubicTo(l + 0.7506 * w, t + 0.1857 * h, l + 0.7771 * w, t + 0.1244 * h, l + 0.7873 * w, t + 0.1066 * h);
      p.cubicTo(l + 0.7899 * w, t + 0.1021 * h, l + 0.8346 * w, t + 0.0129 * h, l + 0.8298 * w, t + 0.0126 * h);
      p.cubicTo(l + 0.647 * w, t + 0.0 * h, l + 0.4528 * w, t + 0.0021 * h, l + 0.2753 * w, t + 0.0502 * h);
      p.cubicTo(l + 0.2507 * w, t + 0.0569 * h, l + 0.2262 * w, t + 0.1147 * h, l + 0.2151 * w, t + 0.134 * h);
      p.cubicTo(l + 0.2108 * w, t + 0.1413 * h, l + 0.1749 * w, t + 0.2274 * h, l + 0.1726 * w, t + 0.2281 * h);
      p.lineTo(l + 0.1726 * w, t + 0.2281 * h);
      return p;
    },
    'خ': (Rect r) {
      final p = Path();
      final l = r.left, t = r.top, w = r.width, h = r.height;
      p.moveTo(l + 0.2449 * w, t + 0.3985 * h);
      p.cubicTo(l + 0.3832 * w, t + 0.361 * h, l + 0.5346 * w, t + 0.3594 * h, l + 0.677 * w, t + 0.3692 * h);
      p.cubicTo(l + 0.7036 * w, t + 0.323 * h, l + 0.7303 * w, t + 0.2768 * h, l + 0.757 * w, t + 0.2306 * h);
      p.cubicTo(l + 0.5891 * w, t + 0.2645 * h, l + 0.4455 * w, t + 0.3601 * h, l + 0.356 * w, t + 0.506 * h);
      p.cubicTo(l + 0.2891 * w, t + 0.6149 * h, l + 0.2304 * w, t + 0.7509 * h, l + 0.3118 * w, t + 0.8688 * h);
      p.cubicTo(l + 0.4025 * w, t + 1.0 * h, l + 0.5896 * w, t + 0.9572 * h, l + 0.6882 * w, t + 0.8665 * h);
      p.cubicTo(l + 0.7115 * w, t + 0.8451 * h, l + 0.7275 * w, t + 0.8113 * h, l + 0.7423 * w, t + 0.784 * h);
      p.cubicTo(l + 0.7498 * w, t + 0.7701 * h, l + 0.7575 * w, t + 0.7557 * h, l + 0.763 * w, t + 0.7408 * h);
      p.cubicTo(l + 0.7624 * w, t + 0.7424 * h, l + 0.7696 * w, t + 0.7234 * h, l + 0.7617 * w, t + 0.7307 * h);
      p.cubicTo(l + 0.6693 * w, t + 0.8158 * h, l + 0.5565 * w, t + 0.8384 * h, l + 0.4449 * w, t + 0.7773 * h);
      p.cubicTo(l + 0.3977 * w, t + 0.7515 * h, l + 0.3703 * w, t + 0.7042 * h, l + 0.3572 * w, t + 0.6536 * h);
      p.cubicTo(l + 0.3501 * w, t + 0.6263 * h, l + 0.3513 * w, t + 0.5978 * h, l + 0.3543 * w, t + 0.5701 * h);
      p.cubicTo(l + 0.356 * w, t + 0.5548 * h, l + 0.3601 * w, t + 0.5396 * h, l + 0.3648 * w, t + 0.5249 * h);
      p.cubicTo(l + 0.3789 * w, t + 0.4813 * h, l + 0.326 * w, t + 0.5778 * h, l + 0.3549 * w, t + 0.5426 * h);
      p.cubicTo(l + 0.4307 * w, t + 0.4505 * h, l + 0.5618 * w, t + 0.3925 * h, l + 0.677 * w, t + 0.3692 * h);
      p.cubicTo(l + 0.6953 * w, t + 0.3655 * h, l + 0.7159 * w, t + 0.3177 * h, l + 0.7239 * w, t + 0.3039 * h);
      p.cubicTo(l + 0.7259 * w, t + 0.3003 * h, l + 0.7608 * w, t + 0.2308 * h, l + 0.757 * w, t + 0.2306 * h);
      p.cubicTo(l + 0.6146 * w, t + 0.2208 * h, l + 0.4632 * w, t + 0.2224 * h, l + 0.3249 * w, t + 0.2599 * h);
      p.cubicTo(l + 0.3058 * w, t + 0.2651 * h, l + 0.2867 * w, t + 0.3102 * h, l + 0.278 * w, t + 0.3252 * h);
      p.cubicTo(l + 0.2747 * w, t + 0.3309 * h, l + 0.2468 * w, t + 0.398 * h, l + 0.2449 * w, t + 0.3985 * h);
      p.lineTo(l + 0.2449 * w, t + 0.3985 * h);
      p.moveTo(l + 0.5314 * w, t + 0.1432 * h);
      p.cubicTo(l + 0.523 * w, t + 0.1517 * h, l + 0.5093 * w, t + 0.1517 * h, l + 0.5009 * w, t + 0.1433 * h);
      p.lineTo(l + 0.4488 * w, t + 0.0911 * h);
      p.cubicTo(l + 0.4403 * w, t + 0.0827 * h, l + 0.4403 * w, t + 0.069 * h, l + 0.4488 * w, t + 0.0606 * h);
      p.lineTo(l + 0.5009 * w, t + 0.0084 * h);
      p.cubicTo(l + 0.5093 * w, t + 0.0 * h, l + 0.523 * w, t + 0.0 * h, l + 0.5314 * w, t + 0.0084 * h);
      p.lineTo(l + 0.5836 * w, t + 0.0606 * h);
      p.cubicTo(l + 0.592 * w, t + 0.069 * h, l + 0.592 * w, t + 0.0827 * h, l + 0.5836 * w, t + 0.0911 * h);
      p.lineTo(l + 0.5314 * w, t + 0.1432 * h);
      return p;
    },
    'د': (Rect r) {
      final p = Path();
      final l = r.left, t = r.top, w = r.width, h = r.height;
      p.moveTo(l + 0.4782 * w, t + 0.2119 * h);
      p.cubicTo(l + 0.5891 * w, t + 0.3728 * h, l + 0.7003 * w, t + 0.5564 * h, l + 0.7437 * w, t + 0.7485 * h);
      p.cubicTo(l + 0.7495 * w, t + 0.7744 * h, l + 0.7521 * w, t + 0.8007 * h, l + 0.7517 * w, t + 0.8274 * h);
      p.cubicTo(l + 0.7515 * w, t + 0.8378 * h, l + 0.7498 * w, t + 0.8482 * h, l + 0.7479 * w, t + 0.8585 * h);
      p.cubicTo(l + 0.735 * w, t + 0.9302 * h, l + 0.8811 * w, t + 0.6821 * h, l + 0.819 * w, t + 0.7284 * h);
      p.cubicTo(l + 0.755 * w, t + 0.7761 * h, l + 0.6523 * w, t + 0.7804 * h, l + 0.5759 * w, t + 0.7833 * h);
      p.cubicTo(l + 0.4597 * w, t + 0.7876 * h, l + 0.3392 * w, t + 0.7732 * h, l + 0.2259 * w, t + 0.7473 * h);
      p.cubicTo(l + 0.1874 * w, t + 0.7385 * h, l + 0.1114 * w, t + 0.9555 * h, l + 0.1064 * w, t + 0.9543 * h);
      p.cubicTo(l + 0.2458 * w, t + 0.9862 * h, l + 0.3941 * w, t + 1.0 * h, l + 0.5363 * w, t + 0.9846 * h);
      p.cubicTo(l + 0.6077 * w, t + 0.9769 * h, l + 0.6884 * w, t + 0.9582 * h, l + 0.7384 * w, t + 0.9035 * h);
      p.cubicTo(l + 0.7969 * w, t + 0.8396 * h, l + 0.8549 * w, t + 0.7383 * h, l + 0.8705 * w, t + 0.6521 * h);
      p.cubicTo(l + 0.8936 * w, t + 0.5235 * h, l + 0.809 * w, t + 0.372 * h, l + 0.7524 * w, t + 0.2628 * h);
      p.cubicTo(l + 0.7063 * w, t + 0.1741 * h, l + 0.6545 * w, t + 0.0873 * h, l + 0.5977 * w, t + 0.0049 * h);
      p.cubicTo(l + 0.5944 * w, t + 0.0 * h, l + 0.5307 * w, t + 0.0972 * h, l + 0.5276 * w, t + 0.1024 * h);
      p.cubicTo(l + 0.5196 * w, t + 0.1164 * h, l + 0.4659 * w, t + 0.194 * h, l + 0.4782 * w, t + 0.2119 * h);
      p.lineTo(l + 0.4782 * w, t + 0.2119 * h);
      return p;
    },
    'ذ': (Rect r) {
      final p = Path();
      final l = r.left, t = r.top, w = r.width, h = r.height;
      p.moveTo(l + 0.47 * w, t + 0.4026 * h);
      p.cubicTo(l + 0.5528 * w, t + 0.5229 * h, l + 0.6338 * w, t + 0.6584 * h, l + 0.6693 * w, t + 0.801 * h);
      p.cubicTo(l + 0.6745 * w, t + 0.8217 * h, l + 0.677 * w, t + 0.8427 * h, l + 0.6771 * w, t + 0.864 * h);
      p.cubicTo(l + 0.677 * w, t + 0.8707 * h, l + 0.6765 * w, t + 0.8773 * h, l + 0.6756 * w, t + 0.8838 * h);
      p.cubicTo(l + 0.6669 * w, t + 0.9605 * h, l + 0.8086 * w, t + 0.7104 * h, l + 0.7492 * w, t + 0.7577 * h);
      p.cubicTo(l + 0.7008 * w, t + 0.7962 * h, l + 0.617 * w, t + 0.7981 * h, l + 0.5584 * w, t + 0.8 * h);
      p.cubicTo(l + 0.4724 * w, t + 0.8027 * h, l + 0.3833 * w, t + 0.7917 * h, l + 0.2994 * w, t + 0.7726 * h);
      p.cubicTo(l + 0.2636 * w, t + 0.7644 * h, l + 0.193 * w, t + 0.9661 * h, l + 0.1883 * w, t + 0.965 * h);
      p.cubicTo(l + 0.2962 * w, t + 0.9896 * h, l + 0.4109 * w, t + 1.0 * h, l + 0.521 * w, t + 0.987 * h);
      p.cubicTo(l + 0.5758 * w, t + 0.9806 * h, l + 0.6377 * w, t + 0.9647 * h, l + 0.6732 * w, t + 0.9197 * h);
      p.cubicTo(l + 0.7206 * w, t + 0.8596 * h, l + 0.7659 * w, t + 0.7849 * h, l + 0.7861 * w, t + 0.7104 * h);
      p.cubicTo(l + 0.8117 * w, t + 0.616 * h, l + 0.7437 * w, t + 0.4944 * h, l + 0.7027 * w, t + 0.4142 * h);
      p.cubicTo(l + 0.6668 * w, t + 0.3439 * h, l + 0.6259 * w, t + 0.2752 * h, l + 0.5811 * w, t + 0.2102 * h);
      p.cubicTo(l + 0.578 * w, t + 0.2056 * h, l + 0.5188 * w, t + 0.2959 * h, l + 0.5159 * w, t + 0.3008 * h);
      p.cubicTo(l + 0.5085 * w, t + 0.3138 * h, l + 0.4586 * w, t + 0.386 * h, l + 0.47 * w, t + 0.4026 * h);
      p.lineTo(l + 0.47 * w, t + 0.4026 * h);
      p.moveTo(l + 0.4724 * w, t + 0.1989 * h);
      p.cubicTo(l + 0.4607 * w, t + 0.2106 * h, l + 0.4417 * w, t + 0.2106 * h, l + 0.43 * w, t + 0.1989 * h);
      p.lineTo(l + 0.3576 * w, t + 0.1265 * h);
      p.cubicTo(l + 0.3459 * w, t + 0.1148 * h, l + 0.3459 * w, t + 0.0958 * h, l + 0.3576 * w, t + 0.0841 * h);
      p.lineTo(l + 0.43 * w, t + 0.0117 * h);
      p.cubicTo(l + 0.4417 * w, t + 0.0 * h, l + 0.4607 * w, t + 0.0 * h, l + 0.4724 * w, t + 0.0117 * h);
      p.lineTo(l + 0.5448 * w, t + 0.0841 * h);
      p.cubicTo(l + 0.5565 * w, t + 0.0958 * h, l + 0.5565 * w, t + 0.1148 * h, l + 0.5448 * w, t + 0.1265 * h);
      p.lineTo(l + 0.4724 * w, t + 0.1989 * h);
      return p;
    },
    'ر': (Rect r) {
      final p = Path();
      final l = r.left, t = r.top, w = r.width, h = r.height;
      p.moveTo(l + 0.6884 * w, t + 0.1791 * h);
      p.cubicTo(l + 0.7113 * w, t + 0.236 * h, l + 0.7285 * w, t + 0.2954 * h, l + 0.7427 * w, t + 0.3549 * h);
      p.cubicTo(l + 0.7566 * w, t + 0.4132 * h, l + 0.7646 * w, t + 0.4727 * h, l + 0.7645 * w, t + 0.5326 * h);
      p.cubicTo(l + 0.7644 * w, t + 0.5558 * h, l + 0.7612 * w, t + 0.5787 * h, l + 0.757 * w, t + 0.6015 * h);
      p.cubicTo(l + 0.7533 * w, t + 0.6195 * h, l + 0.7482 * w, t + 0.6371 * h, l + 0.7417 * w, t + 0.6544 * h);
      p.cubicTo(l + 0.7486 * w, t + 0.6438 * h, l + 0.7554 * w, t + 0.6331 * h, l + 0.7622 * w, t + 0.6225 * h);
      p.cubicTo(l + 0.7517 * w, t + 0.6364 * h, l + 0.7403 * w, t + 0.6495 * h, l + 0.728 * w, t + 0.6619 * h);
      p.cubicTo(l + 0.5979 * w, t + 0.7965 * h, l + 0.4043 * w, t + 0.8186 * h, l + 0.2262 * w, t + 0.8214 * h);
      p.cubicTo(l + 0.2058 * w, t + 0.8217 * h, l + 0.1738 * w, t + 0.8917 * h, l + 0.1658 * w, t + 0.9055 * h);
      p.cubicTo(l + 0.163 * w, t + 0.9104 * h, l + 0.1198 * w, t + 1.0 * h, l + 0.1232 * w, t + 1.0 * h);
      p.cubicTo(l + 0.222 * w, t + 0.9984 * h, l + 0.3224 * w, t + 0.9884 * h, l + 0.4181 * w, t + 0.9637 * h);
      p.cubicTo(l + 0.5496 * w, t + 0.9297 * h, l + 0.6524 * w, t + 0.8329 * h, l + 0.7253 * w, t + 0.7221 * h);
      p.cubicTo(l + 0.8124 * w, t + 0.5897 * h, l + 0.8802 * w, t + 0.4513 * h, l + 0.8651 * w, t + 0.2897 * h);
      p.cubicTo(l + 0.856 * w, t + 0.1916 * h, l + 0.8283 * w, t + 0.092 * h, l + 0.7915 * w, t + 0.0006 * h);
      p.cubicTo(l + 0.7912 * w, t + 0.0 * h, l + 0.7344 * w, t + 0.0789 * h, l + 0.731 * w, t + 0.0847 * h);
      p.cubicTo(l + 0.7215 * w, t + 0.1012 * h, l + 0.6799 * w, t + 0.1579 * h, l + 0.6884 * w, t + 0.1791 * h);
      p.lineTo(l + 0.6884 * w, t + 0.1791 * h);
      return p;
    },
    'ز': (Rect r) {
      final p = Path();
      final l = r.left, t = r.top, w = r.width, h = r.height;
      p.moveTo(l + 0.6524 * w, t + 0.3359 * h);
      p.cubicTo(l + 0.6709 * w, t + 0.3819 * h, l + 0.6848 * w, t + 0.4299 * h, l + 0.6963 * w, t + 0.4781 * h);
      p.cubicTo(l + 0.7076 * w, t + 0.5253 * h, l + 0.714 * w, t + 0.5734 * h, l + 0.714 * w, t + 0.6218 * h);
      p.cubicTo(l + 0.7139 * w, t + 0.6406 * h, l + 0.7113 * w, t + 0.6592 * h, l + 0.7079 * w, t + 0.6776 * h);
      p.cubicTo(l + 0.7049 * w, t + 0.6922 * h, l + 0.7008 * w, t + 0.7064 * h, l + 0.6956 * w, t + 0.7204 * h);
      p.cubicTo(l + 0.7011 * w, t + 0.7118 * h, l + 0.7066 * w, t + 0.7032 * h, l + 0.7121 * w, t + 0.6946 * h);
      p.cubicTo(l + 0.7036 * w, t + 0.7058 * h, l + 0.6944 * w, t + 0.7165 * h, l + 0.6844 * w, t + 0.7265 * h);
      p.cubicTo(l + 0.5792 * w, t + 0.8353 * h, l + 0.4225 * w, t + 0.8533 * h, l + 0.2786 * w, t + 0.8555 * h);
      p.cubicTo(l + 0.262 * w, t + 0.8558 * h, l + 0.2361 * w, t + 0.9124 * h, l + 0.2296 * w, t + 0.9236 * h);
      p.cubicTo(l + 0.2273 * w, t + 0.9275 * h, l + 0.1924 * w, t + 1.0 * h, l + 0.1952 * w, t + 1.0 * h);
      p.cubicTo(l + 0.275 * w, t + 0.9987 * h, l + 0.3563 * w, t + 0.9906 * h, l + 0.4338 * w, t + 0.9706 * h);
      p.cubicTo(l + 0.5401 * w, t + 0.9431 * h, l + 0.6233 * w, t + 0.8648 * h, l + 0.6823 * w, t + 0.7752 * h);
      p.cubicTo(l + 0.7528 * w, t + 0.6681 * h, l + 0.8076 * w, t + 0.5561 * h, l + 0.7954 * w, t + 0.4254 * h);
      p.cubicTo(l + 0.788 * w, t + 0.346 * h, l + 0.7656 * w, t + 0.2654 * h, l + 0.7358 * w, t + 0.1915 * h);
      p.cubicTo(l + 0.7356 * w, t + 0.191 * h, l + 0.6896 * w, t + 0.2548 * h, l + 0.6869 * w, t + 0.2595 * h);
      p.cubicTo(l + 0.6792 * w, t + 0.2728 * h, l + 0.6455 * w, t + 0.3187 * h, l + 0.6524 * w, t + 0.3359 * h);
      p.lineTo(l + 0.6524 * w, t + 0.3359 * h);
      p.moveTo(l + 0.66 * w, t + 0.1392 * h);
      p.cubicTo(l + 0.6467 * w, t + 0.1524 * h, l + 0.6251 * w, t + 0.1524 * h, l + 0.6118 * w, t + 0.1392 * h);
      p.lineTo(l + 0.573 * w, t + 0.1003 * h);
      p.cubicTo(l + 0.5597 * w, t + 0.087 * h, l + 0.5597 * w, t + 0.0654 * h, l + 0.573 * w, t + 0.0521 * h);
      p.lineTo(l + 0.6118 * w, t + 0.0133 * h);
      p.cubicTo(l + 0.6251 * w, t + 0.0 * h, l + 0.6467 * w, t + 0.0 * h, l + 0.66 * w, t + 0.0133 * h);
      p.lineTo(l + 0.6989 * w, t + 0.0521 * h);
      p.cubicTo(l + 0.7121 * w, t + 0.0654 * h, l + 0.7121 * w, t + 0.087 * h, l + 0.6989 * w, t + 0.1003 * h);
      p.lineTo(l + 0.66 * w, t + 0.1392 * h);
      return p;
    },
    'س': (Rect r) {
      final p = Path();
      final l = r.left, t = r.top, w = r.width, h = r.height;
      p.moveTo(l + 0.8897 * w, t + 0.3225 * h);
      p.cubicTo(l + 0.8951 * w, t + 0.3335 * h, l + 0.8988 * w, t + 0.3453 * h, l + 0.9022 * w, t + 0.3571 * h);
      p.cubicTo(l + 0.9059 * w, t + 0.3704 * h, l + 0.9073 * w, t + 0.3839 * h, l + 0.9076 * w, t + 0.3976 * h);
      p.cubicTo(l + 0.9075 * w, t + 0.404 * h, l + 0.9069 * w, t + 0.4103 * h, l + 0.9058 * w, t + 0.4166 * h);
      p.cubicTo(l + 0.9183 * w, t + 0.395 * h, l + 0.9308 * w, t + 0.3734 * h, l + 0.9433 * w, t + 0.3518 * h);
      p.cubicTo(l + 0.9342 * w, t + 0.3592 * h, l + 0.9241 * w, t + 0.3648 * h, l + 0.913 * w, t + 0.3687 * h);
      p.cubicTo(l + 0.8678 * w, t + 0.3867 * h, l + 0.8162 * w, t + 0.3525 * h, l + 0.7894 * w, t + 0.3179 * h);
      p.cubicTo(l + 0.7879 * w, t + 0.316 * h, l + 0.7218 * w, t + 0.4198 * h, l + 0.7191 * w, t + 0.436 * h);
      p.cubicTo(l + 0.7185 * w, t + 0.4392 * h, l + 0.7178 * w, t + 0.4423 * h, l + 0.717 * w, t + 0.4454 * h);
      p.cubicTo(l + 0.709 * w, t + 0.4702 * h, l + 0.7197 * w, t + 0.4512 * h, l + 0.7491 * w, t + 0.3885 * h);
      p.cubicTo(l + 0.7431 * w, t + 0.3935 * h, l + 0.7364 * w, t + 0.3974 * h, l + 0.7289 * w, t + 0.4002 * h);
      p.cubicTo(l + 0.7015 * w, t + 0.4116 * h, l + 0.6664 * w, t + 0.4013 * h, l + 0.6411 * w, t + 0.3893 * h);
      p.cubicTo(l + 0.612 * w, t + 0.3755 * h, l + 0.5878 * w, t + 0.3442 * h, l + 0.5794 * w, t + 0.3132 * h);
      p.cubicTo(l + 0.5798 * w, t + 0.3147 * h, l + 0.5412 * w, t + 0.3654 * h, l + 0.5384 * w, t + 0.3704 * h);
      p.cubicTo(l + 0.5296 * w, t + 0.3856 * h, l + 0.5068 * w, t + 0.4155 * h, l + 0.5094 * w, t + 0.4345 * h);
      p.cubicTo(l + 0.5184 * w, t + 0.499 * h, l + 0.5149 * w, t + 0.5678 * h, l + 0.4997 * w, t + 0.6309 * h);
      p.cubicTo(l + 0.4971 * w, t + 0.6415 * h, l + 0.4935 * w, t + 0.6518 * h, l + 0.4897 * w, t + 0.662 * h);
      p.cubicTo(l + 0.5108 * w, t + 0.6056 * h, l + 0.5255 * w, t + 0.6113 * h, l + 0.4981 * w, t + 0.635 * h);
      p.cubicTo(l + 0.4774 * w, t + 0.6528 * h, l + 0.4517 * w, t + 0.6623 * h, l + 0.4252 * w, t + 0.6674 * h);
      p.cubicTo(l + 0.3675 * w, t + 0.6786 * h, l + 0.2967 * w, t + 0.6694 * h, l + 0.2442 * w, t + 0.6428 * h);
      p.cubicTo(l + 0.1626 * w, t + 0.6015 * h, l + 0.1594 * w, t + 0.5062 * h, l + 0.1769 * w, t + 0.4276 * h);
      p.cubicTo(l + 0.1845 * w, t + 0.3933 * h, l + 0.1969 * w, t + 0.3599 * h, l + 0.2114 * w, t + 0.3279 * h);
      p.cubicTo(l + 0.2173 * w, t + 0.3147 * h, l + 0.2123 * w, t + 0.3256 * h, l + 0.2155 * w, t + 0.319 * h);
      p.cubicTo(l + 0.2167 * w, t + 0.3165 * h, l + 0.218 * w, t + 0.314 * h, l + 0.2193 * w, t + 0.3115 * h);
      p.cubicTo(l + 0.2256 * w, t + 0.299 * h, l + 0.2122 * w, t + 0.3249 * h, l + 0.218 * w, t + 0.3138 * h);
      p.cubicTo(l + 0.2279 * w, t + 0.2951 * h, l + 0.2093 * w, t + 0.3285 * h, l + 0.2177 * w, t + 0.3144 * h);
      p.cubicTo(l + 0.2201 * w, t + 0.3102 * h, l + 0.2535 * w, t + 0.2543 * h, l + 0.2466 * w, t + 0.2503 * h);
      p.cubicTo(l + 0.2396 * w, t + 0.2462 * h, l + 0.208 * w, t + 0.3032 * h, l + 0.2055 * w, t + 0.3074 * h);
      p.cubicTo(l + 0.1307 * w, t + 0.4342 * h, l + 0.0 * w, t + 0.712 * h, l + 0.2113 * w, t + 0.7791 * h);
      p.cubicTo(l + 0.2749 * w, t + 0.7992 * h, l + 0.3552 * w, t + 0.8001 * h, l + 0.4144 * w, t + 0.7673 * h);
      p.cubicTo(l + 0.4792 * w, t + 0.7315 * h, l + 0.5207 * w, t + 0.6426 * h, l + 0.549 * w, t + 0.5784 * h);
      p.cubicTo(l + 0.5851 * w, t + 0.4968 * h, l + 0.5916 * w, t + 0.4011 * h, l + 0.5794 * w, t + 0.3132 * h);
      p.cubicTo(l + 0.5561 * w, t + 0.3537 * h, l + 0.5327 * w, t + 0.3941 * h, l + 0.5094 * w, t + 0.4345 * h);
      p.cubicTo(l + 0.5261 * w, t + 0.4959 * h, l + 0.6088 * w, t + 0.5517 * h, l + 0.6703 * w, t + 0.5167 * h);
      p.cubicTo(l + 0.711 * w, t + 0.4935 * h, l + 0.7348 * w, t + 0.443 * h, l + 0.7566 * w, t + 0.4037 * h);
      p.cubicTo(l + 0.7707 * w, t + 0.3783 * h, l + 0.7848 * w, t + 0.35 * h, l + 0.7898 * w, t + 0.321 * h);
      p.cubicTo(l + 0.7663 * w, t + 0.3604 * h, l + 0.7429 * w, t + 0.3998 * h, l + 0.7194 * w, t + 0.4391 * h);
      p.cubicTo(l + 0.777 * w, t + 0.5134 * h, l + 0.8635 * w, t + 0.5051 * h, l + 0.9137 * w, t + 0.4289 * h);
      p.cubicTo(l + 0.9605 * w, t + 0.3578 * h, l + 1.0 * w, t + 0.2843 * h, l + 0.9597 * w, t + 0.2013 * h);
      p.cubicTo(l + 0.9591 * w, t + 0.1999 * h, l + 0.9207 * w, t + 0.2548 * h, l + 0.9187 * w, t + 0.2584 * h);
      p.cubicTo(l + 0.9128 * w, t + 0.2685 * h, l + 0.8833 * w, t + 0.3094 * h, l + 0.8897 * w, t + 0.3225 * h);
      p.lineTo(l + 0.8897 * w, t + 0.3225 * h);
      return p;
    },
    'ش': (Rect r) {
      final p = Path();
      final l = r.left, t = r.top, w = r.width, h = r.height;
      p.moveTo(l + 0.884 * w, t + 0.4511 * h);
      p.cubicTo(l + 0.8903 * w, t + 0.464 * h, l + 0.8944 * w, t + 0.4778 * h, l + 0.8979 * w, t + 0.4916 * h);
      p.cubicTo(l + 0.9016 * w, t + 0.5068 * h, l + 0.902 * w, t + 0.522 * h, l + 0.9009 * w, t + 0.5375 * h);
      p.cubicTo(l + 0.8931 * w, t + 0.5771 * h, l + 0.9073 * w, t + 0.5543 * h, l + 0.9437 * w, t + 0.4691 * h);
      p.cubicTo(l + 0.934 * w, t + 0.4773 * h, l + 0.9229 * w, t + 0.4834 * h, l + 0.9106 * w, t + 0.4873 * h);
      p.cubicTo(l + 0.8666 * w, t + 0.5037 * h, l + 0.8166 * w, t + 0.4695 * h, l + 0.7906 * w, t + 0.4362 * h);
      p.cubicTo(l + 0.789 * w, t + 0.4341 * h, l + 0.7178 * w, t + 0.546 * h, l + 0.7148 * w, t + 0.5634 * h);
      p.cubicTo(l + 0.7145 * w, t + 0.5656 * h, l + 0.7139 * w, t + 0.5678 * h, l + 0.7135 * w, t + 0.57 * h);
      p.cubicTo(l + 0.702 * w, t + 0.6204 * h, l + 0.7876 * w, t + 0.4746 * h, l + 0.7475 * w, t + 0.5085 * h);
      p.cubicTo(l + 0.7211 * w, t + 0.5308 * h, l + 0.68 * w, t + 0.5217 * h, l + 0.6511 * w, t + 0.5106 * h);
      p.cubicTo(l + 0.6187 * w, t + 0.498 * h, l + 0.5915 * w, t + 0.4649 * h, l + 0.5825 * w, t + 0.4315 * h);
      p.cubicTo(l + 0.5829 * w, t + 0.4331 * h, l + 0.5414 * w, t + 0.4877 * h, l + 0.5383 * w, t + 0.493 * h);
      p.cubicTo(l + 0.5288 * w, t + 0.5094 * h, l + 0.5043 * w, t + 0.5417 * h, l + 0.5071 * w, t + 0.5621 * h);
      p.cubicTo(l + 0.5158 * w, t + 0.6252 * h, l + 0.5124 * w, t + 0.6923 * h, l + 0.498 * w, t + 0.7542 * h);
      p.cubicTo(l + 0.4953 * w, t + 0.7656 * h, l + 0.4915 * w, t + 0.7765 * h, l + 0.4874 * w, t + 0.7875 * h);
      p.cubicTo(l + 0.5161 * w, t + 0.7112 * h, l + 0.5319 * w, t + 0.7244 * h, l + 0.5014 * w, t + 0.7508 * h);
      p.cubicTo(l + 0.4789 * w, t + 0.7701 * h, l + 0.4506 * w, t + 0.7793 * h, l + 0.4218 * w, t + 0.7837 * h);
      p.cubicTo(l + 0.3654 * w, t + 0.7924 * h, l + 0.2986 * w, t + 0.7835 * h, l + 0.2479 * w, t + 0.757 * h);
      p.cubicTo(l + 0.1701 * w, t + 0.7163 * h, l + 0.1666 * w, t + 0.6245 * h, l + 0.1827 * w, t + 0.5488 * h);
      p.cubicTo(l + 0.1902 * w, t + 0.5136 * h, l + 0.2028 * w, t + 0.4796 * h, l + 0.2176 * w, t + 0.4469 * h);
      p.cubicTo(l + 0.224 * w, t + 0.4326 * h, l + 0.2185 * w, t + 0.4447 * h, l + 0.222 * w, t + 0.4376 * h);
      p.cubicTo(l + 0.2307 * w, t + 0.4199 * h, l + 0.218 * w, t + 0.4449 * h, l + 0.2227 * w, t + 0.4359 * h);
      p.cubicTo(l + 0.2332 * w, t + 0.4161 * h, l + 0.2137 * w, t + 0.4512 * h, l + 0.2214 * w, t + 0.4382 * h);
      p.cubicTo(l + 0.224 * w, t + 0.4337 * h, l + 0.2601 * w, t + 0.3735 * h, l + 0.2526 * w, t + 0.3691 * h);
      p.cubicTo(l + 0.245 * w, t + 0.3648 * h, l + 0.211 * w, t + 0.4261 * h, l + 0.2084 * w, t + 0.4306 * h);
      p.cubicTo(l + 0.1336 * w, t + 0.5573 * h, l + 0.0 * w, t + 0.8368 * h, l + 0.2124 * w, t + 0.9039 * h);
      p.cubicTo(l + 0.2773 * w, t + 0.9243 * h, l + 0.3593 * w, t + 0.9245 * h, l + 0.4185 * w, t + 0.8886 * h);
      p.cubicTo(l + 0.4819 * w, t + 0.8501 * h, l + 0.5223 * w, t + 0.7619 * h, l + 0.5513 * w, t + 0.6974 * h);
      p.cubicTo(l + 0.588 * w, t + 0.6157 * h, l + 0.5947 * w, t + 0.5197 * h, l + 0.5825 * w, t + 0.4315 * h);
      p.cubicTo(l + 0.5574 * w, t + 0.4751 * h, l + 0.5322 * w, t + 0.5186 * h, l + 0.5071 * w, t + 0.5621 * h);
      p.cubicTo(l + 0.5233 * w, t + 0.6218 * h, l + 0.6004 * w, t + 0.6748 * h, l + 0.6613 * w, t + 0.6459 * h);
      p.cubicTo(l + 0.705 * w, t + 0.6252 * h, l + 0.7306 * w, t + 0.5721 * h, l + 0.7527 * w, t + 0.5319 * h);
      p.cubicTo(l + 0.7684 * w, t + 0.5033 * h, l + 0.7853 * w, t + 0.4722 * h, l + 0.791 * w, t + 0.4395 * h);
      p.cubicTo(l + 0.7658 * w, t + 0.4819 * h, l + 0.7405 * w, t + 0.5243 * h, l + 0.7153 * w, t + 0.5667 * h);
      p.cubicTo(l + 0.7754 * w, t + 0.6441 * h, l + 0.8609 * w, t + 0.6286 * h, l + 0.9114 * w, t + 0.5518 * h);
      p.cubicTo(l + 0.9586 * w, t + 0.4801 * h, l + 1.0 * w, t + 0.4044 * h, l + 0.9594 * w, t + 0.3206 * h);
      p.cubicTo(l + 0.9587 * w, t + 0.3191 * h, l + 0.9174 * w, t + 0.3782 * h, l + 0.9152 * w, t + 0.3821 * h);
      p.cubicTo(l + 0.9089 * w, t + 0.393 * h, l + 0.8772 * w, t + 0.4369 * h, l + 0.884 * w, t + 0.4511 * h);
      p.lineTo(l + 0.884 * w, t + 0.4511 * h);
      p.moveTo(l + 0.6425 * w, t + 0.3602 * h);
      p.cubicTo(l + 0.6345 * w, t + 0.3681 * h, l + 0.6216 * w, t + 0.3681 * h, l + 0.6137 * w, t + 0.3602 * h);
      p.lineTo(l + 0.5646 * w, t + 0.3111 * h);
      p.cubicTo(l + 0.5566 * w, t + 0.3031 * h, l + 0.5566 * w, t + 0.2903 * h, l + 0.5646 * w, t + 0.2823 * h);
      p.lineTo(l + 0.6137 * w, t + 0.2332 * h);
      p.cubicTo(l + 0.6217 * w, t + 0.2253 * h, l + 0.6345 * w, t + 0.2253 * h, l + 0.6425 * w, t + 0.2332 * h);
      p.lineTo(l + 0.6916 * w, t + 0.2823 * h);
      p.cubicTo(l + 0.6995 * w, t + 0.2903 * h, l + 0.6995 * w, t + 0.3031 * h, l + 0.6916 * w, t + 0.3111 * h);
      p.lineTo(l + 0.6425 * w, t + 0.3602 * h);
      p.moveTo(l + 0.8232 * w, t + 0.3162 * h);
      p.cubicTo(l + 0.8152 * w, t + 0.3241 * h, l + 0.8023 * w, t + 0.3241 * h, l + 0.7944 * w, t + 0.3162 * h);
      p.lineTo(l + 0.7453 * w, t + 0.267 * h);
      p.cubicTo(l + 0.7373 * w, t + 0.2591 * h, l + 0.7373 * w, t + 0.2462 * h, l + 0.7453 * w, t + 0.2383 * h);
      p.lineTo(l + 0.7944 * w, t + 0.1892 * h);
      p.cubicTo(l + 0.8023 * w, t + 0.1812 * h, l + 0.8152 * w, t + 0.1812 * h, l + 0.8232 * w, t + 0.1892 * h);
      p.lineTo(l + 0.8723 * w, t + 0.2383 * h);
      p.cubicTo(l + 0.8802 * w, t + 0.2462 * h, l + 0.8802 * w, t + 0.2591 * h, l + 0.8723 * w, t + 0.267 * h);
      p.lineTo(l + 0.8232 * w, t + 0.3162 * h);
      p.moveTo(l + 0.7088 * w, t + 0.2105 * h);
      p.cubicTo(l + 0.7008 * w, t + 0.2184 * h, l + 0.6879 * w, t + 0.2184 * h, l + 0.68 * w, t + 0.2105 * h);
      p.lineTo(l + 0.6309 * w, t + 0.1613 * h);
      p.cubicTo(l + 0.6229 * w, t + 0.1534 * h, l + 0.6229 * w, t + 0.1405 * h, l + 0.6309 * w, t + 0.1326 * h);
      p.lineTo(l + 0.68 * w, t + 0.0834 * h);
      p.cubicTo(l + 0.688 * w, t + 0.0755 * h, l + 0.7008 * w, t + 0.0755 * h, l + 0.7088 * w, t + 0.0834 * h);
      p.lineTo(l + 0.7579 * w, t + 0.1326 * h);
      p.cubicTo(l + 0.7658 * w, t + 0.1405 * h, l + 0.7658 * w, t + 0.1534 * h, l + 0.7579 * w, t + 0.1613 * h);
      p.lineTo(l + 0.7088 * w, t + 0.2105 * h);
      return p;
    },
    'ص': (Rect r) {
      final p = Path();
      final l = r.left, t = r.top, w = r.width, h = r.height;
      p.moveTo(l + 0.6608 * w, t + 0.347 * h);
      p.cubicTo(l + 0.663 * w, t + 0.335 * h, l + 0.6666 * w, t + 0.3232 * h, l + 0.6706 * w, t + 0.3116 * h);
      p.cubicTo(l + 0.6722 * w, t + 0.3072 * h, l + 0.6739 * w, t + 0.3027 * h, l + 0.6757 * w, t + 0.2983 * h);
      p.cubicTo(l + 0.6509 * w, t + 0.3562 * h, l + 0.6596 * w, t + 0.3275 * h, l + 0.6793 * w, t + 0.3088 * h);
      p.cubicTo(l + 0.6965 * w, t + 0.2926 * h, l + 0.7167 * w, t + 0.2803 * h, l + 0.7374 * w, t + 0.2693 * h);
      p.cubicTo(l + 0.806 * w, t + 0.2328 * h, l + 0.9153 * w, t + 0.2624 * h, l + 0.9157 * w, t + 0.3515 * h);
      p.cubicTo(l + 0.9158 * w, t + 0.3605 * h, l + 0.9144 * w, t + 0.3703 * h, l + 0.9117 * w, t + 0.3788 * h);
      p.cubicTo(l + 0.9442 * w, t + 0.2752 * h, l + 0.9741 * w, t + 0.2943 * h, l + 0.9188 * w, t + 0.3273 * h);
      p.cubicTo(l + 0.8691 * w, t + 0.357 * h, l + 0.8051 * w, t + 0.3643 * h, l + 0.7486 * w, t + 0.3668 * h);
      p.cubicTo(l + 0.6798 * w, t + 0.3699 * h, l + 0.602 * w, t + 0.3564 * h, l + 0.5402 * w, t + 0.3244 * h);
      p.cubicTo(l + 0.5311 * w, t + 0.3197 * h, l + 0.4511 * w, t + 0.4464 * h, l + 0.4595 * w, t + 0.4643 * h);
      p.cubicTo(l + 0.4734 * w, t + 0.494 * h, l + 0.4825 * w, t + 0.5261 * h, l + 0.4895 * w, t + 0.5581 * h);
      p.cubicTo(l + 0.4966 * w, t + 0.5904 * h, l + 0.4987 * w, t + 0.6232 * h, l + 0.497 * w, t + 0.6562 * h);
      p.cubicTo(l + 0.4963 * w, t + 0.6708 * h, l + 0.4936 * w, t + 0.6852 * h, l + 0.4905 * w, t + 0.6995 * h);
      p.cubicTo(l + 0.4804 * w, t + 0.7311 * h, l + 0.4889 * w, t + 0.719 * h, l + 0.5159 * w, t + 0.6632 * h);
      p.cubicTo(l + 0.5066 * w, t + 0.6745 * h, l + 0.4942 * w, t + 0.6834 * h, l + 0.4826 * w, t + 0.6922 * h);
      p.cubicTo(l + 0.4075 * w, t + 0.7492 * h, l + 0.2991 * w, t + 0.7447 * h, l + 0.215 * w, t + 0.7128 * h);
      p.cubicTo(l + 0.1731 * w, t + 0.6969 * h, l + 0.1454 * w, t + 0.6674 * h, l + 0.1231 * w, t + 0.6292 * h);
      p.cubicTo(l + 0.1089 * w, t + 0.6047 * h, l + 0.1049 * w, t + 0.5759 * h, l + 0.106 * w, t + 0.5482 * h);
      p.cubicTo(l + 0.108 * w, t + 0.4957 * h, l + 0.1508 * w, t + 0.4835 * h, l + 0.0705 * w, t + 0.5832 * h);
      p.cubicTo(l + 0.0934 * w, t + 0.5547 * h, l + 0.1118 * w, t + 0.5216 * h, l + 0.1282 * w, t + 0.489 * h);
      p.cubicTo(l + 0.1304 * w, t + 0.4847 * h, l + 0.1528 * w, t + 0.4339 * h, l + 0.1331 * w, t + 0.4584 * h);
      p.cubicTo(l + 0.0701 * w, t + 0.5367 * h, l + 0.0 * w, t + 0.6512 * h, l + 0.0355 * w, t + 0.754 * h);
      p.cubicTo(l + 0.0835 * w, t + 0.8929 * h, l + 0.2898 * w, t + 0.9009 * h, l + 0.3967 * w, t + 0.8372 * h);
      p.cubicTo(l + 0.4519 * w, t + 0.8042 * h, l + 0.4879 * w, t + 0.7445 * h, l + 0.5186 * w, t + 0.6901 * h);
      p.cubicTo(l + 0.5483 * w, t + 0.6375 * h, l + 0.5732 * w, t + 0.5843 * h, l + 0.5786 * w, t + 0.5235 * h);
      p.cubicTo(l + 0.5844 * w, t + 0.4576 * h, l + 0.5682 * w, t + 0.3842 * h, l + 0.5402 * w, t + 0.3244 * h);
      p.cubicTo(l + 0.5133 * w, t + 0.3711 * h, l + 0.4864 * w, t + 0.4176 * h, l + 0.4595 * w, t + 0.4643 * h);
      p.cubicTo(l + 0.5644 * w, t + 0.5186 * h, l + 0.7146 * w, t + 0.5244 * h, l + 0.8217 * w, t + 0.4755 * h);
      p.cubicTo(l + 0.8813 * w, t + 0.4483 * h, l + 0.9148 * w, t + 0.4019 * h, l + 0.9468 * w, t + 0.3463 * h);
      p.cubicTo(l + 0.9714 * w, t + 0.3039 * h, l + 1.0 * w, t + 0.2566 * h, l + 0.9969 * w, t + 0.2057 * h);
      p.cubicTo(l + 0.9938 * w, t + 0.156 * h, l + 0.9513 * w, t + 0.125 * h, l + 0.9059 * w, t + 0.1143 * h);
      p.cubicTo(l + 0.8414 * w, t + 0.0991 * h, l + 0.769 * w, t + 0.1509 * h, l + 0.7292 * w, t + 0.1964 * h);
      p.cubicTo(l + 0.6629 * w, t + 0.2721 * h, l + 0.5972 * w, t + 0.3787 * h, l + 0.5793 * w, t + 0.4797 * h);
      p.cubicTo(l + 0.5781 * w, t + 0.4866 * h, l + 0.6126 * w, t + 0.4414 * h, l + 0.6161 * w, t + 0.4358 * h);
      p.cubicTo(l + 0.632 * w, t + 0.41 * h, l + 0.6554 * w, t + 0.3776 * h, l + 0.6608 * w, t + 0.347 * h);
      p.lineTo(l + 0.6608 * w, t + 0.347 * h);
      return p;
    },
    'ض': (Rect r) {
      final p = Path();
      final l = r.left, t = r.top, w = r.width, h = r.height;
      p.moveTo(l + 0.6608 * w, t + 0.4136 * h);
      p.cubicTo(l + 0.663 * w, t + 0.4015 * h, l + 0.6666 * w, t + 0.3898 * h, l + 0.6706 * w, t + 0.3782 * h);
      p.cubicTo(l + 0.6722 * w, t + 0.3737 * h, l + 0.6739 * w, t + 0.3693 * h, l + 0.6757 * w, t + 0.3649 * h);
      p.cubicTo(l + 0.6509 * w, t + 0.4228 * h, l + 0.6596 * w, t + 0.3941 * h, l + 0.6793 * w, t + 0.3754 * h);
      p.cubicTo(l + 0.6965 * w, t + 0.3592 * h, l + 0.7167 * w, t + 0.3469 * h, l + 0.7374 * w, t + 0.3359 * h);
      p.cubicTo(l + 0.806 * w, t + 0.2994 * h, l + 0.9153 * w, t + 0.329 * h, l + 0.9157 * w, t + 0.4181 * h);
      p.cubicTo(l + 0.9158 * w, t + 0.4271 * h, l + 0.9144 * w, t + 0.4368 * h, l + 0.9117 * w, t + 0.4454 * h);
      p.cubicTo(l + 0.9442 * w, t + 0.3418 * h, l + 0.9741 * w, t + 0.3609 * h, l + 0.9188 * w, t + 0.3939 * h);
      p.cubicTo(l + 0.8691 * w, t + 0.4236 * h, l + 0.8051 * w, t + 0.4308 * h, l + 0.7486 * w, t + 0.4333 * h);
      p.cubicTo(l + 0.6798 * w, t + 0.4364 * h, l + 0.602 * w, t + 0.423 * h, l + 0.5402 * w, t + 0.391 * h);
      p.cubicTo(l + 0.5311 * w, t + 0.3863 * h, l + 0.4511 * w, t + 0.5129 * h, l + 0.4595 * w, t + 0.5308 * h);
      p.cubicTo(l + 0.4734 * w, t + 0.5605 * h, l + 0.4825 * w, t + 0.5927 * h, l + 0.4895 * w, t + 0.6247 * h);
      p.cubicTo(l + 0.4966 * w, t + 0.6569 * h, l + 0.4987 * w, t + 0.6898 * h, l + 0.497 * w, t + 0.7227 * h);
      p.cubicTo(l + 0.4963 * w, t + 0.7374 * h, l + 0.4936 * w, t + 0.7518 * h, l + 0.4905 * w, t + 0.7661 * h);
      p.cubicTo(l + 0.4805 * w, t + 0.7976 * h, l + 0.4889 * w, t + 0.7855 * h, l + 0.5159 * w, t + 0.7297 * h);
      p.cubicTo(l + 0.5066 * w, t + 0.741 * h, l + 0.4942 * w, t + 0.75 * h, l + 0.4826 * w, t + 0.7588 * h);
      p.cubicTo(l + 0.4075 * w, t + 0.8158 * h, l + 0.2991 * w, t + 0.8112 * h, l + 0.215 * w, t + 0.7794 * h);
      p.cubicTo(l + 0.1731 * w, t + 0.7634 * h, l + 0.1454 * w, t + 0.734 * h, l + 0.1231 * w, t + 0.6958 * h);
      p.cubicTo(l + 0.1089 * w, t + 0.6713 * h, l + 0.1049 * w, t + 0.6425 * h, l + 0.106 * w, t + 0.6147 * h);
      p.cubicTo(l + 0.108 * w, t + 0.5623 * h, l + 0.1509 * w, t + 0.55 * h, l + 0.0705 * w, t + 0.6498 * h);
      p.cubicTo(l + 0.0934 * w, t + 0.6213 * h, l + 0.1118 * w, t + 0.5882 * h, l + 0.1282 * w, t + 0.5556 * h);
      p.cubicTo(l + 0.1304 * w, t + 0.5513 * h, l + 0.1528 * w, t + 0.5005 * h, l + 0.1331 * w, t + 0.525 * h);
      p.cubicTo(l + 0.0701 * w, t + 0.6033 * h, l + 0.0 * w, t + 0.7178 * h, l + 0.0355 * w, t + 0.8206 * h);
      p.cubicTo(l + 0.0835 * w, t + 0.9595 * h, l + 0.2898 * w, t + 0.9675 * h, l + 0.3967 * w, t + 0.9037 * h);
      p.cubicTo(l + 0.4519 * w, t + 0.8708 * h, l + 0.4879 * w, t + 0.8111 * h, l + 0.5186 * w, t + 0.7567 * h);
      p.cubicTo(l + 0.5483 * w, t + 0.7041 * h, l + 0.5732 * w, t + 0.6509 * h, l + 0.5786 * w, t + 0.5901 * h);
      p.cubicTo(l + 0.5844 * w, t + 0.5242 * h, l + 0.5682 * w, t + 0.4508 * h, l + 0.5402 * w, t + 0.391 * h);
      p.cubicTo(l + 0.5133 * w, t + 0.4376 * h, l + 0.4864 * w, t + 0.4842 * h, l + 0.4595 * w, t + 0.5308 * h);
      p.cubicTo(l + 0.5644 * w, t + 0.5851 * h, l + 0.7146 * w, t + 0.5909 * h, l + 0.8217 * w, t + 0.5421 * h);
      p.cubicTo(l + 0.8813 * w, t + 0.5149 * h, l + 0.9148 * w, t + 0.4684 * h, l + 0.9468 * w, t + 0.4129 * h);
      p.cubicTo(l + 0.9713 * w, t + 0.3704 * h, l + 1.0 * w, t + 0.3231 * h, l + 0.9968 * w, t + 0.2723 * h);
      p.cubicTo(l + 0.9938 * w, t + 0.2226 * h, l + 0.9513 * w, t + 0.1916 * h, l + 0.9059 * w, t + 0.1809 * h);
      p.cubicTo(l + 0.8414 * w, t + 0.1657 * h, l + 0.769 * w, t + 0.2175 * h, l + 0.7292 * w, t + 0.263 * h);
      p.cubicTo(l + 0.6629 * w, t + 0.3386 * h, l + 0.5972 * w, t + 0.4452 * h, l + 0.5793 * w, t + 0.5463 * h);
      p.cubicTo(l + 0.578 * w, t + 0.5531 * h, l + 0.6126 * w, t + 0.508 * h, l + 0.6161 * w, t + 0.5024 * h);
      p.cubicTo(l + 0.6319 * w, t + 0.4765 * h, l + 0.6554 * w, t + 0.4442 * h, l + 0.6608 * w, t + 0.4136 * h);
      p.lineTo(l + 0.6608 * w, t + 0.4136 * h);
      p.moveTo(l + 0.6935 * w, t + 0.177 * h);
      p.cubicTo(l + 0.6849 * w, t + 0.1855 * h, l + 0.6711 * w, t + 0.1855 * h, l + 0.6627 * w, t + 0.177 * h);
      p.lineTo(l + 0.61 * w, t + 0.1244 * h);
      p.cubicTo(l + 0.6015 * w, t + 0.1159 * h, l + 0.6015 * w, t + 0.1021 * h, l + 0.61 * w, t + 0.0936 * h);
      p.lineTo(l + 0.6627 * w, t + 0.041 * h);
      p.cubicTo(l + 0.6711 * w, t + 0.0325 * h, l + 0.6849 * w, t + 0.0325 * h, l + 0.6935 * w, t + 0.041 * h);
      p.lineTo(l + 0.7461 * w, t + 0.0936 * h);
      p.cubicTo(l + 0.7546 * w, t + 0.1021 * h, l + 0.7546 * w, t + 0.1159 * h, l + 0.7461 * w, t + 0.1244 * h);
      p.lineTo(l + 0.6935 * w, t + 0.177 * h);
      return p;
    },
    'ط': (Rect r) {
      final p = Path();
      final l = r.left, t = r.top, w = r.width, h = r.height;
      p.moveTo(l + 0.4294 * w, t + 0.8285 * h);
      p.cubicTo(l + 0.4351 * w, t + 0.8105 * h, l + 0.4421 * w, t + 0.793 * h, l + 0.4504 * w, t + 0.7762 * h);
      p.cubicTo(l + 0.4597 * w, t + 0.7571 * h, l + 0.4501 * w, t + 0.7762 * h, l + 0.4471 * w, t + 0.7812 * h);
      p.cubicTo(l + 0.4517 * w, t + 0.7735 * h, l + 0.4579 * w, t + 0.7665 * h, l + 0.4636 * w, t + 0.7595 * h);
      p.cubicTo(l + 0.4841 * w, t + 0.734 * h, l + 0.5085 * w, t + 0.7125 * h, l + 0.535 * w, t + 0.6936 * h);
      p.cubicTo(l + 0.6075 * w, t + 0.6416 * h, l + 0.7889 * w, t + 0.6115 * h, l + 0.7972 * w, t + 0.7432 * h);
      p.cubicTo(l + 0.7977 * w, t + 0.7516 * h, l + 0.7964 * w, t + 0.7601 * h, l + 0.7951 * w, t + 0.7684 * h);
      p.cubicTo(l + 0.787 * w, t + 0.8012 * h, l + 0.799 * w, t + 0.7825 * h, l + 0.8311 * w, t + 0.7123 * h);
      p.cubicTo(l + 0.8253 * w, t + 0.7192 * h, l + 0.819 * w, t + 0.7256 * h, l + 0.8122 * w, t + 0.7315 * h);
      p.cubicTo(l + 0.7814 * w, t + 0.7604 * h, l + 0.7425 * w, t + 0.7804 * h, l + 0.7037 * w, t + 0.7962 * h);
      p.cubicTo(l + 0.6227 * w, t + 0.8294 * h, l + 0.531 * w, t + 0.8426 * h, l + 0.4439 * w, t + 0.8395 * h);
      p.cubicTo(l + 0.367 * w, t + 0.8367 * h, l + 0.2747 * w, t + 0.8154 * h, l + 0.2141 * w, t + 0.7644 * h);
      p.cubicTo(l + 0.2116 * w, t + 0.7623 * h, l + 0.1124 * w, t + 0.8972 * h, l + 0.1292 * w, t + 0.9114 * h);
      p.cubicTo(l + 0.2347 * w, t + 1.0 * h, l + 0.4016 * w, t + 0.9974 * h, l + 0.5272 * w, t + 0.9706 * h);
      p.cubicTo(l + 0.6206 * w, t + 0.9507 * h, l + 0.7115 * w, t + 0.9107 * h, l + 0.7722 * w, t + 0.8348 * h);
      p.cubicTo(l + 0.821 * w, t + 0.7737 * h, l + 0.8876 * w, t + 0.6783 * h, l + 0.8824 * w, t + 0.5956 * h);
      p.cubicTo(l + 0.8785 * w, t + 0.5331 * h, l + 0.8229 * w, t + 0.5039 * h, l + 0.7664 * w, t + 0.5009 * h);
      p.cubicTo(l + 0.6839 * w, t + 0.4966 * h, l + 0.6071 * w, t + 0.5444 * h, l + 0.5528 * w, t + 0.6021 * h);
      p.cubicTo(l + 0.4636 * w, t + 0.6968 * h, l + 0.3885 * w, t + 0.8268 * h, l + 0.3487 * w, t + 0.9511 * h);
      p.cubicTo(l + 0.3386 * w, t + 0.9823 * h, l + 0.3707 * w, t + 0.9355 * h, l + 0.3739 * w, t + 0.9305 * h);
      p.cubicTo(l + 0.3944 * w, t + 0.8994 * h, l + 0.4179 * w, t + 0.8643 * h, l + 0.4294 * w, t + 0.8285 * h);
      p.lineTo(l + 0.4294 * w, t + 0.8285 * h);
      p.moveTo(l + 0.3211 * w, t + 0.1485 * h);
      p.cubicTo(l + 0.3089 * w, t + 0.4203 * h, l + 0.3072 * w, t + 0.701 * h, l + 0.353 * w, t + 0.9697 * h);
      p.cubicTo(l + 0.3523 * w, t + 0.9657 * h, l + 0.3986 * w, t + 0.9079 * h, l + 0.4028 * w, t + 0.9005 * h);
      p.cubicTo(l + 0.4131 * w, t + 0.8827 * h, l + 0.4417 * w, t + 0.8451 * h, l + 0.4379 * w, t + 0.8228 * h);
      p.cubicTo(l + 0.3926 * w, t + 0.5567 * h, l + 0.3948 * w, t + 0.2781 * h, l + 0.4069 * w, t + 0.009 * h);
      p.cubicTo(l + 0.4073 * w, t + 0.0 * h, l + 0.3713 * w, t + 0.05 * h, l + 0.3682 * w, t + 0.0551 * h);
      p.cubicTo(l + 0.3533 * w, t + 0.0792 * h, l + 0.3224 * w, t + 0.1188 * h, l + 0.3211 * w, t + 0.1485 * h);
      p.lineTo(l + 0.3211 * w, t + 0.1485 * h);
      return p;
    },
    'ظ': (Rect r) {
      final p = Path();
      final l = r.left, t = r.top, w = r.width, h = r.height;
      p.moveTo(l + 0.4294 * w, t + 0.8285 * h);
      p.cubicTo(l + 0.4351 * w, t + 0.8105 * h, l + 0.4421 * w, t + 0.793 * h, l + 0.4504 * w, t + 0.7762 * h);
      p.cubicTo(l + 0.4597 * w, t + 0.7571 * h, l + 0.4501 * w, t + 0.7762 * h, l + 0.4471 * w, t + 0.7812 * h);
      p.cubicTo(l + 0.4517 * w, t + 0.7735 * h, l + 0.4579 * w, t + 0.7665 * h, l + 0.4636 * w, t + 0.7595 * h);
      p.cubicTo(l + 0.4841 * w, t + 0.734 * h, l + 0.5085 * w, t + 0.7125 * h, l + 0.535 * w, t + 0.6936 * h);
      p.cubicTo(l + 0.6075 * w, t + 0.6416 * h, l + 0.7889 * w, t + 0.6115 * h, l + 0.7972 * w, t + 0.7432 * h);
      p.cubicTo(l + 0.7977 * w, t + 0.7516 * h, l + 0.7964 * w, t + 0.7601 * h, l + 0.7951 * w, t + 0.7684 * h);
      p.cubicTo(l + 0.787 * w, t + 0.8012 * h, l + 0.799 * w, t + 0.7825 * h, l + 0.8311 * w, t + 0.7123 * h);
      p.cubicTo(l + 0.8253 * w, t + 0.7192 * h, l + 0.8189 * w, t + 0.7256 * h, l + 0.8122 * w, t + 0.7315 * h);
      p.cubicTo(l + 0.7814 * w, t + 0.7604 * h, l + 0.7425 * w, t + 0.7804 * h, l + 0.7037 * w, t + 0.7962 * h);
      p.cubicTo(l + 0.6227 * w, t + 0.8294 * h, l + 0.531 * w, t + 0.8426 * h, l + 0.4439 * w, t + 0.8395 * h);
      p.cubicTo(l + 0.367 * w, t + 0.8367 * h, l + 0.2747 * w, t + 0.8154 * h, l + 0.2141 * w, t + 0.7644 * h);
      p.cubicTo(l + 0.2116 * w, t + 0.7623 * h, l + 0.1124 * w, t + 0.8972 * h, l + 0.1292 * w, t + 0.9114 * h);
      p.cubicTo(l + 0.2347 * w, t + 1.0 * h, l + 0.4016 * w, t + 0.9974 * h, l + 0.5272 * w, t + 0.9706 * h);
      p.cubicTo(l + 0.6206 * w, t + 0.9507 * h, l + 0.7115 * w, t + 0.9107 * h, l + 0.7722 * w, t + 0.8348 * h);
      p.cubicTo(l + 0.821 * w, t + 0.7737 * h, l + 0.8876 * w, t + 0.6783 * h, l + 0.8824 * w, t + 0.5956 * h);
      p.cubicTo(l + 0.8785 * w, t + 0.5331 * h, l + 0.8228 * w, t + 0.5039 * h, l + 0.7664 * w, t + 0.5009 * h);
      p.cubicTo(l + 0.6839 * w, t + 0.4966 * h, l + 0.6071 * w, t + 0.5444 * h, l + 0.5528 * w, t + 0.6021 * h);
      p.cubicTo(l + 0.4636 * w, t + 0.6968 * h, l + 0.3885 * w, t + 0.8268 * h, l + 0.3487 * w, t + 0.9511 * h);
      p.cubicTo(l + 0.3386 * w, t + 0.9823 * h, l + 0.3707 * w, t + 0.9355 * h, l + 0.3739 * w, t + 0.9305 * h);
      p.cubicTo(l + 0.3944 * w, t + 0.8994 * h, l + 0.4179 * w, t + 0.8643 * h, l + 0.4294 * w, t + 0.8285 * h);
      p.lineTo(l + 0.4294 * w, t + 0.8285 * h);
      p.moveTo(l + 0.3211 * w, t + 0.1485 * h);
      p.cubicTo(l + 0.3089 * w, t + 0.4203 * h, l + 0.3072 * w, t + 0.701 * h, l + 0.353 * w, t + 0.9697 * h);
      p.cubicTo(l + 0.3523 * w, t + 0.9657 * h, l + 0.3986 * w, t + 0.9079 * h, l + 0.4028 * w, t + 0.9005 * h);
      p.cubicTo(l + 0.4131 * w, t + 0.8827 * h, l + 0.4417 * w, t + 0.8451 * h, l + 0.4379 * w, t + 0.8228 * h);
      p.cubicTo(l + 0.3926 * w, t + 0.5567 * h, l + 0.3948 * w, t + 0.2781 * h, l + 0.4069 * w, t + 0.009 * h);
      p.cubicTo(l + 0.4073 * w, t + 0.0 * h, l + 0.3713 * w, t + 0.05 * h, l + 0.3682 * w, t + 0.0551 * h);
      p.cubicTo(l + 0.3533 * w, t + 0.0792 * h, l + 0.3224 * w, t + 0.1188 * h, l + 0.3211 * w, t + 0.1485 * h);
      p.lineTo(l + 0.3211 * w, t + 0.1485 * h);
      p.moveTo(l + 0.5672 * w, t + 0.4169 * h);
      p.cubicTo(l + 0.5582 * w, t + 0.4259 * h, l + 0.5437 * w, t + 0.4259 * h, l + 0.5348 * w, t + 0.4169 * h);
      p.lineTo(l + 0.4795 * w, t + 0.3616 * h);
      p.cubicTo(l + 0.4705 * w, t + 0.3527 * h, l + 0.4705 * w, t + 0.3382 * h, l + 0.4795 * w, t + 0.3292 * h);
      p.lineTo(l + 0.5348 * w, t + 0.2739 * h);
      p.cubicTo(l + 0.5437 * w, t + 0.265 * h, l + 0.5582 * w, t + 0.265 * h, l + 0.5672 * w, t + 0.2739 * h);
      p.lineTo(l + 0.6225 * w, t + 0.3292 * h);
      p.cubicTo(l + 0.6314 * w, t + 0.3382 * h, l + 0.6314 * w, t + 0.3527 * h, l + 0.6225 * w, t + 0.3616 * h);
      p.lineTo(l + 0.5672 * w, t + 0.4169 * h);
      return p;
    },
    'ع': (Rect r) {
      final p = Path();
      final l = r.left, t = r.top, w = r.width, h = r.height;
      p.moveTo(l + 0.6058 * w, t + 0.0628 * h);
      p.cubicTo(l + 0.5534 * w, t + 0.0234 * h, l + 0.4864 * w, t + 0.0 * h, l + 0.4208 * w, t + 0.0082 * h);
      p.cubicTo(l + 0.3201 * w, t + 0.0209 * h, l + 0.2524 * w, t + 0.1552 * h, l + 0.2251 * w, t + 0.24 * h);
      p.cubicTo(l + 0.199 * w, t + 0.3214 * h, l + 0.2754 * w, t + 0.4209 * h, l + 0.3528 * w, t + 0.4386 * h);
      p.cubicTo(l + 0.4144 * w, t + 0.4526 * h, l + 0.4863 * w, t + 0.441 * h, l + 0.547 * w, t + 0.4264 * h);
      p.cubicTo(l + 0.5771 * w, t + 0.3742 * h, l + 0.6072 * w, t + 0.3221 * h, l + 0.6373 * w, t + 0.27 * h);
      p.cubicTo(l + 0.5505 * w, t + 0.2942 * h, l + 0.4637 * w, t + 0.3337 * h, l + 0.3929 * w, t + 0.3896 * h);
      p.cubicTo(l + 0.3371 * w, t + 0.4337 * h, l + 0.2992 * w, t + 0.4991 * h, l + 0.2659 * w, t + 0.5605 * h);
      p.cubicTo(l + 0.2263 * w, t + 0.6338 * h, l + 0.2041 * w, t + 0.7009 * h, l + 0.2326 * w, t + 0.7822 * h);
      p.cubicTo(l + 0.309 * w, t + 1.0 * h, l + 0.5587 * w, t + 0.961 * h, l + 0.7107 * w, t + 0.8549 * h);
      p.cubicTo(l + 0.7375 * w, t + 0.8361 * h, l + 0.7567 * w, t + 0.7894 * h, l + 0.7717 * w, t + 0.7618 * h);
      p.cubicTo(l + 0.7748 * w, t + 0.756 * h, l + 0.801 * w, t + 0.6965 * h, l + 0.7936 * w, t + 0.7017 * h);
      p.cubicTo(l + 0.6854 * w, t + 0.7772 * h, l + 0.5251 * w, t + 0.8278 * h, l + 0.4086 * w, t + 0.744 * h);
      p.cubicTo(l + 0.3635 * w, t + 0.7116 * h, l + 0.3344 * w, t + 0.6586 * h, l + 0.3165 * w, t + 0.6074 * h);
      p.cubicTo(l + 0.3114 * w, t + 0.5912 * h, l + 0.3087 * w, t + 0.5746 * h, l + 0.3083 * w, t + 0.5576 * h);
      p.cubicTo(l + 0.3057 * w, t + 0.5147 * h, l + 0.338 * w, t + 0.497 * h, l + 0.2767 * w, t + 0.5748 * h);
      p.cubicTo(l + 0.2949 * w, t + 0.5517 * h, l + 0.3206 * w, t + 0.5338 * h, l + 0.3447 * w, t + 0.5173 * h);
      p.cubicTo(l + 0.405 * w, t + 0.4758 * h, l + 0.4766 * w, t + 0.446 * h, l + 0.547 * w, t + 0.4264 * h);
      p.cubicTo(l + 0.5687 * w, t + 0.4203 * h, l + 0.5901 * w, t + 0.3698 * h, l + 0.6 * w, t + 0.3527 * h);
      p.cubicTo(l + 0.6035 * w, t + 0.3466 * h, l + 0.6359 * w, t + 0.2703 * h, l + 0.6373 * w, t + 0.27 * h);
      p.cubicTo(l + 0.5991 * w, t + 0.2792 * h, l + 0.5599 * w, t + 0.2842 * h, l + 0.5208 * w, t + 0.2865 * h);
      p.cubicTo(l + 0.4461 * w, t + 0.2908 * h, l + 0.3954 * w, t + 0.2746 * h, l + 0.3492 * w, t + 0.2152 * h);
      p.cubicTo(l + 0.3388 * w, t + 0.2018 * h, l + 0.331 * w, t + 0.1868 * h, l + 0.3235 * w, t + 0.1716 * h);
      p.cubicTo(l + 0.3191 * w, t + 0.1619 * h, l + 0.3158 * w, t + 0.1519 * h, l + 0.3135 * w, t + 0.1415 * h);
      p.cubicTo(l + 0.3143 * w, t + 0.085 * h, l + 0.2973 * w, t + 0.1034 * h, l + 0.2622 * w, t + 0.1966 * h);
      p.cubicTo(l + 0.2957 * w, t + 0.1644 * h, l + 0.3446 * w, t + 0.1594 * h, l + 0.3883 * w, t + 0.1645 * h);
      p.cubicTo(l + 0.433 * w, t + 0.1698 * h, l + 0.4797 * w, t + 0.1922 * h, l + 0.5156 * w, t + 0.2192 * h);
      p.cubicTo(l + 0.5208 * w, t + 0.2232 * h, l + 0.6221 * w, t + 0.075 * h, l + 0.6058 * w, t + 0.0628 * h);
      p.lineTo(l + 0.6058 * w, t + 0.0628 * h);
      return p;
    },
    'غ': (Rect r) {
      final p = Path();
      final l = r.left, t = r.top, w = r.width, h = r.height;
      p.moveTo(l + 0.5869 * w, t + 0.2303 * h);
      p.cubicTo(l + 0.5438 * w, t + 0.198 * h, l + 0.4888 * w, t + 0.1787 * h, l + 0.4349 * w, t + 0.1855 * h);
      p.cubicTo(l + 0.3522 * w, t + 0.1959 * h, l + 0.2967 * w, t + 0.3062 * h, l + 0.2743 * w, t + 0.3759 * h);
      p.cubicTo(l + 0.2528 * w, t + 0.4427 * h, l + 0.3155 * w, t + 0.5244 * h, l + 0.3791 * w, t + 0.5389 * h);
      p.cubicTo(l + 0.4297 * w, t + 0.5504 * h, l + 0.4888 * w, t + 0.5409 * h, l + 0.5386 * w, t + 0.5289 * h);
      p.cubicTo(l + 0.5633 * w, t + 0.4861 * h, l + 0.588 * w, t + 0.4433 * h, l + 0.6128 * w, t + 0.4005 * h);
      p.cubicTo(l + 0.5415 * w, t + 0.4203 * h, l + 0.4701 * w, t + 0.4528 * h, l + 0.412 * w, t + 0.4987 * h);
      p.cubicTo(l + 0.3662 * w, t + 0.5349 * h, l + 0.3351 * w, t + 0.5886 * h, l + 0.3078 * w, t + 0.6391 * h);
      p.cubicTo(l + 0.2752 * w, t + 0.6993 * h, l + 0.257 * w, t + 0.7543 * h, l + 0.2804 * w, t + 0.8211 * h);
      p.cubicTo(l + 0.3431 * w, t + 1.0 * h, l + 0.5482 * w, t + 0.9679 * h, l + 0.673 * w, t + 0.8808 * h);
      p.cubicTo(l + 0.695 * w, t + 0.8654 * h, l + 0.7108 * w, t + 0.8271 * h, l + 0.7231 * w, t + 0.8044 * h);
      p.cubicTo(l + 0.7257 * w, t + 0.7996 * h, l + 0.7472 * w, t + 0.7507 * h, l + 0.7411 * w, t + 0.755 * h);
      p.cubicTo(l + 0.6522 * w, t + 0.817 * h, l + 0.5207 * w, t + 0.8586 * h, l + 0.4249 * w, t + 0.7898 * h);
      p.cubicTo(l + 0.3879 * w, t + 0.7631 * h, l + 0.364 * w, t + 0.7196 * h, l + 0.3493 * w, t + 0.6776 * h);
      p.cubicTo(l + 0.3451 * w, t + 0.6643 * h, l + 0.3429 * w, t + 0.6506 * h, l + 0.3426 * w, t + 0.6367 * h);
      p.cubicTo(l + 0.3404 * w, t + 0.6015 * h, l + 0.3669 * w, t + 0.5869 * h, l + 0.3166 * w, t + 0.6508 * h);
      p.cubicTo(l + 0.3316 * w, t + 0.6318 * h, l + 0.3526 * w, t + 0.6171 * h, l + 0.3724 * w, t + 0.6036 * h);
      p.cubicTo(l + 0.422 * w, t + 0.5695 * h, l + 0.4808 * w, t + 0.545 * h, l + 0.5386 * w, t + 0.5289 * h);
      p.cubicTo(l + 0.5564 * w, t + 0.5239 * h, l + 0.574 * w, t + 0.4825 * h, l + 0.5821 * w, t + 0.4684 * h);
      p.cubicTo(l + 0.585 * w, t + 0.4634 * h, l + 0.6116 * w, t + 0.4007 * h, l + 0.6128 * w, t + 0.4005 * h);
      p.cubicTo(l + 0.5814 * w, t + 0.408 * h, l + 0.5492 * w, t + 0.4121 * h, l + 0.517 * w, t + 0.414 * h);
      p.cubicTo(l + 0.4557 * w, t + 0.4176 * h, l + 0.4141 * w, t + 0.4043 * h, l + 0.3762 * w, t + 0.3555 * h);
      p.cubicTo(l + 0.3676 * w, t + 0.3444 * h, l + 0.3612 * w, t + 0.3321 * h, l + 0.355 * w, t + 0.3197 * h);
      p.cubicTo(l + 0.3514 * w, t + 0.3117 * h, l + 0.3487 * w, t + 0.3035 * h, l + 0.3468 * w, t + 0.2949 * h);
      p.cubicTo(l + 0.3475 * w, t + 0.2486 * h, l + 0.3335 * w, t + 0.2636 * h, l + 0.3047 * w, t + 0.3402 * h);
      p.cubicTo(l + 0.3322 * w, t + 0.3138 * h, l + 0.3723 * w, t + 0.3096 * h, l + 0.4082 * w, t + 0.3138 * h);
      p.cubicTo(l + 0.445 * w, t + 0.3182 * h, l + 0.4833 * w, t + 0.3366 * h, l + 0.5128 * w, t + 0.3588 * h);
      p.cubicTo(l + 0.5171 * w, t + 0.362 * h, l + 0.6003 * w, t + 0.2404 * h, l + 0.5869 * w, t + 0.2303 * h);
      p.lineTo(l + 0.5869 * w, t + 0.2303 * h);
      p.moveTo(l + 0.4918 * w, t + 0.1328 * h);
      p.cubicTo(l + 0.484 * w, t + 0.1406 * h, l + 0.4713 * w, t + 0.1406 * h, l + 0.4635 * w, t + 0.1328 * h);
      p.lineTo(l + 0.4152 * w, t + 0.0845 * h);
      p.cubicTo(l + 0.4073 * w, t + 0.0766 * h, l + 0.4073 * w, t + 0.064 * h, l + 0.4152 * w, t + 0.0562 * h);
      p.lineTo(l + 0.4635 * w, t + 0.0078 * h);
      p.cubicTo(l + 0.4713 * w, t + 0.0 * h, l + 0.484 * w, t + 0.0 * h, l + 0.4918 * w, t + 0.0078 * h);
      p.lineTo(l + 0.5401 * w, t + 0.0562 * h);
      p.cubicTo(l + 0.5479 * w, t + 0.064 * h, l + 0.5479 * w, t + 0.0766 * h, l + 0.5401 * w, t + 0.0845 * h);
      p.lineTo(l + 0.4918 * w, t + 0.1328 * h);
      return p;
    },
    'ف': (Rect r) {
      final p = Path();
      final l = r.left, t = r.top, w = r.width, h = r.height;
      // Badan Fa: Kepala melingkar + piringan perahu mendatar
      p.moveTo(l + 0.68 * w, t + 0.44 * h);
      p.cubicTo(l + 0.68 * w, t + 0.32 * h, l + 0.78 * w, t + 0.30 * h, l + 0.85 * w, t + 0.36 * h);
      p.cubicTo(l + 0.90 * w, t + 0.41 * h, l + 0.88 * w, t + 0.50 * h, l + 0.81 * w, t + 0.54 * h);
      p.cubicTo(l + 0.76 * w, t + 0.57 * h, l + 0.74 * w, t + 0.64 * h, l + 0.71 * w, t + 0.72 * h);
      p.cubicTo(l + 0.58 * w, t + 0.78 * h, l + 0.35 * w, t + 0.78 * h, l + 0.20 * w, t + 0.74 * h);
      p.cubicTo(l + 0.14 * w, t + 0.70 * h, l + 0.11 * w, t + 0.62 * h, l + 0.12 * w, t + 0.52 * h);
      p.cubicTo(l + 0.13 * w, t + 0.48 * h, l + 0.15 * w, t + 0.50 * h, l + 0.15 * w, t + 0.54 * h);
      p.cubicTo(l + 0.16 * w, t + 0.64 * h, l + 0.25 * w, t + 0.70 * h, l + 0.40 * w, t + 0.71 * h);
      p.cubicTo(l + 0.55 * w, t + 0.71 * h, l + 0.66 * w, t + 0.68 * h, l + 0.68 * w, t + 0.56 * h);
      p.cubicTo(l + 0.66 * w, t + 0.52 * h, l + 0.68 * w, t + 0.46 * h, l + 0.68 * w, t + 0.44 * h);
      p.close();

      // Lubang dalam kepala Fa
      p.moveTo(l + 0.73 * w, t + 0.43 * h);
      p.cubicTo(l + 0.73 * w, t + 0.38 * h, l + 0.78 * w, t + 0.36 * h, l + 0.81 * w, t + 0.40 * h);
      p.cubicTo(l + 0.83 * w, t + 0.44 * h, l + 0.81 * w, t + 0.48 * h, l + 0.77 * w, t + 0.48 * h);
      p.cubicTo(l + 0.74 * w, t + 0.48 * h, l + 0.73 * w, t + 0.46 * h, l + 0.73 * w, t + 0.43 * h);
      p.close();

      // Titik Fa di atas kepala (berpusat di 0.75, 0.14)
      p.moveTo(l + 0.75 * w, t + 0.08 * h);
      p.lineTo(l + 0.80 * w, t + 0.14 * h);
      p.lineTo(l + 0.75 * w, t + 0.20 * h);
      p.lineTo(l + 0.70 * w, t + 0.14 * h);
      p.close();

      return p;
    },
    'ق': (Rect r) {
      final p = Path();
      final l = r.left, t = r.top, w = r.width, h = r.height;
      // Badan Qaf: Kepala melingkar + mangkok bulat turun ke bawah garis
      p.moveTo(l + 0.66 * w, t + 0.40 * h);
      p.cubicTo(l + 0.66 * w, t + 0.28 * h, l + 0.76 * w, t + 0.26 * h, l + 0.83 * w, t + 0.32 * h);
      p.cubicTo(l + 0.88 * w, t + 0.37 * h, l + 0.86 * w, t + 0.46 * h, l + 0.79 * w, t + 0.50 * h);
      p.cubicTo(l + 0.76 * w, t + 0.54 * h, l + 0.73 * w, t + 0.62 * h, l + 0.70 * w, t + 0.72 * h);
      p.cubicTo(l + 0.64 * w, t + 0.86 * h, l + 0.45 * w, t + 0.92 * h, l + 0.30 * w, t + 0.88 * h);
      p.cubicTo(l + 0.18 * w, t + 0.82 * h, l + 0.13 * w, t + 0.68 * h, l + 0.14 * w, t + 0.50 * h);
      p.cubicTo(l + 0.15 * w, t + 0.46 * h, l + 0.18 * w, t + 0.48 * h, l + 0.18 * w, t + 0.53 * h);
      p.cubicTo(l + 0.19 * w, t + 0.65 * h, l + 0.26 * w, t + 0.78 * h, l + 0.36 * w, t + 0.81 * h);
      p.cubicTo(l + 0.48 * w, t + 0.83 * h, l + 0.61 * w, t + 0.76 * h, l + 0.65 * w, t + 0.64 * h);
      p.cubicTo(l + 0.67 * w, t + 0.56 * h, l + 0.66 * w, t + 0.45 * h, l + 0.66 * w, t + 0.40 * h);
      p.close();

      // Lubang dalam kepala Qaf
      p.moveTo(l + 0.71 * w, t + 0.39 * h);
      p.cubicTo(l + 0.71 * w, t + 0.34 * h, l + 0.76 * w, t + 0.32 * h, l + 0.79 * w, t + 0.36 * h);
      p.cubicTo(l + 0.81 * w, t + 0.40 * h, l + 0.79 * w, t + 0.44 * h, l + 0.75 * w, t + 0.44 * h);
      p.cubicTo(l + 0.72 * w, t + 0.44 * h, l + 0.71 * w, t + 0.42 * h, l + 0.71 * w, t + 0.39 * h);
      p.close();

      // Titik 1 Qaf di atas kiri (0.66, 0.13)
      p.moveTo(l + 0.66 * w, t + 0.08 * h);
      p.lineTo(l + 0.71 * w, t + 0.13 * h);
      p.lineTo(l + 0.66 * w, t + 0.18 * h);
      p.lineTo(l + 0.61 * w, t + 0.13 * h);
      p.close();

      // Titik 2 Qaf di atas kanan (0.80, 0.15)
      p.moveTo(l + 0.80 * w, t + 0.10 * h);
      p.lineTo(l + 0.85 * w, t + 0.15 * h);
      p.lineTo(l + 0.80 * w, t + 0.20 * h);
      p.lineTo(l + 0.75 * w, t + 0.15 * h);
      p.close();

      return p;
    },
    'ك': (Rect r) {
      final p = Path();
      final l = r.left, t = r.top, w = r.width, h = r.height;
      p.moveTo(l + 0.1648 * w, t + 0.9056 * h);
      p.cubicTo(l + 0.2145 * w, t + 1.0 * h, l + 0.3566 * w, t + 0.9884 * h, l + 0.4458 * w, t + 0.991 * h);
      p.cubicTo(l + 0.5121 * w, t + 0.9929 * h, l + 0.5797 * w, t + 0.9913 * h, l + 0.644 * w, t + 0.9735 * h);
      p.cubicTo(l + 0.7032 * w, t + 0.9572 * h, l + 0.7384 * w, t + 0.9183 * h, l + 0.7696 * w, t + 0.8674 * h);
      p.cubicTo(l + 0.8056 * w, t + 0.8089 * h, l + 0.8324 * w, t + 0.7512 * h, l + 0.8376 * w, t + 0.6823 * h);
      p.cubicTo(l + 0.8425 * w, t + 0.6158 * h, l + 0.8323 * w, t + 0.5479 * h, l + 0.8234 * w, t + 0.4822 * h);
      p.cubicTo(l + 0.8025 * w, t + 0.328 * h, l + 0.7664 * w, t + 0.1639 * h, l + 0.8111 * w, t + 0.0107 * h);
      p.cubicTo(l + 0.8142 * w, t + 0.0 * h, l + 0.8002 * w, t + 0.0167 * h, l + 0.802 * w, t + 0.0145 * h);
      p.cubicTo(l + 0.7921 * w, t + 0.0264 * h, l + 0.7837 * w, t + 0.0398 * h, l + 0.7756 * w, t + 0.053 * h);
      p.cubicTo(l + 0.7591 * w, t + 0.0798 * h, l + 0.7412 * w, t + 0.1084 * h, l + 0.7324 * w, t + 0.1388 * h);
      p.cubicTo(l + 0.6967 * w, t + 0.2608 * h, l + 0.7138 * w, t + 0.3907 * h, l + 0.7308 * w, t + 0.5144 * h);
      p.cubicTo(l + 0.7404 * w, t + 0.5843 * h, l + 0.7518 * w, t + 0.6538 * h, l + 0.7574 * w, t + 0.7242 * h);
      p.cubicTo(l + 0.7597 * w, t + 0.7529 * h, l + 0.7602 * w, t + 0.7817 * h, l + 0.7588 * w, t + 0.8104 * h);
      p.cubicTo(l + 0.7583 * w, t + 0.8215 * h, l + 0.7568 * w, t + 0.8325 * h, l + 0.7553 * w, t + 0.8435 * h);
      p.cubicTo(l + 0.7477 * w, t + 0.9 * h, l + 0.72 * w, t + 0.8743 * h, l + 0.7912 * w, t + 0.8015 * h);
      p.cubicTo(l + 0.7191 * w, t + 0.8752 * h, l + 0.5671 * w, t + 0.8582 * h, l + 0.4744 * w, t + 0.8541 * h);
      p.cubicTo(l + 0.3965 * w, t + 0.8508 * h, l + 0.2854 * w, t + 0.8515 * h, l + 0.2428 * w, t + 0.7706 * h);
      p.cubicTo(l + 0.2418 * w, t + 0.7687 * h, l + 0.1993 * w, t + 0.8304 * h, l + 0.1971 * w, t + 0.8342 * h);
      p.cubicTo(l + 0.1908 * w, t + 0.845 * h, l + 0.1575 * w, t + 0.8916 * h, l + 0.1648 * w, t + 0.9056 * h);
      p.lineTo(l + 0.1648 * w, t + 0.9056 * h);
      p.moveTo(l + 0.5799 * w, t + 0.3262 * h);
      p.cubicTo(l + 0.4983 * w, t + 0.3497 * h, l + 0.4605 * w, t + 0.4218 * h, l + 0.4265 * w, t + 0.495 * h);
      p.cubicTo(l + 0.4088 * w, t + 0.5331 * h, l + 0.4229 * w, t + 0.5577 * h, l + 0.4549 * w, t + 0.5813 * h);
      p.cubicTo(l + 0.4713 * w, t + 0.5933 * h, l + 0.4893 * w, t + 0.603 * h, l + 0.5061 * w, t + 0.6145 * h);
      p.cubicTo(l + 0.5265 * w, t + 0.6284 * h, l + 0.5288 * w, t + 0.6556 * h, l + 0.5457 * w, t + 0.6235 * h);
      p.cubicTo(l + 0.5614 * w, t + 0.5987 * h, l + 0.5771 * w, t + 0.5739 * h, l + 0.5928 * w, t + 0.5491 * h);
      p.cubicTo(l + 0.5681 * w, t + 0.5801 * h, l + 0.5148 * w, t + 0.5692 * h, l + 0.4808 * w, t + 0.5656 * h);
      p.cubicTo(l + 0.467 * w, t + 0.5641 * h, l + 0.4401 * w, t + 0.6204 * h, l + 0.435 * w, t + 0.6292 * h);
      p.cubicTo(l + 0.4331 * w, t + 0.6326 * h, l + 0.3986 * w, t + 0.7002 * h, l + 0.4028 * w, t + 0.7006 * h);
      p.cubicTo(l + 0.4405 * w, t + 0.7046 * h, l + 0.4785 * w, t + 0.7099 * h, l + 0.5126 * w, t + 0.6901 * h);
      p.cubicTo(l + 0.5325 * w, t + 0.6786 * h, l + 0.5474 * w, t + 0.6495 * h, l + 0.5587 * w, t + 0.631 * h);
      p.cubicTo(l + 0.5754 * w, t + 0.604 * h, l + 0.5951 * w, t + 0.5735 * h, l + 0.6049 * w, t + 0.543 * h);
      p.cubicTo(l + 0.6174 * w, t + 0.5038 * h, l + 0.6006 * w, t + 0.4898 * h, l + 0.5677 * w, t + 0.4686 * h);
      p.cubicTo(l + 0.5505 * w, t + 0.4575 * h, l + 0.5332 * w, t + 0.4472 * h, l + 0.5174 * w, t + 0.4341 * h);
      p.cubicTo(l + 0.5105 * w, t + 0.4285 * h, l + 0.5055 * w, t + 0.4217 * h, l + 0.5007 * w, t + 0.4142 * h);
      p.cubicTo(l + 0.4972 * w, t + 0.4088 * h, l + 0.4999 * w, t + 0.3863 * h, l + 0.4945 * w, t + 0.3978 * h);
      p.cubicTo(l + 0.4761 * w, t + 0.4296 * h, l + 0.4577 * w, t + 0.4615 * h, l + 0.4394 * w, t + 0.4933 * h);
      p.cubicTo(l + 0.4509 * w, t + 0.4764 * h, l + 0.4831 * w, t + 0.4666 * h, l + 0.5019 * w, t + 0.4612 * h);
      p.cubicTo(l + 0.5207 * w, t + 0.4558 * h, l + 0.539 * w, t + 0.4125 * h, l + 0.5476 * w, t + 0.3976 * h);
      p.cubicTo(l + 0.551 * w, t + 0.3918 * h, l + 0.5778 * w, t + 0.3268 * h, l + 0.5799 * w, t + 0.3262 * h);
      p.lineTo(l + 0.5799 * w, t + 0.3262 * h);
      return p;
    },
    'ل': (Rect r) {
      final p = Path();
      final l = r.left, t = r.top, w = r.width, h = r.height;
      p.moveTo(l + 0.6384 * w, t + 0.1526 * h);
      p.cubicTo(l + 0.6307 * w, t + 0.2211 * h, l + 0.6412 * w, t + 0.2941 * h, l + 0.6478 * w, t + 0.362 * h);
      p.cubicTo(l + 0.6568 * w, t + 0.4552 * h, l + 0.6715 * w, t + 0.5478 * h, l + 0.6804 * w, t + 0.641 * h);
      p.cubicTo(l + 0.6872 * w, t + 0.7126 * h, l + 0.6929 * w, t + 0.7913 * h, l + 0.67 * w, t + 0.8607 * h);
      p.cubicTo(l + 0.6973 * w, t + 0.7779 * h, l + 0.7275 * w, t + 0.7793 * h, l + 0.6888 * w, t + 0.8071 * h);
      p.cubicTo(l + 0.6764 * w, t + 0.816 * h, l + 0.6616 * w, t + 0.8214 * h, l + 0.6473 * w, t + 0.8265 * h);
      p.cubicTo(l + 0.616 * w, t + 0.8377 * h, l + 0.5819 * w, t + 0.841 * h, l + 0.5489 * w, t + 0.8426 * h);
      p.cubicTo(l + 0.4913 * w, t + 0.8454 * h, l + 0.4226 * w, t + 0.8372 * h, l + 0.3766 * w, t + 0.7995 * h);
      p.cubicTo(l + 0.3298 * w, t + 0.7611 * h, l + 0.3404 * w, t + 0.6818 * h, l + 0.3498 * w, t + 0.6301 * h);
      p.cubicTo(l + 0.3548 * w, t + 0.6026 * h, l + 0.3629 * w, t + 0.5758 * h, l + 0.3719 * w, t + 0.5494 * h);
      p.cubicTo(l + 0.3754 * w, t + 0.5394 * h, l + 0.3837 * w, t + 0.5187 * h, l + 0.3814 * w, t + 0.5241 * h);
      p.cubicTo(l + 0.3931 * w, t + 0.497 * h, l + 0.3881 * w, t + 0.4935 * h, l + 0.3706 * w, t + 0.5178 * h);
      p.cubicTo(l + 0.3467 * w, t + 0.5511 * h, l + 0.3249 * w, t + 0.5878 * h, l + 0.3086 * w, t + 0.6253 * h);
      p.cubicTo(l + 0.2697 * w, t + 0.7147 * h, l + 0.2164 * w, t + 0.8572 * h, l + 0.2823 * w, t + 0.9446 * h);
      p.cubicTo(l + 0.3241 * w, t + 1.0 * h, l + 0.4303 * w, t + 0.9977 * h, l + 0.4906 * w, t + 0.9925 * h);
      p.cubicTo(l + 0.565 * w, t + 0.9862 * h, l + 0.6202 * w, t + 0.9565 * h, l + 0.6643 * w, t + 0.8972 * h);
      p.cubicTo(l + 0.7154 * w, t + 0.8284 * h, l + 0.7588 * w, t + 0.7457 * h, l + 0.7707 * w, t + 0.6602 * h);
      p.cubicTo(l + 0.7836 * w, t + 0.5671 * h, l + 0.767 * w, t + 0.4691 * h, l + 0.7553 * w, t + 0.3767 * h);
      p.cubicTo(l + 0.7405 * w, t + 0.2588 * h, l + 0.7135 * w, t + 0.1283 * h, l + 0.727 * w, t + 0.0085 * h);
      p.cubicTo(l + 0.728 * w, t + 0.0 * h, l + 0.6905 * w, t + 0.0505 * h, l + 0.687 * w, t + 0.0561 * h);
      p.cubicTo(l + 0.6707 * w, t + 0.0827 * h, l + 0.642 * w, t + 0.1204 * h, l + 0.6384 * w, t + 0.1526 * h);
      p.lineTo(l + 0.6384 * w, t + 0.1526 * h);
      return p;
    },
    'م': (Rect r) {
      final p = Path();
      final l = r.left, t = r.top, w = r.width, h = r.height;
      // Kepala Mim: segitiga kaligrafi Naskh
      p.moveTo(l + 0.44 * w, t + 0.28 * h);
      p.cubicTo(l + 0.48 * w, t + 0.20 * h, l + 0.58 * w, t + 0.16 * h, l + 0.68 * w, t + 0.21 * h);
      p.cubicTo(l + 0.75 * w, t + 0.25 * h, l + 0.74 * w, t + 0.33 * h, l + 0.67 * w, t + 0.38 * h);
      p.cubicTo(l + 0.59 * w, t + 0.42 * h, l + 0.48 * w, t + 0.38 * h, l + 0.43 * w, t + 0.34 * h);
      // Kaki Mim turun vertikal lurus ke bawah
      p.cubicTo(l + 0.41 * w, t + 0.45 * h, l + 0.40 * w, t + 0.65 * h, l + 0.37 * w, t + 0.94 * h);
      p.cubicTo(l + 0.35 * w, t + 0.94 * h, l + 0.34 * w, t + 0.75 * h, l + 0.35 * w, t + 0.55 * h);
      p.cubicTo(l + 0.36 * w, t + 0.40 * h, l + 0.37 * w, t + 0.33 * h, l + 0.44 * w, t + 0.28 * h);
      p.close();

      // Ruang dalam segitiga kepala Mim
      p.moveTo(l + 0.49 * w, t + 0.28 * h);
      p.cubicTo(l + 0.53 * w, t + 0.22 * h, l + 0.62 * w, t + 0.24 * h, l + 0.66 * w, t + 0.28 * h);
      p.cubicTo(l + 0.66 * w, t + 0.33 * h, l + 0.58 * w, t + 0.35 * h, l + 0.51 * w, t + 0.33 * h);
      p.cubicTo(l + 0.48 * w, t + 0.31 * h, l + 0.48 * w, t + 0.29 * h, l + 0.49 * w, t + 0.28 * h);
      p.close();

      return p;
    },
    'ن': (Rect r) {
      final p = Path();
      final l = r.left, t = r.top, w = r.width, h = r.height;
      p.moveTo(l + 0.7254 * w, t + 0.3514 * h);
      p.cubicTo(l + 0.7806 * w, t + 0.414 * h, l + 0.8217 * w, t + 0.492 * h, l + 0.843 * w, t + 0.5724 * h);
      p.cubicTo(l + 0.8523 * w, t + 0.6075 * h, l + 0.8535 * w, t + 0.6435 * h, l + 0.8502 * w, t + 0.6795 * h);
      p.cubicTo(l + 0.8453 * w, t + 0.733 * h, l + 0.8193 * w, t + 0.7104 * h, l + 0.876 * w, t + 0.6518 * h);
      p.cubicTo(l + 0.8612 * w, t + 0.6671 * h, l + 0.8437 * w, t + 0.6798 * h, l + 0.8265 * w, t + 0.6921 * h);
      p.cubicTo(l + 0.7561 * w, t + 0.7428 * h, l + 0.665 * w, t + 0.7598 * h, l + 0.5803 * w, t + 0.7657 * h);
      p.cubicTo(l + 0.4507 * w, t + 0.7746 * h, l + 0.2872 * w, t + 0.7522 * h, l + 0.1974 * w, t + 0.6497 * h);
      p.cubicTo(l + 0.1416 * w, t + 0.586 * h, l + 0.1108 * w, t + 0.5053 * h, l + 0.1251 * w, t + 0.421 * h);
      p.cubicTo(l + 0.1375 * w, t + 0.3475 * h, l + 0.0545 * w, t + 0.5146 * h, l + 0.0924 * w, t + 0.4697 * h);
      p.cubicTo(l + 0.0983 * w, t + 0.4627 * h, l + 0.105 * w, t + 0.4564 * h, l + 0.1116 * w, t + 0.4501 * h);
      p.cubicTo(l + 0.1191 * w, t + 0.4429 * h, l + 0.1271 * w, t + 0.4362 * h, l + 0.1354 * w, t + 0.4301 * h);
      p.cubicTo(l + 0.1689 * w, t + 0.4058 * h, l + 0.1925 * w, t + 0.3492 * h, l + 0.2114 * w, t + 0.3142 * h);
      p.cubicTo(l + 0.2154 * w, t + 0.3068 * h, l + 0.2477 * w, t + 0.2327 * h, l + 0.2387 * w, t + 0.2392 * h);
      p.cubicTo(l + 0.1963 * w, t + 0.2701 * h, l + 0.1628 * w, t + 0.314 * h, l + 0.1338 * w, t + 0.357 * h);
      p.cubicTo(l + 0.0759 * w, t + 0.443 * h, l + 0.0098 * w, t + 0.5463 * h, l + 0.0068 * w, t + 0.6533 * h);
      p.cubicTo(l + 0.0 * w, t + 0.8926 * h, l + 0.2599 * w, t + 0.9639 * h, l + 0.4484 * w, t + 0.9613 * h);
      p.cubicTo(l + 0.5509 * w, t + 0.9599 * h, l + 0.6543 * w, t + 0.9325 * h, l + 0.738 * w, t + 0.8724 * h);
      p.cubicTo(l + 0.8376 * w, t + 0.8008 * h, l + 0.908 * w, t + 0.6669 * h, l + 0.9495 * w, t + 0.5549 * h);
      p.cubicTo(l + 1.0 * w, t + 0.4188 * h, l + 0.9285 * w, t + 0.2594 * h, l + 0.8379 * w, t + 0.1566 * h);
      p.cubicTo(l + 0.8424 * w, t + 0.1616 * h, l + 0.6998 * w, t + 0.3223 * h, l + 0.7254 * w, t + 0.3514 * h);
      p.lineTo(l + 0.7254 * w, t + 0.3514 * h);
      p.moveTo(l + 0.5494 * w, t + 0.2375 * h);
      p.cubicTo(l + 0.5376 * w, t + 0.2494 * h, l + 0.5183 * w, t + 0.2494 * h, l + 0.5065 * w, t + 0.2375 * h);
      p.lineTo(l + 0.4332 * w, t + 0.1642 * h);
      p.cubicTo(l + 0.4213 * w, t + 0.1523 * h, l + 0.4213 * w, t + 0.1331 * h, l + 0.4332 * w, t + 0.1213 * h);
      p.lineTo(l + 0.5065 * w, t + 0.0479 * h);
      p.cubicTo(l + 0.5183 * w, t + 0.0361 * h, l + 0.5376 * w, t + 0.0361 * h, l + 0.5494 * w, t + 0.0479 * h);
      p.lineTo(l + 0.6227 * w, t + 0.1213 * h);
      p.cubicTo(l + 0.6346 * w, t + 0.1331 * h, l + 0.6346 * w, t + 0.1523 * h, l + 0.6227 * w, t + 0.1642 * h);
      p.lineTo(l + 0.5494 * w, t + 0.2375 * h);
      return p;
    },
    'و': (Rect r) {
      final p = Path();
      final l = r.left, t = r.top, w = r.width, h = r.height;
      p.moveTo(l + 0.9121 * w, t + 0.326 * h);
      p.cubicTo(l + 0.8563 * w, t + 0.3729 * h, l + 0.7815 * w, t + 0.3678 * h, l + 0.7192 * w, t + 0.3388 * h);
      p.cubicTo(l + 0.6793 * w, t + 0.3202 * h, l + 0.6476 * w, t + 0.286 * h, l + 0.623 * w, t + 0.2506 * h);
      p.cubicTo(l + 0.6092 * w, t + 0.2305 * h, l + 0.6014 * w, t + 0.2073 * h, l + 0.5953 * w, t + 0.1839 * h);
      p.cubicTo(l + 0.5919 * w, t + 0.1678 * h, l + 0.5912 * w, t + 0.1515 * h, l + 0.5932 * w, t + 0.1353 * h);
      p.cubicTo(l + 0.5345 * w, t + 0.2066 * h, l + 0.522 * w, t + 0.2279 * h, l + 0.5559 * w, t + 0.199 * h);
      p.cubicTo(l + 0.6181 * w, t + 0.1496 * h, l + 0.7193 * w, t + 0.1898 * h, l + 0.7764 * w, t + 0.2269 * h);
      p.cubicTo(l + 0.839 * w, t + 0.2676 * h, l + 0.8528 * w, t + 0.3373 * h, l + 0.8483 * w, t + 0.4073 * h);
      p.cubicTo(l + 0.8455 * w, t + 0.4503 * h, l + 0.8348 * w, t + 0.4928 * h, l + 0.8242 * w, t + 0.5344 * h);
      p.cubicTo(l + 0.8159 * w, t + 0.5667 * h, l + 0.8058 * w, t + 0.5986 * h, l + 0.7951 * w, t + 0.6301 * h);
      p.cubicTo(l + 0.7913 * w, t + 0.641 * h, l + 0.7872 * w, t + 0.6517 * h, l + 0.7827 * w, t + 0.6623 * h);
      p.cubicTo(l + 0.7985 * w, t + 0.6379 * h, l + 0.7987 * w, t + 0.6359 * h, l + 0.7832 * w, t + 0.6563 * h);
      p.cubicTo(l + 0.7173 * w, t + 0.7365 * h, l + 0.6184 * w, t + 0.7757 * h, l + 0.5168 * w, t + 0.7806 * h);
      p.cubicTo(l + 0.386 * w, t + 0.7867 * h, l + 0.2458 * w, t + 0.7161 * h, l + 0.1643 * w, t + 0.6145 * h);
      p.cubicTo(l + 0.1698 * w, t + 0.6214 * h, l + 0.0415 * w, t + 0.7582 * h, l + 0.0646 * w, t + 0.787 * h);
      p.cubicTo(l + 0.19 * w, t + 0.9433 * h, l + 0.4183 * w, t + 1.0 * h, l + 0.596 * w, t + 0.9041 * h);
      p.cubicTo(l + 0.7051 * w, t + 0.8452 * h, l + 0.7751 * w, t + 0.7225 * h, l + 0.8311 * w, t + 0.6171 * h);
      p.cubicTo(l + 0.8917 * w, t + 0.5028 * h, l + 0.9359 * w, t + 0.3726 * h, l + 0.949 * w, t + 0.2436 * h);
      p.cubicTo(l + 0.9585 * w, t + 0.1491 * h, l + 0.924 * w, t + 0.077 * h, l + 0.8393 * w, t + 0.0332 * h);
      p.cubicTo(l + 0.7939 * w, t + 0.0097 * h, l + 0.7417 * w, t + 0.0 * h, l + 0.6915 * w, t + 0.0101 * h);
      p.cubicTo(l + 0.6356 * w, t + 0.0214 * h, l + 0.6008 * w, t + 0.0763 * h, l + 0.5733 * w, t + 0.121 * h);
      p.cubicTo(l + 0.5008 * w, t + 0.239 * h, l + 0.4514 * w, t + 0.3528 * h, l + 0.5587 * w, t + 0.4666 * h);
      p.cubicTo(l + 0.6252 * w, t + 0.5372 * h, l + 0.7428 * w, t + 0.5605 * h, l + 0.8206 * w, t + 0.495 * h);
      p.cubicTo(l + 0.85 * w, t + 0.4703 * h, l + 0.8701 * w, t + 0.4253 * h, l + 0.8879 * w, t + 0.3924 * h);
      p.cubicTo(l + 0.8918 * w, t + 0.3852 * h, l + 0.9187 * w, t + 0.3205 * h, l + 0.9121 * w, t + 0.326 * h);
      p.lineTo(l + 0.9121 * w, t + 0.326 * h);
      return p;
    },
    'ه': (Rect r) {
      final p = Path();
      final l = r.left, t = r.top, w = r.width, h = r.height;
      // Siluet luar Ha simpul (هـ)
      p.moveTo(l + 0.60 * w, t + 0.16 * h);
      p.cubicTo(l + 0.74 * w, t + 0.28 * h, l + 0.85 * w, t + 0.44 * h, l + 0.82 * w, t + 0.60 * h);
      p.cubicTo(l + 0.80 * w, t + 0.72 * h, l + 0.68 * w, t + 0.80 * h, l + 0.52 * w, t + 0.80 * h);
      // Ekor dasar mendatar ke kiri
      p.lineTo(l + 0.14 * w, t + 0.80 * h);
      p.cubicTo(l + 0.12 * w, t + 0.80 * h, l + 0.12 * w, t + 0.72 * h, l + 0.16 * w, t + 0.72 * h);
      p.lineTo(l + 0.46 * w, t + 0.72 * h);
      // Simpul mata dalam
      p.cubicTo(l + 0.42 * w, t + 0.64 * h, l + 0.40 * w, t + 0.52 * h, l + 0.45 * w, t + 0.42 * h);
      p.cubicTo(l + 0.52 * w, t + 0.32 * h, l + 0.64 * w, t + 0.34 * h, l + 0.70 * w, t + 0.44 * h);
      p.cubicTo(l + 0.74 * w, t + 0.52 * h, l + 0.70 * w, t + 0.64 * h, l + 0.60 * w, t + 0.70 * h);
      p.cubicTo(l + 0.68 * w, t + 0.58 * h, l + 0.68 * w, t + 0.40 * h, l + 0.58 * w, t + 0.26 * h);
      p.cubicTo(l + 0.56 * w, t + 0.22 * h, l + 0.56 * w, t + 0.18 * h, l + 0.60 * w, t + 0.16 * h);
      p.close();

      // Lubang dalam mata simpul Ha
      p.moveTo(l + 0.54 * w, t + 0.44 * h);
      p.cubicTo(l + 0.48 * w, t + 0.48 * h, l + 0.48 * w, t + 0.58 * h, l + 0.52 * w, t + 0.64 * h);
      p.cubicTo(l + 0.58 * w, t + 0.64 * h, l + 0.64 * w, t + 0.58 * h, l + 0.62 * w, t + 0.50 * h);
      p.cubicTo(l + 0.60 * w, t + 0.44 * h, l + 0.56 * w, t + 0.42 * h, l + 0.54 * w, t + 0.44 * h);
      p.close();

      return p;
    },
    'ي': (Rect r) {
      final p = Path();
      final l = r.left, t = r.top, w = r.width, h = r.height;
      p.moveTo(l + 0.8941 * w, t + 0.0119 * h);
      p.cubicTo(l + 0.7327 * w, t + 0.0 * h, l + 0.6477 * w, t + 0.1303 * h, l + 0.5843 * w, t + 0.2591 * h);
      p.cubicTo(l + 0.5583 * w, t + 0.3121 * h, l + 0.5213 * w, t + 0.3914 * h, l + 0.5972 * w, t + 0.4178 * h);
      p.cubicTo(l + 0.6519 * w, t + 0.4368 * h, l + 0.7745 * w, t + 0.4269 * h, l + 0.7673 * w, t + 0.515 * h);
      p.cubicTo(l + 0.7666 * w, t + 0.5237 * h, l + 0.7643 * w, t + 0.5322 * h, l + 0.7614 * w, t + 0.5403 * h);
      p.cubicTo(l + 0.7968 * w, t + 0.4858 * h, l + 0.8052 * w, t + 0.4698 * h, l + 0.7865 * w, t + 0.4926 * h);
      p.cubicTo(l + 0.7801 * w, t + 0.5 * h, l + 0.7725 * w, t + 0.5064 * h, l + 0.7651 * w, t + 0.5128 * h);
      p.cubicTo(l + 0.7304 * w, t + 0.543 * h, l + 0.6872 * w, t + 0.5616 * h, l + 0.6436 * w, t + 0.5747 * h);
      p.cubicTo(l + 0.5577 * w, t + 0.6004 * h, l + 0.4582 * w, t + 0.6026 * h, l + 0.3753 * w, t + 0.5662 * h);
      p.cubicTo(l + 0.294 * w, t + 0.5306 * h, l + 0.2493 * w, t + 0.4508 * h, l + 0.2276 * w, t + 0.3686 * h);
      p.cubicTo(l + 0.2151 * w, t + 0.3212 * h, l + 0.2252 * w, t + 0.2695 * h, l + 0.2375 * w, t + 0.2233 * h);
      p.cubicTo(l + 0.2428 * w, t + 0.2034 * h, l + 0.2503 * w, t + 0.1838 * h, l + 0.2584 * w, t + 0.1649 * h);
      p.cubicTo(l + 0.263 * w, t + 0.1541 * h, l + 0.2717 * w, t + 0.1381 * h, l + 0.2613 * w, t + 0.1573 * h);
      p.cubicTo(l + 0.2643 * w, t + 0.1519 * h, l + 0.2845 * w, t + 0.1031 * h, l + 0.2796 * w, t + 0.1073 * h);
      p.cubicTo(l + 0.2574 * w, t + 0.1259 * h, l + 0.2423 * w, t + 0.1598 * h, l + 0.2289 * w, t + 0.1846 * h);
      p.cubicTo(l + 0.1494 * w, t + 0.3312 * h, l + 0.1023 * w, t + 0.5079 * h, l + 0.2279 * w, t + 0.6447 * h);
      p.cubicTo(l + 0.3472 * w, t + 0.7745 * h, l + 0.6018 * w, t + 0.7368 * h, l + 0.7169 * w, t + 0.6208 * h);
      p.cubicTo(l + 0.769 * w, t + 0.5682 * h, l + 0.8147 * w, t + 0.491 * h, l + 0.8366 * w, t + 0.4202 * h);
      p.cubicTo(l + 0.8584 * w, t + 0.3497 * h, l + 0.8141 * w, t + 0.317 * h, l + 0.7477 * w, t + 0.3023 * h);
      p.cubicTo(l + 0.7114 * w, t + 0.2943 * h, l + 0.6679 * w, t + 0.2958 * h, l + 0.6389 * w, t + 0.2692 * h);
      p.cubicTo(l + 0.6287 * w, t + 0.2598 * h, l + 0.6266 * w, t + 0.2456 * h, l + 0.6267 * w, t + 0.2326 * h);
      p.cubicTo(l + 0.6269 * w, t + 0.2216 * h, l + 0.6306 * w, t + 0.2103 * h, l + 0.6341 * w, t + 0.2001 * h);
      p.cubicTo(l + 0.6249 * w, t + 0.2271 * h, l + 0.6368 * w, t + 0.2008 * h, l + 0.648 * w, t + 0.1915 * h);
      p.cubicTo(l + 0.693 * w, t + 0.1541 * h, l + 0.761 * w, t + 0.1376 * h, l + 0.8191 * w, t + 0.1419 * h);
      p.cubicTo(l + 0.8327 * w, t + 0.1429 * h, l + 0.858 * w, t + 0.0895 * h, l + 0.8631 * w, t + 0.0807 * h);
      p.cubicTo(l + 0.865 * w, t + 0.0773 * h, l + 0.8977 * w, t + 0.0122 * h, l + 0.8941 * w, t + 0.0119 * h);
      p.lineTo(l + 0.8941 * w, t + 0.0119 * h);
      p.moveTo(l + 0.6132 * w, t + 0.8813 * h);
      p.cubicTo(l + 0.6048 * w, t + 0.8896 * h, l + 0.5913 * w, t + 0.8896 * h, l + 0.5829 * w, t + 0.8813 * h);
      p.cubicTo(l + 0.5746 * w, t + 0.873 * h, l + 0.5746 * w, t + 0.8594 * h, l + 0.5829 * w, t + 0.8511 * h);
      p.cubicTo(l + 0.5913 * w, t + 0.8427 * h, l + 0.6048 * w, t + 0.8427 * h, l + 0.6132 * w, t + 0.8511 * h);
      p.lineTo(l + 0.6648 * w, t + 0.9027 * h);
      p.cubicTo(l + 0.6731 * w, t + 0.911 * h, l + 0.6731 * w, t + 0.9246 * h, l + 0.6648 * w, t + 0.9329 * h);
      p.lineTo(l + 0.6132 * w, t + 0.9845 * h);
      p.moveTo(l + 0.4401 * w, t + 0.8968 * h);
      p.cubicTo(l + 0.4317 * w, t + 0.9051 * h, l + 0.4182 * w, t + 0.9051 * h, l + 0.4099 * w, t + 0.8968 * h);
      p.cubicTo(l + 0.4015 * w, t + 0.8884 * h, l + 0.4015 * w, t + 0.8749 * h, l + 0.4099 * w, t + 0.8666 * h);
      p.cubicTo(l + 0.4182 * w, t + 0.8582 * h, l + 0.4317 * w, t + 0.8582 * h, l + 0.4401 * w, t + 0.8666 * h);
      p.lineTo(l + 0.4917 * w, t + 0.9182 * h);
      p.cubicTo(l + 0.5 * w, t + 0.9265 * h, l + 0.5 * w, t + 0.9401 * h, l + 0.4917 * w, t + 0.9484 * h);
      p.lineTo(l + 0.4401 * w, t + 1.0 * h);
      return p;
    },
    'لا': (Rect r) {
      final p = Path();
      final l = r.left, t = r.top, w = r.width, h = r.height;
      // Dari current_lam_alif.svg
      p.moveTo(l + 0.6900 * w, t + 0.0800 * h);
      p.cubicTo(l + 0.6700 * w, t + 0.2500 * h, l + 0.5800 * w, t + 0.4200 * h, l + 0.4800 * w, t + 0.5400 * h);
      p.cubicTo(l + 0.4000 * w, t + 0.6500 * h, l + 0.3000 * w, t + 0.7400 * h, l + 0.2500 * w, t + 0.8000 * h);
      p.cubicTo(l + 0.2400 * w, t + 0.8600 * h, l + 0.3500 * w, t + 0.8800 * h, l + 0.5000 * w, t + 0.8600 * h);
      p.cubicTo(l + 0.6500 * w, t + 0.8400 * h, l + 0.7400 * w, t + 0.7800 * h, l + 0.7500 * w, t + 0.7200 * h);
      p.cubicTo(l + 0.7500 * w, t + 0.6800 * h, l + 0.7000 * w, t + 0.7000 * h, l + 0.6500 * w, t + 0.7600 * h);
      p.cubicTo(l + 0.5500 * w, t + 0.8000 * h, l + 0.4200 * w, t + 0.8000 * h, l + 0.3300 * w, t + 0.7800 * h);
      p.cubicTo(l + 0.3800 * w, t + 0.6800 * h, l + 0.4700 * w, t + 0.5600 * h, l + 0.5600 * w, t + 0.4600 * h);
      p.cubicTo(l + 0.6600 * w, t + 0.3200 * h, l + 0.7400 * w, t + 0.1800 * h, l + 0.7400 * w, t + 0.0800 * h);
      p.close();

      p.moveTo(l + 0.3100 * w, t + 0.0800 * h);
      p.cubicTo(l + 0.3300 * w, t + 0.2400 * h, l + 0.4200 * w, t + 0.4000 * h, l + 0.5000 * w, t + 0.5200 * h);
      p.cubicTo(l + 0.5800 * w, t + 0.6400 * h, l + 0.6600 * w, t + 0.7400 * h, l + 0.7000 * w, t + 0.8000 * h);
      p.cubicTo(l + 0.7100 * w, t + 0.8200 * h, l + 0.6600 * w, t + 0.8200 * h, l + 0.6200 * w, t + 0.7800 * h);
      p.cubicTo(l + 0.5400 * w, t + 0.6800 * h, l + 0.4500 * w, t + 0.5600 * h, l + 0.3800 * w, t + 0.4400 * h);
      p.cubicTo(l + 0.3000 * w, t + 0.3000 * h, l + 0.2500 * w, t + 0.1800 * h, l + 0.2600 * w, t + 0.0800 * h);
      p.close();

      return p;
    },
    'ء': (Rect r) {
      final p = Path();
      final l = r.left, t = r.top, w = r.width, h = r.height;
      // Hamzah kaligrafi Naskh proporsional & autentik
      p.moveTo(l + 0.7060 * w, t + 0.2460 * h);
      p.cubicTo(l + 0.6500 * w, t + 0.2100 * h, l + 0.4700 * w, t + 0.2150 * h, l + 0.3600 * w, t + 0.3300 * h);
      p.cubicTo(l + 0.3000 * w, t + 0.3900 * h, l + 0.3000 * w, t + 0.4600 * h, l + 0.3100 * w, t + 0.5000 * h);
      p.cubicTo(l + 0.3200 * w, t + 0.5400 * h, l + 0.3700 * w, t + 0.5800 * h, l + 0.3950 * w, t + 0.6000 * h);
      p.cubicTo(l + 0.3550 * w, t + 0.6500 * h, l + 0.3280 * w, t + 0.7100 * h, l + 0.3300 * w, t + 0.7400 * h);
      p.cubicTo(l + 0.4200 * w, t + 0.6700 * h, l + 0.5200 * w, t + 0.6150 * h, l + 0.6000 * w, t + 0.5850 * h);
      p.cubicTo(l + 0.6600 * w, t + 0.5650 * h, l + 0.7100 * w, t + 0.5500 * h, l + 0.7350 * w, t + 0.5480 * h);
      p.cubicTo(l + 0.7600 * w, t + 0.5000 * h, l + 0.7720 * w, t + 0.4600 * h, l + 0.7720 * w, t + 0.4400 * h);
      p.cubicTo(l + 0.6600 * w, t + 0.4700 * h, l + 0.5000 * w, t + 0.5050 * h, l + 0.4200 * w, t + 0.4850 * h);
      p.cubicTo(l + 0.3800 * w, t + 0.4700 * h, l + 0.3750 * w, t + 0.4200 * h, l + 0.4000 * w, t + 0.3800 * h);
      p.cubicTo(l + 0.4300 * w, t + 0.3400 * h, l + 0.5200 * w, t + 0.3150 * h, l + 0.6450 * w, t + 0.3200 * h);
      p.cubicTo(l + 0.6650 * w, t + 0.3250 * h, l + 0.7050 * w, t + 0.2800 * h, l + 0.7060 * w, t + 0.2460 * h);
      p.close();
      return p;
    },
  };
}
