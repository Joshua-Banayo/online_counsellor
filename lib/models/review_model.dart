// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ReviewModel {
  String? id;
  String? counselorId;
  String? reviewerId;
  String? reviewerName;
  String? reviewerImage;
  String? review;
  double? rating;
  int? createdAt;
  ReviewModel({
    this.id,
    this.counselorId,
    this.reviewerId,
    this.reviewerName,
    this.reviewerImage,
    this.review,
    this.rating,
    this.createdAt,
  });

  ReviewModel copyWith({
    String? id,
    String? counselorId,
    String? reviewerId,
    String? reviewerName,
    String? reviewerImage,
    String? review,
    double? rating,
    int? createdAt,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      counselorId: counselorId ?? this.counselorId,
      reviewerId: reviewerId ?? this.reviewerId,
      reviewerName: reviewerName ?? this.reviewerName,
      reviewerImage: reviewerImage ?? this.reviewerImage,
      review: review ?? this.review,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'counselorId': counselorId,
      'reviewerId': reviewerId,
      'reviewerName': reviewerName,
      'reviewerImage': reviewerImage,
      'review': review,
      'rating': rating,
      'createdAt': createdAt,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'] != null ? map['id'] as String : null,
      counselorId:
          map['counselorId'] != null ? map['counselorId'] as String : null,
      reviewerId:
          map['reviewerId'] != null ? map['reviewerId'] as String : null,
      reviewerName:
          map['reviewerName'] != null ? map['reviewerName'] as String : null,
      reviewerImage:
          map['reviewerImage'] != null ? map['reviewerImage'] as String : null,
      review: map['review'] != null ? map['review'] as String : null,
      rating: map['rating'] != null ? map['rating'] as double : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewModel.fromJson(String source) =>
      ReviewModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReviewModel(id: $id, counselorId: $counselorId, reviewerId: $reviewerId, reviewerName: $reviewerName, reviewerImage: $reviewerImage, review: $review, rating: $rating, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant ReviewModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.counselorId == counselorId &&
        other.reviewerId == reviewerId &&
        other.reviewerName == reviewerName &&
        other.reviewerImage == reviewerImage &&
        other.review == review &&
        other.rating == rating &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        counselorId.hashCode ^
        reviewerId.hashCode ^
        reviewerName.hashCode ^
        reviewerImage.hashCode ^
        review.hashCode ^
        rating.hashCode ^
        createdAt.hashCode;
  }
}
