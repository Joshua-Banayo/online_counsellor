// ignore_for_file: empty_catches

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_counsellor/core/components/widgets/smart_dialog.dart';
import 'package:online_counsellor/core/functions.dart';

import '../models/appointment_model.dart';
import '../services/firebase_fireStore.dart';
import 'data_state.dart';

final appointmentStreamProvider =
    StreamProvider<List<AppointmentModel>>((ref) async* {
  var userId = ref.watch(userProvider).id;
  var appointments = FireStoreServices.getUserAppointments(userId!);
  ref.onDispose(() {
    appointments.drain();
  });
  try {
    var data = <AppointmentModel>[];
    await for (var element in appointments) {
      data =
          element.docs.map((e) => AppointmentModel.fromMap(e.data())).toList();
      yield data;
    }
  } catch (e) {}
});

final appointmentSearchQuery = StateProvider<String>((ref) => '');
final searchAppointmentProvider = StateProvider<List<AppointmentModel>>((ref) {
  var query = ref.watch(appointmentSearchQuery);
  var appointments = ref.watch(appointmentStreamProvider);
  var data = <AppointmentModel>[];
  appointments.whenData((value) {
    data = value
        .where((element) =>
            element.counsellorName!.toLowerCase().contains(query) ||
            element.counsellorType!.toLowerCase().contains(query) ||
            element.userName!.toLowerCase().contains(query) ||
            element.status!.toLowerCase().contains(query) ||
            getDateFromDate(element.date!).toLowerCase().contains(query) ||
            getTimeFromDate(element.time!).toLowerCase().contains(query))
        .toList();
  });
  return data;
});

final singleAppointmentStreamProvider = StreamProvider.autoDispose
    .family<AppointmentModel, String>((ref, id) async* {
  var appointments = FireStoreServices.getSingleAppointment(id);
  ref.onDispose(() {
    appointments.drain();
  });
  try {
    var data = AppointmentModel();
    await for (var element in appointments) {
      data = AppointmentModel.fromMap(element.data() as Map<String, dynamic>);
      yield data;
    }
  } catch (e) {}
});

final selectedAppointmentProvider =
    StateNotifierProvider<SelectedAppointment, AppointmentModel>(
        (ref) => SelectedAppointment());

class SelectedAppointment extends StateNotifier<AppointmentModel> {
  SelectedAppointment() : super(AppointmentModel());
  void setAppointment(AppointmentModel appointment) {
    state = appointment;
  }

  void setTime(int millisecondsSinceEpoch) {
    state = state.copyWith(time: millisecondsSinceEpoch);
  }

  void rescheduleAppointment() {
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Rescheduling appointment...');
    FireStoreServices.rescheduleAppointment(state).then((value) {
      CustomDialog.dismiss();
      CustomDialog.showSuccess(
        title: 'Success',
        message: 'Appointment rescheduled successfully',
      );
    }).catchError((e) {
      CustomDialog.dismiss();
      CustomDialog.showError(
        title: 'Error',
        message: 'Error rescheduling appointment',
      );
    });
  }

  void setDate(int millisecondsSinceEpoch) {
    state = state.copyWith(date: millisecondsSinceEpoch);
  }

  void updateAppointment(String status) {
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Updating appointment...');
    FireStoreServices.updateAppointmentStatus(state.id!, status).then((value) {
      CustomDialog.dismiss();
      CustomDialog.showSuccess(
        title: 'Success',
        message: 'Appointment updated successfully',
      );
    }).catchError((e) {
      CustomDialog.dismiss();
      CustomDialog.showError(
        title: 'Error',
        message: 'Error updating appointment',
      );
    });
  }
}
