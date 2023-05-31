import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/color_manager.dart';
import '../../utils/icon_broken.dart';
import '../../routes/routes_manager.dart';
import "package:collection/collection.dart";
import 'app_bottom_navigation_bar_item.dart';

import '../../utils/values_manager.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  AppBottomNavigationBar(this.currentIndex, {super.key});

  final items = [
    AppBottomNavigationBarItem(
      route: RoutesManager.home,
      icon: IconBroken.Home,
      label: "home".tr,
    ),
    AppBottomNavigationBarItem(
      route: RoutesManager.notes,
      icon: IconBroken.Discovery,
      label: "notes".tr,
    ),
    AppBottomNavigationBarItem(
      route: RoutesManager.holidays,
      icon: IconBroken.Document,
      label: "holidays".tr,
    ),
    AppBottomNavigationBarItem(
      route: RoutesManager.profile,
      icon: IconBroken.Profile,
      label: "profile".tr,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(blurRadius: 5, color: Colors.grey),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        vertical: DistancesManager.gap2,
        horizontal: DistancesManager.gap3,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.mapIndexed((index, item) {
          if (index == currentIndex) {
            return TextButton.icon(
              onPressed: () {
                Get.offAllNamed(item.route);
              },
              icon: Icon(item.icon),
              label: Text(
                item.label,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              ),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                backgroundColor: ColorManager.primary.withAlpha(50),
              ),
            );
          } else {
            return IconButton(
              onPressed: () {
                Get.offAllNamed(item.route);
              },
              icon: Icon(
                item.icon,
                color: Colors.grey[400],
              ),
            );
          }
        }).toList(),
      ),
    );
  }
}
