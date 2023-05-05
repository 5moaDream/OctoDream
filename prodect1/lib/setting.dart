import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  final String title;

  Setting({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          this.title,
        ),
      ),
      body: Column(
        children: <Widget>[

          Text('생태 메시지',
              style: TextStyle(fontSize: 25)
          ),


            TextField(
            obscureText: true,
            decoration: InputDecoration(

              labelText: '상태 메시지 입력',
              hintText: '생태 메시지 입력',
            ),
          ),
          Container(
            child:
            IconButton(onPressed: () {}, icon:Text('확인')),
          ),



          Row(
            children:[
          Text('수면 알람 설정',
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
          IconButton(onPressed: () {}, icon: Icon(Icons.settings)),

          ],
          ),
          Text(
              '하루 8시간 동안 수면합니다'
          ),
          Text('오후 11:00 ~ 오전 7:00'),
          Row(
            children:[
          Text('러닝 거리',
            style: TextStyle(fontSize: 25),),
          TextButton(onPressed: () {}, child: Icon(Icons.settings)),
          ],
          ),
Text('8km'  ),

        ],
      ),
    );
  }
}



