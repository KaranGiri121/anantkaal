import 'package:anantkaal_assignment/features/chat/controller/chat_controller.dart';
import 'package:anantkaal_assignment/features/chat/model/chat_data.dart';
import 'package:anantkaal_assignment/utils/constant/app_color.dart';
import 'package:anantkaal_assignment/utils/constant/font_name.dart';
import 'package:anantkaal_assignment/utils/constant/image_paths.dart';
import 'package:anantkaal_assignment/utils/helper/helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ChatContainer extends StatelessWidget {
  const ChatContainer({super.key, required this.chatData, required this.ownMessage});

  final ChatData chatData;
    final bool ownMessage;


  @override
  Widget build(BuildContext context) {
    var noMessage = chatData.chatDetails.image.isEmpty && chatData.chatDetails.message.isEmpty;
    var messageTime = Helper.extractTime(chatData.chatDetails.createdAt);
    if (noMessage) return SizedBox.shrink();
    if (ownMessage) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "You",
                      style: TextStyle(
                        color: AppColor.chatUsernameColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      messageTime,
                      style: TextStyle(
                        color: AppColor.chatTimeColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                if (chatData.chatDetails.image.isNotEmpty)
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl:
                            "${ChatController.instance.baseUrl}/${chatData.chatDetails.image}",
                        placeholder: (context, url) {
                          return Image(
                            image: AssetImage(ImagePaths.backgroundImage),
                            fit: BoxFit.cover,
                          );
                        },
                        errorWidget: (context, url, error) {
                          return Image(
                            image: AssetImage(ImagePaths.backgroundImage),
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                if (chatData.chatDetails.message.isNotEmpty)
                  Container(
                    padding: EdgeInsets.only(
                      left: 12,
                      top: 12,
                      bottom: 12,
                      right: 24,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.chatBoxBackground,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                        topRight: Radius.zero,
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Text(
                      chatData.chatDetails.message,
                      style: TextStyle(
                        color: AppColor.chatTextColor,
                        fontFamily: FontName.openSans,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
    } else {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.only(right: 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  chatData.userDetails.name,
                  style: TextStyle(
                    color: AppColor.chatUsernameColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                Text(
                  messageTime,
                  style: TextStyle(color: AppColor.chatTimeColor, fontSize: 12),
                ),
              ],
            ),
            if (chatData.chatDetails.image.isNotEmpty)
              SizedBox(
                width: 200,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl:
                       "${ChatController.instance.baseUrl}/${chatData.chatDetails.image}",
                    placeholder: (context, url) {
                      return Image(
                        image: AssetImage(ImagePaths.backgroundImage),
                        fit: BoxFit.cover,
                      );
                    },
                    errorWidget: (context, url, error) {
                      return Image(
                        image: AssetImage(ImagePaths.backgroundImage),
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
            if (chatData.chatDetails.message.isNotEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColor.chatBoxBackground,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Text(
                  chatData.chatDetails.message,
                  style: TextStyle(
                    color: AppColor.chatTextColor,
                    fontFamily: FontName.openSans,
                  ),
                ),
              ),
          ],
        ),
      );
    }
  }
}
