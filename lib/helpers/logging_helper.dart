// import 'package:firebase_crashlytics/firebase_crashlytics.dart'
//     show FirebaseCrashlytics;

import 'package:logger/logger.dart';
// import 'package:dio/dio.dart';

final Logger logger = Logger();

void logMessage(String message) {
  logger.d(message);
  // FirebaseCrashlytics.instance.log(message);
}

void logError(Object error, StackTrace? trace) {
  logger.e("An error occurred", error: error, stackTrace: trace);
  // FirebaseCrashlytics.instance.recordError(error, trace);
  // if (error is DioError) {
  //   logger.e(error.response?.data);
  // }
}

void logInfo(dynamic message) {
  logger.i(message);
}
