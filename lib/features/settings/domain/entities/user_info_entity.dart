class UserInfoEntity {
  UserInfoEntity({required this.userName, required this.email});

  final String userName;
  final String email;

  String get firstLetter => userName[0].toUpperCase();
}
