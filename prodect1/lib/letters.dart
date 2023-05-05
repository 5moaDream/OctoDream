import 'package:flutter/material.dart';
import 'package:prodect1/Datelist.dart';

class letters extends StatefulWidget{
  _letters createState() => _letters();
}

class _letters extends State<letters> {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
        title: 'memolist',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: memolist()
    );
  }
}

class memolist extends StatefulWidget{
  @override
  State<memolist> createState()=>_memolist();
}

class _memolist extends State<memolist>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
        backgroundColor: Colors.lightBlueAccent,
        body: Container(
          padding: EdgeInsets.only(top: 50,left: 30,right: 30,bottom: 5),
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
                      IconButton(onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Datelist()));
                      }, icon: Icon(Icons.close))
                    ],
                  )
              ),
              Container(
                  color: Colors.white,
                  margin: EdgeInsets.only(top: 10,left: 10,right: 10),
                  padding: EdgeInsets.all(6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 3,top: 7,bottom: 7),
                        child: Text('2023년 3월 12일'),
                      ),

                      lett(context)
                    ],
                  )
              )

            ],
          ),
        )
    );
  }
}

lett(BuildContext context){
  return Container(
      padding: EdgeInsets.all(5),
      width: 400,
      height: 450,
      child: Column(
        children: [
          one(context)
        ],
      )
  );
}

one(BuildContext context){
  return Container(
    height: 50,
    padding: EdgeInsets.all(10),
    margin: EdgeInsets.only(left: 5,right: 5,top: 7,bottom: 5),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(70.0),color: Colors.grey),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.all(3),
          child: Icon(Icons.maps_ugc),
        ),
        Container(
          margin: EdgeInsets.all(5),
          child: Text('네 문어는 수면 문어구나! '),
        )
      ],
    ),
  );
}