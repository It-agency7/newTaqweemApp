import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:get/get.dart';
import 'package:hijri_picker/hijri_picker.dart';
import 'package:quickalert/quickalert.dart';
import 'package:taqwim/core/controllers/main_cubit/main_cubit.dart';
import 'package:taqwim/core/helpers/notification_helper.dart';
import 'package:taqwim/core/routes/routes_manager.dart';
import 'package:taqwim/core/utils/constant_manager.dart';
import 'package:taqwim/features/notes_screen/data/models/task_model.dart';
import 'package:taqwim/features/notes_screen/presentation/controller/notes_cubit/notes_cubit.dart';
import 'package:taqwim/features/notes_screen/presentation/controller/notes_cubit/notes_cubit_states.dart';
import '../../../../core/localization/change_locale.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/strings_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../../core/widgets/app_bottom_navigation_bar/app_bottom_navigation_bar.dart';
import '../../../../core/widgets/app_top_bar.dart';
import 'package:collection/collection.dart';
import "package:hijri/hijri_calendar.dart";
import '../widgets/add_note/add_task_dialog.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  var isHijri = false;

  final titleController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  Duration? selectedAlarmTime;
  List<String> tasks = [];
  var activateAlarm = false;
  final detailsController = TextEditingController();

  final dateController = TextEditingController();
  final timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(showBackButton: true),
      bottomNavigationBar: AppBottomNavigationBar(1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(DistancesManager.screenPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${StringsManager.add.tr} ${StringsManager.yourNote.tr.toLowerCase()}",
                  style: const TextStyle(fontSize: 25),
                ),
                const SizedBox(height: DistancesManager.gap2),
                // Title
                Text(
                  StringsManager.title.tr,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: "${StringsManager.choose.tr} ${StringsManager.title.tr.toLowerCase()}",
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return StringsManager.fieldRequired.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: DistancesManager.gap5),
                // Date
                Text(
                  StringsManager.date.tr,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  controller: dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "${StringsManager.choose.tr} ${StringsManager.date.tr.toLowerCase()}",
                    suffixIcon: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        items: [
                          DropdownMenuItem(
                            value: false,
                            child: Text(StringsManager.georgian.tr),
                          ),
                          DropdownMenuItem(
                            value: true,
                            child: Text(StringsManager.hijri.tr),
                          ),
                        ],
                        value: isHijri,
                        onChanged: (isHijri) {
                          setState(() {
                            this.isHijri = isHijri ?? this.isHijri;
                          });
                        },
                      ),
                    ),
                  ),
                  onTap: () async {
                    final initialDate = DateTime.now();
                    final firstDate = initialDate.subtract(const Duration(days: 365 * 10));
                    final lastDate = initialDate.add(const Duration(days: 365 * 10));
                    final locale = Get.find<LocaleController>().language;

                    if (isHijri) {
                      final hijriDate = await showHijriDatePicker(
                        context: context,
                        initialDate: HijriCalendar.fromDate(initialDate),
                        firstDate: HijriCalendar.fromDate(firstDate),
                        lastDate: HijriCalendar.fromDate(lastDate),
                        locale: locale,
                      );
                      if (hijriDate == null) return;
                      selectedDate = hijriDate.hijriToGregorian(
                        hijriDate.hYear,
                        hijriDate.hMonth,
                        hijriDate.hDay,
                      );
                    } else {
                      // DateTime? finalGeorgianDate = await showDatePicker(
                      //   context: context,
                      //   initialDate: initialDate,
                      //   firstDate: firstDate,
                      //   lastDate: lastDate,
                      //   locale: locale,
                      // );
                      String day = MainCubit.get(context).startDay;
                      int dayNum = ConstantsManager().getDayNumber(day);
                      print(dayNum);
                      final georgianDate = await showRoundedDatePicker(
                          context: context,
                          initialDate: initialDate,
                          firstDate: firstDate,
                          lastDate: lastDate,
                          locale: locale,
                          // selectableDayPredicate: (initialDate) {
                          //   if(initialDate.weekday == dayNum){
                          //     return true;
                          //   }else{
                          //     return true;
                          //   }
                          // },
                          builderDay: (DateTime dateTime, bool isCurrentDay, bool isSelected, TextStyle defaultTextStyle) {
                            if (isCurrentDay) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Center(
                                    child: Text(
                                      dateTime.day.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } else if (isSelected) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Center(
                                    child: Text(
                                      dateTime.day.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    dateTime.day.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }
                          });
                      if (georgianDate == null) return;
                      selectedDate = georgianDate;
                    }

                    if (selectedDate != null) {
                      dateController.text = Formatters.formatDate(
                        date: selectedDate!,
                        hijri: isHijri,
                        // weekName: false,
                      );
                    }
                  },
                  validator: (value) {
                    if (selectedDate == null) {
                      return StringsManager.fieldRequired.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: DistancesManager.gap5),
                // Time
                Text(
                  StringsManager.time.tr,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  controller: timeController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "${StringsManager.add.tr} ${StringsManager.time.tr.toLowerCase()}",
                  ),
                  onTap: () async {
                    final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                    if (time == null) return;
                    selectedTime = time;
                    // ignore: use_build_context_synchronously
                    timeController.text = selectedTime!.format(context);
                  },
                  validator: (value) {
                    if (selectedTime == null) {
                      return StringsManager.fieldRequired.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: DistancesManager.gap5),
                // Alarm Time
                Text(
                  StringsManager.alarmTimeOffset.tr,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButtonFormField(
                  isDense: false,
                  items: [
                    DropdownMenuItem(
                      value: const Duration(minutes: 10),
                      child: Text(StringsManager.before10minutes.tr),
                    ),
                    DropdownMenuItem(
                      value: const Duration(hours: 1),
                      child: Text(StringsManager.before1Hour.tr),
                    ),
                    DropdownMenuItem(
                      value: const Duration(days: 1),
                      child: Text(StringsManager.before1Day.tr),
                    ),
                  ],
                  value: selectedAlarmTime,
                  hint: Text("${StringsManager.add.tr} ${StringsManager.alarmTimeOffset.tr}"),
                  onChanged: (value) {
                    selectedAlarmTime = value;
                  },
                  validator: (value) {
                    if (value == null) {
                      return StringsManager.fieldRequired.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: DistancesManager.gap5),
                // Note Details
                Text(
                  StringsManager.note.tr,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  minLines: 5,
                  maxLines: null,
                  controller: detailsController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "${StringsManager.add.tr} ${StringsManager.note.tr.toLowerCase()}",
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return StringsManager.fieldRequired.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: DistancesManager.gap5),
                // Tasks
                Text(
                  StringsManager.tasks.tr,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ...tasks
                    .mapIndexed(
                      (index, task) => Padding(
                        padding: const EdgeInsets.only(top: DistancesManager.gap3),
                        child: Material(
                          clipBehavior: Clip.hardEdge,
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(
                            DistancesManager.cardBorderRadius,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: DistancesManager.gap4,
                              vertical: DistancesManager.gap2,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  task,
                                  style: const TextStyle(fontSize: 20),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      tasks.removeAt(index);
                                    });
                                  },
                                  icon: const Icon(Icons.delete),
                                  constraints: const BoxConstraints(),
                                  splashColor: ColorManager.primary,
                                  splashRadius: 40,
                                  visualDensity: VisualDensity.comfortable,
                                  padding: EdgeInsets.zero,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                const SizedBox(height: DistancesManager.gap3),
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    DistancesManager.cardBorderRadius,
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorManager.primary),
                      borderRadius: BorderRadius.circular(
                        DistancesManager.cardBorderRadius,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AddTaskDialog(
                            onSave: (task) {
                              setState(() {
                                tasks.add(task);
                              });
                            },
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(DistancesManager.gap3),
                        child: Center(
                          child: Icon(
                            Icons.add,
                            color: ColorManager.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: DistancesManager.gap5),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Switch.adaptive(
                      value: activateAlarm,
                      onChanged: (value) {
                        setState(() {
                          activateAlarm = value;
                        });
                      },
                    ),
                    Text(StringsManager.activateAlarm.tr),
                  ],
                ),
                const SizedBox(height: DistancesManager.gap5),
                BlocConsumer<NotesCubit, NotesState>(
                  listener: (context, state) {
                    if (state is NotesAddSuccess) {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        title: 'تم بنجاح',
                        text: '',
                        confirmBtnText: StringsManager.okay.tr,
                        confirmBtnColor: ColorManager.primary,
                      ).then((value) {
                        Get.offAllNamed(RoutesManager.notes);
                      });
                    } else if (state is NotesAddFail) {
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
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: state is NotesAddInProgress
                              ? null
                              : () async {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }
                                  final date =
                                      "${selectedDate?.year.toString().padLeft(0)}-${selectedDate?.month.toString().padLeft(0)}-${selectedDate?.day.toString().padLeft(0)}";
                                  final time =
                                      "${selectedTime?.hour.toString().padLeft(0)}:${selectedTime?.minute.toString().padLeft(0)}:00";
                                  BlocProvider.of<NotesCubit>(context).createNewNote(
                                    title: titleController.text,
                                    date: date,
                                    time: time,
                                    description: detailsController.text,
                                    tasks: tasks,
                                  );
                                  if (activateAlarm) {
                                    var body = "";
                                    if (detailsController.text.length > 50) {
                                      body = "${detailsController.text.substring(0, 47)}...";
                                    } else {
                                      body = detailsController.text;
                                    }

                                    final bool notificationEnabledStatus = await NotificationService.getNotificationStatus();
                                    if (notificationEnabledStatus == true) {
                                      final notificationDate = selectedDate!
                                          .add(
                                            Duration(
                                              hours: selectedTime!.hour,
                                              minutes: selectedTime!.minute,
                                            ),
                                          )
                                          .subtract(selectedAlarmTime!);
                                      NotificationService.createNotification(
                                        title: titleController.text,
                                        body: body,
                                        date: notificationDate,
                                      );
                                    }
                                  }
                                },
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: ColorManager.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              fixedSize: const Size(100, 50)),
                          child: Text(
                            StringsManager.save.tr,
                            style: const TextStyle(fontSize: 17),
                          ),
                        ),
                        TextButton(
                          onPressed: state is NotesAddInProgress
                              ? null
                              : () {
                                  Get.back();
                                },
                          style: TextButton.styleFrom(
                              foregroundColor: ColorManager.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                                side: const BorderSide(color: ColorManager.primary),
                              ),
                              fixedSize: const Size(100, 50)),
                          child: Text(
                            StringsManager.cancel.tr,
                            style: const TextStyle(fontSize: 17),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
