import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart'
    as kakao_flutter_sdk_talk;
import 'friend_home.dart';
import 'Datelist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Friends extends StatefulWidget {
  @override
  _Friends createState() =>
      _Friends(); // StatefulWidget은 상태를 생성하는 createState() 메서드로 구현한다.
}

// 저장된 인증 토큰 및 리프레시 토큰을 가져오는 함수
Future<Map<String, String>> getTokens() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('accessToken');
  String? refreshToken = prefs.getString('refreshToken');
  String? kakao = prefs.getString('kakao');

  return {
    'accessToken': accessToken ?? '',
    'refreshToken': refreshToken ?? '',
    'kakao': kakao ?? '',
  };
}

Future<void> KakaoFriend() async {
  Map<String, String> tokens = await getTokens();
  String accessToken = tokens['accessToken']!;
  String kakao = tokens['kakao']!;

  String apiUrl =
      'http://3.39.126.140:8000/user-service/kakao-friends/$kakao?offset=0'; // 호출할 API의 엔드포인트 URL

  Map<String, String> headers = {
    'Authorization': 'Bearer $accessToken', // 액세스 토큰을 Authorization 헤더에 포함시킴
    'Content-Type': 'application/json;charset=UTF-8',
  };
  try {
    http.Response response =
        await http.get(Uri.parse(apiUrl), headers: headers);
    if (response.statusCode == 200) {
      print('친구 호출 성공: ${response.statusCode}');
    } else {
      // API 호출 실패
      print('친구 호출 실패: ${response.statusCode}');
    }
  } catch (e) {
    // 예외 처리
    print('친구 호출 중 예외 발생: $e');
  }
}

class _Friends extends State<Friends> {
  List myFriend = ['영주', '혜원', '찬영', '광휘', '지연', '은진'];
  List OctoFriend = ['달밤영', '감자 러버', '어쩌라고', '평화주의자', '뷁뚫꺕ㅎ', '분위기메이커'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.gif'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Container(
                  margin: EdgeInsets.fromLTRB(30, 30, 0, 0),
                  child: Text("문어 친구(${myFriend.length})",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        KakaoFriend();
                      },
                      child: Image.asset('assets/images/friend.png', height: 40),
                    ),
                    SizedBox(width: 30,),
                  ],
                ),

              Expanded(
                  child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Datelist()),
                        );
                      },
                      child: Image.asset('assets/images/left.png', height: 55),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: GridView.builder(
                        itemCount: myFriend.length, // 아이템 개수
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1, // 가로 방향 아이템 수
                          childAspectRatio: 2 / 1, // 아이템 가로 세로 비율
                          mainAxisSpacing: 10, // 세로 방향 간격
                          crossAxisSpacing: 10, // 가로 방향 간격
                        ),
                        itemBuilder: (BuildContext context, int i) {
                          //item 의 반목문 항목 형성
                          return buildFriendItem(i);
                        }),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                  ),
                ],
              ))
            ],
          )),
    );
  }

  Widget buildFriendItem(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Text(
                myFriend[index].toString(),
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black12,
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Text(
                OctoFriend[index].toString(),
                style: TextStyle(fontSize: 20),
              ),
            ),
            InkWell(
              onTap: () {
                String ID = myFriend[index].toString(); // 임의 지정 추후 변경
                String Octoname = OctoFriend[index].toString();
                String imageName = 'first_octo.gif';
                // 페이지 변경 로직을 작성합니다.
                // 예를 들어, 다른 페이지로 이동하는 코드를 작성할 수 있습니다.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FriendHome(
                          ID: ID, Octoname: Octoname, imageName: imageName)),
                );
              },
              child: Image.asset(
                'assets/images/first_octo.gif',
                width: 100,
                height: 100,
              ),
            ),
            Expanded(
              child: Container(
                width: 100,
                height: 20,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.1),
                      BlendMode.modulate,
                    ),
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/shadow.png'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
