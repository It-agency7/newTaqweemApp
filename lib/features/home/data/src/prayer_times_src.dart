import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taqwim/core/utils/constant_manager.dart';

import '../../../../core/client/endpoints.dart';

class PrayerTimesSource {
  static final instance = PrayerTimesSource();

  final _dio = Dio(
    BaseOptions(
      baseUrl: "http://api.aladhan.com/v1/timingsByCity",
      connectTimeout: Endpoints.connectionTimeout,
      receiveTimeout: Endpoints.receiveTimeout,
      responseType: ResponseType.json,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<List<Response>> getPrayerTimes(DateTime date, {String? city}) async {
    final List<Future<Response>> requests = [];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? selectedCity = prefs.getString("selectedCity");

    if(selectedCity == null) {
      if(city == null) {
        for (final city in ConstantsManager.saCities) {
          final formattedDate =
              "${date.day.toString().padLeft(2, "0")}-${date.month.toString().padLeft(2, "0")}-${date.year.toString().padLeft(4, "0")}";
          requests.add(
            _dio.get(
              "/$formattedDate",
              queryParameters: {
                "date": formattedDate,
                "country": "SA",
                "method": 4,
                "city": city.englishName,
              },
            ),
          );
        }
      }else{
        print("city: $city");
        final formattedDate =
            "${date.day.toString().padLeft(2, "0")}-${date.month.toString().padLeft(2, "0")}-${date.year.toString().padLeft(4, "0")}";
        requests.add(
          _dio.get(
            "/$formattedDate",
            queryParameters: {
              "date": formattedDate,
              "country": "SA",
              "method": 4,
              "city": city,
            },
          ),
        );
      }
    }else{
      final formattedDate =
          "${date.day.toString().padLeft(2, "0")}-${date.month.toString().padLeft(2, "0")}-${date.year.toString().padLeft(4, "0")}";
      requests.add(
        _dio.get(
          "/$formattedDate",
          queryParameters: {
            "date": formattedDate,
            "country": "SA",
            "method": 4,
            "city": "Abha",
          },
        ),
      );
    }

    final responses = await Future.wait(requests);
    return responses;
  }
}
