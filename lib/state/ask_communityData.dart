// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_counsellor/core/components/widgets/smart_dialog.dart';

import '../models/questions_model.dart';
import '../services/firebase_fireStore.dart';
import 'data_state.dart';

// Firebase Stream of all questions
final allQuestionsStreamProvider =
    StreamProvider.autoDispose<List<QuestionsModel>>((ref) async* {
  final questions = FireStoreServices.getAllQuestionsStream();
  ref.onDispose(() {
    questions.drain();
  });

  var questionsList = <QuestionsModel>[];
  await for (var question in questions) {
    questionsList =
        question.docs.map((e) => QuestionsModel.fromMap(e.data())).toList();
    yield questionsList;
  }
});

final questionsProvider =
    StateNotifierProvider<QuestionsProvider, QuestionsModel>(
        (ref) => QuestionsProvider());

class QuestionsProvider extends StateNotifier<QuestionsModel> {
  QuestionsProvider() : super(QuestionsModel());
  void setQuestion(QuestionsModel question) {
    state = question;
  }

  void setQuestionTitle(String value) {
    state = state.copyWith(question: value);
  }

  void setQuestionCategory(String string) {
    state = state.copyWith(category: string);
  }

  void setQuestionDescription(String value) {
    state = state.copyWith(description: value);
  }

  void setQuestionAnonymous(bool? value) {
    state = state.copyWith(isAnonymous: value);
  }

  void addQuestion(BuildContext context, WidgetRef ref) {
    //show loading dialog
    CustomDialog.showLoading(
      message: 'Posting question...',
    );

    //get user details
    final user = ref.read(userProvider);
    //get document id
    state = state.copyWith(id: FireStoreServices.getDocumentId('questions'));
    //set question details
    state = state.copyWith(
      postById: user.id,
      postByName: user.name,
      postByType: user.userType,
      postedByImage: user.profile,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    //add question to firebase
    FireStoreServices.addQuestion(state).then((value) {
      //close loading dialog
      CustomDialog.dismiss();
      //show success dialog
      CustomDialog.showSuccess(
        title: 'Success',
        message: 'Question posted successfully',
      );
      //clear state
      state = QuestionsModel();
      //pop bottom sheet
      Navigator.pop(context);
    }).catchError((error) {
      //close loading dialog
      CustomDialog.dismiss();
      //show error dialog
      CustomDialog.showError(
          title: 'Error', message: 'An error occurred while posting question');
      Navigator.pop(context);
    });
  }

  void updateQuestion(BuildContext context, WidgetRef ref) {
    //show loading dialog
    CustomDialog.showLoading(
      message: 'Updating question...',
    );

    //add question to firebase
    FireStoreServices.updateQuestion(state).then((value) {
      //close loading dialog
      CustomDialog.dismiss();
      //show success dialog
      CustomDialog.showSuccess(
        title: 'Success',
        message: 'Question updated successfully',
      );
      //clear state
      state = QuestionsModel();
      //pop bottom sheet
      Navigator.pop(context);
    }).catchError((error) {
      //close loading dialog
      CustomDialog.dismiss();
      //show error dialog
      CustomDialog.showError(
          title: 'Error', message: 'An error occurred while updating question');
      Navigator.pop(context);
    });
  }
}

final allQuestionProvider =
    StateNotifierProvider<AllQuestionsProvider, List<QuestionsModel>>(
        (ref) => AllQuestionsProvider());

class AllQuestionsProvider extends StateNotifier<List<QuestionsModel>> {
  AllQuestionsProvider() : super([]) {
    getAllQuestions();
  }
  void setAllQuestions(List<QuestionsModel> questions) {
    state = questions;
  }

  void getAllQuestions() async {
    final list = await FireStoreServices.getAllQuestions();
    state = list;
  }
}

final questionSearchQuery = StateProvider<String>((ref) => '');
final searchQuestionProvider =
    Provider.autoDispose<List<QuestionsModel>>((ref) {
  final query = ref.watch(questionSearchQuery);
  final list = ref.watch(allQuestionProvider);
  if (query.isEmpty) {
    return [];
  }
  return list
      .where((element) =>
          element.question!.toLowerCase().contains(query.toLowerCase()) ||
          element.category!.toLowerCase().contains(query.toLowerCase()))
      .toList();
});
