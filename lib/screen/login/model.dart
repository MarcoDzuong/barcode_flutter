class LoginResponse {

  String message ;
  UserInfo userInfo ;

  LoginResponse({required this.message, required this.userInfo});

  factory LoginResponse.fromJson(Map<String, dynamic> parsedJson) {
    return LoginResponse(
        message: parsedJson['message'].toString(),
        userInfo: UserInfo.fromJson(parsedJson['data']?? Map()));
  }

}

class UserInfo {
  String? accessToken;
  String? tokenType;

  UserInfo({required this.accessToken, required this.tokenType});

  factory UserInfo.fromJson(Map<String, dynamic> parsedJson) {
    return UserInfo(
        accessToken: parsedJson['access_token']?.toString(),
        tokenType: parsedJson['token_type']?.toString());
  }
}
