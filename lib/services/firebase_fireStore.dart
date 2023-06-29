import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_counsellor/models/appointment_model.dart';
import '../models/user_model.dart';

class FireStoreServices {
  static final _fireStore = FirebaseFirestore.instance;

  static Future<UserModel?> getUser(String uid) async {
    final user = await _fireStore.collection('users').doc(uid).get();
    return UserModel.fromMap(user.data()!);
  }

  // save user to firebase
  static Future<String> saveUser(UserModel user) async {
    final response = await _fireStore
        .collection('users')
        .doc(user.id)
        .set(user.toMap())
        .then((value) => 'success')
        .catchError((error) => error.toString());
    return response;
  }

  static updateUserOnlineStatus(String uid, bool bool) async {
    await _fireStore.collection('users').doc(uid).update({'isOnline': bool});
  }

  static getDocumentId(String s) {
    return _fireStore.collection(s).doc().id;
  }

  static Future<List<Map<String, dynamic>>> getAllUsersMap() async {
    final users = await _fireStore.collection('users').get();
    List<Map<String, dynamic>> usersMap = [];
    for (var element in users.docs) {
      usersMap.add(element.data());
    }
    return usersMap;
  }

  static updateUserRating(String userId, double rating) async {
    await _fireStore.collection('users').doc(userId).update({'rating': rating});
  }

  static Future<List<UserModel>> getCounsellors() async {
    final counsellors = await _fireStore
        .collection('users')
        .where('userType', isEqualTo: 'Counsellor')
        .get();
    List<UserModel> counsellorsList = [];
    for (var element in counsellors.docs) {
      counsellorsList.add(UserModel.fromMap(element.data()));
    }
    return counsellorsList;
  }

  static Future<bool> bookAppointment(AppointmentModel state) {
    return _fireStore
        .collection('appointments')
        .doc(state.id)
        .set(state.toMap())
        .then((value) => true)
        .catchError((error) => false);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAppointmentStream(
      String userId, String counsellorId) {
    return _fireStore
        .collection('appointments')
        .where('counsellorId', isEqualTo: counsellorId)
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .snapshots();
  }
}
