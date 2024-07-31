记录于2024-07-31
# flutterWriteLogToFile-》这是一个flutter的日志存储文件的Demo

## 1、flutter clean 清除flutter的旧有构建
## 2、flutter pub get 获取项目所需插件和内容
## 3、flutter run 运行flutter项目

###备注：
此项目未用到具体的log相关插件，参考的某大神代码，但在其基础上做了些改动，也增加了某些内容，
如，
增加：
1、在本demo中，每到第二天就会新建一个新的日志文件，当然也可每隔一定的时间新建日志文件。
2、到第二天时，第一天的日志文件会压缩成gzip文件，并删除源日志文件，在大型项目中，这可以节省一些存储空间。

修改：
项目运行的一些报错，如获取堆栈文件名和行号等信息。
修改日志的栈打印的位置，避免输出的文件名和行号与实际输出语句不对应。

目前没有增加对单个日志存储大小的控制，后续会加上。

如有问题或者好的建议，可联系 jinxiaohu7@163.com
