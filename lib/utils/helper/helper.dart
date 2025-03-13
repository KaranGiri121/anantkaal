import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class Helper {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static String extractTime(String datetimeString) {
    try {
      DateTime datetime = DateTime.parse(datetimeString);

      String time =  DateFormat('h:mm a').format(datetime).toLowerCase();

      return time;
    } catch (e) {
      Logger().e(e);
      return '';
    }
  }
}
