import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taqwim/core/utils/shimmer_container.dart';

import '../../../../../core/utils/values_manager.dart';
import '../../controller/prayer_times_cubit/prayer_times_cubit.dart';
import '../../controller/prayer_times_cubit/prayer_times_cubit_states.dart';
import 'prayer_times_controlles.dart';
import 'prayer_times_table.dart';

class PrayerTimes extends StatefulWidget {
  const PrayerTimes({super.key});

  @override
  State<PrayerTimes> createState() => _PrayerTimesState();
}

class _PrayerTimesState extends State<PrayerTimes> {
  var showHijri = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrayerTimesControlles(
              date: state.chosenDateTime,
              onDateChange: (newDate) {
                BlocProvider.of<PrayerTimesCubit>(context)
                    .loadPrayerTimesOfDate(newDate);
              },
            ),
            const SizedBox(height: DistancesManager.gap3),
            Builder(
              builder: (context) {
                if (state is PrayerTimesLoadingSuccess) {
                  return PrayerTimesTable(prayerTimes: state.prayerTimesList);
                } else if (state is PrayerTimesLoadingInProgress) {
                  return const ShimmerContainer(
                    height: 420,
                    width: double.infinity,
                  );
                } else if (state is PrayerTimesLoadingFail) {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    alignment: Alignment.center,
                    child: Text(state.errorMessage),
                  );
                }
                return Text("Unknown state: ${state.runtimeType}");
              },
            ),
          ],
        );
      },
    );
  }
}
