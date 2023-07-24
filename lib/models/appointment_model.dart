// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class AppointmentModel {
  String? id;
  String? userId;
  List<dynamic>? ids;
  String? counsellorId;
  int? date;
  int? time;
  String? status;
  String? counsellorName;
  String? counsellorImage;
  String? counsellorType;
  String? userImage;
  String? userName;
  bool? counsellorState;
  bool? userState;
  int? createdAt;
  AppointmentModel({
    this.id,
    this.userId,
    this.ids,
    this.counsellorId,
    this.date,
    this.time,
    this.status = 'Pending',
    this.counsellorName,
    this.counsellorImage,
    this.counsellorType,
    this.userImage,
    this.userName,
    this.counsellorState,
    this.userState,
    this.createdAt,
  });

  AppointmentModel copyWith({
    String? id,
    String? userId,
    List<dynamic>? ids,
    String? counsellorId,
    int? date,
    int? time,
    String? status,
    String? counsellorName,
    String? counsellorImage,
    String? counsellorType,
    String? userImage,
    String? userName,
    bool? counsellorState,
    bool? userState,
    int? createdAt,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      ids: ids ?? this.ids,
      counsellorId: counsellorId ?? this.counsellorId,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      counsellorName: counsellorName ?? this.counsellorName,
      counsellorImage: counsellorImage ?? this.counsellorImage,
      counsellorType: counsellorType ?? this.counsellorType,
      userImage: userImage ?? this.userImage,
      userName: userName ?? this.userName,
      counsellorState: counsellorState ?? this.counsellorState,
      userState: userState ?? this.userState,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'ids': ids,
      'counsellorId': counsellorId,
      'date': date,
      'time': time,
      'status': status,
      'counsellorName': counsellorName,
      'counsellorImage': counsellorImage,
      'counsellorType': counsellorType,
      'userImage': userImage,
      'userName': userName,
      'counsellorState': counsellorState,
      'userState': userState,
      'createdAt': createdAt,
    };
  }

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'] != null ? map['id'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      ids: map['ids'] != null
          ? List<dynamic>.from((map['ids'] as List<dynamic>))
          : null,
      counsellorId:
          map['counsellorId'] != null ? map['counsellorId'] as String : null,
      date: map['date'] != null ? map['date'] as int : null,
      time: map['time'] != null ? map['time'] as int : null,
      status: map['status'] != null ? map['status'] as String : null,
      counsellorName: map['counsellorName'] != null
          ? map['counsellorName'] as String
          : null,
      counsellorImage: map['counsellorImage'] != null
          ? map['counsellorImage'] as String
          : null,
      counsellorType: map['counsellorType'] != null
          ? map['counsellorType'] as String
          : null,
      userImage: map['userImage'] != null ? map['userImage'] as String : null,
      userName: map['userName'] != null ? map['userName'] as String : null,
      counsellorState: map['counsellorState'] != null
          ? map['counsellorState'] as bool
          : null,
      userState: map['userState'] != null ? map['userState'] as bool : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppointmentModel.fromJson(String source) =>
      AppointmentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AppointmentModel(id: $id, userId: $userId, ids: $ids, counsellorId: $counsellorId, date: $date, time: $time, status: $status, counsellorName: $counsellorName, counsellorImage: $counsellorImage, counsellorType: $counsellorType, userImage: $userImage, userName: $userName, counsellorState: $counsellorState, userState: $userState, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant AppointmentModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        listEquals(other.ids, ids) &&
        other.counsellorId == counsellorId &&
        other.date == date &&
        other.time == time &&
        other.status == status &&
        other.counsellorName == counsellorName &&
        other.counsellorImage == counsellorImage &&
        other.counsellorType == counsellorType &&
        other.userImage == userImage &&
        other.userName == userName &&
        other.counsellorState == counsellorState &&
        other.userState == userState &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        ids.hashCode ^
        counsellorId.hashCode ^
        date.hashCode ^
        time.hashCode ^
        status.hashCode ^
        counsellorName.hashCode ^
        counsellorImage.hashCode ^
        counsellorType.hashCode ^
        userImage.hashCode ^
        userName.hashCode ^
        counsellorState.hashCode ^
        userState.hashCode ^
        createdAt.hashCode;
  }

  Map<String, dynamic> rescheduleMap() {
    return <String, dynamic>{
      'date': date,
      'time': time,
      'status': 'Pending',
    };
  }
}
