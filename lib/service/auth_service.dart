import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intagramclone/pages/sign_in_page.dart';
import 'package:intagramclone/service/pref_service.dart';
import 'package:get/get.dart';

class AuthService {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static Future<Map<String, User?>> signUpUser(String name,String email, String password)async{
    Map<String, User?> map = {};
    try{
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      map = {"SUCCESS": user};
      if (kDebugMode) {
        print(user.toString());
      }
      return map;
    }
    on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {

        map = {'weak-password': null};
      } else if (e.code == 'email-already-in-use') {
        map = {'email-already-in-use': null};
      }
    }
    catch (e) {
      map = {"ERROR": null};
    }
    return map ;

  }
  static Future<Map<String, User?>> signInUser(String email, String password) async {
    Map<String, User?> map = {};
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      map = {"SUCCESS": user};
      return map;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        map = {'user-not-found': null};
      } else if (e.code == 'wrong-password') {
        map = {'wrong-password': null};
      }
    } catch (e) {
      map = {"ERROR": null};
    }

    return map;
  }

  static void signOutUser(BuildContext context) async {
    await auth.signOut();
    Prefs.remove(StorageKeys.UID).then((value) {
      //Navigator.pushReplacementNamed(context, SignInPage.id);
      Get.to(SignInPage());
    });
  }
}