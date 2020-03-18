import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel, WeekdayFormat;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:my_strengths/ui/custom/icons.dart';

class CalendarScreen extends StatelessWidget {
  CalendarScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select a date"),
      ),
      body: CustomCalendar(),
    );
  }
}

class CustomCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: CalendarCarousel<Event>(
        onDayPressed: (DateTime date, List<Event> events) {
          Navigator.pop(context,date);
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
        markedDatesMap: _getCarouselMarkedDates(),
        markedDateWidget: Container(
          height: 7,
          width: 7,
          decoration: new BoxDecoration(
            color: Color(0xFF4f83cc),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
        // markedDateShowIcon: true,
      ),
    );
  }

  EventList<Event> _getCarouselMarkedDates() {
    //TODO: How to get the list of days from api?
    return EventList<Event>(
      events: {
        new DateTime(2020, 3, 4): [
          new Event(
            date: new DateTime.now(),
            title: 'Event 1',
          ),
        ],
      },
    );
  }
}
