import 'package:charts_flutter/flutter.dart' as charts;
import 'package:gym_tracker/models/utils/human_body.dart';

class Week {
  static final Map<int, charts.Color> weekdayColors = {
    DateTime.monday: BODYPARTCOLORS.blue,
    DateTime.tuesday: BODYPARTCOLORS.blue,
    DateTime.wednesday: BODYPARTCOLORS.blue,
    DateTime.thursday: BODYPARTCOLORS.blue,
    DateTime.friday: BODYPARTCOLORS.blue,
    DateTime.saturday: BODYPARTCOLORS.blue,
    DateTime.sunday: BODYPARTCOLORS.blue
  };

  static final weekdays = [
    DateTime.monday,
    DateTime.tuesday,
    DateTime.wednesday,
    DateTime.thursday,
    DateTime.friday,
    DateTime.saturday,
    DateTime.sunday
  ];

  static String weekdayToStr(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thr';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return 'Unknown';
    }
  }

  static List<DateTime> datesOfCurrentWeek(){
    var now = DateTime.now();
    List<DateTime> weekDates = [now];
    
    DateTime newDate = now.subtract(Duration(days: 1));
    while(newDate.weekday != DateTime.sunday){
      weekDates.add(newDate);
      newDate = newDate.subtract(Duration(days: 1));
    }

    return weekDates;
  }
}