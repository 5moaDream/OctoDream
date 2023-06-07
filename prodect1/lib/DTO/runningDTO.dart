import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RunningDTO {
  final int runningId;
  final int userId;
  final String createdTime;
  final int totalRunningTime;
  final double distance;

  RunningDTO({required this.runningId,required this.userId, required this.createdTime, required this.totalRunningTime,required this.distance});

  factory RunningDTO.fromJson(Map<String, dynamic> json){
    return RunningDTO(
        runningId: json["runningId"],
        userId: json["userId"],
        createdTime: json["createdTime"],
        totalRunningTime: json["totalRunningTime"],
        distance: json["distance"],
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

Future<List<RunningDTO>> fetchtodayrunning() async {
  Map<String, String> tokens = await getTokens();
  String token = tokens['accessToken']!;
  // String token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyNzkzMTI3MzkyIiwiZXhwIjoxNjg3NDA4NTAyfQ.yizKabrMGyUpxrRvxPnw11XZu6dlB9lterq-4SxC_spYBhW2P7wvFq73v6kCs6T4mbTAGVvyjNZBvGQvM7XzJQ';
  // String token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyNzk0MDk2NTI2IiwiZXhwIjoxNjg3MzExMTgyfQ.O2UIaz23NQqE_vZ4YYUdFgaF7e0PJg29PNKxKfqMbgvQzRlJiexeOV1D9-ojhp2LtdM3RUzycuCyj_FiS4D3Xw';
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  var url = Uri.parse('http://3.39.126.140:8000/activity-service/running/today');
  var response = await
  http.get
    (url, headers: headers);
  if (response.statusCode == 200) {// Request was successful
    List<RunningDTO> list = [];

    final result = json.decode(response.body).cast<Map<String, dynamic>>();
    list = result.map<RunningDTO>((json) {
      return RunningDTO.fromJson(json);
    }).toList();

    print(result);

    return list;
  }
  else { // Request failed
    print('Request failed with status: ${response.statusCode}');
    print(response.body);
  }

  throw Exception('Error: ${response.statusCode}');
}

Future<List<RunningDTO>> fetchweekrunning() async {
  Map<String, String> tokens = await getTokens();
  String token = tokens['accessToken']!;
  // String token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyNzk0MDk2NTI2IiwiZXhwIjoxNjg3MzExMTgyfQ.O2UIaz23NQqE_vZ4YYUdFgaF7e0PJg29PNKxKfqMbgvQzRlJiexeOV1D9-ojhp2LtdM3RUzycuCyj_FiS4D3Xw';
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  var url = Uri.parse('http://3.39.126.140:8000/activity-service/running/week');

  // 캐시를 저장할 변수
  List<RunningDTO>? cachedData;

  // 캐시된 데이터가 있는지 확인
  if (cachedData != null) {
    return cachedData;
  }

  var response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final result = json.decode(response.body).cast<Map<String, dynamic>>();
    List<RunningDTO> list = result.map<RunningDTO>((json) {
      return RunningDTO.fromJson(json);
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

Future<List<RunningDTO>> fetchmonthrunning() async {
  Map<String, String> tokens = await getTokens();
  String token = tokens['accessToken']!;
  // String token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyNzk0MDk2NTI2IiwiZXhwIjoxNjg3MzExMTgyfQ.O2UIaz23NQqE_vZ4YYUdFgaF7e0PJg29PNKxKfqMbgvQzRlJiexeOV1D9-ojhp2LtdM3RUzycuCyj_FiS4D3Xw';
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  var url = Uri.parse('http://3.39.126.140:8000/activity-service/running/all');

  // 캐시를 저장할 변수
  List<RunningDTO>? cachedData;

  // 캐시된 데이터가 있는지 확인
  if (cachedData != null) {
    return cachedData;
  }

  var response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final result = json.decode(response.body).cast<Map<String, dynamic>>();
    List<RunningDTO> list = result.map<RunningDTO>((json) {
      return RunningDTO.fromJson(json);
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
