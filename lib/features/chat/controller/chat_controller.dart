import 'dart:convert';
import 'dart:developer';

import 'package:anantkaal_assignment/data/repo/database_handler.dart';
import 'package:anantkaal_assignment/features/authentication/model/user_model.dart';
import 'package:anantkaal_assignment/features/chat/model/chat_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class ChatController extends GetxController {
  static ChatController get instance => Get.find();
  final chatScrollController = ScrollController();
  final isLoading = false.obs;
  var baseUrl = "https://spell.theanantkaal.com";
  var paginationTotalPage = -1;
  var paginationCurrentPage = -1;
  RxList<ChatData> allChats = RxList();
  Rx<UserModel> userInformation = DatabaseHandler.instance.getUserData().obs;
  final TextEditingController chatText = TextEditingController();
  final emojiSection = false.obs;

  @override
  void onInit() {
    if (userInformation.value.userId == -1) {
      fetchUserId();
    } else {
      initWork();
    }
    super.onInit();
  }

  void initWork() {
    fetchNewChat();
    chatScrollController.addListener(() {
      Logger().e(chatScrollController.offset);
      Logger().e(chatScrollController.position.maxScrollExtent);
      if (chatScrollController.offset ==
          chatScrollController.position.maxScrollExtent) {
        Logger().e("message $paginationCurrentPage");
        if (paginationCurrentPage != -1) {
          paginationCurrentPage += 1;
          Logger().e("fetching Old One");
          fetchOldChat();
        }
      }
    });
  }

  void fetchOldChat() async {
    isLoading.value = true;

    var chatUrl = "$baseUrl/api/showglobalchat?page=$paginationCurrentPage";

    var header = {
      "Authorization":
          "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJyb2xlIjoidXNlciIsImV4cCI6MTc0Mjc5ODIzMH0.zrDP2J7RqAxwDzz5dLtjcrDqh8M1pwmU9QapL8Q2Sk0",
    };

    try {
      Logger().e(chatUrl);
      var response = await http.get(Uri.parse(chatUrl), headers: header);
      Logger().e(response.body.toString());
      var responseBody = jsonDecode(response.body);
      var pagination = responseBody["pagination"];

      if (pagination != null) {
        var tempCurrentPage = pagination["current_page"];
        if (tempCurrentPage != null) {
          paginationCurrentPage = tempCurrentPage;
        }
      }
      var data = responseBody["data"];
      if (data != null) {
        for (var information in data) {
          allChats.add(ChatData.fromJson(information));
        }
      }
    } catch (e) {
      if (!Get.isSnackbarOpen) {
        Get.snackbar("Error", "We Are Facing Some Technical Fault");
      }
      log(e.toString());
      Logger().e(e);
    } finally {
      isLoading.value = false;
    }
  }

  void fetchNewChat() async {
    var chatUrl = "$baseUrl/api/showglobalchat?page=1";
    allChats.value = [];
    var header = {"Authorization": userInformation.value.token};

    try {
      Logger().e(chatUrl);

      var response = await http.get(Uri.parse(chatUrl), headers: header);
      Logger().e(response.body.toString());
      var responseBody = jsonDecode(response.body);
      var pagination = responseBody["pagination"];
      if (pagination != null) {
        var tempTotalPage = pagination["total_pages"];
        if (tempTotalPage != null) {
          paginationTotalPage = tempTotalPage;
          paginationCurrentPage = 1;
        }
      }
      var data = responseBody["data"];
      if (data != null) {
        for (var information in data) {
          allChats.add(ChatData.fromJson(information));
        }
      }
    } catch (e) {
      if (!Get.isSnackbarOpen) {
        Get.snackbar("Error", "We Are Facing Some Technical Fault");
      }
      log(e.toString());
      Logger().e(e);
    } finally {
      Logger().e("Done New One");
    }
  }

  void fetchUserId() async {

    var fetchUserUrl = "https://spell.theanantkaal.com/api/showglobaluser";
    var header = {"Authorization": "Bearer ${userInformation.value.token}"};

    var response = await http.get(Uri.parse(fetchUserUrl), headers: header);
    var responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var data = responseBody["data"].first;
      var id = data["id"];
      userInformation.value.userId = id;
      initWork();
    }
  }

  void sendChat(bool isMessage,XFile? imageFile)  async {
    var chatUrl = "https://spell.theanantkaal.com/api/createglobalchat";
    var header = {"Authorization": userInformation.value.token};
    Map<String,dynamic>body ;
    if (isMessage) {
      body= {"message": chatText.text.trim()};
      chatText.text = "";
    } else {
      var imagePath =await  uploadImage(imageFile!);

      if(imagePath.isEmpty){
        return ;
      }
      body = {
        "image": imagePath,
      };
    }
    try{
      var response = await http.post(Uri.parse(chatUrl),headers: header,body: body);
      var responseBody = jsonDecode(response.body);
      Logger().e(responseBody);

      if(response.statusCode == 200){
        var status = responseBody["status"];
        if(status=="true"){
          initWork();
        }else{
          if(!Get.isSnackbarOpen){
            Get.snackbar("Sorry", "Some Technical Fault");
          }
        }
      }
    }catch(e){
      if(!Get.isSnackbarOpen){
        Get.snackbar("Sorry", "Some Technical Fault");
      }
    }
  }

  Future<String> uploadImage(XFile imageFile) async {
    var uploadImageUrl = "https://spell.theanantkaal.com/api/save-Multipart-Image";

    var request = http.MultipartRequest("POST", Uri.parse(uploadImageUrl));
    var stream = http.ByteStream(imageFile.openRead());
    var length = await imageFile.length();

    var multipartFile = http.MultipartFile(
      'file',
      stream,
      length,
      filename: imageFile.path.split('/').last,
    );

    request.files.add(multipartFile);
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(await response.stream.bytesToString());
        Logger().e(responseBody);
        var url = responseBody["half_url"];
        return url;
      } else {
        return "";
      }
    } catch (e) {
      Logger().e(e);
      return "";
    }
  }
}
