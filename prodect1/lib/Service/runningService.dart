import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:async';

// access_token:"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyNzkzMTI3MzkyIiwiZXhwIjoxNjg0MzE0NTg2fQ.2z8DaPUKrZFF0GnsLOZcarn6fxjs3QLyVVRvt-ovTgcWCAj3PacZsMQc5e3c0vChaAi03tHobUL9lJUzTA_7_g"
// refresh_token:"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyNzkzMTI3MzkyIiwiZXhwIjoxNjg2OTAyOTg2fQ.3dE34IWPE58KXoJ-gF9cksm-DN8BL6TK-3fzpyJvbvCr79xYJuUs6ejMqLdWHHlxBtREOPRwhIvMYkxlK7o_1w"}
var logger = Logger(
  printer: PrettyPrinter(),
);


//잠잘래
Future<String> recodeSleep(int createTime, int totalRunning, double distance) async {

  String token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyNzkzMTI3MzkyIiwiZXhwIjoxNjg3NDA4NTAyfQ.yizKabrMGyUpxrRvxPnw11XZu6dlB9lterq-4SxC_spYBhW2P7wvFq73v6kCs6T4mbTAGVvyjNZBvGQvM7XzJQ';

  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  Map<String, dynamic> requestBody = {
    // "createdTime": "2023-05-17T13:50:01.531079",
    // "totalRunningTime": 18,
    // "distance": 2.2
    "createdTime": '${createTime}',
    "totalRunningTime": totalRunning,
    "distance": distance
  };

  String jsonBody = jsonEncode(requestBody);

  var url = Uri.parse('http://3.39.126.140:8000/activity-service/running');
  var response = await http.post(
    url,
    headers: headers,
    body: jsonBody,
  );

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
