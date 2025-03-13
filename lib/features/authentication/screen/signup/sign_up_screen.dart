import 'package:anantkaal_assignment/features/authentication/controller/auth_controller.dart';
import 'package:anantkaal_assignment/utils/constant/font_name.dart';
import 'package:anantkaal_assignment/utils/constant/image_paths.dart';
import 'package:flutter/material.dart';


class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = AuthController.instance;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 55),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePaths.backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                 controller.signUpWithGoogle();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage(ImagePaths.googleIcon),
                    width: 24,
                    height: 24,
                  ),
                  SizedBox(width: 12),
                  Text(
                    "Sign In with Google",
                    style: TextStyle(
                      fontFamily: FontName.openSans,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
