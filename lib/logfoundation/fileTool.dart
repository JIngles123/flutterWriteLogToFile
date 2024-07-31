/*
 * @Author: jlm limeijin@deepglint.com
 * @Date: 2024-07-26 11:52:32
 * @LastEditors: jlm limeijin@deepglint.com
 * @LastEditTime: 2024-07-31 11:39:07
 * @FilePath: /easydeployuiAddcode/lib/util/fileTool.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'dart:io';

import 'package:flutter_write_log_to_file/logfoundation/logNameAndNum.dart';

class FileTool {
  /// 判断文件是否存在
  static Future fileExists(String path) async {
    return await File(path).exists();
  }

  static Future<bool> deleteFile(String path) async {
    File file = File(path);
    bool exists = await file.exists();
    if (exists) {
      file.delete();
      return true;
    }
    return false;
  }

  // 打印目录下所有文件
  static Future<List<String>> listFilesInDirectory(String directoryPath) async {
    // 创建Directory对象
    Directory directory = Directory(directoryPath);
    // 检查目录是否存在
    if (await directory.exists()) {
      // 获取目录中的所有文件
      List<FileSystemEntity> files = directory.listSync();
      // 遍历并打印每个文件的路径
      List<String> fileList = [];
      for (var file in files) {
        if (file is File) {
          fileList.add(file.path);
        }
      }
      return fileList;
    } else {
      jdLog('Directory does not exist.');
      return [];
    }
  }
}
