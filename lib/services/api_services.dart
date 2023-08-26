import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final http.Client _client = http.Client();

  static Future<http.Response> get(
    String url, {
    Map<String, String> headers = const {},
  }) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      Uri uri = Uri.parse(url);

      headers['Content-Type'] = 'application/json; charset=UTF-8';
      var response = await _client.get(
        uri,
        headers: headers,
      );
      return response;
    } else {
      throw Exception('No internet connection please try again!');
    }
  }
}
