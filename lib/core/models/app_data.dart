import 'package:equatable/equatable.dart';

class ApplicationDataModel extends Equatable {
  final String logo;
  final String terms;
  final String who;
  final String facebook;
  final String twitter;
  final String instagram;
  final String youtube;
  final String linkedin;
  final String contactUs;
  final String addWithUs;

  const ApplicationDataModel({
    required this.logo,
    required this.terms,
    required this.who,
    required this.facebook,
    required this.twitter,
    required this.instagram,
    required this.youtube,
    required this.linkedin,
    required this.contactUs,
    required this.addWithUs,
  });

  @override
  List<Object?> get props => [
        logo,
        terms,
        who,
        facebook,
        twitter,
        instagram,
        youtube,
        linkedin,
      ];

  factory ApplicationDataModel.fromJson(Map<String, dynamic> json) {
    return ApplicationDataModel(
      logo: json['logo'] as String,
      terms: json['terms'] as String,
      who: json['who'] as String,
      facebook: json['facebook'] as String,
      twitter: json['twitter'] as String,
      instagram: json['instagram'] as String,
      youtube: json['youtube'] as String,
      linkedin: json['linkedin'] as String,
      contactUs: json['contact_us'] as String,
      addWithUs: json['ad_with_us'] as String,
    );
  }
}
