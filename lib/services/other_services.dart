import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:online_counsellor/models/quotes_model.dart';

class OtherServices {
  static const apiKey = "CcJ40QQqsXjc3UcfPHzNYQ==3tfeodjbnLaCBTK5";
  static const baseUrl = "https://api.api-ninjas.com/v1/quotes?category=";
  static const headers = {
    "X-Api-Key": apiKey,
    "Content-Type": "application/json",
    //add limit
  };

  static Future<QuotesModel?> getQuotes(String category) async {
    final response =
        await http.get(Uri.parse('$baseUrl$category'), headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return QuotesModel.fromMap(data[0]);
    } else {
      return null;
    }
  }
}
