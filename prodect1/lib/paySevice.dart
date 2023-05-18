import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
/* 아임포트 결제 모듈을 불러옵니다. */
import 'package:iamport_flutter/iamport_payment.dart';
/* 아임포트 결제 데이터 모델을 불러옵니다. */
import 'package:iamport_flutter/model/payment_data.dart';

class PaymentService {
  final http.Client httpClient = http.Client();


  http.Client get httpgetter => httpClient;

  //결제 준비
  Future<String?> preparePayment() async {
    try {
      final response = await httpgetter.post(
          Uri.parse('http://3.39.126.140:8000/prepare/9900')); //결제 준비 api 호출
      final responseData = jsonDecode(response.body); //응답 결과 json으로 파싱
      final merchantUid = responseData['merchant_uid'];
      final token = responseData['token']; //고유번호와 결제토큰 추출
      print('결과: $responseData');
      return '$merchantUid|$token'; //문자열로 반환
    } catch (error) { //예외발생
      print('Payment preparation failed with error: $error');
      return null;
    }
  }

  Future<bool> completePayment(String merchantUid, String token) async {
    try {
      // 결제 완료API에 전송할 데이터를 맵 객체로 생성
      final completionData = {
        'pg': 'nice.nictest04m', // PG사 코드표에서 선택
        'pay_method': 'card', // 결제 방식
        'merchant_uid': merchantUid, // 결제 고유 번호
        'name': "문어알", // 제품명
        'amount': 100, // 가격
        'buyer_email': 'jcy0342@gmail.com',
        'buyer_name': '정찬영',
        'buyer_tel': '010-1234-5678',
      };
      final response = await httpgetter.post(
          Uri.parse('http://3.39.126.140:8000/complete'), body: completionData);
      final responseData = jsonDecode(response.body);
      final success = responseData['success'];
      return success == true;
    } catch (error) {
      print('Payment completion failed with error: $error');
      return false; // Return false to indicate the payment completion failure
    }
  }
}
class Payment {
  final PaymentService _service = PaymentService();
  late String _merchantUid = '';
  late String _token = '';
  String get merchantUid => _merchantUid;
  //결제 준비
  Future<void> preparePayment() async {
    final data = await _service.preparePayment();
    if (data != null) {
      final splitData = data.split('|');
      _merchantUid = splitData[0];
      //_token = splitData[1];
      print('결과: $_merchantUid');
    }
  }


  Future<bool> completePayment() async {
    if (_merchantUid == null){
      print('Payment not prepared yet');
      print('실패');
      return false;

    }
    return await _service.completePayment(_merchantUid,_token);
  }
}


class Paymentscreen extends StatefulWidget {
  @override
  State<Paymentscreen> createState() => _PaymentscreenState();
}

class _PaymentscreenState extends State<Paymentscreen> {
  late Payment payment;
  late String merchantUid;

  @override
  void initState() {
    super.initState();
    payment = Payment();
    merchantUid = payment.merchantUid;
  }
  @override
  Widget build(BuildContext context) {
    return IamportPayment(
      appBar: new AppBar(
        title: new Text('아임포트 결제'),
      ),

      /* 웹뷰 로딩 컴포넌트 */
      initialChild: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Image.asset('assets/images/iamport-logo.png'),
              Padding(padding: EdgeInsets.symmetric(vertical: 15)),
              Text('잠시만 기다려주세요...', style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
      /* [필수입력] 가맹점 식별코드 */
      userCode: 'imp46460554',
      /* [필수입력] 결제 데이터 */
      data: PaymentData(
        pg: 'nice.nictest04m',                                          // PG사
        payMethod: 'card',                                           // 결제수단
        name: '문어알',                                  // 주문명
        merchantUid: merchantUid,         // 주문번호
        //merchantUid: 'mid_${DateTime.now().millisecondsSinceEpoch}',
        amount: 100,                                               // 결제금액
        buyerName: '정찬영',                                           // 구매자 이름
        buyerTel: '010-1234-5678',                                     // 구매자 연락처
        buyerEmail: 'jcy0342@gmail.com',                         // 구매자 이메일
        appScheme: '',
        //buyerAddr: '서울시 강남구 신사동 661-16',                         // 구매자 주소
        //buyerPostcode: '06018',                                      // 구매자 우편번호
        //appScheme: 'http://3.39.126.140:8000/prepare/9900',             // 앱 URL scheme
        //cardQuota : [2,3]                                            //결제창 UI 내 할부개월수 제한
      ),

      /* [필수입력] 콜백 함수 */
      callback: (Map<String, String> result) {
        /*String? imp_uid=result['imp_uid'];
        String? merchant_uid=result['merchant_uid'];
        String? success = result['success'];
        if(success=='true'){
          print('Payment successful - imp_uid: $imp_uid, merchant_uid: $merchant_uid');
        } else{
          print('Payment failed or cancelled - imp_uid: $imp_uid, merchant_uid: $merchant_uid');
        }*/
        Navigator.pushReplacementNamed(
          context,
          '/result',
          arguments: result,
        );
      },
    );
  }
}