import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../features/authentication/model/user_model.dart';

class DatabaseHandler extends GetxController {
  static DatabaseHandler get instance => Get.find();
  var storageBox = GetStorage();

  var userInformation = "UserInformation";

  var loggedIn = "UserLoggedIn";

  UserModel getUserData() {
    final userDataMap = storageBox.read(userInformation);
    final userData = UserModel.fromJson(userDataMap);
    return userData;
  }
}