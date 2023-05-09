import 'package:flutter/material.dart';

class dictionary extends StatefulWidget{
  @override
  State<dictionary> createState()=>_dictionary();
}

class _dictionary extends State<dictionary>{
  @override
  Widget build(BuildContext context){
    return AlertDialog(
        title: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('문어 다이어리'),
              IconButton(onPressed: (){
                Navigator.of(context).pop();
              }, icon: Icon(Icons.cancel))
            ],
          ),
        ),
        content: SizedBox(
          height: MediaQuery.of(context).size.height*0.36,
          width: MediaQuery.of(context).size.width*0.84,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height*0.32,
                color: Colors.cyan,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height*0.3,
                  width: MediaQuery.of(context).size.width*0.84,
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('기본문어'),
                            ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                  Colors.transparent, BlendMode.color),
                              child: Image.asset(
                                  'assets/images/first_octo.gif',
                                  height: 100),
                            ),
                            ElevatedButton(
                                onPressed: (){},
                                child: Text('문어 교환'))
                          ],
                        ),
                      )),
                      VerticalDivider(
                        color: Colors.black,
                        thickness: 3,
                      ),
                      Expanded(child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('??문어'),
                            ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                  Colors.transparent, BlendMode.color),
                              child: Image.asset(
                                  'assets/images/first_octo.gif',
                                  height: 100),
                            ),
                            ElevatedButton(
                                onPressed: (){},
                                child: Text('문어 교환'))
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(onPressed: (){}, icon: Icon(Icons.arrow_circle_left)),
                    IconButton(onPressed: (){}, icon: Icon(Icons.arrow_circle_right)),
                  ],
                ),
              ),
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
          //다이얼로그 창 둥글게
          borderRadius:
          BorderRadius.all(Radius.circular(10)),
        ));
  }
}