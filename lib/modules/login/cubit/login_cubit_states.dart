abstract class LoginAppStates {}
class LoginAppInitialState extends LoginAppStates {}

class TogglePassword extends LoginAppStates{}

class LoginLoading extends LoginAppStates{}

class LoginSuccessState extends LoginAppStates
{
  final String uId;

  LoginSuccessState(this.uId);
}

class LoginErrorState extends LoginAppStates{
  final String error;

  LoginErrorState(this.error);
}


