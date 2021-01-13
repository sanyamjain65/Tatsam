class BaseResponse {
    bool success;
    int statusCode;
    String message;

    BaseResponse();

    BaseResponse.fromJson(Map<String, dynamic> json) {
        statusCode = json['status-code'];
        message = json['message'] ?? message;
    }
}
