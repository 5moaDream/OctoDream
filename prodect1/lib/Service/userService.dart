import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);


Future<Info> fetchInfo() async {
  // final queryParameters = {
  //   'userId': 2713582482,
  // };
  // var url = Uri.http('http://3.39.126.140:8000', '/user', queryParameters);
  var url = 'http://3.39.126.140:8000/user?userId=2713582482';
  // var url = 'http://3.39.126.140/?urls.primaryName=user-service#/user?userId=2713582482';
  final response = await http.get(Uri.parse(url));
  // final response = await http.get(url);

  var statusCode = response.statusCode;
  var responseHeaders = response.headers;
  var responseBody = response.body;
  print("statusCode: ${statusCode}");
  print("responseHeaders: ${responseHeaders}");
  print("responseBody: ${responseBody}");

  if (response.statusCode == 200) {
    //만약 서버가 ok응답을 반환하면, json을 파싱합니다
    print('응답했다');
    print(json.decode(response.body));
    logger.d(json.decode(response.body));
    return Info.fromJson(json.decode(response.body));
  } else {
    //만약 응답이 ok가 아니면 에러를 던집니다.
    throw Exception('실패');
  }
}

class Info {
  final userId;
  final characterName;
  final characterUrl;
  final experienceValue;
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


// class userService {
//   // RequestPayment requestPayment = new RequestPayment();
//   //Payment payment = new Payment();
//
//   //final String userUrl = 'http://3.39.126.140:8000/user';
//   final String userUrl = 'http://192.168.0.34:8080/user';
//   // final String cancelUrl = 'http://192.168.0.34:8080/cancel'; // 결제 취소 API 요청 URL
//   // final String completionUrl = 'http://192.168.0.34:8080/completion'; // 결제 완료 API 요청 URL
//
//   //유저 정보 조회
//   Future<String?> userInfo() async {
//     try {
//       final response = await http.post(Uri.parse(userUrl));
//       final responseData = json.decode(response.body); //응답 결과 json으로 파싱
//       final responseD = responseData['response'];
//       final userId = responseD['userId'];
//       final characterName = responseD['characterName'];
//       final characterUrl = responseD['characterUrl'];
//       final experienceValue = responseD['experienceValue'];
//       final stateMsg = responseD['stateMsg'];
//       final thumbnailImageUrl = responseD['thumbnailImageUrl'];
//       final sleepTime = responseD['sleepTime'];
//       final distance = responseD['distance'];
//       final dday = responseD['dday'];
//       return '$userId|$characterName|$characterUrl|$experienceValue|$stateMsg'
//           '|$thumbnailImageUrl|$sleepTime|$distance|$dday'; //문자열로 반환
//     } catch (error) { //예외발생
//       print('error: $error');
//       return null;
//     }
//   }
// }
//
// class User {
//   final userService _service = userService();
//   late String userId = '';
//   late String characterName = '';
//   late String characterUrl = '';
//   late String experienceValue = '';
//   late String stateMsg = '';
//   late String thumbnailImageUrl = '';
//   late String sleepTime = '';
//   late String distance = '';
//   late String dday = '';
//
//   //유저 정보 조회
//   Future<void> userInfo() async {
//     final data = await _service.userInfo();
//     logger.d(data);
//     if (data != null) {
//       final splitData = data.split('|');
//       userId = splitData[0];
//       characterName = splitData[1];
//       characterUrl = splitData[2];
//       experienceValue = splitData[3];
//       stateMsg = splitData[4];
//       thumbnailImageUrl = splitData[5];
//       sleepTime = splitData[6];
//       distance = splitData[7];
//       dday = splitData[8];
//     }
//   }
//
// }