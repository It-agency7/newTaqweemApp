import 'package:dio/dio.dart';
import '../../service/service_locator.dart';
import '../../helpers/cache_helper.dart';

class AuthorizationInterceptor extends Interceptor {
//* Request methods PUT, POST, PATCH, DELETE needs access token,
//* which needs to be passed with "Authorization" header as Bearer token.
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = 'Bearer ${sl<TaqwimPref>().getToken()}';
    super.onRequest(options, handler);
  }
  
  //* DELETE - PUT - POST *** (GET)
  // bool _needAuthorizationHeader(RequestOptions options) {
  //   if (options.method == 'GET') {
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }
}
