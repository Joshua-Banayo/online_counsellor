import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_counsellor/core/components/widgets/custom_input.dart';
import 'package:online_counsellor/models/questions_model.dart';
import 'package:online_counsellor/styles/colors.dart';

import '../../../../../core/functions.dart';
import '../../../../../models/comment_model.dart';
import '../../../../../state/comment_data_state.dart';
import '../../../../../state/data_state.dart';
import '../../../../../styles/styles.dart';

class CommentPage extends ConsumerStatefulWidget {
  const CommentPage({
    super.key,
    required this.post,
  });
  final QuestionsModel post;

  @override
  ConsumerState<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends ConsumerState<CommentPage> {
  final TextEditingController _commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
    final commentsList = ref.watch(commentsStreamProvider(widget.post.id!));
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            radius: 18,
            backgroundColor: Colors.blue,
            backgroundImage:
                !widget.post.isAnonymous! && widget.post.postedByImage != null
                    ? NetworkImage(widget.post.postedByImage!)
                    : null,
            child: widget.post.isAnonymous!
                ? const Text(
                    "A",
                    style: TextStyle(color: Colors.white),
                  )
                : null,
          ),
          title: widget.post.isAnonymous!
              ? Text(
                  "Anonymous",
                  style: normalText(fontWeight: FontWeight.bold, fontSize: 13),
                )
              : RichText(
                  text: TextSpan(children: [
                  TextSpan(
                      text: widget.post.postByName,
                      style: normalText(
                          fontWeight: FontWeight.bold, fontSize: 13)),
                  TextSpan(text: " - ", style: normalText()),
                  TextSpan(
                      text: widget.post.postByType,
                      style: normalText(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54)),
                ])),
          subtitle: Text(getNumberOfTime(widget.post.createdAt!),
              style: normalText(fontSize: 12)),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.post.question!,
                        style: normalText(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(widget.post.description!, style: normalText()),
                    const SizedBox(height: 10),
                    const Divider(),
                    Text("Comments".toUpperCase(),
                        style: normalText(
                            fontWeight: FontWeight.bold,
                            color: secondaryColor)),
                    const SizedBox(height: 10),
                    commentsList.when(data: (data) {
                      if (data.isEmpty) {
                        return const Center(child: Text("No comments yet"));
                      }
                      return ListView.separated(
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 20,
                              ),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.blue,
                                  backgroundImage: data[index].isAnonymous!
                                      ? null
                                      : NetworkImage(
                                          data[index].commentByImage!),
                                  child: data[index].isAnonymous!
                                      ? const Text(
                                          "A",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          data[index].isAnonymous!
                                              ? Text(
                                                  "Anonymous",
                                                  style: normalText(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13),
                                                )
                                              : RichText(
                                                  text: TextSpan(children: [
                                                  TextSpan(
                                                      text: data[index]
                                                          .commentByName,
                                                      style: normalText(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13)),
                                                  TextSpan(
                                                      text: " - ",
                                                      style: normalText()),
                                                  TextSpan(
                                                      text: data[index]
                                                          .commentByType,
                                                      style: normalText(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.black54)),
                                                ])),
                                          if (data[index].commentById ==
                                              user.id)
                                            PopupMenuButton(
                                                child:
                                                    const Icon(Icons.more_vert),
                                                itemBuilder: (context) {
                                                  return [
                                                    PopupMenuItem(
                                                        child: ListTile(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      leading: const Icon(
                                                          Icons.delete),
                                                      title:
                                                          const Text('Delete'),
                                                      onTap: () {
                                                        ref
                                                            .read(
                                                                commentProvider
                                                                    .notifier)
                                                            .deleteComment(
                                                                data[index].id!,
                                                                widget
                                                                    .post.id!);
                                                        Navigator.pop(context);
                                                      },
                                                    )),
                                                    PopupMenuItem(
                                                        child: ListTile(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      leading: const Icon(
                                                          Icons.edit),
                                                      title: const Text('Edit'),
                                                      onTap: () {
                                                        ref
                                                            .read(
                                                                commentProvider
                                                                    .notifier)
                                                            .setComment(
                                                                data[index]);
                                                        _commentController
                                                                .text =
                                                            data[index]
                                                                .comment!;
                                                        Navigator.pop(context);
                                                      },
                                                    ))
                                                  ];
                                                })
                                        ],
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            getNumberOfTime(
                                                data[index].createdAt!),
                                            style: normalText(fontSize: 12)),
                                        const Divider(
                                          height: 10,
                                        ),
                                        Text(data[index].comment!,
                                            style: normalText(fontSize: 13))
                                      ],
                                    ),
                                    isThreeLine: true,
                                    dense: true,
                                    minVerticalPadding: 0,
                                    visualDensity:
                                        const VisualDensity(vertical: -4),
                                    tileColor: Colors.grey.withOpacity(0.1),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                              ],
                            );
                          });
                    }, error: (error, stackTrace) {
                      return Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Error fetching comments',
                            style: normalText(color: Colors.grey),
                          ),
                        ),
                      );
                    }, loading: () {
                      return const Center(child: CircularProgressIndicator());
                    })
                  ]),
            )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Row(children: [
                Checkbox(
                    value: ref.watch(commentProvider).isAnonymous ?? false,
                    onChanged: (value) {
                      ref
                          .read(commentProvider.notifier)
                          .setCommentAnonymous(value);
                    }),
                const SizedBox(width: 5),
                Expanded(
                    child: Text(
                  "Post as Anonymous",
                  style: normalText(fontSize: 12),
                ))
              ]),
              subtitle: Row(
                children: [
                  Expanded(
                    child: CustomTextFields(
                      hintText: 'Write your comments',
                      controller: _commentController,
                      onChanged: (p0) {
                        if (p0.isEmpty) {
                          ref
                              .read(commentProvider.notifier)
                              .setComment(CommentModel());
                        }
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        if (_commentController.text.isNotEmpty) {
                          if (ref.watch(commentProvider).id == null) {
                            ref.read(commentProvider.notifier).addComment(
                                _commentController.text, widget.post.id!, ref);
                            //clear text
                            _commentController.clear();
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus &&
                                currentFocus.focusedChild != null) {
                              currentFocus.focusedChild!.unfocus();
                            }
                          } else {
                            ref
                                .read(commentProvider.notifier)
                                .updateComment(_commentController.text);
                            //clear text
                            _commentController.clear();
                          }
                        }
                      },
                      icon: const Icon(Icons.send, color: primaryColor))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
