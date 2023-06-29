import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:online_counsellor/presentation/pages/home/components/appointment_page.dart';
import 'package:online_counsellor/presentation/pages/home/components/community_page.dart';
import 'package:online_counsellor/presentation/pages/home/components/home_page.dart';
import 'package:online_counsellor/presentation/pages/home/components/prohfile_page.dart';
import 'package:online_counsellor/presentation/pages/home/components/session_page.dart';
import 'package:online_counsellor/services/firebase_fireStore.dart';
import 'package:online_counsellor/styles/styles.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '../../../state/data_state.dart';
import '../../../styles/colors.dart';

class HomeMainPage extends ConsumerStatefulWidget {
  const HomeMainPage({super.key});

  @override
  ConsumerState<HomeMainPage> createState() => _HomeMainState();
}

class _HomeMainState extends ConsumerState<HomeMainPage> {
  List<Widget> _buildScreens(bool isCounsellor) {
    return [
      //if (!isCounsellor)
      const HomePage(),
      const CommunityPage(),
      const SessionPage(),
      const AppointmentPage(),
      const ProfilePage()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems(bool isCounsellor) {
    return [
      //if (!isCounsellor)
      PersistentBottomNavBarItem(
        icon: Icon(MdiIcons.home),
        title: ("Home"),
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(MdiIcons.accountGroup),
        title: ("Community"),
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(MdiIcons.calendarClock),
        title: ("Sessions"),
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(MdiIcons.calendar),
        title: ("Appointments"),
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(MdiIcons.account),
        title: ("Profile"),
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var userTypes = ref.watch(userProvider).userType;
    return WillPopScope(
        onWillPop: () => warnUserBeforeCloseApp(),
        child: SafeArea(
          child: PersistentTabView(
            context,

            screens: _buildScreens(userTypes == 'Counsellor'),
            items: _navBarsItems(userTypes == 'Counsellor'),
            confineInSafeArea: true,
            backgroundColor: Colors.white, // Default is Colors.white.
            handleAndroidBackButtonPress: true, // Default is true.
            resizeToAvoidBottomInset:
                true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
            stateManagement: true, // Default is true.
            hideNavigationBarWhenKeyboardShows:
                true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
            decoration: NavBarDecoration(
              borderRadius: BorderRadius.circular(10.0),
              colorBehindNavBar: Colors.white,
            ),
            popAllScreensOnTapOfSelectedTab: true,
            popActionScreens: PopActionScreensType.all,
            itemAnimationProperties: const ItemAnimationProperties(
              // Navigation Bar's items animation properties.
              duration: Duration(milliseconds: 200),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: const ScreenTransitionAnimation(
              // Screen transition animation on change of selected tab.
              animateTabTransition: true,
              curve: Curves.ease,
              duration: Duration(milliseconds: 200),
            ),
            navBarStyle: NavBarStyle
                .style1, // Choose the nav bar style with this property.
          ),
        ));
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
}
