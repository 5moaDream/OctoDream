import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prodect1/home.dart';
import 'package:prodect1/runningsetting.dart';
import 'package:prodect1/sleepsetting.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:prodect1/sleepsetting.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  PickedTime _inBedTime =PickedTime(h:0,m:0);
  PickedTime _outBedTime =PickedTime(h:0,m:0);

  double _currentDoubleValue =0.0;

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int inBedTimeHour = prefs.getInt('inbedtime_hour') ?? 0;
    int inBedTimeMinute = prefs.getInt('inbedtime_minute') ?? 0;
    int outBedTimeHour = prefs.getInt('outbedtime_hour') ?? 0;
    int outBedTimeMinute = prefs.getInt('outbedtime_minute') ?? 0;

    setState(() {
      _inBedTime = PickedTime(h: inBedTimeHour, m: inBedTimeMinute);
      _outBedTime = PickedTime(h: outBedTimeHour, m: outBedTimeMinute);
    });
  }

  Future<void> loadkm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double RunningKm = prefs.getDouble('runningkm') ?? 0;
    setState(() {
      _currentDoubleValue = RunningKm;
    });
  }

  Future<void> switchsave() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isAlarmEnabled', isAlarmEnabled);
    prefs.setBool('isAlimEnabled', isAlimEnabled);
  }

  Future<void> loadswitch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool onAlam = prefs.getBool('isAlarmEnabled') ?? false;
    bool onAlim = prefs.getBool('isAlimEnabled') ?? false;
    setState(() {
      isAlarmEnabled = onAlam; // SharedPreferences에서 설정값 가져오기
      isAlimEnabled = onAlim;
    });
  }


  @override
  void initState() {
    super.initState();
    info = fetchInfo();
    loadData();
    loadkm();
    loadswitch();
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
                 Row(
                   children: [
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
                     /*TextButton(
                         onPressed: () {
                           showDialog(
                             context: context,
                             builder: (BuildContext context) {
                               return AlertDialog(
                                 title: Text('문어 이름 변경',style: TextStyle(fontSize: 15),),
                                 content: FutureBuilder(
                                     future: info,
                                     builder: (context, snapshot){
                                       if(snapshot.hasData){
                                         final characterName = snapshot.data!.characterName;
                                         return TextField(
                                           decoration: InputDecoration(
                                             labelText:  characterName ?? '',
                                           ),
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
                         child: Text(
                           '수정',style: TextStyle(
                             fontSize: 16,
                             color: Colors.black,
                             fontWeight: FontWeight.w600),
                         )),*/
                   ],
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
                                         return TextField(
                                           decoration: InputDecoration(
                                             labelText:  stateMsg ?? '',
                                             /*style: TextStyle(
                                               fontSize: 30,
                                               color: Colors.black,
                                             ),*/
                                           ),
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
                           '모닝콜 설정',
                           style: TextStyle(fontSize: 20,fontWeight: FontWeight.w100),
                         ),
                         Switch(
                           onChanged: (bool value) {
                             setState(() {
                               isAlarmEnabled = value;  // 사용자가 선택한 값을 저장
                             });
                             switchsave();
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
                               isAlimEnabled = value;  // 사용자가 선택한 값을 저장
                             });
                             switchsave();
                           },
                           value: isAlimEnabled,  // 현재 설정값을 표시
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
  Widget sleeptime(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('수면 시간',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w100),),
              TextButton(
                  onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => sleepsetting()),
                );
              },
                  child: Text('수정',
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.lightBlueAccent,
                        fontWeight: FontWeight.w600),)),
            ],
          ),
          Text(
            '취침 시간: ${_inBedTime.h}시 ${_inBedTime.m}분',
            style: TextStyle(fontSize: 15),
          ),
          Text(
            '기상 시간: ${_outBedTime.h}시 ${_outBedTime.m}분',
            style: TextStyle(fontSize: 15),
          ),
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
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: Text('러닝 거리 설정'),
                        content: Runningsetting(),
                      );
                    });
              }, child: Text('수정',
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.lightBlueAccent,
                    fontWeight: FontWeight.w600),)),
            ],
          ),
          Text('$_currentDoubleValue 러닝을 합니다.'),
        ],
      ),
    );
  }
}

