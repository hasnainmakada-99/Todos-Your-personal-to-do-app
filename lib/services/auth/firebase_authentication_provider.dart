import 'package:todoapp/firebase_options.dart';
import 'package:todoapp/services/auth/auth_provider.dart';
import 'package:todoapp/services/auth/auth_exceptions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todoapp/services/auth/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthenticationProvider implements AuthProvider{
  
  

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );
  }


  @override
  Future<AuthUser> createUser({required String email, required String password}) async {
      try{
          await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
          final user = currentUser;
          if(user!=null){
            return user;
          }
          else{
            throw UserNotLoggedIn();
          }
      }
      on FirebaseAuthException catch(e){
        if (e.code == 'weak-password') {
            throw WeakPasswordException();
          } else if (e.code == 'email-already-in-use') {
            throw EmailAlreadyInUse();
          } else if (e.code == 'invalid-email') {
            throw InvalidEmailException();
          } else {
            throw GenericException();
          }
      }
      catch(e){
        throw GenericException();
      }
  }


@override
  AuthUser? get currentUser{
    final user = FirebaseAuth.instance.currentUser;
    if(user != null){
      return AuthUser.fromFirebase(user);
    }
    else{
      return null;
    }
  }

  @override
  Future<AuthUser> login({required String email, required String password}) async {

      try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

          final user = currentUser;

          if(user!=null){
            return user;
          }
          else{
            throw UserNotLoggedIn();
          }
          

      } on FirebaseAuthException catch(e){
         if (e.code == 'user-not-found') {
        throw UserNotFoundException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordException();
      } else {
        throw GenericException();
      }
      }
      catch(e){
        throw GenericException();
      }
  }

  @override
  Future<void> logout() async{
    final user = FirebaseAuth.instance.currentUser;
    if(user != null){
      await FirebaseAuth.instance.signOut();
    }
    else{
      throw UserNotLoggedIn();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if(user!=null){
      await user.sendEmailVerification();
    }
    else{
      throw UserNotLoggedIn();
    }
  }
  

}
