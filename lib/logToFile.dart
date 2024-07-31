import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:archive/archive.dart';

import 'package:flutter_write_log_to_file/logfoundation/flutter_extension.dart';
import 'package:flutter_write_log_to_file/logfoundation/logNameAndNum.dart';
import 'package:flutter_write_log_to_file/logfoundation/timeTool.dart';
import 'package:flutter_write_log_to_file/logfoundation/fileTool.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class FileWriteLog {
  FileWriteLog._() {
    createDirectory();
  }
  static FileWriteLog? _instance;
  static FileWriteLog get instance => _getOrCreateInstance();
  static FileWriteLog _getOrCreateInstance() {
    if (_instance != null) {
      return _instance!;
    } else {
      _instance = FileWriteLog._();
      return _instance!;
    }
  }

  File? currentFile;
  static bool isFirst = true;

  static log(String content) {
    JDCustomTrace programInfo = JDCustomTrace(StackTrace.current);
    if (isFirst) {
      isFirst = false;
      FileWriteLog.instance.writeFile(programInfo, '-----------------app启动 日志开始-----------------');
      FileWriteLog.instance.writeFile(programInfo, content);
    } else {
      FileWriteLog.instance.writeFile(programInfo, content);
    }
  }

  writeFile(JDCustomTrace programInfo, String content) async {
    if (fileName!='') {
      try {
        DateTime dateTime = DateFormat('yyyy-MM-dd').parse(curLogTime);
        DateTime now = DateTime.now();
        Duration duration = now.difference(dateTime);
        dynamic fileSize = await getFileSize(fileName);
        if (duration.inDays >= 1 || fileSize>=50) {//每天创建一个or单个文件大于指定存储空间 50M 时
          //压缩前一个的日志文件,并删除当前的源文件，再存储至新文件
          duration.inDays >= 1 ? compressLogSeparatedByTime(fileName):compressLogSeparatedBySpace(fileName);
          deleteFile(fileName);

          fileName = '';
          await createFileName();
        }

        /*DateTime dateTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(curLogTime);
        DateTime now = DateTime.now();
        Duration duration = now.difference(dateTime);
        dynamic fileSize = await getFileSize(fileName);
        if (duration.inMinutes == 2 || fileSize>=20) {//每隔2分钟或者大于20k创建一个
          //压缩前一天的日志文件,并删除前一天的源文件
          duration.inMinutes == 2 ? compressLogSeparatedByTime(fileName):compressLogSeparatedBySpace(fileName);
          deleteFile(fileName);

          fileName = '';
          await createFileName();
        }*/

        IOSink sink = currentFile!.openWrite(mode: FileMode.append);
        sink.writeln('${TimeTool.formatFullInfo(DateTime.now())} [${programInfo.fileName}:${programInfo.lineNumber}] $content');
        await sink.flush();
        await sink.close();
      } catch (e) {
        jdLog('写入日志文件的异常----> $e');
      }
    }
  }

  compressLogSeparatedByTime(String filePath) async {
    // 指定源文件和压缩文件路径
    String sourceFilePath = filePath;
    String compressedFilePath = '$filePath.gzip'; // 20xx-xx-xx.log.gzip
    // 读取源文件
    File sourceFile = File(sourceFilePath);
    List<int> fileBytes = await sourceFile.readAsBytes();

    // 压缩文件
    GZipEncoder encoder = GZipEncoder();
    List<int> compressedBytes = encoder.encode(fileBytes)!;
    File compressedFile = File(compressedFilePath);
    await compressedFile.writeAsBytes(compressedBytes);

    print('前一个文件已压缩为 $compressedFilePath');
  }

  compressLogSeparatedBySpace(String filePath) async {
    // 指定源文件和压缩文件路径
    String sourceFilePath = filePath;
    
    String begin = filePath.substring(0,filePath.length-4);
    String end = filePath.substring(filePath.length-4);
    DateTime now = DateTime.now();
    int hour = now.hour;
    int minute = now.minute;
    int second = now.second;
    String compressedFilePath = '${begin}T$hour:$minute:${second}Z$end.gzip';// 20xx-xx-xxT23:59:59Z.log.gzip

    // 读取源文件
    File sourceFile = File(sourceFilePath);
    List<int> fileBytes = await sourceFile.readAsBytes();

    // 压缩文件
    GZipEncoder encoder = GZipEncoder();    
    List<int> compressedBytes = encoder.encode(fileBytes)!;
    File compressedFile = File(compressedFilePath);
    await compressedFile.writeAsBytes(compressedBytes);

    print('前一个文件已压缩为 $compressedFilePath');
  }
  
  deleteFile(String filePath) async {
    final file = File(filePath);
    try {
      if (await file.exists()) {
        await file.delete();
        print('文件已删除, $filePath');
      } else {
        print('文件不存在');
      }
    } catch (e) {
      print('删除文件出错: $e');
    }
  }

  getFileSize(String filePath) async {
    try {
      final file = File(filePath);
      int size = await file.length();
  
      // 转换单位（如需要转换为KB或MB）
      double sizeInKB = size / 1024;
      double sizeInMB = size / 1024 / 1024;
  
      //print('File size in bytes: $size');
      //print('File size in kilobytes: ${sizeInKB.toStringAsFixed(2)}');
      //print('File size in megabytes: ${sizeInMB.toStringAsFixed(2)}');
      return double.parse(sizeInKB.toStringAsFixed(2));
    } catch (e) {
      print('Error getting file size: $e');
      return -1;
    }
  }

  String fileType = '.log';

  Future<String> readFile() async {
    try {
      bool exist = await FileTool.fileExists(fileName);
      if (!exist) {
        jdLog('文件不存在');
        return '';
      }
      File file = File(fileName);
      String contents = await file.readAsString();
      jdLog('read 内容----> $contents');
      return contents;
    } catch (e) {
      return '';
    }
  }

  String fileName = '';
  String curLogTime = '';

  createFileName() {
    print('现在开始创建路径');
    if (fileName.isNotEmptyNullAble) {
      return fileName;
    }
    var time = DateTime.now();
    // 一天创建一个日志文件 半个月前的日志文件删除
    String name = TimeTool.formatDateTime(time);
    //String name = TimeTool.formatFullInfo(time);
    fileName = '$currentDirectory/$name$fileType';
    currentFile = File(fileName);
    curLogTime = name;
    // 检查文件是否存在
    if (currentFile!.existsSync()) {
      print("文件已存在。");
    } else {
      print("文件不存在。");

      // 如果需要创建文件，可以使用 `create` 方法
      try {
        currentFile!.createSync(); // 同步创建文件
        print("文件已创建。$fileName");
      } catch (e) {
        print("创建文件失败: $e");
      }
    }
    return fileName;
  }

  String currentDirectory = '';

  void createDirectory() async {
    print('现在开始创建路径');
    Directory documentPath = await getApplicationDocumentsDirectory();//本机测试
    currentDirectory = '${documentPath.path}Applications/flutterLog';//本机测试
    Directory directory = Directory(currentDirectory);

    if (!await directory.exists()) {
      // 设置recursive为true以确保创建任何必要的父目录
      await directory.create(recursive: true);
      print('目录创建成功! $currentDirectory');
    } else {
      print('目录已存在 $currentDirectory');
    }
    createFileName();
  }

  showFileList() {
    FileTool.listFilesInDirectory(currentDirectory).then((List<String> value) {
      jdLog('当前文件列表----$value');
    });
  }

  deleteAllFiles() {
    FileTool.listFilesInDirectory(currentDirectory).then((List<String> value) {
      value.mapIndex((index, element) {
        FileTool.deleteFile(element);
      });
    });
  }

  deleteOldFiles() {
    FileTool.listFilesInDirectory(currentDirectory).then((List<String> value) {
      var nowTime = DateTime.now();
      value.mapIndex((index, element) {
        try {
          List<String> parts = element.split('/'); // 使用 '/' 分割路径
          // 获取最后一段路径
          String lastSegment = parts.isNotEmpty ? parts.last : '';
          if (lastSegment.endsWith(fileType)) {
            lastSegment = lastSegment.substring(0, lastSegment.length - 4);
          }
          // jdLog('获取的文件名字22------$lastSegment');
          DateTime? time = TimeTool.parse(lastSegment);
          if (time is DateTime) {
            Duration difference = time.difference(nowTime);
            int days = difference.inDays;
            if (days > 7) {
              // 删除超过7天的文件
              jdLog('离现在差距$days天 删除了-------->');
              FileTool.deleteFile(element);
            }
          }
        } catch (onError) {
          jdLog('转换后的onError--------> $onError');
        }
      });
    });
  }
}
