import 'dart:async';

import 'package:flutter/material.dart';
import 'package:prodect1/Service/dictionaryService.dart';


class dictionary extends StatefulWidget{
  @override
  State<dictionary> createState()=>_dictionary();
}

List<Dictionary> dic = [];

class _dictionary extends State<dictionary>
{
  List myFriend = ['영주', '혜원', '찬영', '광휘', '지연', '은진'];

  final ScrollController scroll = ScrollController();

  @override
  void initState() {
    scroll.addListener(() {
      scrollListener();
    });
    super.initState();
  }

  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
  }

  scrollListener() async {
    if (scroll.offset == scroll.position.maxScrollExtent
        && !scroll.position.outOfRange) {
      print('스크롤이 맨 바닥에 위치해 있습니다');
      return Timer(Duration(seconds: 0), () {
        showDialog(
            context: context,
            barrierDismissible: true, //바깥영역 터치시 닫을지
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text("마지막 문어입니다.", textAlign: TextAlign.center,),
                backgroundColor: Colors.white,
              );
            });
        Timer(Duration(seconds: 1),(){
          Navigator.pop(context);
        });
      });
} else if (scroll.offset == scroll.position.minScrollExtent
        && !scroll.position.outOfRange) {
      print('스크롤이 맨 위에 위치해 있습니다');
    }
  }

  @override
  Widget build(BuildContext context){
    return AlertDialog(
        title: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FutureBuilder<List<Dictionary>>(
                future: fetchDictionary(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    dic = snapshot.data!;
                    return Text("hello");
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
              Text('문어 다이어리',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
              IconButton(onPressed: () {
                Navigator.of(context).pop();
              }, icon: Icon(Icons.cancel, color: Colors.white,))
            ],
          ),
        ),
        content: SizedBox(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.36,
          width: MediaQuery
              .of(context)
              .size
              .width * 0.84,
          child: Column(
            children: [
              Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.32,
                color: Colors.blueGrey[50],
                child: Scrollbar(
                  thickness: 4,
                  thumbVisibility: true,
                  controller: scroll,
                  child: GridView.builder(
                      controller: scroll,
                      scrollDirection: Axis.horizontal,
                      itemCount: myFriend.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: 7/4.5,
                        mainAxisSpacing: 2, //수평 Padding
                        crossAxisSpacing: 2,
                      ),
                      itemBuilder: (BuildContext context, int i) {//item 의 반목문 항목 형성
                        return Row(
                          children: [
                            Expanded(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceEvenly,
                                    children: [
                                      Text(myFriend[i].toString()),
                                      ColorFiltered(
                                        colorFilter: ColorFilter.mode(
                                            Colors.transparent, BlendMode.color),
                                        child: SizedBox(
                                          width: 200,
                                            child: Image.network(dic[0].characterImageUrl, width: 200, height: 100, fit: BoxFit.fill,))
                                      ),
                                      ElevatedButton(
                                          onPressed: () {},
                                          child: Text('문어교환'))
                                    ],
                                  ),
                                )),
                          ],);
                      }),
                ),
        ),
      ]
    ),
        ),
        backgroundColor: Colors.brown,
        shape: RoundedRectangleBorder(
          //다이얼로그 창 둥글게
          borderRadius:
          BorderRadius.all(Radius.circular(10)),
        )
    );
  }
}