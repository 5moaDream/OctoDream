import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext) {
    return MaterialApp(
      title: 'Flutter demo',
        theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}


class MyHomePage extends StatelessWidget {
  final String title;

  var timeinput;

  MyHomePage({required this.title});


  bool light = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          this.title,
        ),
      ),
      body:

      Column(
        children:
        <Widget>[
          Text('생태 메시지', style: TextStyle(fontSize: 25)),
         const SizedBox(width: 200, child: TextField(decoration: InputDecoration(labelText: '', border: OutlineInputBorder(),),),),

          Container(child: ElevatedButton(onPressed: () {}, child: Text('확인'),),),



          Row(
            children:[
              Text('수면 알람 설정',
          style: TextStyle(fontSize: 25),),

      Switch(
        value: light,
        activeColor: Colors.green,
        onChanged: (bool value) {

          setState(() {
            light = value;
          });
        },
      ),
      ],
          ),

          Row(
            children:[
          Text('알림 설정',
            style: TextStyle(fontSize: 25),),
          Switch(
            onChanged: (bool value) {},
            value: true,
            activeColor: Colors.green,
          ),
          ],
          ),
          Row(
            children:[
          Text('수면 시간',
            style: TextStyle(fontSize: 25),),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  showAlertDialog(context); {
                    var decrease;
                    AlertDialog alert = AlertDialog(content: Container(
                      padding: EdgeInsets.all(50.0),
                      margin: EdgeInsets.all(50.0),
                      color: Colors.white,
                      width: 800,
                      height: 800,
                      child: TextField(
                        controller: timeinput,
                        decoration: InputDecoration(
                          icon: Icon(Icons.settings),
                          labelText: " "
                        ),
                        readOnly: true,
                        onTap: () async {
                          TimeOfDay? pickedTime =  await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          );


                        },

                      ),
                    ),
                    );

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    );
                  }
                },
              ),



            ],
          ),
          Row(
            children:[
          Text('러닝 거리',
            style: TextStyle(fontSize: 25),),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  showAlertDialog(context); {
                    var decrease;
                    AlertDialog alert = AlertDialog(content: Container(
                      padding: EdgeInsets.all(50.0),
                      margin: EdgeInsets.all(50.0),
                      color: Colors.grey,
                      width: 800,
                      height: 800,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(width:300,
                            child: TextField(decoration: InputDecoration(

                              labelText: '',
                            border:
                            OutlineInputBorder(),
                          ),
                          ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              ElevatedButton(onPressed: () {}, child: Text('취소', style: TextStyle(color: Colors.white),)),
                              ElevatedButton(onPressed: () {}, child: Text('확인', style: TextStyle(color: Colors.white),)),

                            ],
                          )


                        ],
                      ),
                    ),
                    );

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    );
                  }
                },
              ),
          ],
          ),


        ],
      ),
    );
  }

  void setState(Null Function() param0) {}
}


void showAlertDialog(BuildContext context) {
}










