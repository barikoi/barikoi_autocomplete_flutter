import 'package:barikoi_autocomplete/src/api/api_services.dart';

class Repository {
  final ApiServices apiServices = ApiServices();

  Future<dynamic> sendSearchAddressRequest(
      {required String query, required String key}) async {
    final userLoginData =
        await apiServices.autoSearch(query: query, apiKey: key);
    return userLoginData;
  }
}
