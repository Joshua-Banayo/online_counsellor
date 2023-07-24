import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:online_counsellor/presentation/pages/home/home_main.dart';
import 'package:online_counsellor/presentation/pages/authentication/auth_main_page.dart';
import 'package:online_counsellor/services/firebase_auth.dart';
import 'package:online_counsellor/services/firebase_fireStore.dart';
import 'package:online_counsellor/state/data_state.dart';
import 'package:online_counsellor/styles/colors.dart';
import 'core/components/widgets/smart_dialog.dart';
import 'firebase_options.dart';
import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  Future<bool> _initUser() async {
    ref.watch(quotesProvider.notifier).getQuotes();
    ref.watch(counsellorsProvider.notifier).getCounsellors();

    if (FirebaseAuthService.isUserLogin()) {
      User user = FirebaseAuthService.getCurrentUser();
      await FireStoreServices.updateUserOnlineStatus(user.uid, true);
      UserModel? userModel = await FireStoreServices.getUser(user.uid);
      if (userModel != null) {
        ref.read(userProvider.notifier).setUser(userModel);
      } else {
        CustomDialog.showError(
            title: 'Data Error',
            message: 'Unable to get User info, try again later');
      }

      return true;
    } else {
      return false;
    }
  }
  // set user isOnline to false in firestore when app is closed

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Online Counsellor',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
          useMaterial3: true,
        ),
        builder: FlutterSmartDialog.init(),
        home: FutureBuilder<bool>(
            future: _initUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!) {
                  return const HomeMainPage();
                } else {
                  return const AuthMainPage();
                }
              } else {
                return const Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                    child: SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator()),
                  ),
                );
              }
            }));
  }
}
