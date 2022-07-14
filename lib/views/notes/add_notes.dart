import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:todoapp/constants/routes.dart';
import 'package:todoapp/extnsions/get_arguments.dart';
import 'package:todoapp/services/auth/auth_services.dart';
import 'package:todoapp/services/cloud/cloud_note.dart';
import 'package:todoapp/services/cloud/firebase_cloud__storage.dart';

typedef NoteCallBack = void Function(CloudNote note);

class AddUpdateNotes extends StatefulWidget {
  const AddUpdateNotes({Key? key}) : super(key: key);

  @override
  State<AddUpdateNotes> createState() => _AddUpdateNotesState();
}

class _AddUpdateNotesState extends State<AddUpdateNotes> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController controller;
  late BannerAd _bannerAd;
  bool isLoaded = false;
  @override
  void initState() {
    initBannerAd();
    _notesService = FirebaseCloudStorage();
    controller = TextEditingController();
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
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text(
          'Add Your Notes',
          style: TextStyle(fontFamily: 'Fredoka'),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(24, 151, 143, 20),
      ),
      body: Column(
        children: [
          Container(
            width: 500,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(25),
                color: const Color.fromARGB(255, 255, 255, 255)),
            child: Column(
              children: [
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: const TextStyle(fontFamily: 'Fredoka'),
                  decoration: InputDecoration(
                      hintText: 'Start typing your note',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25))),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    width: 90,
                    child: TextButton(
                      onPressed: () async {
                        final user_Id = AuthService.firebase().currentUser!.id;

                        if (controller.text.isEmpty) {
                          const snackbar = SnackBar(
                            content: Text('You cannot add empty notes!'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        } else {
                          final note = controller.text;
                          _notesService.createNewNote(
                            ownerUserId: user_Id,
                            text: note,
                          );

                          Navigator.of(context).pushNamedAndRemoveUntil(
                            notesRoute,
                            (route) => false,
                          );
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 116, 146, 170),
                      ),
                      child: const Text(
                        'Add',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 22,
                          fontFamily: 'Fredoka',
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
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
}
