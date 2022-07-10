import 'package:todoapp/services/auth/auth_provider.dart';
import '../auth/auth_user.dart';
import './firebase_authentication_provider.dart';

class AuthService implements AuthProvider{
final AuthProvider provider;

const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthenticationProvider());


  @override
  Future<AuthUser> createUser({required String email, required String password}) =>
    provider.createUser(email: email, password: password);
  
  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<AuthUser> login({required String email, required String password}) => provider.login(email: email, password: password);

  @override
  Future<void> logout() => provider.logout();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

}