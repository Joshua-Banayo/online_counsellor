// ignore_for_file: empty_catches

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_counsellor/models/session_messages_model.dart';
import '../core/components/widgets/smart_dialog.dart';
import '../models/session_model.dart';
import '../services/firebase_fireStore.dart';
import 'data_state.dart';

//get a stream of session where status is not ended
final activeSessionStream = StreamProvider.autoDispose
    .family<List<SessionModel>, String>((ref, counsellorId) async* {
  var userId = ref.watch(userProvider).id;
  final sessions = FireStoreServices.getActiveServices(
      userId: userId, counsellorId: counsellorId);

  ref.onDispose(() {
    sessions.drain();
  });
  var data = <SessionModel>[];
  await for (var element in sessions) {
    data = element.docs.map((e) => SessionModel.fromMap(e.data())).toList();
    yield data;
  }
});

final currentSessionProvider =
    StateNotifierProvider<CurrentSessionProvider, SessionModel>(
        (ref) => CurrentSessionProvider());

class CurrentSessionProvider extends StateNotifier<SessionModel> {
  CurrentSessionProvider() : super(SessionModel());
  void setCurrentSession(SessionModel session) {
    state = session;
  }

  void bookSession(BuildContext context, WidgetRef ref) async {
    CustomDialog.showLoading(message: 'Booking Session... Please wait');
    var user = ref.watch(userProvider);
    var counsellor = ref.watch(selectedCounsellorProvider);
    state.id = FireStoreServices.getDocumentId('sessions');
    state.counsellorId = counsellor!.id;
    state.counsellorName = counsellor.name;
    state.counsellorImage = counsellor.profile;
    state.userId = user.id;
    state.ids = [counsellor.id, user.id];
    state.userName = user.name;
    state.userImage = user.profile;
    state.createdAt = DateTime.now().toUtc().millisecondsSinceEpoch;
    state.status = 'Pending';
    final bool result = await FireStoreServices.bookSession(state);
    if (result) {
      CustomDialog.dismiss();
      CustomDialog.showSuccess(
        title: 'Success',
        message: 'Session booked successfully',
        onOkayPressed: () {
          Navigator.pop(context);
        },
      );
      //send to chat page
    } else {
      CustomDialog.dismiss();
      CustomDialog.showError(title: 'Error', message: 'Could not book session');
    }
  }

  void setTopic(String string) {
    state = state.copyWith(topic: string);
  }
}

final sessionsStreamProvider =
    StreamProvider.autoDispose<List<SessionModel>>((ref) async* {
  var userId = ref.watch(userProvider).id;
  var sessions = FireStoreServices.getUserSessions(userId);
  ref.onDispose(() {
    sessions.drain();
  });
  var data = <SessionModel>[];
  await for (var element in sessions) {
    data = element.docs.map((e) => SessionModel.fromMap(e.data())).toList();
    yield data;
  }
});

final sessionSearchQuery = StateProvider<String>((ref) => '');

final selectedSessionProvider =
    StateNotifierProvider<SelectedSessionProvider, SessionModel>(
        (ref) => SelectedSessionProvider());

class SelectedSessionProvider extends StateNotifier<SessionModel> {
  SelectedSessionProvider() : super(SessionModel());
  void setSelectedSession(SessionModel session) {
    state = session;
  }

  void updateSessionStatus(String id, String status) async {
    CustomDialog.showLoading(message: 'Updating Session Status... Please wait');
    var result = await FireStoreServices.updateSessionStatus(id, status);
    if (result) {
      CustomDialog.dismiss();
      CustomDialog.showSuccess(
        title: 'Success',
        message: 'Session status updated successfully',
      );
    }
  }
}

final sessionMessagesStreamProvider = StreamProvider.autoDispose
    .family<List<SessionMessagesModel>, String>((ref, id) async* {
  var sessions = FireStoreServices.getUserSessionsMessages(id);
  ref.onDispose(() {
    sessions.drain();
  });
  try {
    var data = <SessionMessagesModel>[];
    await for (var element in sessions) {
      data = element.docs
          .map((e) => SessionMessagesModel.fromMap(e.data()))
          .toList();
      yield data;
    }
  } catch (e) {}
});

final sessionsListProvider = StateNotifierProvider.family<SessionListProvider,
    List<SessionModel>, String>((ref, id) => SessionListProvider(id));

class SessionListProvider extends StateNotifier<List<SessionModel>> {
  SessionListProvider(this.id) : super([]) {
    getUserSessions(id);
  }
  final String id;
  void setSessions(List<SessionModel> sessions) {
    state = sessions;
  }

  void getUserSessions(String id) async {
    var sessions = FireStoreServices.getUserSessions(id);
    try {
      var data = <SessionModel>[];
      await for (var element in sessions) {
        data = element.docs.map((e) => SessionModel.fromMap(e.data())).toList();
        state = data;
      }
    } catch (e) {}
  }
}

final searchSessionProvider =
    Provider.family.autoDispose<List<SessionModel>, String>((ref, id) {
  var query = ref.watch(sessionSearchQuery);
  var sessions = ref.watch(sessionsListProvider(id));
  if (query.isEmpty) {
    return [];
  } else {
    return sessions
        .where((element) =>
            element.topic!.toLowerCase().contains(query.toLowerCase()) ||
            element.counsellorName!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
});
