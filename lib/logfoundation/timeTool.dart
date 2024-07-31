/*
 * @Author: jlm limeijin@deepglint.com
 * @Date: 2024-07-26 11:51:37
 * @LastEditors: jlm limeijin@deepglint.com
 * @LastEditTime: 2024-07-26 11:51:41
 * @FilePath: /easydeployuiAddcode/lib/util/timeTool.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:intl/intl.dart';

class TimeTool {
  TimeTool._();

  static const TDOneDay = 86400000;

  static DateTime now() => DateTime.now();

  static String getCurrentDateStr([String format = 'yyyy-MM-dd']) {
    return TimeTool.formatDateTime(DateTime.now(), format);
  }

  static final DateFormat _apiDayFormat = DateFormat('yyyy-MM-dd');
  static String getDayString(DateTime d) => _apiDayFormat.format(d);

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static String format(int dateTs, [String format = 'yyyy-MM-dd']) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dateTs);
    return formatDateTime(dateTime, format);
  }

  static String formatUtc(int dateTs, [String format = 'yyyy-MM-dd']) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(dateTs, isUtc: true);
    return formatDateTime(dateTime, format);
  }

  static String formatFullInfo(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  static String formatDateTime(DateTime dateTime,
      [String format = 'yyyy-MM-dd']) {
    return DateFormat(format).format(dateTime);
  }

  static String formatDayForWeek(DateTime dateTime, [String format = '星期']) {
    const weekList = ['零', '一', '二', '三', '四', '五', '六', '日'];
    return '$format${weekList[dateTime.weekday]}';
  }

  static DateTime? parse(String? dateStr, [String format = 'yyyy-MM-dd']) {
    if (dateStr?.isNotEmpty != true) return null;
    return DateFormat(format).parse(dateStr!);
  }

  int formatDate() {
    DateTime now = DateTime.now();

    return now.day; // 获取今天的日期并返回日期的字符串
  }

  /// 格式化倒计时为：15h30m33s
  static String formatDuration(int seconds) {
    Duration duration = Duration(seconds: seconds);

    int hours = duration.inHours;
    int minutes = (duration.inMinutes % 60);
    int remainingSeconds = (duration.inSeconds % 60);

    if (hours > 0) {
      return '$hours :${minutes.toString()} :${remainingSeconds.toString()}';
    } else if (minutes > 0) {
      return '${minutes.toString()}:${remainingSeconds.toString()}';
    } else {
      return remainingSeconds.toString();
    }
  }
}
