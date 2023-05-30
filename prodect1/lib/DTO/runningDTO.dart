import 'dart:convert';
import 'package:http/http.dart' as http;

class RunningDTO {
  int? runningId;
  int? userId;
  String? createdTime;
  int? totalRunningTime;
  double? distnace;

  RunningDTO({required this.runningId,required this.userId, required this.createdTime, required this.totalRunningTime,required this.distnace});

  factory RunningDTO.fromJson(Map<String, dynamic> json){
    return RunningDTO(
        runningId: json["runningId"],
        userId: json["userId"],
        createdTime: json["createdTime"],
        totalRunningTime: json["totalRunningTime"],
        distnace: json["distance"],
    );
  }
}

Future<List<RunningDTO>> fetchtodayrunning() async {
  String token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyNzkzMTI3MzkyIiwiZXhwIjoxNjg3NDA4NTAyfQ.yizKabrMGyUpxrRvxPnw11XZu6dlB9lterq-4SxC_spYBhW2P7wvFq73v6kCs6T4mbTAGVvyjNZBvGQvM7XzJQ';
  // String token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyNzk0MDk2NTI2IiwiZXhwIjoxNjg3MzExMTgyfQ.O2UIaz23NQqE_vZ4YYUdFgaF7e0PJg29PNKxKfqMbgvQzRlJiexeOV1D9-ojhp2LtdM3RUzycuCyj_FiS4D3Xw';
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
    List<RunningDTO> list = result.map<RunningDTO>((json) {
      return RunningDTO.fromJson(json);
    }).toList();
    return list;
  }
  else { // Request failed
    print('Request failed with status: ${response.statusCode}');
    print(response.body);
  }

  throw Exception('Error: ${response.statusCode}');
}

Future<List<RunningDTO>> fetchweekrunning() async {
  String token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyNzk0MDk2NTI2IiwiZXhwIjoxNjg3MzExMTgyfQ.O2UIaz23NQqE_vZ4YYUdFgaF7e0PJg29PNKxKfqMbgvQzRlJiexeOV1D9-ojhp2LtdM3RUzycuCyj_FiS4D3Xw';
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  var url = Uri.parse('http://3.39.126.140:8000/activity-service/running/week');
  var response = await
  http.get
    (url, headers: headers);
  if (response.statusCode == 200) { // Request was successful
    final result = json.decode(response.body).cast<Map<String, dynamic>>();
    List<RunningDTO> list = result.map<RunningDTO>((json) {
      return RunningDTO.fromJson(json);
    }).toList();

    for(int i = 0; i<list.length; i++)
      print(list[i].createdTime);
    return list;
  }
  else { // Request failed
    print('Request failed with status: ${response.statusCode}');
    print(response.body);
  }

  throw Exception('Error: ${response.statusCode}');
}

