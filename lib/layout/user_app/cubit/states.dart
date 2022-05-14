abstract class UserHomeLayoutStates {}

class UserHomeLayoutAppInitialState extends UserHomeLayoutStates {}

class UploadPhotoSuccessState extends UserHomeLayoutStates {}

class LoadingState extends UserHomeLayoutStates {}

class LoadingProfileState extends UserHomeLayoutStates {}

class GetUserSuccessState extends UserHomeLayoutStates {}

class GetPostsDataSuccessState extends UserHomeLayoutStates {}

class UploadPhotoErrorState extends UserHomeLayoutStates {
  String error;

  UploadPhotoErrorState(this.error);
}

class GetPostsDataErrorState extends UserHomeLayoutStates {
  String error;

  GetPostsDataErrorState(this.error);
}
class GetUserErrorState extends UserHomeLayoutStates {
  String error;

  GetUserErrorState(this.error);
}
