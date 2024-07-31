/*
 * @Author: jlm limeijin@deepglint.com
 * @Date: 2024-07-26 11:33:17
 * @LastEditors: jlm limeijin@deepglint.com
 * @LastEditTime: 2024-07-30 17:20:24
 * @FilePath: /easydeployuiAddcode/lib/util/logAddFileNameAndLineNumber.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:flutter/foundation.dart';

void jdLog(Object log, {bool showLine = true}) {
  //if (kDebugMode) {
    if (showLine) {
      JDCustomTrace programInfo = JDCustomTrace(StackTrace.current);
      print("[${programInfo.fileName}:${programInfo.lineNumber}] $log");
    } else {
      print("$log");
    }
  //}
}

class JDCustomTrace {
  final StackTrace? _trace;

  String fileName = '';
  int lineNumber = 0;

  JDCustomTrace(this._trace) {
    _parseTrace();
  }

  void _parseTrace() {
    var traceString = _trace.toString().split("\n")[1];
    var indexOfFileName = traceString.indexOf(RegExp(r'[A-Za-z_]+.dart'));
    var fileInfo = traceString.substring(indexOfFileName);// preview.dart:352)
    List listOfInfo = fileInfo.split(":");

    if (listOfInfo.length >= 2) {
      fileName = listOfInfo[0];      
      lineNumber = int.parse(listOfInfo[1].substring(0,listOfInfo[1].length-1));
    }
  }
}
