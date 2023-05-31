import 'dart:ffi';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'friend_home.dart';
import 'Datelist.dart';
import 'package:prodect1/Service/friendService.dart';

class Friends extends StatefulWidget {
  @override
  _Friends createState() =>
      _Friends(); // StatefulWidget은 상태를 생성하는 createState() 메서드로 구현한다.
}

class _Friends extends State<Friends> {
  Future<List<Friend>>? friend;
  List myFriend = ['영주', '혜원', '찬영', '광휘', '지연', '은진'];
  List OctoFriend = ['달밤영', '감자 러버', '어쩌라고', '평화주의자', '뷁뚫꺕ㅎ', '분위기메이커'];

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
                "문어 친구(${myFriend.length})",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Friend>>(
                future: friend,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Show a loading indicator while fetching the friend list
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '조회된 친구가 --\n'
                            '-- 없습니닷 0 ^ 0',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                            fontFamily: 'Neo'),
                      ),
                    );// Show an error message if fetching fails
                  } else if (snapshot.hasData) {
                    final friendList = snapshot.data!; // Access the friend list from the snapshot

                    return Row(
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
                            itemCount: friendList.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
            ),
          ],
        ),
      ),
    );
  }


  Widget buildFriendItem(List<Friend> friend, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Image.network(
              friend[index].thumbnailImageUrl,
              width: 100,
              height: 100,
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding( // 친구 문어 닉네임
              padding: EdgeInsets.only(bottom: 4),
              child: Text(
                friend[index].nickName,
                style: TextStyle(fontSize: 20),
              ),
            ),
            InkWell( // 친구 문어 이미지
              onTap: () {
                final Long Id = friend[index].Id; // 임의 지정 추후 변경
                final String nickName = friend[index].nickName;
                final characterImageUrl = friend[index].characterImageUrl;
                // 페이지 변경 로직을 작성합니다.
                // 예를 들어, 다른 페이지로 이동하는 코드를 작성할 수 있습니다.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FriendHome(
                          Id: Id, nickName: nickName, characterImageUrl: characterImageUrl)),
                );
              },
              child: Image.network(
                friend[index].characterImageUrl,
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
