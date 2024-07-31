// 类型转换

class JDConvert {
  static String asStringNotNull(dynamic value, {String defaultString = ""}) {
    if (value != null && (value is String)) {
      return value;
    } else {
      if (value is num) {
        return value.toString();
      } else if (value is bool) {
        return value.toString();
      }
      return defaultString;
    }
  }

  static int asIntNotNull(dynamic value) {
    if (value != null && (value is int)) {
      return value;
    } else {
      if (value is String) {
        return int.tryParse(value) ?? 0;
      } else if (value is double) {
        return int.parse(value.toString());
      } else if (value is bool) {
        return value == true ? 1 : 0;
      }
      return 0;
    }
  }

  static bool asBoolNotNull(dynamic value) {
    if (value != null && (value is bool)) {
      return value;
    } else {
      if (value is String) {
        return ((int.tryParse(value) ?? 0) >= 1) ||
            value.toLowerCase() == 'true' ||
            value.toLowerCase() == 'yes';
      } else if (value is num) {
        return value != 0;
      }
      return false;
    }
  }

  static double asDoubleNotNull(dynamic value) {
    if (value != null && (value is double)) {
      return value;
    } else {
      if (value is String) {
        return double.tryParse(value) ?? 0.0;
      } else if (value is int) {
        return value * 1.0;
      } else if (value is bool) {
        return value == true ? 1.0 : 0.0;
      }
      return 0.0;
    }
  }

  static Map asMapNotNull(dynamic value) {
    if (value != null && (value is Map)) {
      return value;
    } else {
      return {};
    }
  }

  static List asListNotNull(dynamic value) {
    if (value != null && (value is List)) {
      return value;
    } else {
      return [];
    }
  }
}
