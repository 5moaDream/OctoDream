import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prodect1/home.dart';
import 'package:prodect1/sleepsetting.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';

import 'Service/userService.dart';

class Setting extends StatelessWidget {
  final String title;

  Setting({required this.title});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'settingPage',
      home: SettingPage(),
    );
  }
}

class SettingPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isAlarmEnabled = false;
  bool isAlimEnabled = false;
  Future<Info>? info;

  @override
  void initState() {
    super.initState();
    info = fetchInfo();
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: Container(
       decoration: BoxDecoration(
         image: DecorationImage(
           image: AssetImage('assets/images/background.gif'),
           fit: BoxFit.fill,),
       ),
       child: Container(
         padding: EdgeInsets.all(50),
         color: Colors.black.withOpacity(0.3),
         child: Column(
           children: [
             SizedBox(
               height: 50,
             ),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 //이름
                 FutureBuilder(
                   future: info,
                     builder: (context, snapshot){
                     if(snapshot.hasData){
                       final characterName = snapshot.data!.characterName;
                       return Text(
                         characterName,
                         style: TextStyle(
                           fontSize: 30,
                           color: Colors.black,
                           fontWeight: FontWeight.bold,
                           letterSpacing: 2.0,
                           fontFamily: 'Neo',
                         ),
                       );
                     } else if (snapshot.hasError) {
                       // 데이터 가져오기 실패 시 에러 처리
                       return Text('Error: ${snapshot.error}');
                     } else {
                       // 데이터 가져오는 동안 로딩 표시
                       return CircularProgressIndicator();
                     }
                   }
                   ),
                 IconButton(onPressed: () {
                   Navigator.push(context,
                       MaterialPageRoute(builder: (context) => MyHomePage()));
                 }, icon: Icon(Icons.close))
               ],
             ),

             Container(
               padding: EdgeInsets.all(20),
               margin: EdgeInsets.all(20),
               height: 400,
               width: 300,
               decoration: BoxDecoration(
                 color: Colors.white.withOpacity(0.8),
                 borderRadius: BorderRadius.circular(30),
               ),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   FutureBuilder(
                       future: info,
                       builder: (context, snapshot){
                         if(snapshot.hasData){
                           final stateMsg = snapshot.data!.stateMsg;
                           return Container(
                             child: Text(
                               stateMsg ?? '놀러온 친구에게 말해주세여!',
                                 style: TextStyle(
                                 fontSize: 15,
                                 color: Colors.black,
                             ),),
                           );
                         }
                         else if (snapshot.hasError) {
                           // 데이터 가져오기 실패 시 에러 처리
                           return Text('Error: ${snapshot.error}');
                         } else {
                           // 데이터 가져오는 동안 로딩 표시
                           return CircularProgressIndicator();
                         }
                       }
                       ),
                   Container(
                     child:
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         SizedBox(
                           width: 10,
                         ),
                         IconButton(onPressed: () {
                           showDialog(
                             context: context,
                             builder: (BuildContext context) {
                               return AlertDialog(
                                 title: Text('상태메시지는 친구에게 보여집니다!',style: TextStyle(fontSize: 15),),
                                 content: FutureBuilder(
                                     future: info,
                                     builder: (context, snapshot){
                                       if(snapshot.hasData){
                                         final stateMsg = snapshot.data!.stateMsg;
                                         return Text(
                                           stateMsg ?? '',
                                           style: TextStyle(
                                             fontSize: 30,
                                             color: Colors.black,
                                           ),);
                                       }
                                       else if (snapshot.hasError) {
                                         // 데이터 가져오기 실패 시 에러 처리
                                         return Text('Error: ${snapshot.error}');
                                       } else {
                                         // 데이터 가져오는 동안 로딩 표시
                                         return CircularProgressIndicator();
                                       }
                                     }
                                 ),
                                 actions: [
                                   TextButton(
                                     onPressed: () {
                                       Navigator.of(context).pop(); // 팝업 닫기
                                     },
                                     child: Text('확인'),
                                   ),
                                 ],
                               );
                             },
                           );
                         },
                             icon:Text('수정',style: TextStyle(
                               fontSize: 16,
                             color: Colors.lightBlueAccent,
                             fontWeight: FontWeight.w600),)
                         ),
                       ],
                     ),
                   ),
                   Container(
                     padding: EdgeInsets.only(left: 5),
                     child: Row(
                       children: [
                         Text(
                           '수면 알람 설정',
                           style: TextStyle(fontSize: 20,fontWeight: FontWeight.w100),
                         ),
                         Switch(
                           onChanged: (bool value) {
                             setState(() {
                               isAlarmEnabled = value;  // 사용자가 선택한 값을 저장
                             });
                           },
                           value: isAlarmEnabled,  // 현재 설정값을 표시
                           activeColor: Colors.green,
                         ),
                       ],
                     ),
                   ),
                   Container(
                     padding: EdgeInsets.only(left: 5),
                     child: Row(
                       children: [
                         Text(
                           '알림 설정',
                           style: TextStyle(fontSize: 20,fontWeight: FontWeight.w100),
                         ),
                         Switch(
                           onChanged: (bool value) {
                             setState(() {
                               isAlarmEnabled = value;  // 사용자가 선택한 값을 저장
                             });
                           },
                           value: isAlarmEnabled,  // 현재 설정값을 표시
                           activeColor: Colors.green,
                         ),
                       ],
                     ),
                   ),
                   sleeptime(context),
                   runningkm(context)
                 ],
               ),
             ),

           ],
         ),
       )
     ),
   );
  }
}

Widget sleeptime(BuildContext context){
  return Container(
    padding: EdgeInsets.all(3),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('수면 시간',
              style: TextStyle(fontSize: 20,fontWeight: FontWeight.w100),),
            TextButton(onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => sleepsetting()));
            },
                child: Text('수정',
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.lightBlueAccent,
                      fontWeight: FontWeight.w600),)),
          ],
        ),
        Text('__시 __분부터 __시 __분까지 \n 수면을 취합니다.')
      ],
    ),
  );
}

Widget runningkm(BuildContext context){
  return Container(
    padding: EdgeInsets.all(5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            Text('러닝 거리',
              style: TextStyle(fontSize: 20,fontWeight: FontWeight.w100),),
            TextButton(onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => sleepsetting()));
            }, child: Text('수정',
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.lightBlueAccent,
                  fontWeight: FontWeight.w600),)),
          ],
        ),
        Text('_km 러닝을 합니다.'),
      ],
    ),
  );
}