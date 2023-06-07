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

  Widget images(int id, String url){
    if(id==100) {
      return Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        height: 120,
        child: Image.asset(url, color: Colors.black38.withOpacity(0.6),),
      );
      } else {
      return Image.network(url, fit: BoxFit.cover,height: 125,);
    }
  }

  Widget button(int id, String url){
    if(id==100) {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black87,
            // 텍스트 색상
            backgroundColor: Colors.brown[200],
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  10), // 버튼의 모서리를 둥글게 조절
            ),
          ),
          onPressed: () {
            null;
          },
          child: Text('문어교환'));
    } else {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black87,
            // 텍스트 색상
            backgroundColor: Colors.brown[200],
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  10), // 버튼의 모서리를 둥글게 조절
            ),
          ),
          onPressed: () {
            // updateUserOcto(url);
            // MyHomePage.
          },
          child: Text('문어교환'));
    }
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
    return FutureBuilder<List<Dictionary>>(
      future: fetchDictionary(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          int j = 0;
          dic=[];
          for (int i = 0; i < 7; i++) {
            if (j < snapshot.data!.length) {
              int id = snapshot.data![j].characterId;
              String name = snapshot.data![j].characterName;
              String octo = snapshot.data![j].characterImageUrl;
              dic.add(Dictionary(characterId: id, characterName: name, characterImageUrl: octo));
              j++;
            }
            else {
              dic.add(Dictionary(characterId: 100, characterName: "??문어", characterImageUrl: 'assets/images/question.png'));
            }
          }
          return dicHome();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget dicHome(){
    return AlertDialog(
        title: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), // 테두리를 둥글게 설정
                    color: Colors.blueGrey[50],
                  ),
                  child: Scrollbar(
                    thickness: 4,
                    thumbVisibility: true,
                    controller: scroll,
                    child: GridView.builder(
                        controller: scroll,
                        scrollDirection: Axis.horizontal,
                        itemCount: dic.length,
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
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(dic[i].characterName,
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                        ColorFiltered(
                                            colorFilter: ColorFilter.mode(
                                                Colors.transparent, BlendMode.color),
                                            child: images(dic[i].characterId, dic[i].characterImageUrl),
                                            ),
                                button(dic[i].characterId, dic[i].characterImageUrl),
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