class UserModel {
  final String userName;
  final String userEmail;
  String token;
  int userId;

  UserModel({
    required this.userName,
    required this.userEmail,
    this.token = "",
    this.userId = -1,
  });

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      userName: data["userName"] ?? "",
      userEmail: data["userEmail"] ?? "",
      token: data["token"] ?? "",
      userId: data["userId"] ?? -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userName": userName,
      "userEmail": userEmail,
      "token": token,
      "userId": userId,
    };
  }
}
