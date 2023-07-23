import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_counsellor/presentation/pages/profile/view_page.dart';
import '../../../generated/assets.dart';
import '../../../state/data_state.dart';
import '../../../styles/colors.dart';
import 'edit_page.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: IndexedStack(
          index: ref.watch(userProfileIndexProvider),
          children: const [
            ProfileViewPage(),
            ProfileEditPage(),
          ]),
    );
  }
}
