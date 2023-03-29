import'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class diary extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // appBar에 AppBar 위젯을 가져온다.
      appBar: null,
      floatingActionButton: floatingButtons(),

      body: SafeArea(
        child: mydiary(),
      ), // 리스트 함수를 불러온다.
    );
  }

  Widget floatingButtons() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      visible: true,
      curve: Curves.bounceIn,
      backgroundColor: Colors.pink[200],
      children: [
        SpeedDialChild(
            child: const Icon(Icons.calendar_month, color: Colors.white),
            label: "캘린더",
            labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 13.0),
            backgroundColor: Colors.indigo.shade900,
            labelBackgroundColor: Colors.indigo.shade900,
            onTap: () {}),
        SpeedDialChild(
            child: const Icon(Icons.bed, color: Colors.white),
            label: "수면",
            labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 13.0),
            backgroundColor: Colors.indigo.shade900,
            labelBackgroundColor: Colors.indigo.shade900,
            onTap: () {}),
        SpeedDialChild(
          child: const Icon(
            Icons.run_circle_outlined,
            color: Colors.white,
          ),
          label: "러닝",
          backgroundColor: Colors.indigo.shade900,
          labelBackgroundColor: Colors.indigo.shade900,
          labelStyle: const TextStyle(
              fontWeight: FontWeight.w500, color: Colors.white, fontSize: 13.0),
          onTap: () {},
        ),
        SpeedDialChild(
          child: const Icon(
            Icons.add_chart_rounded,
            color: Colors.white,
          ),
          label: "나의 기록",
          backgroundColor: Colors.indigo.shade900,
          labelBackgroundColor: Colors.indigo.shade900,
          labelStyle: const TextStyle(
              fontWeight: FontWeight.w500, color: Colors.white, fontSize: 13.0),
          onTap: () {},
        )
      ],
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