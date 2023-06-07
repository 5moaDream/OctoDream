import 'dart:ffi';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'friend_home.dart';
import 'Datelist.dart';
import 'package:prodect1/Service/friendService.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

class Friends extends StatefulWidget {
  @override
  _Friends createState() =>
      _Friends(); // StatefulWidget은 상태를 생성하는 createState() 메서드로 구현한다.
}

class _Friends extends State<Friends> {
  Future<List<Friend>>? friend;

  @override
  void initState() {
    super.initState();
    friend = fetchFriend();
  }

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
              child: Text(
                "문어 친구",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
                      child: Image.asset('assets/images/left.png',
                          height: 55, color: Colors.black38.withOpacity(0.2)),
                    ),
                  ),
                  FutureBuilder<List<Friend>>(
                    future: friend,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // Show a loading indicator while fetching the friend list
                      } else if (snapshot.hasError) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(width: 80),
                            Center(
                              child: Text(
                                '조회된 친구가\n'
                                '-- 없습니닷 0 ^ 0',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                    fontFamily: 'Neo'),
                              ),
                            ), // Show an error message if fetching fails
                          ],
                        );
                      } else if (snapshot.hasData) {
                        final friendList = snapshot
                            .data!; // Access the friend list from the snapshot

                        logger.d("왜 안되냐고 ff ${friendList[1].characterName}");
                        return Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: GridView.builder(
                                itemCount: friendList.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  childAspectRatio: 2 / 1,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                ),
                                itemBuilder: (BuildContext context, int i) {
                                  return buildFriendItem(friendList, i);
                                },
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                            ),
                          ],
                        );
                      } else {
                        return Container(); // Return an empty container if no data is available
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength) + "\n" + text.substring(maxLength, text.length);
    }
  }

  Widget buildFriendItem(List<Friend> friend, int index) {
    String originalText = friend[index].nickName; // friend 리스트에서 index에 해당하는 닉네임 값 가져오기
    String modifiedText = truncateText(originalText, 8);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              // 친구 닉네임
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                modifiedText,
                style: TextStyle(fontSize: 18),
              ),
            ),
            CircleAvatar(
              radius: 50, // 반지름 크기를 조정하여 원의 크기를 설정합니다.
              backgroundImage: NetworkImage(friend[index].thumbnailImageUrl),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              // 친구 문어 닉네임
              padding: EdgeInsets.only(bottom: 4),
              child: Text(
                friend[index].characterName,
                style: TextStyle(fontSize: 20),
              ),
            ),
            InkWell(
              // 친구 문어 이미지
              onTap: () {
                final int? Id = friend[index].id; // 임의 지정 추후 변경
                final String characterName = friend[index].characterName;
                final String stateMsg = friend[index].statusMSG;
                final String characterImage =
                    friend[index].characterImage;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FriendHome(
                          id: Id,
                          characterName: characterName,
                          stateMsg: stateMsg,
                          characterImage: characterImage)),
                );
              },

              child: Image.network(
                friend[index].characterImage,
                width: 130,
                height: 120,
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
