import 'package:anantkaal_assignment/data/repo/database_handler.dart';
import 'package:anantkaal_assignment/features/authentication/screen/signup/sign_up_form.dart';
import 'package:anantkaal_assignment/features/authentication/screen/signup/sign_up_screen.dart';
import 'package:anantkaal_assignment/features/chat/screen/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

import '../../features/authentication/model/user_model.dart';

class FirebaseHandler extends GetxController {
  static FirebaseHandler get instance => Get.find();
  final firebaseAuth = FirebaseAuth.instance;

  @override
  void onReady() {
    handleRedirection();
    super.onReady();
  }

  void handleRedirection() async {
    var user = firebaseAuth.currentUser;
    FlutterNativeSplash.remove();
    if (user == null) {
      Get.offAll(() => SignUpScreen());
    } else {
      final databaseHandler = DatabaseHandler.instance;

      if (databaseHandler.storageBox.read(databaseHandler.loggedIn) == true) {
        Get.offAll(() => ChatScreen());
      } else {
        await databaseHandler.storageBox.writeIfNull(
          databaseHandler.userInformation,
          UserModel(
            userName: user.displayName ?? "Anonymous",
            userEmail: user.email ?? "example@gmail.com",
          ).toJson(),
        );

        Logger().e(databaseHandler.storageBox.read(databaseHandler.loggedIn));
        Get.offAll(() => SignUpForm());
      }
    }
  }

  Future<UserCredential?> getSignWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? auth = await account?.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: auth?.accessToken,
        idToken: auth?.idToken,
      );

      return firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }
}
