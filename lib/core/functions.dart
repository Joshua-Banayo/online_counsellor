import 'dart:math';

import 'package:flutter/material.dart';

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

//