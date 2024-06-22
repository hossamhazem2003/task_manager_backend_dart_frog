class LoginResponseModel {
  String accessToken;

  LoginResponseModel({required this.accessToken});

  // Convert a LoginResponseModel object into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
    };
  }

  // Create a LoginResponseModel object from a JSON map.
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['accessToken'] as String,
    );
  }
}
