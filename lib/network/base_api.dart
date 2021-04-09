import 'api.dart';

enum RequestType { GET }

class BaseApi {
  BaseApi(this.url, this.requestType,
      {this.queryParams}) {
    client = ApiClient();
  }


  ApiClient client;

  String url;
  Map<String, dynamic> queryParams;
  final RequestType requestType;
  dynamic response;

  Future<dynamic> makeRequest() async {
    switch (requestType) {
      case RequestType.GET:
        response = await client.get(url, queryParams: queryParams);
        return response;
        break;
    }
  }
}
