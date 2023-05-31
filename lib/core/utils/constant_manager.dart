import 'package:taqwim/core/models/city.dart';

class ConstantsManager {
  static const saCities = [
    CityModel(
      englishName: "Mecca",
      arabicName: "مكة",
    ),
    CityModel(
      englishName: "Medina",
      arabicName: "المدينة",
    ),
    CityModel(
      englishName: "Riyadh",
      arabicName: "الرياض",
    ),
    CityModel(
      englishName: "Taif",
      arabicName: "الطائف",
    ),
    CityModel(
      englishName: "Jeddah",
      arabicName: "جدة",
    ),
    CityModel(
      englishName: "Buraydah",
      arabicName: "بريدة",
    ),
    CityModel(
      englishName: "Dammam",
      arabicName: "الدمام",
    ),
    CityModel(
      englishName: "Abha",
      arabicName: "أبها",
    ),
    CityModel(
      englishName: "Tabuk",
      arabicName: "تبوك",
    ),
    CityModel(
      englishName: "Ha'il",
      arabicName: "حائل",
    ),
    CityModel(
      englishName: "Arar",
      arabicName: "عرعر",
    ),
    CityModel(
      englishName: "Jizan",
      arabicName: "جازان",
    ),
    CityModel(
      englishName: "Najran",
      arabicName: "نجران",
    ),
    CityModel(
      englishName: "Al Bahah",
      arabicName: "الباحة",
    ),
    CityModel(
      englishName: "Sakakah",
      arabicName: "سكاكا",
    ),
  ];

  int getDayNumber(String dayName) {
    switch (dayName.toLowerCase()) {
      case 'monday':
        return DateTime.monday;
      case 'tuesday':
        return DateTime.tuesday;
      case 'wednesday':
        return DateTime.wednesday;
      case 'thursday':
        return DateTime.thursday;
      case 'friday':
        return DateTime.friday;
      case 'saturday':
        return DateTime.saturday;
      case 'sunday':
        return DateTime.sunday;
      default:
        return -1; // Return -1 for an invalid day name
    }
  }
}
