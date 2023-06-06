import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class diaryList {
  final String today;
  final String content;

  diaryList({required this.today, required this.content});

  factory diaryList.fromJson(Map<String, dynamic> json) {
    return diaryList(
      today: json["today"],
      content: json["content"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "today": today,
      "content": content,
    };
  }
}

class runningList {
  final String today;
  final double totalDistance;

  runningList({required this.today, required this.totalDistance});

  factory runningList.fromJson(Map<String, dynamic> json) {
    return runningList(
      today: json["today"],
      totalDistance: json["totalDistance"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "today": today,
      "totalDistance": totalDistance,
    };
  }
}

class sleepList {
  final String today;
  final int sleepTime;

  sleepList({required this.today, required this.sleepTime});

  factory sleepList.fromJson(Map<String, dynamic> json) {
    return sleepList(
      today: json["today"],
      sleepTime: json["sleepTime"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "today": today,
      "sleepTime": sleepTime,
    };
  }
}

class CalendarDTO {
  List<diaryList> diarylist;
  List<runningList> runninglist;
  List<sleepList> sleeplist;

  CalendarDTO({
    required this.diarylist,
    required this.runninglist,
    required this.sleeplist,
  });

  factory CalendarDTO.fromJson(Map<String, dynamic> json) {
    List<dynamic> diaryJsonList = json["diaryList"];
    List<dynamic> runningJsonList = json["runningList"];
    List<dynamic> sleepJsonList = json["sleepList"];

    List<diaryList> diarylist = diaryJsonList.map((diaryJson) {
      return diaryList.fromJson(diaryJson);
    }).toList();

    List<runningList> runninglist = runningJsonList.map((runningJson) {
      return runningList.fromJson(runningJson);
    }).toList();

    List<sleepList> sleeplist = sleepJsonList.map((sleepJson) {
      return sleepList.fromJson(sleepJson);
    }).toList();

    return CalendarDTO(
      diarylist: diarylist,
      runninglist: runninglist,
      sleeplist: sleeplist,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "diaryList": diarylist.map((diary) => diary.toJson()).toList(),
      "runningList": runninglist.map((running) => running.toJson()).toList(),
      "sleepList": sleeplist.map((sleep) => sleep.toJson()).toList(),
    };
  }
}

// 저장된 인증 토큰 및 리프레시 토큰을 가져오는 함수
Future<Map<String, String>> getTokens() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('accessToken');

  return {
    'accessToken': accessToken ?? '',
  };
}

Future<CalendarDTO> fetchtodaycalendar() async {
  Map<String, String> tokens = await getTokens();
  String token = tokens['accessToken']!;
  // String token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyNzk0MDk2NTI2IiwiZXhwIjoxNjg3MzExMTgyfQ.O2UIaz23NQqE_vZ4YYUdFgaF7e0PJg29PNKxKfqMbgvQzRlJiexeOV1D9-ojhp2LtdM3RUzycuCyj_FiS4D3Xw';
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  var url = Uri.parse('http://3.39.126.140:8000/activity-service/calender/2023-05-01');
  var response = await http.get(url, headers: headers);
  if (response.statusCode == 200) { // Request was successful
    final encodedBody = utf8.decode(response.bodyBytes);
    final result = json.decode(encodedBody);

    List<diaryList> diarylist = (result['diaryList'] as List<dynamic>).map((json) {
      return diaryList.fromJson(json);
    }).toList();

    List<runningList> runninglist = (result['runningList'] as List<dynamic>).map((json) {
      return runningList.fromJson(json);
    }).toList();

    List<sleepList> sleeplist = (result['sleepList'] as List<dynamic>).map((json) {
      return sleepList.fromJson(json);
    }).toList();

    CalendarDTO calendarDTO = CalendarDTO(diarylist: diarylist, runninglist: runninglist, sleeplist: sleeplist);

    print(result);

    return calendarDTO;
  } else { // Request failed
    print('Request failed with status: ${response.statusCode}');
    print(response.body);
  }

  throw Exception('Error: ${response.statusCode}');
}

class Event {
  final String content;
  final double distance;
  final double sleepTime;

  Event(this.content, this.distance, this.sleepTime);

  String get getContent => content;

  Map<String, dynamic> toJson() {
    return {
      "content": content,
      "distance": distance,
      "sleepTime": sleepTime,
    };
  }
}

Map<DateTime, List<Event>> convertToEventMap(CalendarDTO calendarDTO) {
  Map<DateTime, List<Event>> events = {};

  // Combine events with the same date and content
  void combineEvents(DateTime date, Event newEvent) {
    if (events.containsKey(date)) {
      List<Event> existingEvents = events[date]!;
      existingEvents.add(newEvent);
    } else {
      events[date] = [newEvent];
    }
  }

  // Iterate over the diary list
  for (diaryList diary in calendarDTO.diarylist) {
    DateTime date1 = DateTime.parse(diary.today!).toUtc();
    for (runningList running in calendarDTO.runninglist) {
      DateTime date2 = DateTime.parse(running.today!).toUtc();
      for (sleepList sleep in calendarDTO.sleeplist) {
        DateTime date = DateTime.parse(sleep.today!).toUtc();
        if(!events.containsKey(date)){
          if (date == date1 && date == date2) {
            combineEvents(date, Event(
              diary.content,
              running.totalDistance,
              sleep.sleepTime.toDouble(),
            ));
          }
          else if (date == date1 && date != date2) {
            combineEvents(date, Event(
              diary.content,
              0,
              sleep.sleepTime.toDouble(),
            ));
          }
          else if (date != date1 && date == date2) {
            combineEvents(date, Event(
              '',
              running.totalDistance,
              sleep.sleepTime.toDouble(),
            ));
          }
          else if (date != date1 && date != date2 && date1 == date2) {
            combineEvents(date, Event(
              '',
              0,
              sleep.sleepTime.toDouble(),
            ));
          }
        }
      }
      if (!events.containsKey(date2) && date2 == date1) {
        combineEvents(date2, Event(diary.content,running.totalDistance, 0));
      }
      if (!events.containsKey(date2) && date2 != date1) {
        combineEvents(date2, Event('',running.totalDistance, 0));
      }
    }
    if (!events.containsKey(date1)) {
      combineEvents(date1, Event(diary.content,0, 0));
    }
  }
  return events;
}
