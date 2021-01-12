import 'api.dart';

enum RequestType { PUT, POST, GET }

class BaseApi {
  BaseApi(this.url, this.requestType,
      {this.map, this.withoutRequestHeaders = false, this.queryParams}) {
    client = ApiClient();
  }

  ApiClient client;

  String url;
  Map<String, dynamic> queryParams;
  final RequestType requestType;
  dynamic response;
  final dynamic map;
  final bool withoutRequestHeaders;

  Future<dynamic> makeRequest() async {
    switch (requestType) {
      case RequestType.GET:
        response = await client.get(url, withoutHeaders: withoutRequestHeaders, queryParams: queryParams);
        return response;
        break;
    }
  }

  Future<dynamic> handleFailure(dynamic response) async {
    switch (response['status']) {
      //RENEW_TOKEN
      case 430:
        // final dynamic responseToken = await client.get(renewTokenUrl);
        // if (responseToken['status'] == 200) {
        //   return makeRequest();
        // }
        // return responseToken;

      //Token Malformed
      case 401:
        // ExceptionHandlerInterface().handleException(tokenMalformedCode);
        // return response;

      //other status codes
      default:
        return response;
    }
  }
}
