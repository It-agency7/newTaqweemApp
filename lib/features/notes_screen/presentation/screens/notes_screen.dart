import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';
import '../../../../core/helpers/cache_helper.dart';
import '../../../../core/service/service_locator.dart';
import '../../../../core/utils/styles_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../../core/widgets/no_internet_connection.dart';
import '../../data/repos/notes_repo.dart';
import '../controller/notes_cubit/notes_cubit.dart';
import '../controller/notes_cubit/notes_cubit_states.dart';
import '../widgets/note_card.dart';
import '../widgets/notes_controls/notes_controls.dart';
import '../../../../core/widgets/app_bottom_navigation_bar/app_bottom_navigation_bar.dart';
import '../../../../core/widgets/app_top_bar.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

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
      bottomNavigationBar: AppBottomNavigationBar(1),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool isConnected = connectivity != ConnectivityResult.none;
          if (isConnected) {
            return NotesBodyWidget(runtimeType: runtimeType);
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

class NotesBodyWidget extends StatelessWidget {
  const NotesBodyWidget({
    super.key,
    required this.runtimeType,
  });

  @override
  final Type runtimeType;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesCubit, NotesState>(
      builder: (context, state) {
        var itemCount = 2;
        if (state is NotesLoadingSuccess && state.notes.isNotEmpty) {
          itemCount = state.notes.length + 1;
        }
        return ListView.builder(
          padding: const EdgeInsets.all(
            DistancesManager.screenPadding,
          ),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            if (index == 0) {
              return const NotesControls();
            } else if (state is NotesLoadingInProgress) {
              return Container(
                height: 400,
                alignment: Alignment.center,
                child: const CircularProgressIndicator.adaptive(),
              );
            } else if (state is NotesLoadingFail) {
              return Container(
                height: 400,
                alignment: Alignment.center,
                child: (sl<TaqwimPref>().getToken()?.isNotEmpty ?? false)
                    ? Text(
                        'no_note_in_current_time'.tr,
                      )
                    : Text(
                        'must_login'.tr,
                        textAlign: TextAlign.center,
                      ),
              );
            } else if (state is NotesLoadingSuccess && state.notes.isEmpty) {
              return Container(
                height: 400,
                alignment: Alignment.center,
                child: Text(
                  "empty".tr,
                  style: TextStylesManager.centralScreen,
                ),
              );
            } else if (state is NotesLoadingSuccess && state.notes.isNotEmpty) {
              final note = state.notes[index - 1];
              return Padding(
                padding: const EdgeInsets.only(top: DistancesManager.gap3),
                child: NoteCard(note),
              );
            }
            return Text("Unhandeled State: ${state.runtimeType}");
          },
        );
      },
    );
  }
}
