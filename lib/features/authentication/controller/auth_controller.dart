import 'dart:convert';

import 'package:anantkaal_assignment/features/authentication/model/user_model.dart';
import 'package:anantkaal_assignment/features/authentication/screen/signup/sign_up_form.dart';
import 'package:anantkaal_assignment/features/chat/screen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:country_state_city/country_state_city.dart' as Country;
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../../../data/repo/database_handler.dart';
import '../../../data/repo/firebase_handler.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();
  final obscurePassword = true.obs;

  final RxList<Country.Country> countryList = RxList();
  final RxList<Country.State> stateList = RxList();
  final RxList<Country.City> cityList = RxList();
  final Rx<Country.Country?> selectCountry = Rx(null);
  final Rx<Country.State?> selectedState = Rx(null);
  final Rx<Country.City?> selectedCity = Rx(null);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController fullName = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController postalCode = TextEditingController();

  final RxString selectedGender = "Male".obs;

  final dob = "".obs;

  @override
  void onInit() {
    Country.getAllCountries().then((value) {
      countryList.addAll(value);
    });
    super.onInit();
  }

  void signUpWithGoogle() async {
    try {
      var authCredential = await FirebaseHandler.instance.getSignWithGoogle();
      if (authCredential != null) {
        if (authCredential.user != null) {
          await DatabaseHandler.instance.storageBox.write(
            DatabaseHandler.instance.userInformation,
            UserModel(
              userName: authCredential.user!.displayName ?? "Anonymous",
              userEmail: authCredential.user!.email ?? "example@gmail.com",
            ).toJson(),
          );

          Get.off(()=> SignUpForm());
        }else{
          if(!Get.isSnackbarOpen){
            Get.snackbar("Sign In", "Please Try Again");
          }
        }
      }else{
        if(!Get.isSnackbarOpen){
          Get.snackbar("Sign In", "Please Try Again");
        }
      }
    } catch (e) {
      if(!Get.isSnackbarOpen){
        Get.snackbar("Error", "Technical Fault");
      }
    }
  }

  void createAccount() async {
    if(!formKey.currentState!.validate()){
      return ;
    }

    try{
      var createUser = "https://spell.theanantkaal.com/api/createglobaluser";
      var body = {
        "name": fullName.text.trim(),
        "email": email.text.trim(),
        "phone_number": phone.text.trim(),
        "gender": selectedGender.value,
        "address": address.text.trim(),
        "city": selectedCity.value?.name,
        "state": selectedState.value?.name,
        "date_of_birth": dob.value,
      };

      Logger().e(body);
      var response = await http.post(
        Uri.parse(createUser),
        body: body,
      );

      Logger().e(response.body);
      if(response.statusCode == 200){
          var responseBody = jsonDecode(response.body);
          Logger().e(responseBody);
          var status = responseBody["status"] ;
          var message = responseBody["message"];
          if(status =="true"){
            var token = responseBody["token"];
            final databaseHandler = DatabaseHandler.instance;
            var userData = databaseHandler.getUserData();
            userData.token = token;
            databaseHandler.storageBox.write(databaseHandler.userInformation, userData.toJson());
            databaseHandler.storageBox.write(databaseHandler.loggedIn, true);
            Get.to(()=> ChatScreen());
          }else{
            if(!Get.isSnackbarOpen){
              Get.snackbar("Issue", message);
            }
          }
      }
    }finally{

    }
  }

  String validatePassword(String password) {
    if (password.length < 8) {
      return "Password Length Should Be More Than 8";
    }

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialCharacters = password.contains(
      RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
    );

    if (hasUppercase && hasLowercase && hasDigits && hasSpecialCharacters) {
      return "";
    } else {
      return "Password Contains At Least One Uppercase Letter, One Lowercase Letter, One digit, And One Special Character,";
    }
  }


}
