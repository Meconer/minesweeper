import 'package:logger/logger.dart';

class MyLogPrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    return [event.message];
  }
}
