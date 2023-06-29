// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class QuotesModel {
  String quote;
  String author;
  String category;
  QuotesModel({
    required this.quote,
    required this.author,
    required this.category,
  });

  QuotesModel copyWith({
    String? quote,
    String? author,
    String? category,
  }) {
    return QuotesModel(
      quote: quote ?? this.quote,
      author: author ?? this.author,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'quote': quote,
      'author': author,
      'category': category,
    };
  }

  factory QuotesModel.fromMap(Map<String, dynamic> map) {
    return QuotesModel(
      quote: map['quote'] as String,
      author: map['author'] as String,
      category: map['category'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuotesModel.fromJson(String source) =>
      QuotesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'QuotesModel(quote: $quote, author: $author, category: $category)';

  @override
  bool operator ==(covariant QuotesModel other) {
    if (identical(this, other)) return true;

    return other.quote == quote &&
        other.author == author &&
        other.category == category;
  }

  @override
  int get hashCode => quote.hashCode ^ author.hashCode ^ category.hashCode;
}
