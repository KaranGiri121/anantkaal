import 'package:anantkaal_assignment/features/chat/controller/chat_controller.dart';
import 'package:anantkaal_assignment/features/chat/screen/widgets/chat_container.dart';
import 'package:anantkaal_assignment/features/chat/screen/widgets/chat_input_field.dart';
import 'package:anantkaal_assignment/utils/constant/app_color.dart';
import 'package:anantkaal_assignment/utils/constant/font_name.dart';
import 'package:anantkaal_assignment/utils/constant/image_paths.dart';
import 'package:anantkaal_assignment/utils/helper/full_screen_loader.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatController = Get.put(ChatController());
    final canPop = false.obs;
    return Obx(
      ()=> PopScope(
        canPop: canPop.value,
        onPopInvokedWithResult: (didPop, result) {
          if (chatController.emojiSection.value) {
            chatController.emojiSection.value = false;
          }
          canPop.value = true;
        },
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            backgroundColor: AppColor.buttonColor,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Group Chat",
                  style: TextStyle(
                    letterSpacing: 1,
                    wordSpacing: 2,
                    fontFamily: FontName.cherry,
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                    color: Color(0xffFDFFFF),
                  ),
                ),
                Obx(
                  () => Text(
                    "Hi ${chatController.userInformation.value.userName}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {},
                child: Image(
                  image: AssetImage(ImagePaths.magicWandIcon),
                  width: 24,
                  height: 24,
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shrinkWrap: true,
                    reverse: true,
                    controller: chatController.chatScrollController,
                    itemCount: chatController.allChats.length + 1,
                    itemBuilder: (context, index) {
                      if (chatController.allChats.length == index) {
                        return chatController.isLoading.value
                            ? Center(child: CircularProgressIndicator())
                            : SizedBox.shrink();
                      }
                      var chatData = chatController.allChats[index];
                      return ChatContainer(
                        chatData: chatData,
                        ownMessage:
                            chatController.userInformation.value.userId ==
                            chatData.userDetails.id,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 12),
              ChatInputField(),
              Obx(
                () =>
                    chatController.emojiSection.value
                        ? EmojiPicker()
                        : SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
