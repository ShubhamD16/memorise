import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

class Signup extends StatelessWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/night_background.jpg"),
                fit: BoxFit.cover)),
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                "assets/icon/Memorize_Icon.jpeg",
                fit: BoxFit.contain,
                height: 300,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              child: Text(
                "Flash Memorize",
                maxLines: 2,
                textAlign: TextAlign.center,
                style: GoogleFonts.architectsDaughter(
                    fontSize: 50,
                    color: Colors.white.withOpacity(0.8),
                    shadows: [
                      Shadow(color: Colors.black87, offset: Offset(5, 5))
                    ],
                    height: 0.8),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                signInWithGoogle();
              },
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
