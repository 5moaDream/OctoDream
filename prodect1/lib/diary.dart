import 'dart:convert';

import'package:flutter/material.dart';
import 'floatingbutton.dart';
import 'package:http/http.dart' as http;

class Diary {
  final DateTime today;
  final String content;

  Diary({required this.today,required this.content});

  factory Diary.fromJson(Map<String, dynamic> json){
    return Diary(
      today: json["day"],
      content: json["content"],
    );
  }
}

Future<Diary> fetchDiary() async {
  http.Response response = await http.get(
    Uri.parse('http://3.39.126.140:8000/collection/diary/userId'));

  if (response.statusCode == 200) {
    // json 데이터를 수신해서 User 객체로 변환
    final diaryMap = json.decode(response.body);
    return Diary.fromJson(diaryMap);
  }

  throw Exception('데이터 수신 실패!');
}

class diary extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // appBar에 AppBar 위젯을 가져온다.
      appBar: null,
      floatingActionButton: floatingButton(),

      body: SafeArea(
        child: mydiary(),
      ), // 리스트 함수를 불러온다.
    );
  }
}

class mydiary extends StatefulWidget {
  @override
  _mydiary createState() => _mydiary(); // StatefulWidget은 상태를 생성하는 createState() 메서드로 구현한다.
}

class myList {
  String day;
  String text;
  myList(this.day, this.text,);
}

List<myList> mylist = <myList>[
  myList('5월 3일', '오늘의 일기'),
  myList('5월 2일', '오늘의 일기'),
  myList('5월 1일', '오늘의 일기'),
];

class _mydiary extends State<mydiary> {
  @override
  Widget build(BuildContext context) {
    // ListView.builder()에 구분선이 추가된 형태 => ListView.separated()
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.gif'),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
              future: fetchDiary(),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  final content = snapshot.data?.content;
                  return Text(content!);
                }
                return CircularProgressIndicator();
              }
          ),
          Container(
            padding: EdgeInsets.only(top: 20, left: 30, bottom: 10),
            child: Text("일기",
              style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold
              ),
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width*0.9,
              height: MediaQuery.of(context).size.height*0.85,
              color:Colors.white.withOpacity(0.82),
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(10, 12, 8, 8),
                itemCount: mylist.length, //리스트 개수
                // itemBuilder 리스트에서 반복되는 Contaniner(항목) 형태
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Icon(Icons.hourglass_bottom,
                      color: Colors.blueGrey, size: 40,),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(mylist[index].day,
                          style: TextStyle(
                            fontSize: 18,
                            // fontWeight: FontWeight.bold 폰트 굵기
                          ),),
                        Text(mylist[index].text,
                          style: TextStyle(
                            fontSize: 16,
                            // fontWeight: FontWeight.bold 폰트 굵기
                          ),),
                      ],
                    ),
                    onTap: (){},
                  ); },
                separatorBuilder: (BuildContext context, int index) => const Divider(
                  color: Colors.black12, // 리스트 구분선 색
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}