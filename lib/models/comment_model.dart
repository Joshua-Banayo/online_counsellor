// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CommentModel {
  String? id;
  String? postId;
  String? comment;
  String? commentById;
  String? commentByName;
  String? commentByType;
  String? commentByImage;
  bool? isAnonymous;
  int? createdAt;
  CommentModel({
    this.id,
    this.postId,
    this.comment,
    this.commentById,
    this.commentByName,
    this.commentByType,
    this.commentByImage,
    this.isAnonymous = false,
    this.createdAt,
  });

  CommentModel copyWith({
    String? id,
    String? postId,
    String? comment,
    String? commentById,
    String? commentByName,
    String? commentByType,
    String? commentByImage,
    bool? isAnonymous,
    int? createdAt,
  }) {
    return CommentModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      comment: comment ?? this.comment,
      commentById: commentById ?? this.commentById,
      commentByName: commentByName ?? this.commentByName,
      commentByType: commentByType ?? this.commentByType,
      commentByImage: commentByImage ?? this.commentByImage,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'postId': postId,
      'comment': comment,
      'commentById': commentById,
      'commentByName': commentByName,
      'commentByType': commentByType,
      'commentByImage': commentByImage,
      'isAnonymous': isAnonymous,
      'createdAt': createdAt,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] != null ? map['id'] as String : null,
      postId: map['postId'] != null ? map['postId'] as String : null,
      comment: map['comment'] != null ? map['comment'] as String : null,
      commentById:
          map['commentById'] != null ? map['commentById'] as String : null,
      commentByName:
          map['commentByName'] != null ? map['commentByName'] as String : null,
      commentByType:
          map['commentByType'] != null ? map['commentByType'] as String : null,
      commentByImage: map['commentByImage'] != null
          ? map['commentByImage'] as String
          : null,
      isAnonymous:
          map['isAnonymous'] != null ? map['isAnonymous'] as bool : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CommentModel(id: $id, postId: $postId, comment: $comment, commentById: $commentById, commentByName: $commentByName, commentByType: $commentByType, commentByImage: $commentByImage, isAnonymous: $isAnonymous, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant CommentModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.postId == postId &&
        other.comment == comment &&
        other.commentById == commentById &&
        other.commentByName == commentByName &&
        other.commentByType == commentByType &&
        other.commentByImage == commentByImage &&
        other.isAnonymous == isAnonymous &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        postId.hashCode ^
        comment.hashCode ^
        commentById.hashCode ^
        commentByName.hashCode ^
        commentByType.hashCode ^
        commentByImage.hashCode ^
        isAnonymous.hashCode ^
        createdAt.hashCode;
  }

  Map<String, dynamic> updateMap() {
    return <String, dynamic>{
      'comment': comment,
      'isAnonymous': isAnonymous,
    };
  }
}
