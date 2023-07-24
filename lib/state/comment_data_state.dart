//stream of comments by question id
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/comment_model.dart';
import '../services/firebase_fireStore.dart';
import 'data_state.dart';

final commentsStreamProvider = StreamProvider.autoDispose
    .family<List<CommentModel>, String>((ref, id) async* {
  final comments = FireStoreServices.getComments(id);
  ref.onDispose(() {
    comments.drain();
  });

  var list = <CommentModel>[];
  await for (var comment in comments) {
    list = comment.docs.map((e) => CommentModel.fromMap(e.data())).toList();
    yield list;
  }
});

final commentProvider = StateNotifierProvider<CommentProvider, CommentModel>(
    (ref) => CommentProvider());

class CommentProvider extends StateNotifier<CommentModel> {
  CommentProvider() : super(CommentModel());
  void setComment(CommentModel comment) {
    state = comment;
  }

  void addComment(String text, String id, WidgetRef ref) async {
    //get current user
    var user = ref.read(userProvider);
    //get comment id
    var commentId = FireStoreServices.getDocumentId('',
        collection: FirebaseFirestore.instance
            .collection('questions')
            .doc(id)
            .collection('comments'));
    state = state.copyWith(
      comment: text,
      commentByName: user.name,
      commentByImage: user.profile,
      commentById: user.id,
      commentByType: user.userType,
      id: commentId,
      createdAt: DateTime.now().toUtc().millisecondsSinceEpoch,
      postId: id,
    );
    await FireStoreServices.saveComment(state);
    //clear state
    state = CommentModel();
  }

  void setCommentAnonymous(bool? value) {
    state = state.copyWith(isAnonymous: value);
  }

  void updateComment(String text) {
    state = state.copyWith(comment: text);
    //update comment in firestore
    FireStoreServices.updateComment(state);
  }

  void deleteComment(String id, String postId) async {
    await FireStoreServices.deleteComment(id, postId);
  }
}


