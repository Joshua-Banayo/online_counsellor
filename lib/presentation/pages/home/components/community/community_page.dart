import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:online_counsellor/core/components/widgets/custom_button.dart';
import 'package:online_counsellor/core/components/widgets/custom_input.dart';
import 'package:online_counsellor/core/functions.dart';
import 'package:online_counsellor/presentation/pages/home/components/community/question_card.dart';
import 'package:online_counsellor/state/ask_communityData.dart';
import 'package:online_counsellor/styles/styles.dart';

import '../../../../../styles/colors.dart';
import 'ask_community.dart';

class CommunityPage extends ConsumerStatefulWidget {
  const CommunityPage({super.key});

  @override
  ConsumerState<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends ConsumerState<CommunityPage> {
  final FocusNode _focus = FocusNode();

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final questionsList = ref.watch(allQuestionsStreamProvider);
    return Scaffold(
        floatingActionButton: SizedBox(
          width: 180,
          height: 45,
          child: CustomButton(
            text: "Ask a Question",
            onPressed: () {
              sendToPage(
                  context,
                  const AskCommunity(
                    null,
                  ));
            },
            color: Colors.blue,
            icon: MdiIcons.plus,
          ),
        ),
        body: questionsList.when(data: (data) {
          return ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 10, bottom: 20),
              child: CustomTextFields(
                hintText: "Search",
                focusNode: _focus,
                controller: _controller,
                suffixIcon: _focus.hasFocus
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _controller.clear();
                            ref.read(questionSearchQuery.notifier).state = '';
                            _focus.unfocus();
                          });
                        },
                        icon: Icon(MdiIcons.close, color: primaryColor))
                    : Icon(MdiIcons.magnify, color: primaryColor),
                onChanged: (value) {
                  ref.read(questionSearchQuery.notifier).state = value;
                },
              ),
            ),
            subtitle: _focus.hasFocus
                ? LayoutBuilder(builder: (context, constraint) {
                    var list = ref.watch(searchQuestionProvider);

                    if (list.isNotEmpty) {
                      return ListView.builder(
                        padding: const EdgeInsets.only(bottom: 150),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return QuestionCard(list[index]);
                        },
                      );
                    } else {
                      return Center(
                          child:
                              Text('No Questions Found', style: normalText()));
                    }
                  })
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 150),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return QuestionCard(data[index]);
                    },
                  ),
          );
        }, error: (error, stackTrace) {
          return Padding(
              padding: const EdgeInsets.all(10),
              child: Text('Something went wrong!',
                  style: normalText(color: Colors.grey.shade400)));
        }, loading: () {
          return const Center(child: CircularProgressIndicator());
        }));
  }
}
