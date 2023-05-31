import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taqwim/core/client/endpoints.dart';
import 'package:taqwim/features/home/data/repo/prayer_times_repo.dart';

import '../../../data/models/prayer_times_model.dart';
import 'prayer_times_cubit_states.dart';

class PrayerTimesCubit extends Cubit<PrayerTimesState> {
  final _prayerTimesRepo = PrayerTimesRepo.instance;

  PrayerTimesCubit() : super(PrayerTimesLoadingInProgress()) {
    loadPrayerTimesOfDate(DateTime.now());
  }

  @override
  void emit(PrayerTimesState state) {
    if (!isClosed) super.emit(state);
  }

  void loadPrayerTimesOfDate(DateTime date,{String? city}) async {
    print("loadPrayerTimesOfDate");
    emit(PrayerTimesLoadingInProgress(date));
    await Future.delayed(const Duration(seconds: 1));

    emit(
      PrayerTimesLoadingSuccess(
        prayerTimesList: await _prayerTimesRepo.getPrayerTimes(date,city: city),
        chosenDateTime: date,
      ),
    );
  }
}

// final List<PrayerTimesModel> _prayerTimes = [
//   PrayerTimesModel(
//     date: DateTime.now(),
//     city: "مكة",
//     fajrTime: const TimeOfDay(hour: 5, minute: 15),
//     duhrTime: const TimeOfDay(hour: 12, minute: 30),
//     asrTime: const TimeOfDay(hour: 15, minute: 54),
//     maghribTime: const TimeOfDay(hour: 18, minute: 29),
//     ishaaTime: const TimeOfDay(hour: 19, minute: 59),
//   ),
//   PrayerTimesModel(
//     date: DateTime.now(),
//     city: "مدينة",
//     fajrTime: const TimeOfDay(hour: 5, minute: 16),
//     duhrTime: const TimeOfDay(hour: 12, minute: 31),
//     asrTime: const TimeOfDay(hour: 15, minute: 55),
//     maghribTime: const TimeOfDay(hour: 18, minute: 30),
//     ishaaTime: const TimeOfDay(hour: 20, minute: 0),
//   ),
//   PrayerTimesModel(
//     date: DateTime.now(),
//     city: "مكة",
//     fajrTime: const TimeOfDay(hour: 5, minute: 15),
//     duhrTime: const TimeOfDay(hour: 12, minute: 30),
//     asrTime: const TimeOfDay(hour: 15, minute: 54),
//     maghribTime: const TimeOfDay(hour: 18, minute: 29),
//     ishaaTime: const TimeOfDay(hour: 19, minute: 59),
//   ),
//   PrayerTimesModel(
//     date: DateTime.now(),
//     city: "مدينة",
//     fajrTime: const TimeOfDay(hour: 5, minute: 16),
//     duhrTime: const TimeOfDay(hour: 12, minute: 31),
//     asrTime: const TimeOfDay(hour: 15, minute: 55),
//     maghribTime: const TimeOfDay(hour: 18, minute: 30),
//     ishaaTime: const TimeOfDay(hour: 20, minute: 0),
//   ),
//   PrayerTimesModel(
//     date: DateTime.now(),
//     city: "مكة",
//     fajrTime: const TimeOfDay(hour: 5, minute: 15),
//     duhrTime: const TimeOfDay(hour: 12, minute: 30),
//     asrTime: const TimeOfDay(hour: 15, minute: 54),
//     maghribTime: const TimeOfDay(hour: 18, minute: 29),
//     ishaaTime: const TimeOfDay(hour: 19, minute: 59),
//   ),
//   PrayerTimesModel(
//     date: DateTime.now(),
//     city: "مدينة",
//     fajrTime: const TimeOfDay(hour: 5, minute: 16),
//     duhrTime: const TimeOfDay(hour: 12, minute: 31),
//     asrTime: const TimeOfDay(hour: 15, minute: 55),
//     maghribTime: const TimeOfDay(hour: 18, minute: 30),
//     ishaaTime: const TimeOfDay(hour: 20, minute: 0),
//   ),
//   PrayerTimesModel(
//     date: DateTime.now(),
//     city: "مكة",
//     fajrTime: const TimeOfDay(hour: 5, minute: 15),
//     duhrTime: const TimeOfDay(hour: 12, minute: 30),
//     asrTime: const TimeOfDay(hour: 15, minute: 54),
//     maghribTime: const TimeOfDay(hour: 18, minute: 29),
//     ishaaTime: const TimeOfDay(hour: 19, minute: 59),
//   ),
//   PrayerTimesModel(
//     date: DateTime.now(),
//     city: "مدينة",
//     fajrTime: const TimeOfDay(hour: 5, minute: 16),
//     duhrTime: const TimeOfDay(hour: 12, minute: 31),
//     asrTime: const TimeOfDay(hour: 15, minute: 55),
//     maghribTime: const TimeOfDay(hour: 18, minute: 30),
//     ishaaTime: const TimeOfDay(hour: 20, minute: 0),
//   ),
//   PrayerTimesModel(
//     date: DateTime.now(),
//     city: "مكة",
//     fajrTime: const TimeOfDay(hour: 5, minute: 15),
//     duhrTime: const TimeOfDay(hour: 12, minute: 30),
//     asrTime: const TimeOfDay(hour: 15, minute: 54),
//     maghribTime: const TimeOfDay(hour: 18, minute: 29),
//     ishaaTime: const TimeOfDay(hour: 19, minute: 59),
//   ),
//   PrayerTimesModel(
//     date: DateTime.now(),
//     city: "مدينة",
//     fajrTime: const TimeOfDay(hour: 5, minute: 16),
//     duhrTime: const TimeOfDay(hour: 12, minute: 31),
//     asrTime: const TimeOfDay(hour: 15, minute: 55),
//     maghribTime: const TimeOfDay(hour: 18, minute: 30),
//     ishaaTime: const TimeOfDay(hour: 20, minute: 0),
//   ),
// ];
