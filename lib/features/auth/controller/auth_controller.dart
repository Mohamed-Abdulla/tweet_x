import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tweet_x/apis/auth_api.dart';
import 'package:tweet_x/core/utils.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(authAPI: ref.watch(authAPIProvider));
});

// StateNotifier is a class provided by Riverpod that helps in managing the state of the app
// it will emit the state to the listeners whenever the state changes
class AuthController extends StateNotifier<bool> {
  //bool is the state of the app to manage loading state
  final AuthAPI _authAPI;
  AuthController({required AuthAPI authAPI})
      : _authAPI = authAPI,
        super(false); //initial state is false

  //this function will be called when the user is signing up
//state = loading
  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    //state is set to true when the user is signing up
    state = true;
    final res = await _authAPI.signUp(email: email, password: password);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) => print(r.email));
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    //state is set to true when the user is signing up
    state = true;
    final res = await _authAPI.login(email: email, password: password);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) => print(r.userId));
  }
}
