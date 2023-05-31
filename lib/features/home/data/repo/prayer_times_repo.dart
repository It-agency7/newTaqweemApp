 import 'package:shared_preferences/shared_preferences.dart';
import 'package:taqwim/core/localization/change_locale.dart';
import 'package:taqwim/core/utils/constant_manager.dart';
import 'package:taqwim/features/home/data/models/prayer_times_model.dart';
import 'package:taqwim/features/home/data/src/prayer_times_src.dart';

class PrayerTimesRepo {
  static final instance = PrayerTimesRepo();
  final _prayerTimesSource = PrayerTimesSource.instance;

  Future<List<PrayerTimesModel>> getPrayerTimes(DateTime date, {String? city}) async {
    final responses = await _prayerTimesSource.getPrayerTimes(date, city: city);

    final List<PrayerTimesModel> prayerTimes = [];

    String lang = await SharedPreferences.getInstance().then((value) => value.getString("lang") ?? "ar");

    for (var i = 0; i < responses.length; i++) {
      final response = responses[i];
      final city = ConstantsManager.saCities[i];
      final prayerTimesData = response.data["data"]["timings"] as Map;
      prayerTimesData["city"] = lang == "ar" ? city.arabicName : city.englishName;
      prayerTimes.add(PrayerTimesModel.fromJson(prayerTimesData));
    }

    return prayerTimes;
  }
}
