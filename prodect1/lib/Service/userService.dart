import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

// 저장된 인증 토큰 및 리프레시 토큰을 가져오는 함수
Future<Map<String, String>> getTokens() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('accessToken');

  return {
    'accessToken': accessToken ?? '',
  };
}

Future<double> fetchDistance() async {
  Map<String, String> tokens = await getTokens();
  String token = tokens['accessToken']!;
  // String token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyNzkzMTI3MzkyIiwiZXhwIjoxNjg3NDA4NTAyfQ.yizKabrMGyUpxrRvxPnw11XZu6dlB9lterq-4SxC_spYBhW2P7wvFq73v6kCs6T4mbTAGVvyjNZBvGQvM7XzJQ';
  // String token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyNzk0MDk2NTI2IiwiZXhwIjoxNjg3MzExMTgyfQ.O2UIaz23NQqE_vZ4YYUdFgaF7e0PJg29PNKxKfqMbgvQzRlJiexeOV1D9-ojhp2LtdM3RUzycuCyj_FiS4D3Xw';

  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };
  var url = Uri.parse('http://3.39.126.140:8000/user-service/user');
  // var url = Uri.parse('http://3.39.126.140:8000/unauthorization/kakao-login');
  var response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    var responseBody = response.body;
    var decodedResponse = jsonDecode(responseBody);
    var distance = decodedResponse['distance'];
    return double.parse(distance.toString());
  } else {
    throw Exception('Failed to fetch distance');
  }
}


Future<Info> fetchInfo() async {
  Map<String, String> tokens = await getTokens();
  String token = tokens['accessToken']!;
  // String token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyNzkzMTI3MzkyIiwiZXhwIjoxNjg3NDA4NTAyfQ.yizKabrMGyUpxrRvxPnw11XZu6dlB9lterq-4SxC_spYBhW2P7wvFq73v6kCs6T4mbTAGVvyjNZBvGQvM7XzJQ';
  // String token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyNzk0MDk2NTI2IiwiZXhwIjoxNjg3MzExMTgyfQ.O2UIaz23NQqE_vZ4YYUdFgaF7e0PJg29PNKxKfqMbgvQzRlJiexeOV1D9-ojhp2LtdM3RUzycuCyj_FiS4D3Xw';

  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };
  var url = Uri.parse('http://3.39.126.140:8000/user-service/user');
  // var url = Uri.parse('http://3.39.126.140:8000/unauthorization/kakao-login');
  var response = await http.get(url, headers: headers);
  if (response.statusCode == 200) {
    // Request was successful
    var responseBody = response.body;
    // Parse the response body here
  } else {
    // Request failed
    print('Request failed with status: ${response.statusCode}');
  }

  var statusCode = response.statusCode;
  var responseHeaders = response.headers;
  var responseBody = response.body;
  print("statusCode: ${statusCode}");
  print("responseHeaders: ${responseHeaders}");
  print("responseBody: ${responseBody}");

  if (response.statusCode == 200) {
    //만약 서버가 ok응답을 반환하면, json을 파싱합니다
    print(utf8.decode(response.bodyBytes));
    logger.d(utf8.decode(response.bodyBytes));
    // return Info.fromJson(json.decode(response.body));
    return Info.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    //만약 응답이 ok가 아니면 에러를 던집니다.
    throw Exception('실패');
  }
}

class Info {
  final userId;
  final characterName;
  final characterUrl;
  final int experienceValue;
  final stateMsg;
  final thumbnailImageUrl;
  final sleepTime;
  final distance;
  final dday;

  Info(
      {required this.userId,
        required this.characterName,
        required this.characterUrl,
        required this.experienceValue,
        required this.stateMsg,
        required this.thumbnailImageUrl,
        required this.sleepTime,
        required this.distance,
        required this.dday});

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      userId: json["userId"],
      characterName: json["characterName"],
      characterUrl: json["characterUrl"],
      experienceValue: json["experienceValue"],
      stateMsg: json["stateMsg"],
      thumbnailImageUrl: json["thumbnailImageUrl"],
      sleepTime: json["sleepTime"],
      distance: json["distance"],
      dday: json["dday"],
    );
  }
}
