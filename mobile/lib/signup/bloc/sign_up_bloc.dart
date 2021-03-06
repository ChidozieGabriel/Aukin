import 'package:bloc/bloc.dart';
import 'package:identity_client/identity_client.dart';

import 'sign_up_event.dart';
import 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc(this.identityClient) : super(SignUpStarted());

  final IdentityClient identityClient;

  Stream<SignUpState> _signUpHandler(
      CreateUserWithRegisterCredentials event) async* {
    yield SignUpLoading();
    await Future.delayed(Duration(milliseconds: 700));

    try {
      await identityClient.createUserWithRegisterCredentials(
          password: event.password,
          userEmail: event.email,
          username: event.name);
      yield SuccessRegistered();
      await Future.delayed(Duration(milliseconds: 700));
      yield SignUpCreatedAccount();
    } on ServerException catch (error) {
      yield SignUpFailed(error.error.messages);
    } catch (erro) {
      yield SignUpFailed([
        'An unknown error has occurred.',
      ]);
    }
  }

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is CreateUserWithRegisterCredentials) {
      yield* _signUpHandler(event);
    }
  }
}
