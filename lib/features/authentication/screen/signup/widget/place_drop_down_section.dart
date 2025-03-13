import 'package:anantkaal_assignment/features/authentication/controller/auth_controller.dart';
import 'package:anantkaal_assignment/utils/constant/image_paths.dart';
import 'package:country_state_city/country_state_city.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../../../utils/constant/app_color.dart';

class PlaceDropDownSection extends StatelessWidget {
  const PlaceDropDownSection({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = AuthController.instance;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Country",style: TextStyle(color: AppColor.textFieldLabel,fontSize: 14,fontWeight: FontWeight.w600),),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xffD7D7D7)),
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Obx(
                () => DropdownButton(
                  icon: ImageIcon(AssetImage(ImagePaths.downIcon),color: Color(0xff438E96)),
              value: authController.selectCountry.value,
              hint: Text("Please Select Country"),
              underline: SizedBox.shrink(),
              isExpanded: true,
              items:
              authController.countryList.map((element) {
                return DropdownMenuItem(
                  value: element,
                  child: Text(element.name),
                );
              }).toList(),
              onTap: () {
                authController.stateList.value = [];
                authController.cityList.value = [];
                authController.selectedCity.value = null;
                authController.selectedState.value = null;
              },
              onChanged: (value) async {
                if (value != null) {
                  authController.selectCountry.value = value;
                  authController.stateList.value =
                  await getStatesOfCountry(value.isoCode);
                  Logger().e(authController.stateList.length);
                }
              },
            ),
          ),
        ),
        SizedBox(height: 12,),
        Text("State",style: TextStyle(color: AppColor.textFieldLabel,fontSize: 14,fontWeight: FontWeight.w600),),
        Obx(
              () => Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xffD7D7D7)),
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButton(
              onTap: () {
                authController.cityList.value = [];
                authController.selectedCity.value = null;
              },
              icon: ImageIcon(AssetImage(ImagePaths.downIcon),color: Color(0xff438E96)),
              value: authController.selectedState.value,
              hint:
              authController.selectCountry.value == null
                  ? Text("Please Select Country First")
                  : authController.stateList.isEmpty
                  ? Text("No State Found Sorry")
                  : Text("Please Select State"),
              underline: SizedBox.shrink(),
              isExpanded: true,
              items:
              authController.stateList.map((element) {
                return DropdownMenuItem(
                  value: element,
                  child: Text(element.name),
                );
              }).toList(),
              onChanged: (value) async {
                if (value != null) {
                  authController.selectedState.value = value;
                  authController
                      .cityList
                      .value = await getStateCities(
                    authController.selectCountry.value!.isoCode,
                    authController.selectedState.value!.isoCode,
                  );
                }
              },
            ),
          ),
        ),
        SizedBox(height: 12,),
        Text("City",style: TextStyle(color: AppColor.textFieldLabel,fontSize: 14,fontWeight: FontWeight.w600),),
        Obx(
              () => Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xffD7D7D7)),
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButton(
              icon: ImageIcon(AssetImage(ImagePaths.downIcon),color: Color(0xff438E96)),
              value: authController.selectedCity.value,
              hint:
              authController.selectedState.value == null
                  ? Text("Please Select State First")
                  : authController.cityList.isEmpty
                  ? Text("No City Found Sorry")
                  : Text("Please Select Ciyt"),
              underline: SizedBox.shrink(),
              isExpanded: true,
              items:
              authController.cityList.map((element) {
                return DropdownMenuItem(
                  value: element,
                  child: Text(element.name),
                );
              }).toList(),
              onChanged: (value) async {
                if (value != null) {
                  authController.selectedCity.value = value;
                }
              },
            ),
          ),
        ),
        SizedBox(height: 12,),
      ],
    );
  }
}
