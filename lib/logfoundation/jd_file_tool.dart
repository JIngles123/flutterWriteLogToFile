import 'dart:io';

import 'package:flutter_write_log_to_file/logfoundation/logNameAndNum.dart';

class JDFileTool {
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
          jdLog('File: ${file.path}');
        }
      }
      return fileList;
    } else {
      jdLog('Directory does not exist.');
      return [];
    }
  }
}
