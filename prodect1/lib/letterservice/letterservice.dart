import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class lettone{
  final int guestBookId;
  final int userId;
  final int guestId;
  final String content;
  final bool read;
  final String createdTime;

  lettone({
    required this.guestBookId, required this.userId, required this.guestId,
    required this.content, required this.read, required this.createdTime
  });

  factory lettone.fromJson(Map<String, dynamic> json) {
    return lettone(
      guestBookId: json['guestBookId'],
      userId: json['userId'],
      guestId: json['guestId'],
      content: json['content'],
      read: json['read'],
      createdTime: json['createdTime'],
    );
  }
}

// 저장된 인증 토큰 및 리프레시 토큰을 가져오는 함수
Future<Map<String, String>> getTokens() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('accessToken');

  return {
    'accessToken': accessToken ?? '',
  };
}

Future<List<lettone>> fetchdata() async {
  Map<String, String> tokens = await getTokens();
  String token = tokens['accessToken']!;
  // String token =
      'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyNzkzMTI3MzkyIiwiZXhwIjoxNjg3NDA4NTAyfQ.yizKabrMGyUpxrRvxPnw11XZu6dlB9lterq-4SxC_spYBhW2P7wvFq73v6kCs6T4mbTAGVvyjNZBvGQvM7XzJQ';
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  var url = Uri.parse('http://3.39.126.140:8000/activity-service/guest-book');
  var response = await http.get(url, headers: headers);
  if (response.statusCode == 200) {
    // Request was successful
    final result = jsonDecode(response.body).cast<Map<String, dynamic>>();
    List<lettone> list = result.map<lettone>((json) {
      return lettone.fromJson(json);
    }).toList();
    print(list);
    return list; // 데이터 반환
  } else {
    // Request failed
    print('Request failed with status: ${response.statusCode}');
    print(response.body);
    return []; // 빈 리스트 반환
  }
}

class letterList{
  final String content;
  final String name;
  final int year;
  final int month;
  final int day;
  letterList(this.content, this.name, this.year, this.month, this.day);
}

List<letterList> convertToMyList(List<lettone> lettList) {
  List<letterList> lettersList = lettList.map((letter) {
    String content = letter.content;
    String name = letter.guestId.toString();
    DateTime createdTime = DateTime.parse(letter.createdTime);
    int year = createdTime.year;
    int month = createdTime.month;
    int day = createdTime.day;
    return letterList(content, name, year, month, day);
  }).toList();
  print("$lettersList");
  return lettersList;
}