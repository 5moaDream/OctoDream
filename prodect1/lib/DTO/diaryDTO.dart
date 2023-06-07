import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DiaryDTO {
  final int diaryId;
  final int userId;
  final String content;
  final String createdTime;

  DiaryDTO({required this.diaryId,required this.userId,required this.content, required this.createdTime});

  factory DiaryDTO.fromJson(Map<String, dynamic> json){
    return DiaryDTO(
      diaryId: json["diaryId"],
      userId: json["userId"],
      content: json["content"],
      createdTime: json["createdTime"],
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

Future<List<DiaryDTO>> fetchtodaydiary() async {
  Map<String, String> tokens = await getTokens();
  String token = tokens['accessToken']!;
  // String token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyNzk0MDk2NTI2IiwiZXhwIjoxNjg3MzExMTgyfQ.O2UIaz23NQqE_vZ4YYUdFgaF7e0PJg29PNKxKfqMbgvQzRlJiexeOV1D9-ojhp2LtdM3RUzycuCyj_FiS4D3Xw';
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  var url = Uri.parse('http://3.39.126.140:8000/activity-service/diary');
  var response = await
  http.get
    (url, headers: headers);
  if (response.statusCode == 200) { // Request was successful
    final result = json.decode(utf8.decode(response.bodyBytes)).cast<Map<String, dynamic>>();
    List<DiaryDTO> list = result.map<DiaryDTO>((json) {
      return DiaryDTO.fromJson(json);
    }).toList();
    print(list);

    return list;
  }
  else { // Request failed
    print('Request failed with status: ${response.statusCode}');
    print(response.body);
  }

  throw Exception('Error: ${response.statusCode}');
}

class myList {
  final String day;
  final String text;

  myList(this.day, this.text);
}

List<myList> convertToMyList(List<DiaryDTO> diaryList) {
  List<myList> mylist = diaryList.map((diary) {
    DateTime date = DateTime.parse(diary.createdTime);
    String day = '${date.year}-${date.month}-${date.day+1}';
    String text = diary.content.replaceAll('"', '');
    return myList(day, text);
  }).toList();

  print("두근두근 ${mylist}");
  return mylist;
}
