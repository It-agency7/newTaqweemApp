import 'package:equatable/equatable.dart';

class TermsAndConditionsModel extends Equatable{
  final String termsAndConditions;

  const TermsAndConditionsModel({
    required this.termsAndConditions,
  });

  @override
  List<Object?> get props => [
    termsAndConditions,
  ];
}