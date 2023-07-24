import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_counsellor/core/components/widgets/custom_button.dart';
import 'package:online_counsellor/core/components/widgets/custom_drop_down.dart';
import 'package:online_counsellor/core/components/widgets/custom_input.dart';
import 'package:online_counsellor/models/questions_model.dart';
import 'package:online_counsellor/state/ask_communityData.dart';
import 'package:online_counsellor/styles/styles.dart';

import '../../../../../core/components/constants/strings.dart';

class AskCommunity extends ConsumerStatefulWidget {
  const AskCommunity(this.question, {super.key});
  final QuestionsModel? question;

  @override
  ConsumerState<AskCommunity> createState() => _AskCommunityState();
}

class _AskCommunityState extends ConsumerState<AskCommunity> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    //check if widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.question != null) {
        ref.read(questionsProvider.notifier).setQuestion(widget.question!);
        _questionController.text = widget.question!.question!;
        _descriptionController.text = widget.question!.description!;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            'Ask the community',
            style: normalText(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(children: [
                const SizedBox(
                  height: 10,
                ),
                CustomDropDown(
                    hintText: 'Select Topic Category',
                    label: 'Topic Category',
                    value: ref.watch(questionsProvider).category,
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a topic category';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      ref
                          .read(questionsProvider.notifier)
                          .setQuestionCategory(value.toString());
                    },
                    items: counsellingTopicCategory
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList()),
                const SizedBox(
                  height: 24,
                ),
                CustomTextFields(
                  hintText: 'Ask your question',
                  controller: _questionController,
                  label: 'Question',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your question';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    ref
                        .read(questionsProvider.notifier)
                        .setQuestionTitle(value);
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                CustomTextFields(
                  hintText: 'Add a description',
                  label: 'Description',
                  controller: _descriptionController,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    ref
                        .read(questionsProvider.notifier)
                        .setQuestionDescription(value);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                //add checkbox for anonymous
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Checkbox(
                      value: ref.watch(questionsProvider).isAnonymous ?? false,
                      onChanged: (value) {
                        ref
                            .read(questionsProvider.notifier)
                            .setQuestionAnonymous(value);
                      }),
                  title: Text(
                    'Post Anonymously',
                    style:
                        normalText(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Your question will be posted without your name, profile picture and other details',
                    style: normalText(fontSize: 14),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (widget.question == null)
                  CustomButton(
                      text: 'Post Question',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          ref
                              .read(questionsProvider.notifier)
                              .addQuestion(context, ref);
                        }
                      }),
                if (widget.question != null)
                  CustomButton(
                      text: 'Update Question',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          ref
                              .read(questionsProvider.notifier)
                              .updateQuestion(context, ref);
                        }
                      }),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
