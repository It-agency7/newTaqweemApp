import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:hijri/hijri_calendar.dart";
import 'package:hijri_picker/hijri_picker.dart';

import '../../../../../core/utils/color_manager.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/utils/icon_broken.dart';

class PrayerTimesControlles extends StatefulWidget {
  final DateTime date;
  final Function(DateTime newDate)? onDateChange;

  const PrayerTimesControlles(
      {super.key, required this.date, this.onDateChange});

  @override
  State<PrayerTimesControlles> createState() => _PrayerTimesControllesState();
}

class _PrayerTimesControllesState extends State<PrayerTimesControlles> {
  var _showHijri = false;

  @override
  Widget build(BuildContext context) {
    HijriCalendar.setLocal(Localizations.localeOf(context).languageCode);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: _updateDate,
          icon: const Icon(IconBroken.Calendar),
          label: Text(Formatters.formatDate(
            date: widget.date,
            hijri: _showHijri,
          )),
          style: TextButton.styleFrom(
            backgroundColor: ColorManager.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton(
            items: [
              DropdownMenuItem(
                value: true,
                child: Text("hijri".tr),
              ),
              DropdownMenuItem(
                value: false,
                child: Text("gregorian".tr),
              ),
            ],
            value: _showHijri,
            onChanged: (showHijri) {
              if (showHijri == null) return;
              setState(() {
                _showHijri = showHijri;
              });
            },
            iconEnabledColor: ColorManager.primary,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: ColorManager.primary),
          ),
        ),
      ],
    );
  }

  void _updateDate() async {
    final initialDate = widget.date;
    final firstDate = widget.date.subtract(const Duration(days: 365));
    final lastDate = widget.date.add(const Duration(days: 365));
    const locale = Locale("ar", "SA");

    if (_showHijri) {
      final hijriDate = await showHijriDatePicker(
        context: context,
        initialDate: HijriCalendar.fromDate(initialDate),
        firstDate: HijriCalendar.fromDate(firstDate),
        lastDate: HijriCalendar.fromDate(lastDate),
        locale: locale,
      );
      if (hijriDate == null) return;
      widget.onDateChange?.call(
        hijriDate.hijriToGregorian(
          hijriDate.hYear,
          hijriDate.hMonth,
          hijriDate.hDay,
        ),
      );
    } else {
      final georgianDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        locale: locale,
      );

      if (georgianDate == null) return;

      widget.onDateChange?.call(georgianDate);
    }
  }
}
