import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

// access_token:"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyNzkzMTI3MzkyIiwiZXhwIjoxNjg0MzE0NTg2fQ.2z8DaPUKrZFF0GnsLOZcarn6fxjs3QLyVVRvt-ovTgcWCAj3PacZsMQc5e3c0vChaAi03tHobUL9lJUzTA_7_g"
// refresh_token:"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyNzkzMTI3MzkyIiwiZXhwIjoxNjg2OTAyOTg2fQ.3dE34IWPE58KXoJ-gF9cksm-DN8BL6TK-3fzpyJvbvCr79xYJuUs6ejMqLdWHHlxBtREOPRwhIvMYkxlK7o_1w"}
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

//상태메시지 변경
Future<String> updateStateMSG(String stateMSG) async {
  Map<String, String> tokens = await getTokens();
  String token = tokens['accessToken']!;
  // String token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyNzkzMTI3MzkyIiwiZXhwIjoxNjg3NDA4NTAyfQ.yizKabrMGyUpxrRvxPnw11XZu6dlB9lterq-4SxC_spYBhW2P7wvFq73v6kCs6T4mbTAGVvyjNZBvGQvM7XzJQ';

  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  var url = Uri.parse('http://3.39.126.140:8000/user-service/msg/${stateMSG}');
  var response = await http.put(url, headers: headers);
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
    return utf8.decode(response.bodyBytes);
    //return Info.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    //만약 응답이 ok가 아니면 에러를 던집니다.
    throw Exception('실패');
  }
}

//수면시간,러닝 설정
Future<String> updateTarget(int sleepTime, double distance) async {
  Map<String, String> tokens = await getTokens();
  String token = tokens['accessToken']!;
  // String token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyNzkzMTI3MzkyIiwiZXhwIjoxNjg2OTAyOTg2fQ.3dE34IWPE58KXoJ-gF9cksm-DN8BL6TK-3fzpyJvbvCr79xYJuUs6ejMqLdWHHlxBtREOPRwhIvMYkxlK7o_1w';

  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  var url = Uri.parse('http://3.39.126.140:8000/user-service/target/sleep/${sleepTime}/distance/${distance}');
  var response = await http.put(url, headers: headers);
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
    return utf8.decode(response.bodyBytes);
    //return Info.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    //만약 응답이 ok가 아니면 에러를 던집니다.
    throw Exception('실패');
  }
}