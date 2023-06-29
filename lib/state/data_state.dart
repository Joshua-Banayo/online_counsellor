import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:online_counsellor/core/components/constants/strings.dart';
import 'package:online_counsellor/core/functions.dart';
import 'package:online_counsellor/presentation/pages/authentication/sign_up_page.dart';
import 'package:online_counsellor/services/other_services.dart';
import '../core/components/widgets/smart_dialog.dart';
import '../models/appointment_model.dart';
import '../models/quotes_model.dart';
import '../models/user_model.dart';
import '../presentation/pages/home/home_main.dart';
import '../services/firebase_auth.dart';
import '../services/firebase_fireStore.dart';
import '../services/firebase_storage.dart';
import 'navigation_state.dart';

final userProvider =
    StateNotifierProvider<UserProvider, UserModel>((ref) => UserProvider());

class UserProvider extends StateNotifier<UserModel> {
  UserProvider() : super(UserModel());

  void setUser(UserModel user) {
    state = user;
  }

  void setUserName(String value) {
    state = state.copyWith(name: value);
  }

  void setUserEmail(String value) {
    state = state.copyWith(email: value);
  }

  void setUserPhone(String value) {
    state = state.copyWith(phone: value);
  }

  void setUserPassword(String value) {
    state = state.copyWith(password: value);
  }

  void setUserGender(value) {
    state = state.copyWith(gender: value);
  }

  void setUserAddress(String value) {
    state = state.copyWith(address: value);
  }

  void setUserType(String type) {
    state = state.copyWith(userType: type);
  }

  void setDOB(String s) {
    state = state.copyWith(dob: s);
  }

  void setUserRegion(String region) {
    state = state.copyWith(region: region);
  }

  void setUserCity(String s) {
    state = state.copyWith(city: s);
  }

  void setAbout(String s) {
    state = state.copyWith(about: s);
  }

  void setCounsellorType(String type) {
    state = state.copyWith(counsellorType: type);
  }

  void setMaritalStatus(String status) {
    state = state.copyWith(maritalStatus: status);
  }

  void setEducationLevel(String edu) {
    state = state.copyWith(educationLevel: edu);
  }

  void setReligion(String religion) {
    state = state.copyWith(religion: religion);
  }

  void setEmploymentStatus(String emp) {
    state = state.copyWith(employmentStatus: emp);
  }

  void createUser(WidgetRef ref) async {
    CustomDialog.showLoading(message: 'Creating User... Please wait');
    final userImage = ref.watch(userImageProvider);
    state = state.copyWith(createdAt: DateTime.now().millisecondsSinceEpoch);
    //create user in firebase auth
    final user = await FirebaseAuthService.createUserWithEmailAndPassword(
        state.email!, state.password!);
    if (user != null) {
      //send verification email
      await FirebaseAuthService.sendEmailVerification();
      state = state.copyWith(id: user.uid);
      //save user image to cloud storage
      if (userImage != null) {
        final userImageUrl = await CloudStorageServices.saveUserImage(
            userImage, state.id.toString());
        state = state.copyWith(profile: userImageUrl);
      }
      //save certificate to cloud storage
      final certificate = ref.watch(certificateProvider);
      if (certificate != null) {
        final certificateUrl = await CloudStorageServices.saveCertificate(
            certificate, state.id.toString());
        state = state.copyWith(licenseCert: certificateUrl);
      }
      //save user to firestore
      final String response = await FireStoreServices.saveUser(state);
      if (response == 'success') {
        //? UPDATE user profile
        // clear all states
        ref.read(userProvider.notifier).state = UserModel();
        ref.read(userImageProvider.notifier).state = null;
        ref.read(certificateProvider.notifier).state = null;
        ref.read(signUpIndexProvider.notifier).state = 0;
        ref.read(authIndexProvider.notifier).state = 0;
        await FirebaseAuthService.signOut();
        CustomDialog.dismiss();
        CustomDialog.showSuccess(
          title: 'Success',
          message:
              'User created successfully\n A verification email has been sent to your email address\n Please verify your email address to login',
        );
      } else {
        CustomDialog.dismiss();
        CustomDialog.showError(
          title: 'Error',
          message: response,
        );
      }
    }
  }
}

final userSignInProvider = StateNotifierProvider<UserSignInProvider, User?>(
    (ref) => UserSignInProvider());

class UserSignInProvider extends StateNotifier<User?> {
  UserSignInProvider() : super(null);

  void setUser(User? user) {
    state = user;
  }

  void signIn(
      {required BuildContext context,
      required WidgetRef ref,
      required String email,
      required String password}) async {
    CustomDialog.showLoading(message: 'Signing In... Please wait');
    final user = await FirebaseAuthService.signIn(email, password);
    if (user != null) {
      state = user;
      if (user.emailVerified) {
        //get user from firestore
        final UserModel? userModel = await FireStoreServices.getUser(user.uid);
        if (userModel != null) {
          //check if user type is equal userModel.usertype
          var userType = ref.watch(userTypeProvider);
          if (userType != userModel.userType) {
            await FirebaseAuthService.signOut();
            CustomDialog.dismiss();
            CustomDialog.showError(
              title: 'Error',
              message:
                  'You are not authorized to login as a ${userModel.userType}',
            );
            return;
          } else {
            //set user to provider
            CustomDialog.dismiss();
            ref.read(userProvider.notifier).setUser(userModel);
            if (mounted) {
              noReturnSendToPage(context, const HomeMainPage());
            }
          }
        } else {
          await FirebaseAuthService.signOut();
          CustomDialog.dismiss();
          CustomDialog.showError(
            title: 'Error',
            message: 'Could not retrieve user...Try again later ',
          );
        }
      } else {
        await FirebaseAuthService.signOut();
        CustomDialog.dismiss();
        CustomDialog.showInfo(
            title: 'Email not verified',
            message:
                'Please verify your email address to login.\n Do not have verification Link ?',
            onConfirmText: 'Send Link',
            onConfirm: () {
              FirebaseAuthService.sendEmailVerification();
              CustomDialog.dismiss();
            });
      }
    }
  }
}

final userImageProvider = StateProvider<File?>((ref) => null);
final certificateProvider = StateProvider<File?>((ref) => null);

final userTypeProvider = StateProvider<String?>((ref) => null);
final counsellorTypeProvider = StateProvider<String?>((ref) => null);
final selectedCategoryProvider =
    StateProvider<String>((ref) => counsellorTypeList[0]);

final quotesProvider = StateNotifierProvider<QuotesProvider, QuotesModel?>(
    (ref) => QuotesProvider());

class QuotesProvider extends StateNotifier<QuotesModel?> {
  QuotesProvider() : super(QuotesModel(author: '', quote: '', category: '')) {
    getQuotes();
  }
  void setQuotes(QuotesModel quotes) {
    state = quotes;
  }

  void getQuotes() async {
    var cat = getRandomCat();
    final QuotesModel? quotes = await OtherServices.getQuotes(cat);
    state = quotes;
  }
}

final counsellorsProvider =
    StateNotifierProvider<CounsellorsProvider, List<UserModel>>(
        (ref) => CounsellorsProvider());

class CounsellorsProvider extends StateNotifier<List<UserModel>> {
  CounsellorsProvider() : super([]) {
    getCounsellors();
  }
  void setCounsellors(List<UserModel> counsellors) {
    state = counsellors;
  }

  void getCounsellors() async {
    final List<UserModel> counsellors =
        await FireStoreServices.getCounsellors();
    state = counsellors;
  }
}

final filteredCounsellorsProvider =
    StateProvider.autoDispose.family<List<UserModel>, String>((ref, search) {
  var list = ref.watch(counsellorsProvider);
  if (search.isEmpty) return list;
  return list
      .where((element) =>
          element.counsellorType!
              .toLowerCase()
              .contains(search.toLowerCase()) ||
          element.name!.toLowerCase().contains(search.toLowerCase()))
      .toList();
});

final searchQueryProvider = StateProvider<String>((ref) => '');
final searchControllerProvider =
    StateProvider.autoDispose<List<UserModel>>((ref) {
  var list = ref.watch(counsellorsProvider);
  var search = ref.watch(searchQueryProvider);
  if (search.isEmpty) return [];
  return list
      .where((element) =>
          element.counsellorType!
              .toLowerCase()
              .contains(search.toLowerCase()) ||
          element.name!.toLowerCase().contains(search.toLowerCase()))
      .toList();
});

final selectedCounsellorProvider = StateProvider<UserModel?>((ref) => null);

final currentAppointmentProvider =
    StateNotifierProvider<CurrentAppointmentProvider, AppointmentModel>(
        (ref) => CurrentAppointmentProvider());

class CurrentAppointmentProvider extends StateNotifier<AppointmentModel> {
  CurrentAppointmentProvider() : super(AppointmentModel());
  void setCurrentAppointment(AppointmentModel appointment) {
    state = appointment;
  }

  void setDate(DateTime? value) {
    var date = DateFormat('EEE dd, MMM yyyy').format(value!);
    state = state.copyWith(date: date);
  }

  void setTime(TimeOfDay? value, BuildContext context) {
    var time = value!.format(context);
    state =
        state.copyWith(time: '$time ${value.period.index == 0 ? 'AM' : 'PM'}');
  }

  void bookAppointment(BuildContext context, WidgetRef ref) async {
    CustomDialog.showLoading(message: 'Booking Appointment... Please wait');
    var user = ref.watch(userProvider);
    var counsellor = ref.watch(selectedCounsellorProvider);
    state.id = '${user.id}_${counsellor!.id}';
    state.counsellorId = counsellor.id;
    state.counsellorName = counsellor.name;
    state.counsellorImage = counsellor.profile;
    state.userId = user.id;
    state.userName = user.name;
    state.userImage = user.profile;
    state.counsellorType = counsellor.counsellorType;
    state.counsellorState = false;
    state.userState = true;
    state.status = 'pending';
    state.createdAt = DateTime.now().toUtc().millisecondsSinceEpoch;
    final bool result = await FireStoreServices.bookAppointment(state);
    if (result) {
      CustomDialog.dismiss();
      CustomDialog.showSuccess(
        title: 'Success',
        message: 'Appointment booked successfully',
        onOkayPressed: () {
          Navigator.pop(context);
        },
      );
    } else {
      CustomDialog.dismiss();
      CustomDialog.showError(
          title: 'Error', message: 'Could not book appointment');
    }
  }
}

final appointmentStreamProvider =
    StreamProvider.autoDispose<QuerySnapshot<Map<String, dynamic>>>((ref) {
  var userId = ref.watch(userProvider).id;
  var counsellorId = ref.watch(selectedCounsellorProvider)!.id;
  return FireStoreServices.getAppointmentStream(userId!, counsellorId!);
});
