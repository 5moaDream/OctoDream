import 'package:flutter/material.dart';
import 'package:prodect1/setting.dart';
import 'package:prodect1/home.dart';
import 'Service/firstSetService.dart';

class firstDisplay extends StatefulWidget {
  @override
  _firstDisplay createState() => _firstDisplay();
}

class _firstDisplay extends State<firstDisplay> {
  bool _isTextVisible = false;
  bool _isButtonVisible = false;

  @override
  void initState() {
    super.initState();

    // 2초 후에 텍스트가 서서히 나타나도록 설정
    Future.delayed(Duration(seconds: 2), () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _isTextVisible = true;
        });
      });

    });
  }

  void _showButton() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isButtonVisible = true;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (_isTextVisible) {
            _showButton();
          }
        },
        child: Scaffold(
          //상중하를 나눠주는 위젯
          body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.gif'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedOpacity(
                        opacity: _isTextVisible ? 1.0 : 0.0,
                        duration: Duration(seconds: 1), // 애니메이션 지속 시간 설정
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(5, 5, 5, 15),
                              child: Text("당신의 문어는 \n \n 어떤 꿈을 꾸고 있나요?",
                                style: TextStyle(
                                    fontSize: 28,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2.0,
                                    fontFamily: 'Neo'
                                ), textAlign: TextAlign.center,),
                            ),
                            AnimatedOpacity(
                              opacity: _isButtonVisible ? 1.0 : 0.0,
                              duration: Duration(seconds: 1),
                              child: OutlinedButton(
                                child: Text("나의 문어 만들기",
                                  style: TextStyle(
                                    color: Colors.black87,
                                  ),),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: true, //바깥영역 터치시 닫을지
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            title: Text('당신의 문어 이름'),
                                            content: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    TextField(
                                                      controller: myController,
                                                      decoration:
                                                      InputDecoration(hintText: '문어 이름을 입력해 주세요'),
                                                    ),
                                                  ],
                                                )),
                                            actions: [
                                              ElevatedButton(
                                                child: Text('확인'),
                                                onPressed: () {
                                                  if (myController.text == "") {
                                                    showDialog(
                                                        context: context,
                                                        barrierDismissible: false,
                                                        builder: (BuildContext context) {
                                                          Future.delayed(Duration(seconds: 1),
                                                                  () {
                                                                Navigator.pop(context);
                                                              });
                                                          return AlertDialog(
                                                            content: SingleChildScrollView(
                                                                child: new Text("이름을 입력하세요.")),
                                                          );
                                                        });
                                                  } else {
                                                    fetchName(myController.text);
                                                    Future.delayed(Duration(seconds: 3));
                                                    Navigator.of(context).pop();
                                                    Navigator.push(context,
                                                      MaterialPageRoute(builder: (context) => MyHomePage()),
                                                    );
                                                    //디자인 좀 바꾸고
                                                    showDialog(
                                                        context: context,
                                                        barrierDismissible: false,
                                                        builder: (BuildContext context) {
                                                          Future.delayed(Duration(seconds: 2));
                                                          return AlertDialog(
                                                            content: SingleChildScrollView(
                                                                child: new Text("수면 시간과 러닝 거리를 \n 설정해 주세요.",
                                                                  textAlign: TextAlign.center,)),
                                                            actions: [
                                                              Center(
                                                                child: ElevatedButton(
                                                                  //설정화면 이동말고 설정할 수 잇게...
                                                                  child: Text('설정 화면으로 이동'),
                                                                  onPressed: () {
                                                                    Navigator.of(context).pop();
                                                                    Future.delayed(Duration(seconds: 1));
                                                                    Navigator.push(context,
                                                                      MaterialPageRoute(builder: (context) => Setting(title: '설정',)),
                                                                    );
                                                                  },
                                                                ),
                                                              )
                                                            ],
                                                          );
                                                        });
                                                  }
                                                },
                                              )
                                            ],
                                            shape: RoundedRectangleBorder(
                                              //다이어로그 창 둥글게
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(20)),
                                            ));
                                      });
                                },
                              ),
                            )
                          ],
                        ),
                      )

                    ],
                  )
              )
          ),
        ),
    );
  }
}