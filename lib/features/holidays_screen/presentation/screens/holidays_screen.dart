import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taqwim/core/utils/color_manager.dart';
import 'package:taqwim/features/holidays_screen/presentation/screens/holidays_details_screen.dart';
import 'package:taqwim/features/notes_screen/data/models/note_model.dart';
import 'package:taqwim/features/notes_screen/presentation/screens/note_details_screen.dart';
import '../../../../core/utils/styles_manager.dart';
import '../../../../core/widgets/no_internet_connection.dart';
import '../../../notes_screen/presentation/widgets/note_card.dart';
import '../../../notes_screen/presentation/widgets/notes_controls/notes_controls.dart';
import '../../data/repo/holiday_times_repo.dart';
import '../controller/holiday_times_cubit/holiday_times_cubit.dart';
import '../controller/holiday_times_cubit/holiday_times_states.dart';
import '../../../../core/service/service_locator.dart';
import '../widgets/holiday_times_table.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../../core/widgets/app_bottom_navigation_bar/app_bottom_navigation_bar.dart';
import '../../../../core/widgets/app_top_bar.dart';

class HolidaysScreen extends StatelessWidget {
  const HolidaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(),
      bottomNavigationBar: AppBottomNavigationBar(2),
      drawer: TopAppBar().buildDrawer(context),
      onDrawerChanged: (value) async {
        if (!value) {
          await sl<AudioPlayer>().stop();
        }
      },
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool isConnected = connectivity != ConnectivityResult.none;
          if (isConnected) {
            return HolidaysBodyWidget();
          } else {
            return const NoInternetConnectionWidget();
          }
        },
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class HolidaysBodyWidget extends StatelessWidget {
  HolidaysBodyWidget({
    super.key,
  });
  bool showDetails = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(DistancesManager.screenPadding),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Text(
                'officially_holidays_in_saudi_arabia'.tr,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            DistancesManager.gapNormal.ph,
            BlocProvider(
              create: (context) =>
                  HolidayTimesCubit(sl<HolidayTimesRepository>()),
              child: BlocBuilder<HolidayTimesCubit, HolidayTimesState>(
                builder: (context, state) {
                  var itemCount = 1;
                  if (state is HolidayTimesLoadingSuccess) {
                    itemCount = state.noteModel.length;
                  }
                  if (state is HolidayTimesLoadingInProgress) {
                    return Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 2,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    );
                  } else if (state is HolidayTimesLoadingSuccess) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          HolidayTimesTable(
                            holidayTimes: state.holidayTimesModel,
                          ),
                          DistancesManager.gapNormal.ph,
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 2,
                            child: ListView.builder(
                              itemCount: itemCount,
                              itemBuilder: (context, index) {
                                if (state.noteModel.isEmpty) {
                                  return Container(
                                    height: 400,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "empty".tr,
                                      style: TextStylesManager.centralScreen,
                                    ),
                                  );
                                } else if (state.noteModel.isNotEmpty) {
                                  final note = state.noteModel[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: DistancesManager.gap3),
                                    child: buildHoldayCard(note),
                                  );
                                }
                                return Text(
                                    "Unhandeled State: ${state.runtimeType}");
                              },
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                    return Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 2,
                      alignment: Alignment.center,
                      child: const Text("حدث خطأ في التحميل"),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildHoldayCard(NoteModel note) {
    final DateFormat formatter = DateFormat('EEEE');
    final DateTime timeWill = DateTime.parse(note.date).add(Duration(
        hours: (int.parse(note.time[0] + note.time[1])),
        minutes: int.parse(note.time[3] + note.time[4])));
    return Column(
      children: [
        Material(
          clipBehavior: Clip.hardEdge,
          borderRadius: BorderRadius.circular(
            DistancesManager.cardBorderRadius,
          ),
          color: ColorManager.primary,
          child: InkWell(
            onTap: showDetails
                ? null
                : () {
                    Get.to(
                      () => HolidaysDetailsScreen(note: note),
                    );
                  },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(DistancesManager.gap2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        note.title,
                        style: TextStylesManager.cardTitle,
                      ),
                    ],
                  ),
                  Text(
                    note.description
                        .replaceFirst('<p>', '')
                        .replaceAll('</p>', ''),
                    style: const TextStyle(color: ColorManager.white),
                    maxLines: showDetails ? null : 2,
                    overflow: showDetails ? null : TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: DistancesManager.gap1),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${formatter.format(DateTime.parse(note.date)).tr} - ${note.date}",
                          style: const TextStyle(
                              fontSize: 10, color: ColorManager.white),
                        ),
                      ),
                      const Icon(Icons.access_time_rounded,
                          size: 10, color: ColorManager.white),
                      const SizedBox(width: DistancesManager.gap1),
                      Text(
                        note.time.substring(0, 5),
                        style: const TextStyle(
                            fontSize: 10, color: ColorManager.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
