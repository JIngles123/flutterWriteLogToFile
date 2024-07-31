import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_write_log_to_file/logfoundation/jd_convert.dart';

const String kItems = 'items';
const String kList = 'list';
const String kSuccess = 'success';

class TDResponseConstant {
  static const String success = 'success';
  static const String message = 'message';

  // 错误码：0为成功
  static const String errorCode = 'code';

  //请求异常的返回
  static const String error = 'error';
}

/// 屏幕密度
var density = 1.0;

extension IntDensityExtension on num {
  //屏幕宽度 / 375
  double get dp => this * density;

  // 垂直间距
  SizedBox get vGap {
    return SizedBox(height: toDouble());
  }

  //水平间距
  SizedBox get hGap {
    return SizedBox(width: toDouble());
  }
}

extension IterableExtension<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;

  E? firstWhereOrNull(bool Function(E) test) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  E? firstOrNullWhere(bool Function(E element) test, {E? Function()? orElse}) {
    for (E element in this) {
      if (test(element)) return element;
    }
    if (orElse != null) return orElse();
    return null;
  }

  E? get lastOrNull => isEmpty ? null : last;

  E? lastOrNullWhere(bool Function(E element) test, {E? Function()? orElse}) {
    late E result;
    bool foundMatching = false;
    for (E element in this) {
      if (test(element)) {
        result = element;
        foundMatching = true;
      }
    }
    if (foundMatching) return result;
    if (orElse != null) return orElse();
    return null;
  }

  int get lastIndex => isEmpty ? -1 : length - 1;

  toJson() => json.encode(this);
}

extension StringExtension on String? {
  /// String 空安全处理
  String get notNull => this ?? '';
  bool get isEmptyNullAble => (this ?? '').isEmpty;
  bool get isNotEmptyNullAble => (this ?? '').isNotEmpty;

  int convertInt() {
    return JDConvert.asIntNotNull(this);
  }

  double convertDouble() {
    return JDConvert.asDoubleNotNull(this);
  }
}

extension StringDensityExtension on String {
  bool get isJson {
    if (isEmpty) return false;
    return (startsWith("{") && endsWith("}")) ||
        (startsWith("[") && endsWith("]"));
  }

  int convertInt() {
    return JDConvert.asIntNotNull(this);
  }
}

extension MediaQueryExtension on BuildContext {
  Size get size => MediaQuery.of(this).size;
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;

  Color get backgroundColor => Theme.of(this).scaffoldBackgroundColor;
  Color get dialogBackgroundColor => Theme.of(this).canvasColor;
}

typedef ListIndexFunction<E, R> = R Function(int index, E element);
typedef MapIndexFunction<K, V, R> = R Function(
    int index, MapEntry<K, V> element);

extension ListNullAbleExtension<E> on List<E>? {
  bool get isNotEmptyNullable {
    return (this ?? []).isNotEmpty;
  }

  bool get isEmptyNullable {
    return (this ?? []).isEmpty;
  }

  int get lengthNullable {
    return (this != null ? (this?.length ?? 0) : 0);
  }
}

extension ListExtension<E> on List<E> {
  Iterable<R> mapIndex<R>(ListIndexFunction<E, R> function) {
    List<R> list = [];
    List.generate(length, (index) {
      list.add(function.call(index, this[index]));
    });
    return list;
  }

  E? get(int index) {
    if (index < 0 || length == 0 || index >= length) return null;
    return this[index];
  }

  int get lastIndex => isEmpty ? -1 : length - 1;

  toJson() => json.encode(this);
}

typedef MapFunction<K, V> = bool Function(MapEntry<K?, V?> element);

extension MapExtension<K, V> on Map<K, V> {
  V? get(K? key) => this[key];

  String getStringNotNull(String key) {
    V? value = this[key];
    if (value != null && value is String) {
      return value;
    } else {
      return JDConvert.asStringNotNull(value);
    }
  }

  Map<String, dynamic> stringDynamicMap() {
    return Map<String, dynamic>.from(this);
  }

  List getListNotNull(String key) {
    V? value = this[key];
    if (value != null && value is List) {
      return value;
    } else {
      return [];
    }
  }

  List getItemsListNotNull() {
    Map<String, dynamic> map = this.getMapNotNull(kItems);
    return map.getListNotNull(kList);
  }

  Map<String, dynamic> getMapNotNull(String key) {
    V? value = this[key];
    if (value != null && value is Map) {
      return Map<String, dynamic>.from(value);
    } else {
      return {};
    }
  }

  int getIntNotNull(String key) {
    V? value = this[key];
    if (value != null && value is int) {
      return value;
    } else {
      return JDConvert.asIntNotNull(value);
    }
  }

  bool getBoolNotNull(String key) {
    V? value = this[key];
    return JDConvert.asBoolNotNull(value);
  }

  double getDoubleNotNull(String key) {
    V? value = this[key];
    if (value != null && value is double) {
      return value;
    } else {
      return JDConvert.asDoubleNotNull(value);
    }
  }

  bool responseSucceed() {
    return this.getBoolNotNull(TDResponseConstant.success);
  }

  toJson() => json.encode(this);
}

extension RectExtension on Rect {
  bool containsRect(Rect other) {
    return other.left >= left &&
        other.right <= right &&
        other.top >= top &&
        other.bottom <= bottom;
  }
}

extension FutureExtension<T> on Future<T> {
  Future<T> whenCreated(FutureOr<void> Function() action) {
    action.call();
    return this;
  }
}

extension TDDurationExtension on Duration {
  DateTime get dateTime =>
      DateTime.fromMicrosecondsSinceEpoch(inMicroseconds, isUtc: true);
}

extension DateTimeExtension on DateTime {
  Duration get duration => Duration(microseconds: microsecondsSinceEpoch);

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
}
