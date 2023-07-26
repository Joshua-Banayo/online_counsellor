// ignore_for_file: empty_catches

import 'dart:async';
import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:online_counsellor/models/session_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_counsellor/core/components/constants/strings.dart';
import 'package:online_counsellor/core/functions.dart';
import 'package:online_counsellor/presentation/pages/authentication/sign_up_page.dart';
import 'package:online_counsellor/services/other_services.dart';
import '../core/components/widgets/smart_dialog.dart';
import '../models/appointment_model.dart';
import '../models/audio_recording_model.dart';
import '../models/quotes_model.dart';
import '../models/session_messages_model.dart';
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

  void updateUser(WidgetRef ref,
      {File? imageFile,
      required String name,
      required String dob,
      required String phone,
      required String address,
      required String city,
      required String region,
      required String about}) async {
    CustomDialog.showLoading(message: 'Updating User... Please wait');
    if (imageFile != null) {
      final imageUrl =
          await CloudStorageServices.saveUserImage(imageFile, state.id!);
      state = state.copyWith(profile: imageUrl);
    }
    state = state.copyWith(
        name: name,
        dob: dob,
        phone: phone,
        address: address,
        city: city,
        region: region,
        about: about);
    var results = await FireStoreServices.updateUser(state);
    if (results) {
      CustomDialog.dismiss();
      CustomDialog.showSuccess(
        title: 'Success',
        message: 'User updated successfully',
      );
      ref.read(userProfileIndexProvider.notifier).state = 0;
    } else {
      CustomDialog.dismiss();
      CustomDialog.showError(
        title: 'Error',
        message: 'Error updating user',
      );
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
            //set user online status to true
            await FireStoreServices.updateUserOnlineStatus(user.uid, true);
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
    if (value == null) return;

    state = state.copyWith(date: value.millisecondsSinceEpoch);
  }

  void setTime(TimeOfDay? value, BuildContext context) {
    if (value == null) return;
    state = state.copyWith(time: value.toDateTime().millisecondsSinceEpoch);
  }

  void bookAppointment(BuildContext context, WidgetRef ref) async {
    CustomDialog.showLoading(message: 'Booking Appointment... Please wait');
    var user = ref.watch(userProvider);
    var counsellor = ref.watch(selectedCounsellorProvider);
    state.id = FireStoreServices.getDocumentId('appointments');
    state.counsellorId = counsellor!.id;
    state.ids = [counsellor.id, user.id];
    state.counsellorName = counsellor.name;
    state.counsellorImage = counsellor.profile;
    state.userId = user.id;
    state.userName = user.name;
    state.userImage = user.profile;
    state.counsellorType = counsellor.counsellorType;
    state.counsellorState = false;
    state.userState = true;
    state.status = 'Pending';
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
    StreamProvider.autoDispose<List<AppointmentModel>>((ref) async* {
  var userId = ref.watch(userProvider).id;
  var counsellorId = ref.watch(selectedCounsellorProvider)!.id;
  var appointments =
      FireStoreServices.getAppointmentStream(userId!, counsellorId!);
  ref.onDispose(() {
    appointments.drain();
  });
  try {
    var data = <AppointmentModel>[];
    await for (var element in appointments) {
      data =
          element.docs.map((e) => AppointmentModel.fromMap(e.data())).toList();
      yield data
          .where((element) =>
              element.status == 'Pending' || element.status == 'Accepted')
          .toList();
    }
  } catch (e) {}
});

final messageTokenProvider = StateProvider<String?>((ref) => null);

final selectedCounsellorStreamProvider =
    StreamProvider.autoDispose.family<UserModel?, String>((ref, id) async* {
  var counsellor = FireStoreServices.getCounsellor(id);
  ref.onDispose(() {
    counsellor.drain();
  });
  var data = UserModel();
  await for (var element in counsellor) {
    data = UserModel.fromMap(element.data()!);
    yield data;
  }
});

final audioRecordingTimerProvider =
    StateNotifierProvider<AudioRecordingTimer, AudioTimer>(
        (ref) => AudioRecordingTimer());

class AudioRecordingTimer extends StateNotifier<AudioTimer> {
  AudioRecordingTimer() : super(AudioTimer(minutes: 0, seconds: 0));
  void setTimer(AudioTimer timer) {
    state = timer;
  }

  void setMinutes(int value) {
    state = state.copyWith(minutes: value);
  }

  void setSeconds(int value) {
    state = state.copyWith(seconds: value);
  }
}

final audioRecordingProvider =
    StateNotifierProvider.autoDispose<AudioRecordingProvider, File?>((ref) {
  final record = Record();
  final player = AudioPlayer();
  ref.onDispose(() {
    record.dispose();
    player.dispose();
  });
  return AudioRecordingProvider(record, player);
});

class AudioRecordingProvider extends StateNotifier<File?> {
  AudioRecordingProvider(this.record, this.player) : super(null);
  final Record record;
  Timer? timer;
  final AudioPlayer player;

  void setAudioFile(File file) {
    state = file;
  }

  //start recording
  void startRecording(String id, WidgetRef ref) async {
    try {
      //get path from path provider
      final Directory root = await getApplicationDocumentsDirectory();
      final String directoryPath = '${root.path}/$id.wav';
      // Check and request permission
      if (await record.hasPermission()) {
        // Start recording
        await record.start(
          path: directoryPath,
          encoder: AudioEncoder.wav, // by default
          bitRate: 128000, // by default
          samplingRate: 44100, // by default
        );
        timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          var time = timer.tick;
          var minutes = time ~/ 60;
          var seconds = time % 60;
          ref
              .read(audioRecordingTimerProvider.notifier)
              .setTimer(AudioTimer(minutes: minutes, seconds: seconds));
        });
      }
    } catch (e) {}
  }

  // pause recording
  void pauseRecording() async {
    await record.pause();
    timer!.cancel();
  }

  //resume recording
  void resumeRecording(WidgetRef ref) async {
    await record.resume();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      var time = timer.tick;
      var minutes = time ~/ 60;
      var seconds = time % 60;
      ref
          .read(audioRecordingTimerProvider.notifier)
          .setTimer(AudioTimer(minutes: minutes, seconds: seconds));
    });
  }

  //stop recording
  void stopRecording(String id, WidgetRef ref) async {
    //get path from path provider
    final Directory root = await getApplicationDocumentsDirectory();
    final String directoryPath = '${root.path}/$id.wav';
    timer!.cancel();
    await record.stop();
    state = File(directoryPath);
    // //set timer to 0
    //set playing time to recording time
    ref
        .read(playingTimerProvider.notifier)
        .setTimer(ref.watch(audioRecordingTimerProvider));
    // ref
    //     .read(audioRecordingTimerProvider.notifier)
    //     .setTimer(AudioTimer(minutes: 0, seconds: 0));
  }

  void playRecording(WidgetRef ref) {
    player.setFilePath(state!.path);
    //ref.read(audioDurationProvider.notifier).state = player.duration!;
    player.play();
    ref.read(isPlayingProvider.notifier).state = true;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      var currentTimer = ref.watch(playingTimerProvider);
      ref.read(playingTimerProvider.notifier).setTimer(AudioTimer(
          minutes: currentTimer.minutes != 0 ? currentTimer.minutes - 1 : 0,
          seconds: currentTimer.seconds != 0 ? currentTimer.seconds - 1 : 0));
    });
    player.playerStateStream.listen((event) {
      //reduce time by 1 second using timer

      if (event.processingState == ProcessingState.completed) {
        player.stop();
        ref.read(isPlayingProvider.notifier).state = false;
        ref
            .read(playingTimerProvider.notifier)
            .setTimer(ref.watch(audioRecordingTimerProvider));
        //cancel timer
        timer!.cancel();
      }
    });
  }

  void pausePlaying(WidgetRef ref) {
    player.pause();
    ref.read(isPlayingProvider.notifier).state = false;
    // pause timer
    timer!.cancel();
  }

  void deleteRecording(WidgetRef ref) {
    state!.delete();
    state = null;
    ref.read(isPlayingProvider.notifier).state = false;
    ref
        .read(audioRecordingTimerProvider.notifier)
        .setTimer(AudioTimer(minutes: 0, seconds: 0));
  }

  void sendRecording(
      BuildContext context, SessionModel session, WidgetRef ref) async {
    //show loading
    CustomDialog.showLoading(message: 'Sending Audio... Please wait');
    //save file to cloud storage
    final String url = await CloudStorageServices.sendFile(state!, session.id!);
    //save file to firestore

    //send message to firebase firestore
    var uid = ref.watch(userProvider).id;
    var receiverId =
        uid == session.userId ? session.counsellorId! : session.userId;
    var receiverName =
        uid == session.userId ? session.counsellorName! : session.userName;
    var receiverImage =
        uid == session.userId ? session.counsellorImage! : session.userImage!;
    SessionMessagesModel messagesModel = SessionMessagesModel();
    messagesModel.type = 'audio';
    messagesModel.senderId = uid;
    messagesModel.senderName = ref.watch(userProvider).name;
    messagesModel.senderImage = ref.watch(userProvider).profile;
    messagesModel.receiverId = receiverId;
    messagesModel.receiverName = receiverName;
    messagesModel.receiverImage = receiverImage;
    messagesModel.isRead = false;
    messagesModel.mediaFile = url;
    messagesModel.createdAt = DateTime.now().millisecondsSinceEpoch;
    messagesModel.id = FireStoreServices.getDocumentId('',
        collection: FirebaseFirestore.instance
            .collection('sessions')
            .doc(session.id)
            .collection('messages'));
    messagesModel.sessionId = session.id;
    var result = await FireStoreServices.addSessionMessages(messagesModel);
    if (result) {
      //delete file
      state!.delete();
      state = null;
      //clear timer
      ref
          .read(audioRecordingTimerProvider.notifier)
          .setTimer(AudioTimer(minutes: 0, seconds: 0));
      ref
          .read(playingTimerProvider.notifier)
          .setTimer(AudioTimer(minutes: 0, seconds: 0));
      //close loading

      CustomDialog.dismiss();
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }
}

final isPlayingProvider = StateProvider<bool>((ref) => false);
final playingTimerProvider =
    StateNotifierProvider<AudioPlayingTimer, AudioTimer>(
        (ref) => AudioPlayingTimer());

class AudioPlayingTimer extends StateNotifier<AudioTimer> {
  AudioPlayingTimer() : super(AudioTimer(minutes: 0, seconds: 0));
  void setTimer(AudioTimer timer) {
    state = timer;
  }

  void setMinutes(int value) {
    state = state.copyWith(minutes: value);
  }

  void setSeconds(int value) {
    state = state.copyWith(seconds: value);
  }
}

final audioPlayerProvider =
    StateNotifierProvider.autoDispose<AudioPlayerProvider, bool>((ref) {
  final player = AudioPlayer();
  ref.onDispose(() {
    player.dispose();
  });
  return AudioPlayerProvider(player);
});

class AudioPlayerProvider extends StateNotifier<bool> {
  final AudioPlayer player;
  AudioPlayerProvider(this.player) : super(false);
  void playAudio(String s, WidgetRef ref) async {
    player.setUrl(s);
    player.play();
    state = true;
    player.durationStream.listen((event) {
      ref.read(audioPlayerDurationProvider.notifier).state = event!;
    });
    // get duration  stream
    player.positionStream.listen((event) {
      ref.read(audioPlayerDurationProvider.notifier).state = event;
      var currAudioPlaying = event.inMicroseconds.ceilToDouble();
      final currTime = (currAudioPlaying /
          (player.duration?.inMicroseconds.ceilToDouble() ?? 1.0));
      ref.read(audioPlayerTimerProvider.notifier).state =
          currTime > 1.0 ? 1.0 : currTime;
    });
    player.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        player.stop();
        state = false;
        ref.read(audioPlayerTimerProvider.notifier).state = 0.0;
      }
    });
  }

  // pause audio
  void pauseAudio() {
    player.pause();
    state = false;
  }
}

final audioPlayerDurationProvider =
    StateProvider<Duration>((ref) => const Duration());
final audioPlayerTimerProvider = StateProvider<double>((ref) => 0.0);

final userProfileIndexProvider = StateProvider<int>((ref) => 0);