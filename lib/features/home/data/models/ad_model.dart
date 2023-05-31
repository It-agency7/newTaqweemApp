import 'package:equatable/equatable.dart';

class AdModelTest {
  final String imageUrl;
  final String link;

  AdModelTest({
    required this.imageUrl,
    required this.link,
  });
}

class AdsModel extends Equatable {
  final String message;
  final bool status;
  final List<DataModel> data;

  const AdsModel({
    required this.message,
    required this.status,
    required this.data,
  });

  factory AdsModel.fromJson(Map<String, dynamic> json) => AdsModel(
        message: json['message'],
        status: json['status'],
        data: List<DataModel>.from(
          (json['data'] as List).map(
            (e) => DataModel.fromJson(e),
          ),
        ),
      );

  @override
  List<Object?> get props => [
        message,
        status,
        data,
      ];
}

class DataModel extends Equatable {
  final int id;
  final String link;
  final String place;
  final String imageUrl;

  const DataModel({
    required this.link,
    required this.imageUrl,
    required this.place,
    required this.id,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
        link: json['link'],
        imageUrl: json['ImageUrl'],
        place: json['place'],
        id: json['id'],
      );

  @override
  List<Object?> get props => [
        link,
        place,
        imageUrl,
        id,
      ];
}
