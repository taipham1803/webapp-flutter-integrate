import 'package:logger/logger.dart';

class EmddiLogger {
  Logger logger;

  static const Debug = true;

  EmddiLogger._private() {
    logger = Logger();
  }

  static final EmddiLogger _instance = EmddiLogger._private();

//  static L get instance => _instance;

  static void e(String message) {
    if (Debug) {
      _instance.logger.e(message);
    }
  }
}
