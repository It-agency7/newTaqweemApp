import 'package:flutter/material.dart';

class DistancesManager {
  static const gapLarge = 40.0;
  static const gapNormal = 20.0;
  static const gapSmall = 10.0;
    static const cardBorderRadius = 10.0;
  static const screenPadding = 15.0;
  static const gap1 = 5.0;
  static const gap2 = 10.0;
  static const gap3 = 15.0;
  static const gap4 = 20.0;
  static const gap5 = 25.0;
}

///this extension allows you to easily create SizedBox widgets
///with heights equal to specific numeric values, without
///having to repeat the same code over and over again.
extension EmptyPadding on num {
  SizedBox get ph => SizedBox(
        height: toDouble(),
      );

  SizedBox get pw => SizedBox(
        width: toDouble(),
      );
}
