import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:protrack/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<List> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final UserCredential authResult =
      await _auth.signInWithCredential(credential);
  final User user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final User currentUser = await _auth.currentUser;
  assert(user.uid == currentUser.uid);

  print(_auth.currentUser.displayName);
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setBool("loggedIn", true);
  return [user, authResult.additionalUserInfo.isNewUser];
  // bool registered = sharedPreferences.getBool("registered");
  // print(registered);
  // if (!registered) {
    // var query =
    //     await FirebaseFirestore.instance.collection("Users").doc(authResult.user.email);
    
    // query.get().then((value) {
    //   if(value.exists){
    //     print("Already registered");
    //     sharedPreferences.setBool("registered", true);
    //     return [user, authResult.additionalUserInfo.isNewUser, true];
    //   }
    // });

  // }
}

void signOutGoogle(context) async {
  await googleSignIn.signOut().then((value) async {
    print(_auth.currentUser.displayName);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("loggedIn", false);
    sharedPreferences.setBool("registered", false);
    print("User Sign Out");
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
          pageBuilder: (context, animation, anotherAnimation) {
            return Splash();
          },
          transitionDuration: Duration(milliseconds: 2000),
          transitionsBuilder: (context, animation, anotherAnimation, child) {
            animation =
                CurvedAnimation(curve: Curves.elasticInOut, parent: animation);
            return Align(
                child: SlideTransition(
              position: Tween(begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0))
                  .animate(animation),
              child: child,
            ));
          }),
      (route) => false,
    );
  });
  
}
