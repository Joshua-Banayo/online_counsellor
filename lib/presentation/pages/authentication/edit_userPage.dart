// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../generated/assets.dart';
import '../../../styles/colors.dart';

class EditUserPage extends ConsumerWidget {
  const EditUserPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
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
      ),
    ));
  }
}
