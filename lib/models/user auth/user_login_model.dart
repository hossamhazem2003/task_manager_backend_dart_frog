class UserLoginModel {
  UserLoginModel({this.password, this.name});

  factory UserLoginModel.fromJson(Map<String, dynamic> json) => UserLoginModel(
        password: json['password'] as String?,
        name: json['email'] as String?,
      );
  final String? password;
  final String? name;

  Map<String, dynamic> toJson() => {
        'password': password,
        'email': name,
      };
}
