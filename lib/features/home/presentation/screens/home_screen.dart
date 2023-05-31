import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:taqwim/features/home/presentation/controller/prayer_times_cubit/prayer_times_cubit.dart';
import 'package:taqwim/features/home/presentation/controller/prayer_times_cubit/prayer_times_cubit_states.dart';
import 'package:taqwim/features/notes_screen/presentation/controller/notes_cubit/notes_cubit.dart';
import 'package:taqwim/features/notes_screen/presentation/controller/notes_cubit/notes_cubit_states.dart';
import 'package:taqwim/features/notes_screen/presentation/widgets/note_card.dart';
import '../../../../core/service/service_locator.dart';
import '../../../../core/utils/shimmer_container.dart';
import '../../../../core/widgets/no_internet_connection.dart';
import '../controller/ads_cubit/ads_cubit.dart';
import '../widgets/ad_banner.dart';
import '../../../../core/widgets/app_bottom_navigation_bar/app_bottom_navigation_bar.dart';
import '../widgets/go_to_notes_card.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../widgets/prayer_times_section/prayer_times.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(),
      drawer: TopAppBar().buildDrawer(context),
      onDrawerChanged: (value) async {
        if (!value) {
          await sl<AudioPlayer>().stop();
        }
      },
      bottomNavigationBar: AppBottomNavigationBar(0),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool isConnected = connectivity != ConnectivityResult.none;
          if (isConnected) {
            return const HomeBodyWidget();
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

class HomeBodyWidget extends StatelessWidget {
  const HomeBodyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdsCubit, AdsStates>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(DistancesManager.screenPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ImageSlideshow(
                  height: 80,
                  autoPlayInterval: 5000,
                  isLoop: true,
                  indicatorBackgroundColor: Colors.transparent,
                  indicatorColor: Colors.transparent,
                  children: state is AdsLoadingSuccessState
                      ? state.adsList.data
                          .where((element) => element.place == "1")
                          .map(
                            (ad) => Padding(
                              padding: const EdgeInsets.only(bottom: DistancesManager.gap3),
                              child: AdBanner(
                                image: ad.imageUrl,
                                url: ad.link,
                              ),
                            ),
                          )
                          .toList()
                      : [
                          const Padding(
                            padding: EdgeInsets.only(
                              bottom: DistancesManager.gap3,
                            ),
                            child: ShimmerContainer(
                              width: double.infinity,
                              height: 55,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                              bottom: DistancesManager.gap3,
                            ),
                            child: ShimmerContainer(
                              width: double.infinity,
                              height: 55,
                            ),
                          ),
                        ],
                ),
                ImageSlideshow(
                  height: 80,
                  autoPlayInterval: 5000,
                  isLoop: true,
                  indicatorBackgroundColor: Colors.transparent,
                  indicatorColor: Colors.transparent,
                  children: state is AdsLoadingSuccessState
                      ? state.adsList.data
                          .where((element) => element.place == "2")
                          .map(
                            (ad) => Padding(
                              padding: const EdgeInsets.only(bottom: DistancesManager.gap3),
                              child: AdBanner(
                                image: ad.imageUrl,
                                url: ad.link,
                              ),
                            ),
                          )
                          .toList()
                      : [
                          const Padding(
                            padding: EdgeInsets.only(
                              bottom: DistancesManager.gap3,
                            ),
                            child: ShimmerContainer(
                              width: double.infinity,
                              height: 55,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                              bottom: DistancesManager.gap3,
                            ),
                            child: ShimmerContainer(
                              width: double.infinity,
                              height: 55,
                            ),
                          ),
                        ],
                ),
                BlocProvider(
                  create: (context) => PrayerTimesCubit(),
                  child: BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
                    builder: (context, prayerTimesState) {
                      return BlocBuilder<NotesCubit, NotesState>(
                        builder: (context, notesState) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const PrayerTimes(),
                              if (notesState is NotesLoadingSuccess)
                                ...notesState.notes
                                    .where((note) {
                                      final noteDate = DateTime(
                                        int.parse(note.date.split("-")[0]),
                                        int.parse(note.date.split("-")[1]),
                                        int.parse(note.date.split("-")[2]),
                                      );
                                      return noteDate.difference(prayerTimesState.chosenDateTime).inDays == 0;
                                    })
                                    .map((note) => Padding(
                                          padding: const EdgeInsets.only(
                                            top: DistancesManager.gap3,
                                          ),
                                          child: NoteCard(note),
                                        ))
                                    .toList(),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: DistancesManager.gap3),
                if (state is AdsLoadingSuccessState)
                  ImageSlideshow(
                    height: 80,
                    autoPlayInterval: 5000,
                    isLoop: true,
                    indicatorBackgroundColor: Colors.transparent,
                    indicatorColor: Colors.transparent,
                    children: state.adsList.data
                        .where((element) => element.place == "3")
                        .map(
                          (ad) => Padding(
                            padding: const EdgeInsets.only(bottom: DistancesManager.gap3),
                            child: AdBanner(
                              image: ad.imageUrl,
                              url: ad.link,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                // if (state is AdsLoadingSuccessState)
                //   ...state.adsList.data
                //       .skip(2)
                //       .map(
                //         (ad) => Padding(
                //       padding: const EdgeInsets.only(
                //           bottom: DistancesManager.gap3),
                //       child: AdBanner(
                //         image: ad.imageUrl,
                //         url: ad.link,
                //       ),
                //     ),
                //   )
                //       .toList()
              ],
            ),
          ),
        );
      },
    );
  }
}
