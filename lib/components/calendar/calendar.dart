import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';

import '/models/booking.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime? _selectedDay;
  DateTime? _focusedDay;
  List<Booking> bookings = [];

  List<Booking> _getBookingsForThisDay(DateTime day) {
    // TODO day mit bookingdate vergleichen
    return bookings;
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: _focusedDay == null ? DateTime.now() : _focusedDay!,
      locale: 'de_DE',
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableCalendarFormats: const {CalendarFormat.month: 'Monat'},
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
          print(_selectedDay);
        });
      },
      calendarFormat: CalendarFormat.month,
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      eventLoader: (day) {
        return _getBookingsForThisDay(day);
      },
    );
  }
}
