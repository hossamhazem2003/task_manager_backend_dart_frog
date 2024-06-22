class UserSignIn {

  UserSignIn({required this.name, required this.age, required this.lastName, required this.password, required this.email, required this.userId});
 

  factory UserSignIn.fromJson(Map<String, dynamic> json) => UserSignIn(
        userId: json['userId'] as String,
        name: json['name'] as String?,
        age: json['age'] as int?,
        lastName: json['lastName'] as String?,
        password: json['password'] as String?,
        email: json['email'] as String?,
      );

  final String? name;
  final int? age;
  final String? lastName;
  final String? password;
  final String? email;
  final String userId;

  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
        'lastName': lastName,
        'password': password,
        'email': email,
        'userId': userId,
      };
}
