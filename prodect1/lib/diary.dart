import'package:flutter/material.dart';
import 'floatingbutton.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(top: 20, left: 30, bottom: 10),
          child: Text("일기",
            style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
            itemCount: mylist.length, //리스트 개수
            // itemBuilder 리스트에서 반복되는 Contaniner(항목) 형태
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Icon(Icons.hourglass_bottom,
                  color: Colors.blueGrey[200], size: 40,),
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
      ],
    );
  }
}