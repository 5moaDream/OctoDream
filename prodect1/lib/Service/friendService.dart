import 'dart:convert';
import 'dart:ffi';
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
  String? kakaoToken = prefs.getString('kakaoToken');

  return {
    'accessToken': accessToken ?? '',
    'kakaoToken': kakaoToken ?? '',
  };
}

// 카카오 친구 불러오기
Future<List<Friend>> fetchFriend() async {
  Map<String, String> tokens = await getTokens();
  String accessToken = tokens['accessToken']!;
  String kakaoToken = tokens['kakaoToken']!;

  Map<String, String> headers = {
    'Authorization': 'Bearer $accessToken', // 액세스 토큰을 Authorization 헤더에 포함시킴
    'Content-Type': 'application/json;charset=UTF-8',
  };

  var url = Uri.parse(
      'http://3.39.126.140:8000/user-service/kakao-friends/$kakaoToken?offset=0');
  var response = await http.get(url, headers: headers);
  logger.d("왜 안되냐고 ${response.statusCode}");
  if (response.statusCode == 200) {
    logger.d("왜 안되냐고 ${response.statusCode}");
    final result = json
        .decode(utf8.decode(response.bodyBytes))
        .cast<Map<String, dynamic>>();
    List<Friend> friend = result.map<Friend>((json) {
      return Friend.fromJson(json);
    }).toList();
    logger.d("왜 안되냐고 ${response.statusCode}");

    return friend;
  } else {
    //만약 응답이 ok가 아니면 에러를 던집니다.
    throw Exception('실패');
  }
}

class Friend {
  final Long Id; // 친구 아이디
  final String nickName; // 친구 문어 닉네임
  final String characterImageUrl; // 친구 문어 이미지
  final String thumbnailImageUrl; // 친구 프로필 사진

  Friend({
    required this.Id,
    required this.nickName,
    required this.characterImageUrl,
    required this.thumbnailImageUrl,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      Id: json["Id"],
      nickName: json["nickName"],
      characterImageUrl: json["characterImageUrl"],
      thumbnailImageUrl: json["thumbnailImageUrl"],
    );
  }
}
