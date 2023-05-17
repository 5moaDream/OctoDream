import 'package:flutter/material.dart';
import 'package:prodect1/Datelist.dart';

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

class one{
  late String context;
  late String name;
  one(this.context,this.name);
}

List<one>One=<one>[
  one('안녕 너 문어 구경했어', '-지연-'),
  one('우리 친구 됐다!', '-유라-'),
  one('너 문어 짱 멋지다', '-승희-')
];

class _newletter extends State<newletter>{
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
                                MaterialPageRoute(builder: (context) => Datelist()));
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
                      lett(context)],
                  )
              )
            ],
          ),
        )
    );
  }
}

lett(BuildContext context) {
  return Container(
      padding: EdgeInsets.all(5),
      width: 400,
      height: 450,
      child: Column(
        children: [
          Container(
            height: 50,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(left: 5, right: 5, top: 7, bottom: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(70.0),
                color: Colors.lightGreenAccent),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.star),
                Text(One[0].context),
                Text(One[0].name),
              ],
            ),
          ),
          Container(
            height: 50,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(left: 5, right: 5, top: 7, bottom: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(70.0),
                color: Colors.lightGreenAccent),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.star),
                Text(One[2].context),
                Text(One[2].name),
              ],
            ),
          ),
        ],
      )
  );
}