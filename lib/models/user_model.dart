class UserModel {
  late String userImage;
  late String userName;
  late String userEmail;
  late String userNumber;
  late String major;
  late String gender;
  late String ID;
  late String userID;

  UserModel({
    required this.userImage,
    required this.userName,
    required this.userEmail,
    required this.userNumber,
    required this.major,
    required this.gender,
    required this.ID,
    required this.userID,
  });

  UserModel.formJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    userImage = json['userImage'];
    userName = json['userName'];
    userEmail = json['userEmail'];
    userNumber = json['userNumber'];
    major = json['major'];
    gender = json['gender'];
    ID = json['ID'];
    userID = json['userID'];
  }

  Map<String, dynamic> toJson() {
    return {
      'userImage': userImage,
      'userName': userName,
      'userEmail': userEmail,
      'userNumber': userNumber,
      'major': major,
      'gender': gender,
      'ID': ID,
      'userID': userID,
    };
  }
}
