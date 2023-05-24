import 'package:flutter/material.dart';
import 'package:prodect1/newletters.dart';
import 'letters.dart';
import 'home.dart';
import 'friends.dart';

void main() {
  runApp(const Datelist());
}

class Datelist extends StatelessWidget {
  const Datelist({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '방명록',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: datelist());
  }
}

class datelist extends StatefulWidget {
  @override
  State<datelist> createState() => _datelist();
}

class _datelist extends State<datelist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.gif'),
            fit: BoxFit.fill,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width*0.2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.only(top: 80)),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyHomePage()),);},
                      child: Image.asset('assets/images/left.png',
                          height: 60, color: Colors.black38.withOpacity(0.2)),),
                  ),
                  Container(),
                ],
              ),
            ),
            Expanded(
                child:
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                          MaterialPageRoute(builder: (context) => newletter()));},
                        child: Image.asset('assets/images/chest.png',
                            height: 200),
                    ),
                  ),),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.2,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: GestureDetector(
                        onTap: () => {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => letters()))},
                        child:
                        Image.asset('assets/images/letters.png', height: 80),),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Friends()),);                    },
                      child: Image.asset('assets/images/right.png',
                          height: 60, color: Colors.black38.withOpacity(0.2)),),
                    Container()
                  ],
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}
