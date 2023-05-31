import 'package:equatable/equatable.dart';
class HolidayTimesModel extends Equatable {
  final String message;
  final bool status;
  final List<DataModel> data;

  const HolidayTimesModel({
    required this.message,
    required this.status,
    required this.data,
  });

  @override
  List<Object?> get props => [
        message,
        status,
        data,
      ];

  factory HolidayTimesModel.fromJson(Map<String, dynamic> json) =>
      HolidayTimesModel(
        message: json['message'],
        status: json['status'],
        data: List<DataModel>.from(
          (json['data'] as List).map(
            (holiday) => DataModel.fromJson(holiday),
          ),
        ),
      );
}

class DataModel extends Equatable {
  final int id;
  final String name;
  final String day;
  final String hijiriDate;
  final String hijiriDateString;
  final String gregorianDate;
  final String gregorianDateString;

  const DataModel({
    required this.id,
    required this.name,
    required this.day,
    required this.hijiriDate,
    required this.hijiriDateString,
    required this.gregorianDate,
    required this.gregorianDateString,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        day,
        hijiriDate,
        hijiriDateString,
        gregorianDate,
        gregorianDateString,
      ];

  factory DataModel.fromJson(Map<String, dynamic> json) {
    String day = json['day'];
    switch (day) {
      case 'Monday':
        day = 'الاثنين';
        break;
      case 'Tuesday':
        day = 'الثلاثاء';
        break;
      case 'Wednesday':
        day = 'الأربعاء';
        break;
      case 'Thursday':
        day = 'الخميس';
        break;
      case 'Friday':
        day = 'الجمعة';
        break;
      case 'Saturday':
        day = 'السبت';
        break;
      case 'Sunday':
        day = 'الأحد';
        break;
      default:
        day = '';
    }
    return DataModel(
      id: json['id'],
      name: json['name'],
      day: day,
      hijiriDate: json['higri_date'],
      hijiriDateString: json['higri_date_string'],
      gregorianDate: json['date'],
      gregorianDateString: json['date_string'],
    );
  }
}
