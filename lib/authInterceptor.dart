import 'package:dio/dio.dart';

/// 驗證Interceptor
class AuthInterceptor extends Interceptor {
  final _authorization = "CWA-6618EB9F-44A4-43C6-B368-23A869675020";

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    var params = options.queryParameters = Map.from(options.queryParameters);

    /// 如請求參數裡還未包含驗證參數，則新增
    if (params['Authorization'] == null) {
      params['Authorization'] = _authorization;
    }

    options.queryParameters = params;

    return super.onRequest(options, handler);
  }
}