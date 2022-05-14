abstract class AdminHomeLayoutStates {}

class AdminHomeLayoutAppInitialState extends AdminHomeLayoutStates {}

class UploadPhotoSuccessState extends AdminHomeLayoutStates {}

class UploadPostSuccessState extends AdminHomeLayoutStates {}

class UploadPhotoToDBSuccessState extends AdminHomeLayoutStates {}

class GetPostsDataSuccessState extends AdminHomeLayoutStates {}

class GetPostsDataLoadingState extends AdminHomeLayoutStates {}

class UploadPhotoErrorState extends AdminHomeLayoutStates {
  String error;

  UploadPhotoErrorState(this.error);
}

class GetPostsDataErrorState extends AdminHomeLayoutStates {
  String error;

  GetPostsDataErrorState(this.error);
}

class UploadPhotoToDBErrorState extends AdminHomeLayoutStates {
  String error;

  UploadPhotoToDBErrorState(this.error);
}

class UploadPostErrorState extends AdminHomeLayoutStates {
  String error;

  UploadPostErrorState(this.error);
}
