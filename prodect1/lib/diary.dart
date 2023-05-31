import'package:flutter/material.dart';
import 'DTO/diaryDTO.dart';
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

List<myList> list = [];

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
      child: FutureBuilder<List<DiaryDTO>>(
          future: fetchtodaydiary(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // Data has been successfully fetched
              list = convertToMyList(snapshot.data!);
              print("${list[0].day}, ${list[0].text}");
              print("${list[1].day}, ${list[1].text}");
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                      height: MediaQuery.of(context).size.height*0.82,
                      width: MediaQuery.of(context).size.width*0.9,
                      color: Colors.white.withOpacity(0.6),
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                        itemCount: list.length, //리스트 개수
                        // itemBuilder 리스트에서 반복되는 Contaniner(항목) 형태
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: Icon(Icons.hourglass_bottom,
                              color: Color(0xff0f2f4f), size: 40,),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(list[index].day,
                                  style: TextStyle(
                                    fontSize: 18,
                                    // fontWeight: FontWeight.bold 폰트 굵기
                                  ),),
                                Text(list[index].text,
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
              );
            }
            else if (snapshot.hasError) {
              // Error occurred while fetching data
              print(snapshot.error);
              return Text('Error: ${snapshot.error}');
            }
            return CircularProgressIndicator();
          }),
    );
  }
}