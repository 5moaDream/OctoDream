import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

Future<List<Dictionary>> fetchDictionary() async {

  String token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyNzkzMTI3MzkyIiwiZXhwIjoxNjg3NDA4NTAyfQ.yizKabrMGyUpxrRvxPnw11XZu6dlB9lterq-4SxC_spYBhW2P7wvFq73v6kCs6T4mbTAGVvyjNZBvGQvM7XzJQ';
  // String token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyNzk0MDk2NTI2IiwiZXhwIjoxNjg3MzExMTgyfQ.O2UIaz23NQqE_vZ4YYUdFgaF7e0PJg29PNKxKfqMbgvQzRlJiexeOV1D9-ojhp2LtdM3RUzycuCyj_FiS4D3Xw';

  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };
  var url = Uri.parse('http://3.39.126.140:8000/user-service/collection');
  // var url = Uri.parse('http://3.39.126.140:8000/unauthorization/kakao-login');
  var response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final result = json.decode(utf8.decode(response.bodyBytes)).cast<Map<String, dynamic>>();
    List<Dictionary> list = result.map<Dictionary>((json) {
      return Dictionary.fromJson(json);
    }).toList();

    return list;
  } else {
    //만약 응답이 ok가 아니면 에러를 던집니다.
    throw Exception('실패');
  }
}

class Dictionary {
  final int characterId;
  final String characterName;
  final characterImageUrl;

  Dictionary(
      {required this.characterId,
        required this.characterName,
        required this.characterImageUrl,
        });

  factory Dictionary.fromJson(Map<String, dynamic> json) {
    return Dictionary(
      characterId: json["characterId"],
      characterName: json["characterName"],
      characterImageUrl: json["characterImageUrl"],
    );
  }
}
