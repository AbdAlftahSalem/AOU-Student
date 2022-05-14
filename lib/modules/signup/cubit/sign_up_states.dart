abstract class SignUpAppStates {}
class SignUpAppInitialState extends SignUpAppStates {}

class TogglePassword extends SignUpAppStates{}

class UploadPhotoSuccessState extends SignUpAppStates{}

class SignUpCreateUSerSuccessState extends SignUpAppStates{}

class SignUpLoading extends SignUpAppStates{}

class UploadPhotoErrorState extends SignUpAppStates{
  final String error;

  UploadPhotoErrorState(this.error);
}
class SignUpCreateUSerErrorState extends SignUpAppStates{
  final String error;

  SignUpCreateUSerErrorState(this.error);
}