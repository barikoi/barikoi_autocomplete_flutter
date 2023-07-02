import 'dart:developer';
import 'package:http/http.dart' as http;

abstract class BaseService {
  Future<dynamic> autoSearch(
      {required String query, required String apiKey});
}

class ApiServices implements BaseService {
  @override
  Future<dynamic> autoSearch(
      {required String query,
      required String apiKey}) async {
    try {
      final response = await http.get(
          Uri.parse("https://barikoi.xyz/v1/api/search/autocomplete/$apiKey/place?q=$query"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          });

      log("auth_check -> ${response.body}");

      return response;
    } catch (e) {
      throw (e.toString());
    }
  }
}
