import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';

void noReturnSendToPage(BuildContext context, Widget newPage) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => newPage),
      (route) => false);
}

void sendToPage(BuildContext context, Widget newPage) {
  Navigator.push(
      context, MaterialPageRoute(builder: (BuildContext context) => newPage));
}

//send to transparent page
void sendToTransparentPage(BuildContext context, Widget newPage) {
  Navigator.push(
      context,
      PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) {
            return newPage;
          }));
}

final listCat = [
  'hope',
  'marriage',
  'fear',
  'equality',
  'family',
  'faith',
  'failure'
];
String getRandomCat() {
  final random = Random();
  return listCat[random.nextInt(listCat.length)];
}

double getRandomRating() {
  final random = Random();
  // return random rating less than 10 and greater than 0.9 and with 1 decimal place
  return double.tryParse((random.nextDouble() * 9.1 + 0.9).toStringAsFixed(1))!;
}

List<UserModel> sortUsersByRating(List<UserModel> users) {
  users.sort((a, b) => b.rating!.compareTo(a.rating!));
  // return in descending order
  return users;
}

String getNumberOfTime(int dateTime) {
  final now = DateTime.now();
  final difference =
      now.difference(DateTime.fromMillisecondsSinceEpoch(dateTime));
  //get yesterday

  if (difference.inDays > 0 && difference.inDays < 2) {
    return "${difference.inDays} days ago";
  } else if (difference.inHours > 0 && difference.inHours < 24) {
    return "${difference.inHours} hours ago";
  } else if (difference.inMinutes > 0 && difference.inMinutes < 60) {
    return "${difference.inMinutes} minutes ago";
  } else if (difference.inSeconds > 0 && difference.inSeconds < 60) {
    return "${difference.inSeconds} seconds ago";
  } else if (difference.inSeconds == 0) {
    return "Just now";
  } else {
    //return date with format EEE, MMM d, yyyy
    return DateFormat('EEE, MMM d, yyyy')
        .format(DateTime.fromMillisecondsSinceEpoch(dateTime));
  }
}

extension TOD on TimeOfDay {
  DateTime toDateTime() {
    return DateTime(1, 1, 1, hour, minute);
  }
}

String getDateFromDate(int? dateTime) {
  if (dateTime != null) {
    return DateFormat('EEE, MMM d, yyyy')
        .format(DateTime.fromMillisecondsSinceEpoch(dateTime));
  } else {
    return '';
  }
}

String getTimeFromDate(int? dateTime) {
  if (dateTime != null) {
    return DateFormat('hh:mm a')
        .format(DateTime.fromMillisecondsSinceEpoch(dateTime));
  } else {
    return '';
  }
}
