import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_key.dart';

class Api {
  static final url = Uri.parse("https://api.openai.com/v1/images/generations");

  static final header = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apikey'
  };

  static generateImage(String? text, String? size) async {
    var response = await http.post(
      url,
      headers: header,
      body: jsonEncode(
        {
          "prompt": text,
          "n": 1,
          "size": size,
        },
      ),
    );
    if (response.statusCode==200) {
      var data=jsonDecode(response.body.toString());
      return data['data'][0]['url'].toString();
      // print(data);
    }
    else{
      print("Failed to fetch data");
    }
  }
}
