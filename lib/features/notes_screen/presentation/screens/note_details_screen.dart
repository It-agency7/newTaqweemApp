import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:taqwim/core/routes/routes_manager.dart';
import 'package:taqwim/core/utils/color_manager.dart';
import 'package:taqwim/core/utils/strings_manager.dart';
import 'package:taqwim/core/utils/styles_manager.dart';
import 'package:taqwim/core/utils/values_manager.dart';
import 'package:taqwim/core/widgets/app_bottom_navigation_bar/app_bottom_navigation_bar.dart';
import 'package:taqwim/core/widgets/app_top_bar.dart';
import 'package:taqwim/features/notes_screen/data/models/note_model.dart';
import 'package:taqwim/features/notes_screen/data/models/task_model.dart';
import 'package:taqwim/features/notes_screen/presentation/controller/notes_cubit/notes_cubit.dart';
import 'package:taqwim/features/notes_screen/presentation/controller/notes_cubit/notes_cubit_states.dart';
import 'package:taqwim/features/notes_screen/presentation/widgets/note_card.dart';
import 'package:collection/collection.dart';

class NoteDetailsScreen extends StatefulWidget {
  final NoteModel note;
  const NoteDetailsScreen({super.key, required this.note});

  @override
  State<NoteDetailsScreen> createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  late NoteModel note;
  @override
  void initState() {
    note = widget.note;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('EEEE');
    final DateTime timeWill = DateTime.parse(note.date).add(Duration(
        hours: (int.parse(note.time[0] + note.time[1])),
        minutes: int.parse(note.time[3] + note.time[4])));
    return Scaffold(
      appBar: TopAppBar(showBackButton: true),
      bottomNavigationBar: AppBottomNavigationBar(1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(DistancesManager.screenPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(
                  DistancesManager.cardBorderRadius,
                ),
                color: ColorManager.secondary,
                child: InkWell(
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
                              style: const TextStyle(
                                  fontSize: 20, color: ColorManager.primary),
                            ),
                            if (DateTime.now().isAfter(timeWill))
                              const Icon(
                                Icons.notifications_active,
                                color: Colors.green,
                                size: 20,
                              ),
                          ],
                        ),
                        Text(
                          note.description
                              .replaceFirst('<p>', '')
                              .replaceAll('</p>', ''),
                        ),
                        const SizedBox(height: DistancesManager.gap1),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${formatter.format(DateTime.parse(note.date)).tr} - ${note.date}",
                                style: const TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            const Icon(Icons.access_time_rounded, size: 10),
                            const SizedBox(width: DistancesManager.gap1),
                            Text(
                              note.time.substring(0, 5),
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        if (note.tasks.isNotEmpty) ...[
                          15.ph,
                          Material(
                            clipBehavior: Clip.hardEdge,
                            borderRadius: BorderRadius.circular(
                              DistancesManager.cardBorderRadius,
                            ),
                            color: ColorManager.secondary,
                            child: Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.all(DistancesManager.gap2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    "المهام",
                                    style: TextStylesManager.cardTitle,
                                  ),
                                  ...note.tasks
                                      .mapIndexed(
                                        (index, task) => Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Divider(
                                                color: ColorManager.primary),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(task.title),
                                                Checkbox(
                                                  value: task.isFinished,
                                                  onChanged: (isFinished) {
                                                    final newTask =
                                                        task.copyWith(
                                                      isFinished: isFinished,
                                                    );
                                                    setState(() {
                                                      note.tasks[index] =
                                                          newTask;
                                                    });
                                                    BlocProvider.of<NotesCubit>(
                                                            context)
                                                        .updateTask(
                                                            newTask: newTask);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              15.ph,
              BlocConsumer<NotesCubit, NotesState>(
                listener: (context, state) {
                  if (state is NotesDeleteSuccess) {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      title: 'تم بنجاح',
                      text: '',
                      confirmBtnText: StringsManager.okay.tr,
                      confirmBtnColor: ColorManager.primary,
                    ).then((value) {
                      Get.back();
                    });
                  } else if (state is NotesDeleteFail) {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      title: 'حدث خطأ ما',
                      text: '',
                      confirmBtnText: StringsManager.okay.tr,
                      confirmBtnColor: Colors.red,
                    );
                  }
                },
                builder: (context, state) {
                  return TextButton.icon(
                    onPressed: state is NotesDeleteInProgress
                        ? null
                        : () {
                            BlocProvider.of<NotesCubit>(context)
                                .deleteNote(note.id);
                          },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    label: const Text("حذف الملاحظة"),
                    icon: const Icon(Icons.delete),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
