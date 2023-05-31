import 'package:flutter/material.dart';
import 'package:hijri/digits_converter.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

class Formatters {
  static String formatDate(
      {required DateTime date, bool hijri = false, bool weekName = true}) {
    String formattedDate = "";

    if (hijri) {
      HijriCalendar.language = "ar";
      final hijriDate = HijriCalendar.fromDate(date);
      if (weekName) {
        formattedDate += "${hijriDate.dayWeName}, ";
      }
      formattedDate +=
          "${DigitsConverter.convertWesternNumberToEastern(hijriDate.hDay)} ${hijriDate.longMonthName} ${DigitsConverter.convertWesternNumberToEastern(hijriDate.hYear)}";
    } else {
      if (weekName) {
        formattedDate = DateFormat.yMMMMEEEEd("ar").format(date);
      } else {
        formattedDate = DateFormat.yMMMMd("ar").format(date);
      }
    }

    return formattedDate;
  }

  static String formatPrayerTime(TimeOfDay prayerTime) {
    final hours = DigitsConverter.convertWesternNumberToEastern(
      prayerTime.hour % 12 == 0 ? 12 : prayerTime.hour % 12,
    );
    final minutes = DigitsConverter.convertWesternNumberToEastern(
      prayerTime.minute,
    );

    return "$hours:$minutes";
  }
}
