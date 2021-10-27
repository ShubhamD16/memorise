import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memorise/components/fontsdata.dart';
import 'package:memorise/pages/mainpage.dart';
import 'package:memorise/pages/siginup.dart';
import 'package:memorise/providers/casdsdata.dart';
import 'package:memorise/providers/settings_provider.dart';
import 'package:memorise/providers/sharedcards_provider.dart';
import 'package:memorise/providers/userdata_provider.dart';
import 'package:memorise/providers/userstate_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, usersnap) {
            if (usersnap.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (!usersnap.hasData) {
              return const Scaffold(
                body: Signup(),
              );
            }
            //////////////////////////////////////
            // Ading Providers

            List<SingleChildWidget> providers = [
              // User Login Data
              ChangeNotifierProvider<UserState>.value(
                  value: UserState(usersnap.data)),
              // theme and font
              ChangeNotifierProvider<Setting>.value(value: Setting()),
            ];

            if (usersnap.hasData) {
              // User Data
              providers.add(StreamProvider<UserData>.value(
                value: FirebaseFirestore.instance
                    .collection("users")
                    .doc(usersnap.data!.uid)
                    .snapshots()
                    .map((event) => UserData(event.data())),
                initialData: UserData({}),
              ));

              // User Cards

              providers.add(StreamProvider<AllCardsData>.value(
                value: FirebaseFirestore.instance
                    .collection("cards")
                    .where("uid", isEqualTo: usersnap.data!.uid)
                    .orderBy("timestamp", descending: true)
                    .snapshots()
                    .map((event) {
                  return AllCardsData(event.docs);
                }),
                initialData: AllCardsData([]),
              ));

              // SharedCards
              providers.add(StreamProvider<SharedCards>.value(
                value: FirebaseFirestore.instance
                    .collection("cards")
                    .where("shared", arrayContains: usersnap.data!.uid)
                    .orderBy("timestamp", descending: true)
                    .snapshots()
                    .map((event) {
                  return SharedCards(event.docs);
                }),
                initialData: SharedCards([]),
              ));
            }

            ///////////////////////////////////////

            return MultiProvider(
              providers: providers,
              builder: (context, child) {
                String mode, font;
                if (context.watch<UserData>().data != null) {
                  if (context.watch<UserData>().data!.isNotEmpty) {
                    font = context.watch<UserData>().data!["font"];
                    mode = context.watch<UserData>().data!["mode"];

                    if (mode == "light") {
                      context.read<Setting>().setfontmode(
                          GetFont().getheme(font), Brightness.light);
                    } else {
                      context.read<Setting>().setfontmode(
                          GetFont().getheme(font), Brightness.dark);
                    }
                  }
                }
                return MaterialApp(
                  title: 'Flutter Demo',
                  theme: context.watch<Setting>().getTheme(context),
                  routes: {
                    "/": (context) => const Dashboard(),
                  },
                  initialRoute: "/",
                );
              },
            );
          }),
    );
  }
}
