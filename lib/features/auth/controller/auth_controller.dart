import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tweet_x/apis/auth_api.dart';
import 'package:tweet_x/apis/user_api.dart';
import 'package:tweet_x/core/utils.dart';
import 'package:tweet_x/features/auth/view/login_view.dart';
import 'package:tweet_x/features/home/home_view.dart';
import 'package:appwrite/models.dart';
import 'package:tweet_x/models/user_model.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authAPI: ref.watch(authAPIProvider),
    userAPI: ref.watch(userAPIProvider),
  );
});

final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

// StateNotifier is a class provided by Riverpod that helps in managing the state of the app
// it will emit the state to the listeners whenever the state changes
class AuthController extends StateNotifier<bool> {
  //bool is the state of the app to manage loading state
  final AuthAPI _authAPI;
  final UserAPI _userAPI;
  AuthController({required AuthAPI authAPI, required UserAPI userAPI})
      : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false); //initial state is false

  Future<User?> currentUser() => _authAPI.currentUserAccount();

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
    res.fold((l) => showSnackBar(context, l.message), (r) async {
      //save the user data in the database
      UserModel userModel = UserModel(
        email: email,
        name: getNameFromEmail(email),
        followers: [],
        following: [],
        profilePic: '',
        bannerPic: '',
        uid: '',
        bio: '',
        isTwitterBlue: false,
      );
      final res2 = await _userAPI.saveUserData(userModel);
      res2.fold((l) => showSnackBar(context, l.message), (r) {
        showSnackBar(context, 'Account created successfully! Please login.');
        Navigator.push(context, LoginView.route());
      });
    });
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
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Login successfully!');
      Navigator.push(context, HomeView.route());
    });
  }
}
