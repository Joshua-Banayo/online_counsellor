import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_counsellor/models/questions_model.dart';
import 'package:online_counsellor/styles/colors.dart';
import 'package:online_counsellor/styles/styles.dart';

import '../../../../../core/functions.dart';
import '../../../../../state/comment_data_state.dart';
import '../../../../../state/data_state.dart';
import 'ask_community.dart';
import 'comment_page.dart';

class QuestionCard extends ConsumerWidget {
  const QuestionCard(this.question, {super.key});
  final QuestionsModel question;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userProvider);
    var comments = ref.watch(commentsStreamProvider(question.id!));
    return InkWell(
      onTap: () => sendToPage(context, CommentPage(post: question)),
      child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    trailing: user.id == question.postById!
                        ? IconButton(
                            onPressed: () {
                              sendToPage(
                                  context,
                                  AskCommunity(
                                    question,
                                  ));
                            },
                            icon: const Icon(Icons.edit),
                          )
                        : null,
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.blue,
                      backgroundImage: !question.isAnonymous! &&
                              question.postedByImage != null
                          ? NetworkImage(question.postedByImage!)
                          : null,
                      child: question.isAnonymous!
                          ? const Text(
                              "A",
                              style: TextStyle(color: Colors.white),
                            )
                          : null,
                    ),
                    title: question.isAnonymous!
                        ? Text(
                            "Anonymous",
                            style: normalText(fontWeight: FontWeight.bold),
                          )
                        : RichText(
                            text: TextSpan(children: [
                            TextSpan(
                                text: question.postByName,
                                style: normalText(
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                            TextSpan(text: " - ", style: normalText()),
                            TextSpan(
                                text: question.postByType,
                                style: normalText(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54)),
                          ])),
                    subtitle: Text(getNumberOfTime(question.createdAt!),
                        style: normalText(fontSize: 12)),
                  ),
                  Text(
                    question.question!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: normalText(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    question.description!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const Divider(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(question.category!,
                          style: normalText(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54)),
                      comments.when(
                          loading: () => Text(
                                'Getting comments...',
                                style: normalText(fontSize: 9),
                              ),
                          error: (error, stack) => const Text(''),
                          data: (data) {
                            return Row(
                              children: [
                                const Icon(
                                  Icons.comment,
                                  color: primaryColor,
                                  size: 18,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Comments(${data.length})',
                                  style: normalText(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black54),
                                ),
                              ],
                            );
                          })
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ))),
    );
  }
}
