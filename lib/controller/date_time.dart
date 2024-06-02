// import 'dart:html';

import 'package:uuid/uuid.dart';

const OPENING_TIME = 11;
const CLOSING_TIME = 23;

List<Map<String, dynamic>> generateTimeSlots(DateTime date) {
  DateTime openingTime =
      DateTime(date.year, date.month, date.day, OPENING_TIME, 0); // 11:00 AM
  DateTime closingTime =
      DateTime(date.year, date.month, date.day, CLOSING_TIME, 0); // 11:00 PM
  List<Map<String, dynamic>> slots = [];
  DateTime currentTime = DateTime(
      date.year, date.month, date.day, openingTime.hour, openingTime.minute);
  var uuid = Uuid();

  while (currentTime.isBefore(DateTime(
      date.year, date.month, date.day, closingTime.hour, closingTime.minute))) {
    DateTime endTime = currentTime.add(Duration(minutes: 30));

    slots.add({
      'slotId': uuid.v4(),
      'start': currentTime.toIso8601String(),
      'end': endTime.toIso8601String(),
      'isBooked': false,
      'clientId': null,
      'updatedAt': null,
      'isAvailable': true,
    });

    currentTime = endTime;
  }

  print('slots----> ${slots}');

  // print(
  //     'date -----> ${DateFormat('dd-MM-yyyy').format(DateTime.parse('2024-06-02T11:30:00.000'))}');

  // print('slots length----> ${DateTime()}');

  return slots;
}
