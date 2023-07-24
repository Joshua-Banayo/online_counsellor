import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_counsellor/core/functions.dart';
import 'package:online_counsellor/models/user_model.dart';
import 'package:online_counsellor/styles/colors.dart';
import '../../state/data_state.dart';
import 'counsellor_open_page.dart';

class CounsellorCard extends ConsumerWidget {
  const CounsellorCard({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        ref.read(selectedCounsellorProvider.notifier).state = user;
        sendToTransparentPage(context, const CounsellorViewPage());
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        padding: const EdgeInsets.all(10),
        width: size.width * 0.95,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
              height: 150,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: user.profile != null
                    ? DecorationImage(
                        image: NetworkImage(user.profile!),
                        fit: BoxFit.fill,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.counsellorType.toString().toUpperCase(),
                    maxLines: 1,
                    style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(user.name ?? "Name",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(user.email ?? "Email",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        const TextStyle(color: Colors.black45, fontSize: 14)),
                const SizedBox(height: 2),
                Text(user.phone ?? "Phone Number",
                    style:
                        const TextStyle(color: Colors.black45, fontSize: 14)),
                const SizedBox(height: 2),
                Text(
                    '${user.address ?? "Address"}, ${user.city ?? "City"}, ${user.region ?? "Region"}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        const TextStyle(color: Colors.black45, fontSize: 14)),
                const SizedBox(height: 10),
                //rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(user.rating.toString(),
                        style: const TextStyle(
                            color: primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    for (var i = 0; i < user.rating!.toInt(); i++)
                      const Icon(Icons.star, color: primaryColor, size: 16),
                  ],
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
