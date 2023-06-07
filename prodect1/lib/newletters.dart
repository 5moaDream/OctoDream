import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:prodect1/Datelist.dart';
import 'package:http/http.dart' as http;
import 'letterservice/newletterservice.dart';


class newletterlist extends StatefulWidget{
  _newletterlist createState() => _newletterlist();
}

class _newletterlist extends State<newletterlist> {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
        title: 'newletter',
        theme: ThemeData(primarySwatch: Colors.blue,),
        home: newletter()
    );
  }
}

class newletter extends StatefulWidget{
  @override
  State<newletter> createState()=>_newletter();
}

List<newletterList> list =[];

class _newletter extends State<newletter>{
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      List<newlettone> newdata = await fetchdata();
      setState(() {
        list = convertToMyList(newdata);
      });
    } catch (error) {
      print('Error: $error');
      // 에러 처리 로직 추가
    }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
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
                      Text('새로운 쪽지',style: TextStyle(fontSize: 25),),
                      IconButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => datelist()));
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 3,top: 7,bottom: 7),
                        child: Text('새로운 쪽지를 확인해보세요!'),
                      ),
                      newlett(context)],
                  )
              )
            ],
          ),
        )
    );
  }
  Widget newlett(BuildContext context) {
    if (list.isEmpty) {
      return Container(); // 또는 적절한 로딩 또는 에러 표시 위젯을 반환하세요.
    }
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
                        title: Text(item.name),
                        content: Container(
                          width: 300,
                          height: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.content),
                              SizedBox(height: 8),
                              Text('${item.year}-${item.month}-${item.day}'),
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
                child: Container(
                  height: 50,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(left: 5, right: 5, top: 7, bottom: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(70.0),
                    color: Colors.lightGreenAccent,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.star),
                      Text(item.content),
                      Text(item.name),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

}
