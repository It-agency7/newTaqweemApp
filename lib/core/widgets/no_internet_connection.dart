import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:taqwim/core/utils/values_manager.dart';

class NoInternetConnectionWidget extends StatelessWidget {
  const NoInternetConnectionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/images/offline.svg'),
        10.ph,
        Text(
          'لا يوجد اتصال بالانترنت',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}