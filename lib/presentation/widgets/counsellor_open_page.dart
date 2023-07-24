import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:online_counsellor/core/components/widgets/custom_button.dart';
import 'package:online_counsellor/core/components/widgets/custom_drop_down.dart';
import 'package:online_counsellor/core/functions.dart';
import 'package:online_counsellor/models/user_model.dart';
import 'package:online_counsellor/presentation/pages/home/components/session/session_chat_page.dart';
import 'package:online_counsellor/state/data_state.dart';
import 'package:online_counsellor/styles/colors.dart';
import 'package:online_counsellor/styles/styles.dart';
import '../../core/components/constants/strings.dart';
import '../../state/session_state.dart';

class CounsellorViewPage extends ConsumerWidget {
  const CounsellorViewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel? counsellor = ref.watch(selectedCounsellorProvider);
    var stream = ref.watch(activeSessionStream(counsellor!.id!));
    return SafeArea(
      child: Scaffold(
          body: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 120,
                        child: CustomButton(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          color: Colors.red,
                          text: 'Close',
                          onPressed: () => Navigator.pop(context),
                          icon: MdiIcons.closeBox,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (counsellor.profile != null)
                    Image.network(
                      counsellor.profile!,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(counsellor.counsellorType.toString().toUpperCase(),
                          maxLines: 1,
                          style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      Expanded(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                            const Icon(Icons.star,
                                color: primaryColor, size: 20),
                            Text(counsellor.rating.toString(),
                                style: normalText(
                                    color: primaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))
                          ]))
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(counsellor.name.toString(),
                      maxLines: 1,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Email: ',
                        style: normalText(),
                      ),
                      TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                          ),
                          onPressed: () {},
                          child: Text(counsellor.email.toString(),
                              style: normalText(color: Colors.blue))),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Phone: ',
                        style: normalText(),
                      ),
                      TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                          ),
                          onPressed: () {},
                          child: Text(counsellor.phone.toString(),
                              style: normalText(color: Colors.blue))),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Address: ',
                        style: normalText(),
                      ),
                      Text(counsellor.address.toString(),
                          style: normalText(color: Colors.blue))
                    ],
                  ),
                  const Divider(),
                  ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('About',
                          style: normalText(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          counsellor.about ?? '',
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: normalText(fontSize: 14),
                        ),
                      )),
                  const Divider(),
                  SizedBox(
                    height: 50,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return stream.when(
                                loading: () => const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: LinearProgressIndicator(
                                      color: primaryColor,
                                    )),
                                data: (data) {
                                  if (data.isEmpty) {
                                    return CustomButton(
                                      color: secondaryColor,
                                      text: 'Start Session',
                                      onPressed: () {
                                        setSessionTopic(
                                            context, ref, counsellor);
                                      },
                                      icon: MdiIcons.chatProcessing,
                                    );
                                  } else {
                                    return CustomButton(
                                      color: secondaryColor,
                                      text: 'Open Session',
                                      onPressed: () {
                                        ref
                                            .read(
                                                currentSessionProvider.notifier)
                                            .setCurrentSession(data[0]);
                                        ref
                                            .read(selectedSessionProvider
                                                .notifier)
                                            .setSelectedSession(data[0]);
                                        sendToPage(
                                            context, const SessionChatPage());
                                      },
                                      icon: MdiIcons.chatProcessing,
                                    );
                                  }
                                },
                                error: (error, stackTrace) => Center(
                                  child: Text(
                                    'Error',
                                    style: normalText(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              var stream = ref.watch(appointmentStreamProvider);
                              return stream.when(
                                  data: (data) {
                                    if (data.isEmpty) {
                                      return CustomButton(
                                        color: primaryColor,
                                        text: 'Book Appoint.',
                                        onPressed: () {
                                          getDateTimes(
                                              context, ref, counsellor);
                                        },
                                        icon: MdiIcons.calendarPlus,
                                      );
                                    } else {
                                      return Text('Pending Appoint.',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                              normalText(color: Colors.grey));
                                    }
                                  },
                                  loading: () => const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: LinearProgressIndicator(
                                        color: primaryColor,
                                      )),
                                  error: (error, stackTrace) {
                                    //throw error

                                    return Center(
                                      child: Text(
                                        'error',
                                        style: normalText(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                    );
                                  });
                            }),
                          ),
                        ]),
                  ),
                  const SizedBox(height: 20),
                ]),
          ),
        ),
      )),
    );
  }

  void setSessionTopic(
      BuildContext context, WidgetRef ref, UserModel counsellor) {
    // open bottom sheet to set session topic
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomDropDown(
                    hintText: 'Select topic for the session',
                    onChanged: (value) {
                      ref
                          .read(currentSessionProvider.notifier)
                          .setTopic(value.toString());
                    },
                    items: counsellingTopicCategory
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList()),
                const SizedBox(height: 10),
                CustomButton(
                  color: primaryColor,
                  text: 'Start Session',
                  onPressed: () {
                    ref
                        .read(currentSessionProvider.notifier)
                        .bookSession(context, ref);
                  },
                  icon: MdiIcons.chatProcessing,
                ),
              ],
            ),
          );
        });
  }

  void getDateTimes(BuildContext context, WidgetRef ref, UserModel counsellor) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Select Date and Time',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () async {
                          await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year + 1),
                          ).then((value) {
                            if (value != null) {
                              ref
                                  .read(currentAppointmentProvider.notifier)
                                  .setDate(value);
                            }
                          });
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              color: Colors.blue,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Text('Date:',
                                style: normalText(color: Colors.blue)),
                            const SizedBox(width: 10),
                            if (ref.watch(currentAppointmentProvider).date !=
                                null)
                              Text(
                                  getDateFromDate(ref
                                      .watch(currentAppointmentProvider)
                                      .date),
                                  style: normalText(
                                      color: primaryColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          ).then((value) {
                            if (value != null) {
                              ref
                                  .read(currentAppointmentProvider.notifier)
                                  .setTime(value, context);
                            }
                          });
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.timer,
                              color: Colors.blue,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Text('Time: ',
                                style: normalText(color: Colors.blue)),
                            const SizedBox(width: 10),
                            if (ref.watch(currentAppointmentProvider).time !=
                                null)
                              Text(
                                  getTimeFromDate(ref
                                      .watch(currentAppointmentProvider)
                                      .time),
                                  style: normalText(
                                      color: primaryColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                CustomButton(
                  color: primaryColor,
                  text: 'Book',
                  onPressed: () {
                    ref
                        .read(currentAppointmentProvider.notifier)
                        .bookAppointment(context, ref);
                  },
                  icon: MdiIcons.calendarPlus,
                ),
              ],
            ),
          );
        });
  }
}
