/*
 * @Author: jlm limeijin@deepglint.com
 * @Date: 2024-07-26 11:55:23
 * @LastEditors: jlm limeijin@deepglint.com
 * @LastEditTime: 2024-07-31 11:37:32
 * @FilePath: /easydeployuiAddcode/lib/util/logfoundation/list_value_notifier.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:flutter/foundation.dart';
import 'package:flutter_write_log_to_file/logfoundation/flutter_extension.dart';

class ListValueNotifier<E> extends ChangeNotifier
    implements ValueListenable<List<E>> {
  final _list = <E>[];

  int get length => _list.length;

  bool get isEmpty => _list.isEmpty;

  bool get isNotEmpty => _list.isNotEmpty;

  @override
  List<E> get value => _list;

  E? getDataAt(int index) => _list.get(index);

  void forEach(void Function(E element) action) {
    for (E element in _list) {
      action(element);
    }
  }

  List<E> getAllData() => _list;

  void replaceAll(Iterable<E> data) {
    _list.clear();
    _list.addAll(data);
    notifyListeners();
  }

  void appendData(E data, [int? position]) {
    if (position != null) {
      _list.insert(position, data);
    } else {
      _list.add(data);
    }
    notifyListeners();
  }

  void appendAllData(Iterable<E> data, [int? position]) {
    if (position != null) {
      _list.insertAll(position, data);
    } else {
      _list.addAll(data);
    }
    notifyListeners();
  }

  void remove(E data) {
    if (_list.remove(data)) {
      notifyListeners();
    }
  }

  E removeAt(int index) {
    final value = _list.removeAt(index);
    if (value != null) {
      notifyListeners();
    }
    return value;
  }

  void removeAll() {
    if (_list.isEmpty) return;
    _list.clear();
    notifyListeners();
  }
}
