// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   final String title;
//
//   MyHomePage({required this.title});
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   bool light = true;
//   bool notification = true;
//
//   TimeOfDay? selectedSleepTime;
//   TimeOfDay? selectedRunningTime;
//
//   Future<void> _selectTime(BuildContext context, bool isSleepTime) async {
//     final TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: isSleepTime
//           ? selectedSleepTime ?? TimeOfDay.now()
//           : selectedRunningTime ?? TimeOfDay.now(),
//     );
//
//     if (pickedTime != null) {
//       setState(() {
//         if (isSleepTime) {
//           selectedSleepTime = pickedTime;
//         } else {
//           selectedRunningTime = pickedTime;
//         }
//       });
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.title,
//         ),
//       ),
//       body: Column(
//         children: <Widget>[
//           Text(
//             '생태 메시지',
//             style: TextStyle(fontSize: 25),
//           ),
//           SizedBox(
//             width: 200,
//             child: TextField(
//               decoration: InputDecoration(
//                 labelText: '',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ),
//           Container(
//             child: ElevatedButton(
//               onPressed: () {},
//               child: Text('확인'),
//             ),
//           ),
//           Row(
//             children: [
//               Text(
//                 '수면 알람 설정',
//                 style: TextStyle(fontSize: 25),
//               ),
//               Switch(
//                 value: light,
//                 activeColor: Colors.green,
//                 onChanged: (bool value) {
//                   setState(() {
//                     light = value;
//                   });
//                 },
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               Text(
//                 '알림 설정',
//                 style: TextStyle(fontSize: 25),
//               ),
//               Switch(
//                 value: notification,
//                 activeColor: Colors.green,
//                 onChanged: (bool value) {
//                   setState(() {
//                     notification = value;
//                   });
//                 },
//               ),
//             ],
//           ),
//
//           Row(
//             children: [
//               Text(
//                 '수면 시간',
//                 style: TextStyle(fontSize: 25),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.settings),
//                 onPressed: () {
//                   showAlertDialog(context);
//                 },
//               ),
//             ],
//           ),
//
//           Row(
//             children: [
//               Text(
//                 '러닝 거리',
//                 style: TextStyle(fontSize: 25),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.settings),
//                 onPressed: () {
//                   showAlertDialog(context);
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   void showAlertDialog(BuildContext context) {
//     AlertDialog alert = AlertDialog(
//       content: Container(
//         padding: EdgeInsets.all(50.0),
//         margin: EdgeInsets.all(50.0),
//         color: Colors.white,
//         width: 800,
//         height: 800,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             SizedBox(
//               width: 300,
//               child: TextField(
//                 decoration: InputDecoration(
//                   labelText: '',
//                   border: OutlineInputBorder(),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.black, width: 2.0),
//                   ),
//                 ),
//               ),
//             ),
//
//
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: Text(
//                     '취소',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {Navigator.pop(context);},
//                   child: Text(
//                     '확인',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }
// }
