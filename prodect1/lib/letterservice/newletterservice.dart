import 'dart:convert';
import 'package:http/http.dart' as http;

class newlettone{
  final int guestBookId;
  final int userId;
  final int guestId;
  final String content;
  final bool read;
  final String createdTime;

  newlettone({
    required this.guestBookId, required this.userId, required this.guestId,
    required this.content, required this.read, required this.createdTime
  });

  factory newlettone.fromJson(Map<String, dynamic> json) {
    return newlettone(
      guestBookId: json['guestBookId'],
      userId: json['userId'],
      guestId: json['guestId'],
      content: json['content'],
      read: json['read'],
      createdTime: json['createdTime'],
    );
  }
}

Future<List<newlettone>> fetchdata() async {
  String token =
      'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyNzkzMTI3MzkyIiwiZXhwIjoxNjg3NDA4NTAyfQ.yizKabrMGyUpxrRvxPnw11XZu6dlB9lterq-4SxC_spYBhW2P7wvFq73v6kCs6T4mbTAGVvyjNZBvGQvM7XzJQ';
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  var url = Uri.parse('http://3.39.126.140:8000/activity-service/guest-book/unread');
  var response = await http.get(url, headers: headers);
  if (response.statusCode == 200) {
    // Request was successful
    final result = jsonDecode(utf8.decode(response.bodyBytes)).cast<Map<String, dynamic>>();
    List<newlettone> list = result.map<newlettone>((json) {
      return newlettone.fromJson(json);
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

class newletterList{
  final String content;
  final String name;
  final int year;
  final int month;
  final int day;
  newletterList(this.content, this.name, this.year, this.month, this.day);
}

List<newletterList> convertToMyList(List<newlettone> newlettList) {
  List<newletterList> newlettersList = newlettList.map((newletter) {
    String content = newletter.content;
    String name = newletter.guestId.toString();
    DateTime createdTime = DateTime.parse(newletter.createdTime);
    int year = createdTime.year;
    int month = createdTime.month;
    int day = createdTime.day;
    return newletterList(content, name, year, month, day);
  }).toList();
  print("$newlettersList");
  return newlettersList;
}