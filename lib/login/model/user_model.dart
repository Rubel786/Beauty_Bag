class UserModel {
  final String accessToken; // Changed to accessToken
  final int id; // Changed to int, as API returns int

  UserModel({
    required this.accessToken,
    required this.id,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      accessToken: json["accessToken"], // Changed to accessToken
      id: json["id"], // Changed to id
    );
  }
}