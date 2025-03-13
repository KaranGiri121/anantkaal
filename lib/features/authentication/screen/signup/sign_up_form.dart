import 'package:anantkaal_assignment/data/repo/database_handler.dart';
import 'package:anantkaal_assignment/features/authentication/controller/auth_controller.dart';
import 'package:anantkaal_assignment/features/authentication/screen/signup/widget/place_drop_down_section.dart';
import 'package:anantkaal_assignment/utils/constant/app_color.dart';
import 'package:anantkaal_assignment/utils/constant/font_name.dart';
import 'package:anantkaal_assignment/utils/constant/image_paths.dart';
import 'package:anantkaal_assignment/utils/widgets/text_field_label.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = AuthController.instance;
    final userData = DatabaseHandler.instance.getUserData();
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 12,
          right: 12,
          top: kToolbarHeight,
          bottom: kBottomNavigationBarHeight,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(
          "Sign Up",
          style: TextStyle(
            fontFamily: FontName.cherry,
            fontSize: 40,
            color: Color(0xff438E96),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "Please enter your credentials to proceed ",
          style: TextStyle(color: Color(0xff3A4750), fontSize: 16),
        ),
        Form(
          autovalidateMode: AutovalidateMode.onUnfocus,
          key: authController.formKey,
          child: Column(
              children: [
              TextFieldLabel(
              validator: (value)
          {
          if (value != null) {
          if (value.isEmpty) {
          return "Full Name Cannot Be Empty";
          }
          }

          return null;
          },
          textController:
          authController.fullName..text = userData.userName,
          labelName: "Full Name",
          textColor: Color(0xff356169),
        ),
        TextFieldLabel(
          textController: authController.phone,
          validator: (value) {
            if (value != null) {
              if (value.isEmpty) {
                return "Phone Number Cannot Be Empty";
              }
              if (value.length > 10) {
                return "Phone Number Cannot Exceed 10 Digit";
              }
              if (value.length < 10) {
                return "Phone Number Cannot Less Than 10 Digit";
              }
            }
            return null;
          },
          keyboardType: TextInputType.number,
          labelName: "Phone",
          textColor: Color(0xff356169),
        ),
        TextFieldLabel(
          textController:
          authController.email..text = "karangiri121@gmail.com",
          labelName: "Email address",
          textColor: Color(0xff325158),
          enable: false,
        ),
        Obx(
              () =>
              TextFieldLabel(
                textController: authController.password,
                validator: (value) {
                  if (value != null) {
                    var validatePassword = authController
                        .validatePassword(value);
                    if (validatePassword.isNotEmpty) {
                      return validatePassword;
                    }
                  }
                  return null;
                },
                labelName: "Password",
                textColor: Color(0xff356169),
                obscureText: authController.obscurePassword.value,
                suffixIcon: IconButton(
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    authController.obscurePassword.value =
                    !authController.obscurePassword.value;
                  },
                  icon: authController.obscurePassword.value ? ImageIcon(
                    AssetImage(ImagePaths.eyeSlashIcon),) : Icon(
                      CupertinoIcons.eye),
                  color: AppColor.buttonColor,
                ),
              ),
        ),

      TextFieldLabel(
        textController: authController.address,
        validator: (value) {
          if (value != null) {
            if (value.isEmpty) {
              return "Please Enter Address";
            }
          }
          return null;
        },
        labelName: "Address:",
        maxLine: 3,
        hintText: "Address Line 1\nAddress Line 2\nAddress Line3",
        textColor: Color(0xff325158),
      ),

      PlaceDropDownSection(),

      TextFieldLabel(
        textController: authController.postalCode,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value != null) {
            if (value.isEmpty) {
              return "Please Enter PostalCode";
            }
            if (value.length < 6 || value.length > 6) {
              return "Please Enter Six Digit Postal Code";
            }
          }
          return null;
        },
        labelName: "Postal Code",
        hintText: "123456",
      ),

      Obx(
            () =>
            InkWell(
              onTap: () async {
                var pickedDate = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1990),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  authController.dob.value =
                  "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                }
              },
              child: TextFieldLabel(
                validator: (value) {
                  if (authController.dob.value.isEmpty) {
                    return "Please Select Date Of Birth";
                  }
                  return null;
                },
                enable: false,
                labelName: "Date Picker",
                hintText:
                authController.dob.isEmpty
                    ? "Select"
                    : authController.dob.value,
                suffixIcon: IconButton(
                  onPressed: () async {
                    var pickedDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1990),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      authController.dob.value =
                      "${pickedDate.day}/${pickedDate.month}/${pickedDate
                          .year}";
                    }
                  },
                  icon: ImageIcon(AssetImage(ImagePaths.calenderIcon),
                    color: Color(0xff438E96),),
                ),
                textColor: Colors.red,
              ),
            ),
      ),
      ],
    ),
    ),
    Obx(
    () => Row(
    children: [
    Radio<String>(
    activeColor: AppColor.radioActiveColor,
    value: 'Male',
    groupValue: authController.selectedGender.value,
    onChanged: (value) {
    authController.selectedGender.value = value!;
    },
    ),
    const Text('Male'),
    Radio<String>(
    activeColor: AppColor.radioActiveColor,
    value: 'Female',
    groupValue: authController.selectedGender.value,
    onChanged: (value) {
    authController.selectedGender.value = value!;
    },
    ),
    const Text('Female'),
    Radio<String>(
    activeColor: AppColor.radioActiveColor,
    value: "None",
    groupValue: authController.selectedGender.value,
    onChanged: (value) {
    authController.selectedGender.value = value!;
    },
    ),
    Expanded(
    child: Text(
    "Prefer not to say",
    overflow: TextOverflow.ellipsis,
    ),
    ),
    ],
    ),
    ),

    SizedBox(
    width: double.infinity,

    child: ElevatedButton(
    style: ElevatedButton.styleFrom(
    padding: EdgeInsets.symmetric(vertical: 18),
    ),
    onPressed: () {
    authController.createAccount();
    },
    child: Text("CREATE ACCOUNT"),
    ),
    ),
    ],
    ),
    ),
    );
  }
}
