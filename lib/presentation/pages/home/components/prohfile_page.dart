import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_counsellor/core/components/widgets/custom_button.dart';
import 'package:online_counsellor/generated/assets.dart';
import 'package:online_counsellor/state/data_state.dart';
import 'package:online_counsellor/styles/colors.dart';
import '../../../../core/components/constants/strings.dart';
import '../../../../core/functions.dart';
import '../../../../styles/styles.dart';
import '../../authentication/edit_userPage.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(children: [
        Image.asset(
          Assets.logoIcon,
          height: 50,
        ),
        const SizedBox(width: 10),
        Text(
          'Online Counsellor',
          style: GoogleFonts.lobster(
            fontSize: 30,
            color: primaryColor,
          ),
        ),
      ]),
      subtitle: LayoutBuilder(builder: (context, constraints) {
        if (ref.watch(userProvider).userType == "Counsellor") {
          return const CounsellorProfile();
        } else {
          return const ClientProfile();
        }
      }),
    );
  }
}

class CounsellorProfile extends ConsumerStatefulWidget {
  const CounsellorProfile({super.key});

  @override
  ConsumerState<CounsellorProfile> createState() => _CounsellorProfileState();
}

class _CounsellorProfileState extends ConsumerState<CounsellorProfile> {
  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 40),
            // Profile Picture in a circle
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
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
                          style: normalText(
                              color: primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text(user.name ?? "Name",
                          style: normalText(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text(user.email ?? "Email",
                          style:
                              normalText(color: Colors.black45, fontSize: 14)),
                      const SizedBox(height: 10),
                      Text(user.phone ?? "Phone Number",
                          style:
                              normalText(color: Colors.black45, fontSize: 14)),
                      const SizedBox(height: 10),
                      Text(
                          '${user.address ?? "Address"}, ${user.city ?? "City"}, ${user.region ?? "Region"}',
                          style:
                              normalText(color: Colors.black45, fontSize: 14)),
                      const SizedBox(height: 10),
                    ],
                  ))
                ]),
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Reviews',
                      style: normalText(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {},
                    child: Text('View All',
                        style: normalText(
                            color: primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              subtitle: CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  aspectRatio: 1,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  enlargeFactor: 1,
                  enlargeStrategy: CenterPageEnlargeStrategy.scale,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastEaseInToSlowEaseOut,
                  enlargeCenterPage: true,
                  // onPageChanged: callbackFunction,
                  scrollDirection: Axis.horizontal,
                ),
                items: reviews
                    .map((e) => ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          leading: const CircleAvatar(
                            radius: 20,
                            backgroundColor: primaryColor,
                          ),
                          title: Text(e["name"] ?? "Name",
                              style: normalText(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(e["review"] ?? "Review",
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: normalText(
                                      color: Colors.black45, fontSize: 14)),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: primaryColor,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(e["rating"].toString(),
                                      style: normalText(
                                          color: Colors.black45, fontSize: 14)),
                                ],
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 10),
            CustomButton(
                text: "Edit Profile",
                onPressed: () {
                  sendToPage(context, const EditUserPage());
                }),
            // Name
            // Email
            // Phone Number
            // Address
            // Counselling Type
          ],
        ),
      ),
    );
  }
}

class ClientProfile extends StatefulWidget {
  const ClientProfile({super.key});

  @override
  State<ClientProfile> createState() => _ClientProfileState();
}

class _ClientProfileState extends State<ClientProfile> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
