import 'package:anantkaal_assignment/features/chat/controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../utils/constant/font_name.dart';
import '../../../../utils/constant/image_paths.dart';
import '../../../../utils/helper/full_screen_loader.dart';

class ChatInputField extends StatelessWidget {
  const ChatInputField({super.key});

  @override
  Widget build(BuildContext context) {
    final chatController = ChatController.instance;

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xff438E96))),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: SizedBox(
        height: 45,
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xffDDEFF0),
                  border: Border.all(color: Color(0xff438E96)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: TextField(
                  expands: true,
                  maxLines: null,
                  minLines: null,
                  controller: chatController.chatText,
                  style: TextStyle(color: Color(0xff438E96)),
                  decoration: InputDecoration(
                    hintText: "Enter Message",
                    hintStyle: TextStyle(
                      fontFamily: FontName.openSans,
                      color: Color(0xff438E96),
                    ),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    prefixIcon: IconButton(
                      onPressed: () {
                        chatController.emojiSection.value = !chatController.emojiSection.value;
                      },
                      icon: ImageIcon(
                        AssetImage(ImagePaths.emojiIcon),
                        color: Color(0xff438E96),
                      ),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () async {
                        final image = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        );
                        if (image != null) {
                          FullScreenLoader.imageSendConfirmation(
                            onConfirm: () {
                              FullScreenLoader.stopLoader();
                              chatController.sendChat(false, image);
                            },
                          );
                        }
                      },
                      icon: ImageIcon(
                        AssetImage(ImagePaths.galleryIcon),
                        color: Color(0xff438E96),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            SizedBox(
              height: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  if (chatController.chatText.text.trim().isNotEmpty) {
                    FullScreenLoader.stopLoader();
                    chatController.sendChat(true, null);
                  }
                },
                child: ImageIcon(
                  AssetImage(ImagePaths.sendIcon),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
