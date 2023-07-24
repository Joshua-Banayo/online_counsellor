import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:online_counsellor/core/functions.dart';
import 'package:online_counsellor/presentation/pages/home/components/appointment/appointment_page.dart';
import 'package:online_counsellor/presentation/pages/home/components/community/community_page.dart';
import 'package:online_counsellor/presentation/pages/home/components/home_page.dart';
import 'package:online_counsellor/presentation/pages/home/components/session/session_page.dart';
import 'package:online_counsellor/services/firebase_fireStore.dart';
import 'package:online_counsellor/state/navigation_state.dart';
import 'package:online_counsellor/styles/styles.dart';
import '../../../generated/assets.dart';
import '../../../services/firebase_auth.dart';
import '../../../state/data_state.dart';
import '../../../styles/colors.dart';
import '../authentication/auth_main_page.dart';
import '../profile/profile_page.dart';

class HomeMainPage extends ConsumerStatefulWidget {
  const HomeMainPage({super.key});

  @override
  ConsumerState<HomeMainPage> createState() => _HomeMainState();
}

class _HomeMainState extends ConsumerState<HomeMainPage> {
  List<Widget> _buildScreens(bool isCounsellor) {
    return [
      if (!isCounsellor) const HomePage(),
      const CommunityPage(),
      const SessionPage(),
      const AppointmentPage(),
      //const ProfilePage()
    ];
  }

  @override
  Widget build(BuildContext context) {
    var userTypes = ref.watch(userProvider).userType;
    return WillPopScope(
        onWillPop: () => warnUserBeforeCloseApp(),
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Row(children: [
                Image.asset(
                  Assets.logoIcon,
                  height: 45,
                ),
                const SizedBox(width: 10),
                Text(
                  'Online Counsellor',
                  style: GoogleFonts.lobster(
                    fontSize: 26,
                    color: primaryColor,
                  ),
                ),
              ]),
              actions: [
                PopupMenuButton(
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: primaryColor.withOpacity(.5),
                      backgroundImage: ref.watch(userProvider).profile != null
                          ? NetworkImage(ref.watch(userProvider).profile!)
                          : null,
                    ),
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                            child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.account_circle),
                          title: const Text('Profile'),
                          onTap: () {
                            sendToPage(context, const ProfilePage());
                          },
                        )),
                        PopupMenuItem(
                            child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.logout),
                          title: const Text('Logout'),
                          onTap: () async {
                            //set user isOnline to false in firestore
                            var userId = ref.read(userProvider).id;
                            await FireStoreServices.updateUserOnlineStatus(
                                userId!, false);
                            await FirebaseAuthService.signOut();
                            if (mounted) {
                              noReturnSendToPage(context, const AuthMainPage());
                            }
                          },
                        ))
                      ];
                    }),
                const SizedBox(width: 10)
              ],
            ),
            bottomNavigationBar: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: GNav(
                  onTabChange: (index) {
                    ref.read(bottomNavIndexProvider.notifier).state = index;
                  },
                  tabActiveBorder: Border.all(
                      color: Colors.black, width: 1), // tab button border
                  padding: const EdgeInsets.all(8),
                  gap: 8,
                  activeColor: primaryColor,
                  tabs: [
                    if (userTypes != 'Counsellor')
                      GButton(
                        icon: MdiIcons.home,
                        text: 'Home',
                      ),
                    GButton(
                      icon: MdiIcons.accountGroup,
                      text: 'Community',
                    ),
                    GButton(
                      icon: MdiIcons.calendarClock,
                      text: 'Sessions',
                    ),
                    GButton(
                      icon: MdiIcons.calendar,
                      text: 'Appointments',
                    ),
                  ]),
            ),
            body: getWidgets(_buildScreens(userTypes == 'Counsellor'),
                ref.watch(bottomNavIndexProvider))));
  }

  Future<bool> warnUserBeforeCloseApp() async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit App',
                style: normalText(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    fontSize: 16)),
            content: Text('Do you want to exit an App?',
                style: normalText(
                    fontWeight: FontWeight.normal,
                    color: primaryColor,
                    fontSize: 14)),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                //return false when click on "NO"
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () {
                  closeApp();
                },
                //return true when click on "Yes"
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false; //if showDialog had returned null, then return false
  }

  void closeApp() async {
    //set user isOnline to false in firestore
    var userId = ref.read(userProvider).id;
    await FireStoreServices.updateUserOnlineStatus(userId!, false)
        .then((value) => Navigator.of(context).pop(true));
  }

  Widget getWidgets(List<Widget> buildScreens, int watch) {
    switch (watch) {
      case 0:
        return buildScreens[0];
      case 1:
        return buildScreens[1];
      case 2:
        return buildScreens[2];
      case 3:
        return buildScreens[3];
      case 4:
        return buildScreens[4];
      default:
        return buildScreens[0];
    }
  }
}
