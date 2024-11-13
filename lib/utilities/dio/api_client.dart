import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:ipodaily/utilities/dio/api_end_points.dart';

class NewClient {
  Dio init() {
    Dio dio = Dio();
    dio.options.baseUrl = APIEndPoints.base;
    RequestOptions? requestOptions;

    updateCrashlytics(e) {
      if (kDebugMode == false) {
        final crashlytics = FirebaseCrashlytics.instance;

        crashlytics.recordError(
          "API EXCEPTION DIO: ${requestOptions?.path}",
          e.stackTrace,
          fatal: true,
        );

        crashlytics.setCustomKey("baseUrl", '${requestOptions?.baseUrl}');

        crashlytics.setCustomKey("api_end_point", '${requestOptions?.path}');



        debugPrint("---------- crashlytics updated ----------");
      }
    }

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        onError: (e, handler) {
          updateCrashlytics(e);
          return handler.next(e);
        },
      ),
    );
    return dio;
  }
}
