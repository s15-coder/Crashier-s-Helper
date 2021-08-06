import 'dart:convert';

import 'package:http/http.dart' as http;

class ServiceApi {
  final String url = "https://messagesclients.herokuapp.com/message";
  Future<Map> sendMessage(String email, String message) async {
    http.Response response = await http.post(
      Uri.parse(url),
      body: {
        "email": email,
        "message": message,
      },
    );
    return jsonDecode(response.body);
  }
}
