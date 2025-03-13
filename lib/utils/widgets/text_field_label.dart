import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant/app_color.dart';

class TextFieldLabel extends StatelessWidget {
  const TextFieldLabel({
    super.key,
    required this.labelName,
    this.textController,
    this.suffixIcon,
    this.validator,
    this.textColor = const Color(0xff356169),
    this.obscureText = false,
    this.enable = true,
    this.hintText,
    this.maxLine = 1,
    this.keyboardType = TextInputType.text,
  });

  final String labelName;
  final String? hintText;
  final Color textColor;
  final TextEditingController? textController;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool enable;
  final int? maxLine;
  final TextInputType keyboardType;


  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    final hasFocus = false.obs;
    focusNode.addListener(() {
      hasFocus.value = focusNode.hasFocus;
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 6,),
        Text(labelName,style: TextStyle(color: AppColor.textFieldLabel,fontSize: 14,fontWeight: FontWeight.w600),),

        Obx(
          () => Container(
            margin: EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color:
                  hasFocus.value
                      ? AppColor.focusTextFieldBackground
                      : AppColor.enableTextFieldBackground,
              boxShadow: [
                BoxShadow(
                  color: Color(0xffbfe0e2),
                  spreadRadius: hasFocus.value ? 3 : 0,
                  blurStyle: BlurStyle.outer,
                ),
              ],
            ),
            child: TextFormField(
              keyboardType: keyboardType,
              validator: validator,
              focusNode: focusNode,
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              controller: textController,
              obscureText: obscureText,

              maxLines: maxLine,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                enabled: enable,
                hintText: hintText,
                hintStyle: TextStyle(color: AppColor.hintTextFieldColor),
                suffixIcon: suffixIcon,
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor.enableTextFieldOutline.withOpacity(0.25),
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor.enableTextFieldOutline.withOpacity(0.25),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor.focusTextFieldOutline,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }
}
