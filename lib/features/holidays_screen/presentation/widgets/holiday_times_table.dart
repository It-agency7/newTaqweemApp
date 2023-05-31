import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../data/models/holiday_times_model.dart';

class HolidayTimesTable extends StatelessWidget {
  final HolidayTimesModel holidayTimes;
  const HolidayTimesTable({
    super.key,
    required this.holidayTimes,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(DistancesManager.cardBorderRadius),
      child: DefaultTextStyle.merge(
        style: const TextStyle(fontSize: 10),
        textAlign: TextAlign.center,
        child: Table(
          columnWidths: const {
            1: MaxColumnWidth(
              FixedColumnWidth(50),
              IntrinsicColumnWidth(),
            ),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              decoration: BoxDecoration(color: ColorManager.primary),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: DistancesManager.gap1,
                  ),
                  child: Text(
                    "holiday".tr,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Text(
                  "day".tr,
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "${'date'.tr} (${'hijri'.tr})",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "${'date'.tr} (${'gregorian'.tr})",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            ...holidayTimes.data
                .mapIndexed(
                  (index, holidayTime) => TableRow(
                    decoration: BoxDecoration(
                      color: ColorManager.primary.withAlpha(
                        index % 2 == 0 ? 50 : 100,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(DistancesManager.gap1),
                        child: Text(
                          holidayTime.name,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(DistancesManager.gap1),
                        child: Text(
                          holidayTime.day,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(DistancesManager.gap1),
                        child: Text(holidayTime.hijiriDateString),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(DistancesManager.gap1),
                        child: Text(
                          holidayTime.gregorianDateString,
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}
