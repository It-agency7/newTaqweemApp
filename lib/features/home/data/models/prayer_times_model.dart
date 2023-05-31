import 'package:flutter/material.dart';

class PrayerTimesModel {
  final String city;
  final TimeOfDay fajrTime;
  final TimeOfDay duhrTime;
  final TimeOfDay asrTime;
  final TimeOfDay maghribTime;
  final TimeOfDay ishaaTime;

  PrayerTimesModel({
    required this.city,
    required this.fajrTime,
    required this.duhrTime,
    required this.asrTime,
    required this.maghribTime,
    required this.ishaaTime,
  });

  factory PrayerTimesModel.fromJson(Map json) {
    TimeOfDay toTimeOfDay(String timeOfDay) {
      final hour = int.parse(timeOfDay.split(":")[0]);
      final minute = int.parse(timeOfDay.split(":")[1]);
      return TimeOfDay(hour: hour, minute: minute);
    }

    return PrayerTimesModel(
      city: json["city"]!,
      fajrTime: toTimeOfDay(json["Fajr"]),
      duhrTime: toTimeOfDay(json["Dhuhr"]),
      asrTime: toTimeOfDay(json["Asr"]),
      maghribTime: toTimeOfDay(json["Maghrib"]),
      ishaaTime: toTimeOfDay(json["Isha"]),
    );
  }
}
