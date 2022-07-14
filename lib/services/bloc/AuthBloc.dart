import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:todoapp/services/auth/auth_provider.dart';
import 'package:todoapp/services/auth/auth_services.dart';
import 'package:todoapp/services/auth/auth_user.dart';
import 'package:todoapp/services/auth/firebase_authentication_provider.dart';
import 'package:todoapp/services/bloc/AuthStates.dart';

class AuthBloc extends Cubit<AuthState> {
  AuthBloc() : super(AuthStateUninitialized(isLoading: true));

  void shouldRegister() {
    emit(const AuthStateRegistering(exception: null, isLoading: false));
  }

  void sendEmailVerification() async {
    await AuthService.firebase().sendEmailVerification();
    emit(state);
  }

  void register({required String email, required String password}) async {
    try {
      await AuthService.firebase().createUser(email: email, password: password);
      await AuthService.firebase().sendEmailVerification();
      emit(const AuthStateNeedsVerification(isLoading: false));
    } on Exception catch (e) {
      emit(
        AuthStateRegistering(exception: e, isLoading: false),
      );
    }
  }

  void initialise() async {
    await AuthService.firebase().initialize();
    final user = AuthService.firebase().currentUser;
    if (user == null) {
      emit(AuthStateLoggedOut(exception: null, isLoading: false));
    } else if (!user.isEmailVerified) {
      emit(const AuthStateNeedsVerification(isLoading: false));
    } else {
      emit(AuthStateLoggedIn(user: user, isLoading: false));
    }
  }

  void login({required String email, required String password}) async {
    emit(const AuthStateLoggedOut(exception: null, isLoading: true));
    try {
      final user =
          await AuthService.firebase().login(email: email, password: password);

      if (!user.isEmailVerified) {
        emit(AuthStateLoggedOut(exception: null, isLoading: false));
        emit(AuthStateNeedsVerification(isLoading: false));
      } else {
        emit(AuthStateLoggedIn(user: user, isLoading: false));
      }
    } on Exception catch (e) {
      emit(AuthStateLoggedOut(exception: e, isLoading: false));
    }
  }

  void logout() async {
    try {
      await AuthService.firebase().logout();
      emit(AuthStateLoggedOut(exception: null, isLoading: false));
    } on Exception catch (e) {
      emit(AuthStateLoggedOut(exception: e, isLoading: false));
    }
  }
}
