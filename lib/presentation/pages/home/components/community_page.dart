import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:online_counsellor/core/components/widgets/custom_button.dart';
import 'package:online_counsellor/core/components/widgets/custom_input.dart';

import '../../../../generated/assets.dart';
import '../../../../styles/colors.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        floatingActionButton: SizedBox(
          width: 180,
          height: 45,
          child: CustomButton(
            text: "Ask a Question",
            onPressed: () {},
            color: Colors.blue,
            icon: MdiIcons.plus,
          ),
        ),
        body: ListTile(
          contentPadding: const EdgeInsets.all(0),
          title: Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
            child: CustomTextFields(
              hintText: "Search",
              radius: 25,
              onChanged: (value) {},
              suffixIcon: Icon(MdiIcons.magnify),
            ),
          ),
          subtitle: ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text("A"),
                ),
                title: Text("Question $index"),
                subtitle: Text("Answer $index"),
              );
            },
          ),
        ));
  }
}
