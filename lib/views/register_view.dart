import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/constants/routes.dart';
import 'package:todoapp/services/auth/auth_exceptions.dart';
import 'package:todoapp/services/auth/auth_services.dart';
import 'package:todoapp/services/bloc/AuthBloc.dart';
import 'package:todoapp/services/bloc/AuthStates.dart';
import 'package:todoapp/views/notes_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordException) {
            await showErrorDialog(context, 'Weak Password');
          } else if (state.exception is EmailAlreadyInUse) {
            await showErrorDialog(context, 'Email Already in use');
          } else if (state.exception is GenericException) {
            await showErrorDialog(context, 'Authentication Error');
          } else if (state.exception is InvalidEmailException) {
            await showErrorDialog(context, 'Invalid Email');
          }
        }
      },
      child: Scaffold(
        backgroundColor: Color.fromRGBO(6, 40, 61, 30),
        body: FutureBuilder(builder: (context, snapshot) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 50),
                child: const Text(
                  'Todos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 45,
                    fontFamily: 'Fredoka',
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                child: const Text(
                  'Register',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Fredoka',
                      fontWeight: FontWeight.w900,
                      fontSize: 35),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 60, left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(83, 191, 157, 20),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  controller: _email,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter Your Email Here',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(83, 191, 157, 20),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  controller: _password,
                  autocorrect: false,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    hintText: 'Enter Your Password Here',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Column(
                  children: [
                    SizedBox(
                      width: 290,
                      child: TextButton(
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;

                          BlocProvider.of<AuthBloc>(context)
                              .register(email: email, password: password);
                          final user = await AuthService.firebase().currentUser;
                          if (user?.isEmailVerified) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                notesRoute, (route) => false);
                          } else {
                            //AuthService.firebase().sendEmailVerification();
                            BlocProvider.of<AuthBloc>(context)
                                .sendEmailVerification();
                            final snack = SnackBar(
                              content: const Text(
                                  "We've sent you a verification email, It maybe in the spam folder"),
                              action: SnackBarAction(
                                  label: 'close', onPressed: () {}),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(snack);
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Color.fromRGBO(53, 66, 89, 50),
                        ),
                        child: const Text('Register',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontFamily: 'Fredoka',
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                    Container(
                      height: 50,
                      margin: const EdgeInsets.only(top: 30),
                      child: SizedBox(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              loginRoute,
                              (route) => false,
                            );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(53, 66, 89, 50),
                          ),
                          child: const Text(
                            "Already have an account ? Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Fredoka',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
