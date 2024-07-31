import 'package:flutter/material.dart';

class JDColors {
  JDColors._();

  static Color parseColor(String code) {
    if (code.startsWith("#") && code.length == 9) {
      return Color(int.parse(code.replaceAll('#', '0x')));
    } else if (code.startsWith("#") && code.length == 7) {
      return Color(int.parse(code.replaceAll('#', '0xFF')));
    }
    throw "语法错误 color: $code";
  }

  static PrimaryMaterialStateColor primaryMaterialStateColor(
          BuildContext context) =>
      PrimaryMaterialStateColor(primaryColor(context));

  // ------------------------------------------------------------------------------------

  /// 主题色
  static Color primaryColor(BuildContext context) =>
      Theme.of(context).primaryColor;

  static Color scaffoldColor(BuildContext context) =>
      Theme.of(context).scaffoldBackgroundColor;

  static Color dividerColor(BuildContext context) =>
      Theme.of(context).dividerColor;

  static Color canvasColor(BuildContext context) =>
      Theme.of(context).canvasColor;

  static Color cardColor(BuildContext context) => Theme.of(context).cardColor;

  static const Color appMain = Colors.green;

  static const Color mainYellow = Color(0xFFFECC32);
  static const Color disableYellow = Color(0xd8666666);
  static const Color background = Color(0xFFF2F4F8);
  static const Color appBtn = appMain;

  static const Color c666666 = Color(0xFF666666);
  static const Color c222222 = Color(0xFF222222);
  static const Color c333333 = Color(0xFF333333);
  static const Color c999999 = Color(0xFF999999);
  static const Color cF1F1F1 = Color(0xFFF1F1F1);
  static const Color cECECEC = Color(0xFFECECEC);
  static const Color cF08223 = Color(0xFFF08223);
  static const Color cF5F5F5 = Color(0xFFF5F5F5);
  static const Color c1F2A36 = Color(0xFF1F2A36);
  static const Color cEEEEEE = Color(0xFFEEEEEE);
  static const Color appPurple = Color(0xFF9474FD);

  static const Color transparent = Colors.transparent;
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color red = Color(0xFFFF0035);
  static const Color gray = Color(0xFFDDDDDD);
  static const Color green = Color(0xFF07C160);
  static const Color line = Color(0xFFEEEEEE);
}

extension ColorExt on Color {
  Color autoFit(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light) {
      return this;
    } else {
      return reverse;
    }
  }

  Color get reverse => Color(value ^ 0x00FFFFFF);
}

class PrimaryMaterialStateColor extends MaterialStateColor {
  final Color _defaultColor;

  PrimaryMaterialStateColor(this._defaultColor) : super(_defaultColor.value);

  @override
  Color resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed)) {
      return _defaultColor;
    }
    return _defaultColor;
  }
}
