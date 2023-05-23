import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

// access_token:"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyNzkzMTI3MzkyIiwiZXhwIjoxNjg3MzQwNzEwfQ.-FOiDGLxthSSoUc7kA15_s5jzm9r5u6wXskU6rWNLwla3PmoOuqG_UzAT-wS_VYgYo8A-ji7L08gAOvItj4tyw"
// refresh_token:"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyNzkzMTI3MzkyIiwiZXhwIjoxNjg3MzQwNzEwfQ.-FOiDGLxthSSoUc7kA15_s5jzm9r5u6wXskU6rWNLwla3PmoOuqG_UzAT-wS_VYgYo8A-ji7L08gAOvItj4tyw"}
var logger = Logger(
  printer: PrettyPrinter(),
);


Future<Info> fetchInfo() async {

  String token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyNzkzMTI3MzkyIiwiZXhwIjoxNjg3MzQwNzEwfQ.-FOiDGLxthSSoUc7kA15_s5jzm9r5u6wXskU6rWNLwla3PmoOuqG_UzAT-wS_VYgYo8A-ji7L08gAOvItj4tyw';

  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  var url = Uri.parse('http://3.39.126.140:8000/user-service/user');
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
