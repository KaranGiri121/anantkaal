import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FullScreenLoader {
  static bool loaded = false;

  static void circularLoader() {
    loaded = true;
    showDialog(
      context: Get.overlayContext!,
      builder: (context) {
        return Dialog(
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  static void stopLoader() {
    if (loaded) {
      loaded = false;
      Navigator.of(Get.overlayContext!).pop();
    }
  }

  static void imageSendConfirmation({void Function()? onConfirm}) {
    loaded = true;
    showDialog(
      context: Get.overlayContext!,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Are You Sure ?\nYou Want To Send This Image"),
                SizedBox(height: 24,),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          stopLoader();
                        },
                        child: Text("Cancel"),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onConfirm,
                        child: Text("Sure"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
