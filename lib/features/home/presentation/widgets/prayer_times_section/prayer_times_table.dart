import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/color_manager.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/utils/values_manager.dart';
import '../../../data/models/prayer_times_model.dart';

class PrayerTimesTable extends StatelessWidget {
  final List<PrayerTimesModel> prayerTimes;
  const PrayerTimesTable({
    super.key,
    required this.prayerTimes,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(DistancesManager.cardBorderRadius),
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            decoration: BoxDecoration(color: ColorManager.primary),
            children: [
              Center(
                child: Text(
                  "city".tr,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Center(
                child: Text(
                  "fajr".tr,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Center(
                child: Text(
                  "duhr".tr,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Center(
                child: Text(
                  "asr".tr,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Center(
                child: Text(
                  "majrib".tr,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Center(
                child: Text(
                  "fajr".tr,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          ...prayerTimes
              .mapIndexed(
                (index, prayerTime) => TableRow(
                  decoration: BoxDecoration(
                    color: ColorManager.primary.withAlpha(
                      index % 2 == 0 ? 50 : 100,
                    ),
                  ),
                  children: [
                    Center(child: Text(prayerTime.city)),
                    Center(
                      child: Text(
                        Formatters.formatPrayerTime(
                          prayerTime.fajrTime,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        Formatters.formatPrayerTime(
                          prayerTime.duhrTime,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        Formatters.formatPrayerTime(
                          prayerTime.asrTime,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        Formatters.formatPrayerTime(
                          prayerTime.maghribTime,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        Formatters.formatPrayerTime(
                          prayerTime.ishaaTime,
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
