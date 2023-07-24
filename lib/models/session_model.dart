// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class SessionModel {
  String? id;
  String? userId;
  List<dynamic>? ids;
  String? counsellorId;
  String? counsellorName;
  String? counsellorImage;
  String? userName;
  String? userImage;
  String? status;
  int? endedAt;
  int? createdAt;
  String? topic;
  SessionModel({
    this.id,
    this.userId,
    this.ids,
    this.counsellorId,
    this.counsellorName,
    this.counsellorImage,
    this.userName,
    this.userImage,
    this.status = 'Pending',
    this.endedAt,
    this.createdAt,
    this.topic,
  });

  SessionModel copyWith({
    String? id,
    String? userId,
    List<dynamic>? ids,
    String? counsellorId,
    String? counsellorName,
    String? counsellorImage,
    String? userName,
    String? userImage,
    String? status,
    int? endedAt,
    int? createdAt,
    String? topic,
  }) {
    return SessionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      ids: ids ?? this.ids,
      counsellorId: counsellorId ?? this.counsellorId,
      counsellorName: counsellorName ?? this.counsellorName,
      counsellorImage: counsellorImage ?? this.counsellorImage,
      userName: userName ?? this.userName,
      userImage: userImage ?? this.userImage,
      status: status ?? this.status,
      endedAt: endedAt ?? this.endedAt,
      createdAt: createdAt ?? this.createdAt,
      topic: topic ?? this.topic,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'ids': ids,
      'counsellorId': counsellorId,
      'counsellorName': counsellorName,
      'counsellorImage': counsellorImage,
      'userName': userName,
      'userImage': userImage,
      'status': status,
      'endedAt': endedAt,
      'createdAt': createdAt,
      'topic': topic,
    };
  }

  factory SessionModel.fromMap(Map<String, dynamic> map) {
    return SessionModel(
      id: map['id'] != null ? map['id'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      ids: map['ids'] != null
          ? List<dynamic>.from((map['ids'] as List<dynamic>))
          : null,
      counsellorId:
          map['counsellorId'] != null ? map['counsellorId'] as String : null,
      counsellorName: map['counsellorName'] != null
          ? map['counsellorName'] as String
          : null,
      counsellorImage: map['counsellorImage'] != null
          ? map['counsellorImage'] as String
          : null,
      userName: map['userName'] != null ? map['userName'] as String : null,
      userImage: map['userImage'] != null ? map['userImage'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      endedAt: map['endedAt'] != null ? map['endedAt'] as int : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as int : null,
      topic: map['topic'] != null ? map['topic'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SessionModel.fromJson(String source) =>
      SessionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SessionModel(id: $id, userId: $userId, ids: $ids, counsellorId: $counsellorId, counsellorName: $counsellorName, counsellorImage: $counsellorImage, userName: $userName, userImage: $userImage, status: $status, endedAt: $endedAt, createdAt: $createdAt, topic: $topic)';
  }

  @override
  bool operator ==(covariant SessionModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        listEquals(other.ids, ids) &&
        other.counsellorId == counsellorId &&
        other.counsellorName == counsellorName &&
        other.counsellorImage == counsellorImage &&
        other.userName == userName &&
        other.userImage == userImage &&
        other.status == status &&
        other.endedAt == endedAt &&
        other.createdAt == createdAt &&
        other.topic == topic;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        ids.hashCode ^
        counsellorId.hashCode ^
        counsellorName.hashCode ^
        counsellorImage.hashCode ^
        userName.hashCode ^
        userImage.hashCode ^
        status.hashCode ^
        endedAt.hashCode ^
        createdAt.hashCode ^
        topic.hashCode;
  }
}
