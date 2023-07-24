// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class QuestionsModel {
  String? id;
  String? question;
  String? description;
  String? category;
  String? postById;
  String? postByName;
  String? postByType;
  String? postedByImage;
  bool? isAnonymous;
  int? createdAt;
  QuestionsModel({
    this.id,
    this.question,
    this.description,
    this.category,
    this.postById,
    this.postByName,
    this.postByType,
    this.postedByImage,
    this.isAnonymous = false,
    this.createdAt,
  });

  QuestionsModel copyWith({
    String? id,
    String? question,
    String? description,
    String? category,
    String? postById,
    String? postByName,
    String? postByType,
    String? postedByImage,
    bool? isAnonymous,
    int? createdAt,
  }) {
    return QuestionsModel(
      id: id ?? this.id,
      question: question ?? this.question,
      description: description ?? this.description,
      category: category ?? this.category,
      postById: postById ?? this.postById,
      postByName: postByName ?? this.postByName,
      postByType: postByType ?? this.postByType,
      postedByImage: postedByImage ?? this.postedByImage,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'question': question,
      'description': description,
      'category': category,
      'postById': postById,
      'postByName': postByName,
      'postByType': postByType,
      'postedByImage': postedByImage,
      'isAnonymous': isAnonymous,
      'createdAt': createdAt,
    };
  }

  factory QuestionsModel.fromMap(Map<String, dynamic> map) {
    return QuestionsModel(
      id: map['id'] != null ? map['id'] as String : null,
      question: map['question'] != null ? map['question'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      category: map['category'] != null ? map['category'] as String : null,
      postById: map['postById'] != null ? map['postById'] as String : null,
      postByName:
          map['postByName'] != null ? map['postByName'] as String : null,
      postByType:
          map['postByType'] != null ? map['postByType'] as String : null,
      postedByImage:
          map['postedByImage'] != null ? map['postedByImage'] as String : null,
      isAnonymous:
          map['isAnonymous'] != null ? map['isAnonymous'] as bool : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestionsModel.fromJson(String source) =>
      QuestionsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'QuestionsModel(id: $id, question: $question, description: $description, category: $category, postById: $postById, postByName: $postByName, postByType: $postByType, postedByImage: $postedByImage, isAnonymous: $isAnonymous, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant QuestionsModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.question == question &&
        other.description == description &&
        other.category == category &&
        other.postById == postById &&
        other.postByName == postByName &&
        other.postByType == postByType &&
        other.postedByImage == postedByImage &&
        other.isAnonymous == isAnonymous &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        question.hashCode ^
        description.hashCode ^
        category.hashCode ^
        postById.hashCode ^
        postByName.hashCode ^
        postByType.hashCode ^
        postedByImage.hashCode ^
        isAnonymous.hashCode ^
        createdAt.hashCode;
  }

  Map<Object, Object?> updateMap() {
    return <String, dynamic>{
      'question': question,
      'description': description,
      'category': category,
      'isAnonymous': isAnonymous,
    };
  }
}
