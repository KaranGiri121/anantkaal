import 'package:anantkaal_assignment/data/general_binding/general_binding.dart';

import 'package:anantkaal_assignment/firebase_options.dart';
import 'package:anantkaal_assignment/utils/constant/app_color.dart';
import 'package:anantkaal_assignment/utils/constant/font_name.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  var widget = WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  FlutterNativeSplash.preserve(widgetsBinding: widget);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: GeneralBinding(),
      theme: ThemeData(
        scaffoldBackgroundColor: AppColor.backgroundColor,
        fontFamily: FontName.exo,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColor.buttonColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ),

      home: Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
