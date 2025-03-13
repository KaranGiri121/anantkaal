import 'package:anantkaal_assignment/data/repo/database_handler.dart';
import 'package:anantkaal_assignment/data/repo/firebase_handler.dart';
import 'package:anantkaal_assignment/features/authentication/controller/auth_controller.dart';
import 'package:get/get.dart';

class GeneralBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(DatabaseHandler());
    Get.put(FirebaseHandler());
    Get.put(AuthController());
  }

}