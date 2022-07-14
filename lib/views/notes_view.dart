import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';
import 'package:todoapp/Ads/Adhelper.dart';
import 'package:todoapp/constants/routes.dart';
import 'package:todoapp/services/auth/auth_services.dart';
import 'package:todoapp/services/bloc/AuthBloc.dart';
import 'package:todoapp/services/bloc/AuthStates.dart';
import 'package:todoapp/services/cloud/cloud_note.dart';
import 'package:todoapp/services/cloud/firebase_cloud__storage.dart';
import 'package:todoapp/utilities/alert_dialog.dart';
import 'package:todoapp/views/notes/add_notes.dart';
import 'package:todoapp/views/notes/note_list_view.dart';

import '../services/auth/auth_user.dart';

enum MenuItem { logout }

class notesView extends StatefulWidget {
  const notesView({Key? key}) : super(key: key);

  @override
  State<notesView> createState() => _notesViewState();
}

class _notesViewState extends State<notesView> {
  late final FirebaseCloudStorage _notesService;
  String get user_id => AuthService.firebase().currentUser!.id;
  late BannerAd _bannerAd;
  bool isLoaded = false;
  @override
  void initState() {
    initBannerAd();
    //BlocProvider.of<>(context)
    _bannerAd.load();
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  initBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-8351931034895476/3722995036',
      request: AdRequest(),
      listener: BannerAdListener(onAdLoaded: ((ad) {
        setState(
          () {
            isLoaded = true;
          },
        );
      }), onAdFailedToLoad: (ad, err) {
        print(err);
      }),
    );
    _bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(24, 151, 143, 20),
        title: const Text('Your Notes'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(PageTransition(
                  child: AddUpdateNotes(),
                  type: PageTransitionType.rightToLeft));
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuItem>(
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuItem>(
                  value: MenuItem.logout,
                  child: const Text('Log out'),
                )
              ];
            },
            onSelected: (value) async {
              switch (value) {
                case MenuItem.logout:
                  final logout = await showlogoutDialog(context);
                  if (logout) {
                    BlocProvider.of<AuthBloc>(context).logout();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  }
                  log(logout.toString());
                  break;
              }
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: _notesService.allNotes(ownerUserId: user_id),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                return NotesListView(
                  notes: allNotes,
                  onTap: (note) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(addNotes, (route) => false);
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: isLoaded
          ? Container(
              width: _bannerAd.size.width.toDouble(),
              height: _bannerAd.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd),
            )
          : SizedBox(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

Future<void> showErrorDialog(BuildContext context, String text) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Some Error occured'),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          )
        ],
      );
    },
  );
}


 // bottomNavigationBar: isLoaded
      //     ? Container(
      //         width: _bannerAd.size.width.toDouble(),
      //         height: _bannerAd.size.height.toDouble(),
      //         child: AdWidget(ad: _bannerAd),
      //       )
      //     : SizedBox(),