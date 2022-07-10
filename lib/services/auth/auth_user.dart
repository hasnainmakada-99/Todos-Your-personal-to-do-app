import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {

  // ignore: prefer_typing_uninitialized_variables
  final isEmailVerified;
  final id;
  final email;
  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
    });

  // facotry constructor to instantiate another object from the pervious object

 factory AuthUser.fromFirebase(User user){
  return AuthUser(isEmailVerified: user.emailVerified, email: user.email, id: user.uid);
 }

}
