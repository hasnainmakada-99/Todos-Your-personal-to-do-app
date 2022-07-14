import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:todoapp/constants/enums.dart';
import 'package:todoapp/constants/routes.dart';
import 'package:todoapp/services/auth/auth_services.dart';
import 'package:todoapp/services/auth/firebase_authentication_provider.dart';
import 'package:todoapp/services/bloc/AuthBloc.dart';
import 'package:todoapp/services/bloc/AuthEvents.dart';
import 'package:todoapp/services/bloc/AuthStates.dart';
import 'package:todoapp/services/bloc/internet_cubit.dart';
import 'package:todoapp/services/bloc/internet_state.dart';
import 'package:todoapp/utilities/loading_dialog.dart';
import 'package:todoapp/views/login_view.dart';
import 'package:todoapp/views/notes/add_notes.dart';
import 'package:todoapp/views/register_view.dart';
import 'views/notes_view.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: Splash(),
        routes: {
          loginRoute: (context) => const loginView(),
          registerRoute: (context) => const RegisterView(),
          notesRoute: (context) => const notesView(),
          addNotes: (context) => const AddUpdateNotes(),
        },
        builder: EasyLoading.init(),
      ),
    ),
  );
}

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateRoute: HomePage(),
      duration: 2000,
      imageSize: 130,
      imageSrc: 'assests/images/todo.jpg',
      text: 'Todos',
      textType: TextType.NormalText,
      backgroundColor: Colors.white,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).initialise();
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state.isLoading) {
          await EasyLoading.showProgress(100);
        } else {
          await EasyLoading.dismiss();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const notesView();
        } else if (state is AuthStateLoggedOut) {
          return const loginView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
