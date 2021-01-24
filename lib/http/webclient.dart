import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

final Client client = HttpClientWithInterceptor.build(
  interceptors: [],
  requestTimeout: Duration(seconds: 5),
);

const String baseUrl = "http://192.168.15.5:8080";
