import 'dart:convert';
import 'package:http/http.dart' as http;

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

Future<List<SleepDTO>> fetchtodayrunning() async {
  String token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyNzk0MDk2NTI2IiwiZXhwIjoxNjg3MzExMTgyfQ.O2UIaz23NQqE_vZ4YYUdFgaF7e0PJg29PNKxKfqMbgvQzRlJiexeOV1D9-ojhp2LtdM3RUzycuCyj_FiS4D3Xw';
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  var url = Uri.parse('http://3.39.126.140:8000/activity-service/running/today');
  var response = await
  http.get
    (url, headers: headers);
  if (response.statusCode == 200) { // Request was successful
    final result = json.decode(response.body).cast<Map<String, dynamic>>();
    List<SleepDTO> list = result.map<SleepDTO>((json) {
      return SleepDTO.fromJson(json);
    }).toList();
    return list;
  }
  else { // Request failed
    print('Request failed with status: ${response.statusCode}');
    print(response.body);
  }

  throw Exception('Error: ${response.statusCode}');
}