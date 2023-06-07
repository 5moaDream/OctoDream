import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prodect1/Datelist.dart';
import 'package:http/http.dart' as http;
import 'package:prodect1/runningsetting.dart';

import 'letterservice/letterservice.dart';



class letters extends StatefulWidget{
  _letters createState() => _letters();
}

class _letters extends State<letters> {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
        title: 'letterlist',
        theme: ThemeData(primarySwatch: Colors.blue,),
        home: letterlist()
    );
  }
}

class letterlist extends StatefulWidget{
  @override
  State<letterlist> createState()=>_letterlist();
}

List<letterList> list=[];

class _letterlist extends State<letterlist>{
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      List<lettone> data = await fetchdata();
      setState(() {
        list = convertToMyList(data);
      });
    } catch (error) {
      print('Error: $error');
      // 에러 처리 로직 추가
    }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      //배경은 이미지로
      // backgroundColor: Colors.lightBlueAccent,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.gif'),
              fit: BoxFit.fill,),)
          ,padding: EdgeInsets.only(top: 50,left: 30,right: 30,bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.only(top: 5,bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('방명록',style: TextStyle(fontSize: 25),),
                      IconButton(
                          onPressed: () {
                            Navigator.push(context,MaterialPageRoute(builder: (context) => Datelist()));
                          },
                          icon: Icon(Icons.close)
                      )
                    ],
                  )
              ),
              Container(
                  color: Colors.white.withOpacity(0.8),
                  margin: EdgeInsets.only(top: 10,left: 10,right: 10),
                  padding: EdgeInsets.all(6),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Column(
                            children: [
                              lett(context)
                            ],
                          ),

                        ],
                    ),
                  )
              )
            ],
          ),
        )
    );
  }
  Widget lett(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(5),
        width: 400,
        height: 450,
        child: Column(
          children: [
            for (var item in list)
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('새로운 메시지'),
                        content:
                            Container(
                              width: 300,
                              height: 300,
                              child: Column(
                                children: [
                                  Text(item.content),
                                  SizedBox(height: 8),
                                  Text('${item.year}년 ${item.month}월 ${item.day}일'),
                                ],
                              ),
                            ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      padding: EdgeInsets.all(10),
                      margin:
                      EdgeInsets.only(left: 5, right: 5, top: 7, bottom: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(70.0),
                        color: Colors.lightGreenAccent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.content),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

