import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel, WeekdayFormat;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:my_strengths/utils/utils.dart';
import 'dart:ui';

class CalendarScreen extends StatelessWidget {
  final EventList<Event> eventList;
  final Locale locale;
  CalendarScreen(this.eventList,this.locale);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('select_date')),
      ),
      body: CustomCalendar(eventList,locale),
    );
  }
}

class CustomCalendar extends StatelessWidget {
  //TODO: Change the locale
  final EventList<Event> eventList;
  final Locale locale;
  CustomCalendar(this.eventList,this.locale);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: CalendarCarousel<Event>(
        onDayPressed: (DateTime date, List<Event> events) {
          Navigator.pop(context, date);
        },
        thisMonthDayBorderColor: Colors.transparent,
        selectedDayButtonColor: Color(0xFF4f83cc),
        selectedDayBorderColor: Color(0xFF4f83cc),
        selectedDayTextStyle: TextStyle(color: Colors.white),
        weekendTextStyle: TextStyle(color: Colors.white),
        daysTextStyle: TextStyle(color: Colors.white),
        nextDaysTextStyle: TextStyle(color: Colors.grey),
        prevDaysTextStyle: TextStyle(color: Colors.grey),
        weekdayTextStyle: TextStyle(color: Colors.grey),
        weekDayFormat: WeekdayFormat.short,
        showHeader: true,
        isScrollable: false,
        weekFormat: false,
        firstDayOfWeek: 1,
        selectedDateTime: DateTime.now(),
        daysHaveCircularBorder: true,
        customGridViewPhysics: NeverScrollableScrollPhysics(),
        markedDatesMap: eventList,
        markedDateWidget: Container(
          height: 7,
          width: 7,
          decoration: new BoxDecoration(
            color: Color(0xFF4f83cc),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
        locale: locale.languageCode,
        // markedDateShowIcon: true,
      ),
    );
  }
}
