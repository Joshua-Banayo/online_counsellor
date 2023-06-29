import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:online_counsellor/core/components/widgets/custom_button.dart';
import 'package:online_counsellor/models/user_model.dart';
import 'package:online_counsellor/state/data_state.dart';
import 'package:online_counsellor/styles/colors.dart';
import 'package:online_counsellor/styles/styles.dart';

class CounsellorViewPage extends ConsumerWidget {
  const CounsellorViewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel? counsellor = ref.watch(selectedCounsellorProvider);
    return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.5),
        body: Container(
          margin: const EdgeInsets.all(10),
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
                          width: 100,
                          child: CustomButton(
                            color: Colors.red,
                            text: 'Close',
                            onPressed: () => Navigator.pop(context),
                            icon: MdiIcons.closeBox,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (counsellor!.profile != null)
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
                            counsellor.about.toString(),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: normalText(fontSize: 14),
                          ),
                        ))
                  ]),
            ),
            subtitle: SizedBox(
              height: 50,
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Expanded(
                  child: CustomButton(
                    color: secondaryColor,
                    text: 'Start Session',
                    onPressed: () {},
                    icon: MdiIcons.chatProcessing,
                  ),
                ),
                const SizedBox(width: 10),
                LayoutBuilder(builder: (context, constraints) {
                  var stream = ref.watch(appointmentStreamProvider);
                  return stream.when(
                    data: (data) {
                      if (data.docs.isEmpty) {
                        return CustomButton(
                          color: primaryColor,
                          text: 'Book Appoint.',
                          onPressed: () {
                            getDateTimes(context, ref, counsellor);
                          },
                          icon: MdiIcons.calendarPlus,
                        );
                      } else {
                        return Text('Pending Appointment',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: normalText(color: Colors.grey));
                      }
                    },
                    loading: () => const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        )),
                    error: (error, stackTrace) => Text(error.toString()),
                  );
                }),
              ]),
            ),
          ),
        ));
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
                            ref
                                .read(currentAppointmentProvider.notifier)
                                .setDate(value);
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
                                  ref
                                      .watch(currentAppointmentProvider)
                                      .date
                                      .toString(),
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
                            ref
                                .read(currentAppointmentProvider.notifier)
                                .setTime(value, context);
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
                                  ref
                                      .watch(currentAppointmentProvider)
                                      .time
                                      .toString(),
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
