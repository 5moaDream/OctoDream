import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SleepDTO {
  final int? sleepTime;
  final int? userId;
  final String? sleptTime;
  final String? wakeUpTime;
  final int? totalSleepTime;

  SleepDTO({required this.sleepTime, required this.userId, required this.sleptTime, required this.wakeUpTime, required this.totalSleepTime});

  factory SleepDTO.fromJson(Map<String, dynamic> json){
    return SleepDTO(
      sleepTime: json["sleepTime"],
      userId: json["userId"],
      sleptTime: json["sleptTime"],
      wakeUpTime: json["wakeUpTime"],
      totalSleepTime: json["totalSleepTime"],
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

Future<SleepDTO> fetchtodaysleep() async {
  try {
    Map<String, String> tokens = await getTokens();
    String token = tokens['accessToken']!;
    // String token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyNzk0MDk2NTI2IiwiZXhwIjoxNjg3MzExMTgyfQ.O2UIaz23NQqE_vZ4YYUdFgaF7e0PJg29PNKxKfqMbgvQzRlJiexeOV1D9-ojhp2LtdM3RUzycuCyj_FiS4D3Xw';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var url = Uri.parse('http://3.39.126.140:8000/activity-service/sleep/today');
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) { // Request was successful
      if (response.body.isEmpty) {
        return SleepDTO(
          sleepTime: 0,
          userId: 0,
          sleptTime: '',
          wakeUpTime: '',
          totalSleepTime: 0,
        );
      }

      final result = json.decode(response.body);
      return SleepDTO.fromJson(result);

    } else { // Request failed
      print('Request failed with status: ${response.statusCode}');
      print(response.body);
    }
  } catch (e) {
    print('Exception occurred: $e');
  }

  throw Exception('An error occurred while fetching sleep data');
}


Future<List<SleepDTO>> fetchweeksleep() async {
  Map<String, String> tokens = await getTokens();
  String token = tokens['accessToken']!;
  // String token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyNzk0MDk2NTI2IiwiZXhwIjoxNjg3MzExMTgyfQ.O2UIaz23NQqE_vZ4YYUdFgaF7e0PJg29PNKxKfqMbgvQzRlJiexeOV1D9-ojhp2LtdM3RUzycuCyj_FiS4D3Xw';
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  var url = Uri.parse('http://3.39.126.140:8000/activity-service/sleep/week');

  var response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final result = json.decode(response.body).cast<Map<String, dynamic>>();
    List<SleepDTO> list = result.map<SleepDTO>((json) {
      return SleepDTO.fromJson(json);
    }).toList();

    return list;
  } else {
    print('Request failed with status: ${response.statusCode}');
    print(response.body);
    throw Exception('Error: ${response.statusCode}');
  }
}

Future<List<SleepDTO>> fetchmonthsleep() async {
  Map<String, String> tokens = await getTokens();
  String token = tokens['accessToken']!;
  // String token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyNzk0MDk2NTI2IiwiZXhwIjoxNjg3MzExMTgyfQ.O2UIaz23NQqE_vZ4YYUdFgaF7e0PJg29PNKxKfqMbgvQzRlJiexeOV1D9-ojhp2LtdM3RUzycuCyj_FiS4D3Xw';
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  var url = Uri.parse('http://3.39.126.140:8000/activity-service/sleep/all');

  // 캐시를 저장할 변수
  List<SleepDTO>? cachedData;

  // 캐시된 데이터가 있는지 확인
  if (cachedData != null) {
    return cachedData;
  }

  var response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final result = json.decode(response.body).cast<Map<String, dynamic>>();
    List<SleepDTO> list = result.map<SleepDTO>((json) {
      return SleepDTO.fromJson(json);
    }).toList();

    // 데이터를 캐시에 저장
    cachedData = list;

    return list;
  } else {
    print('Request failed with status: ${response.statusCode}');
    print(response.body);
    throw Exception('Error: ${response.statusCode}');
  }
}
