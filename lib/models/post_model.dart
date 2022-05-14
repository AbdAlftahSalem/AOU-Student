class PostModel {
  late String postImage;
  late String aboutPost;

  PostModel({
    required this.postImage,
    required this.aboutPost,
  });

  PostModel.formJson(Map <String, dynamic>? json) {
    if (json == null) {
      return;
    }
    postImage = json['postImage'];
    aboutPost = json['aboutPost'];
  }
  Map<String, dynamic> toJson() {
    return {
      'postImage': postImage,
      'aboutPost': aboutPost,
    };
  }
}
