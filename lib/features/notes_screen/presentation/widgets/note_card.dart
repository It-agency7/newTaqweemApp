import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taqwim/features/notes_screen/presentation/screens/note_details_screen.dart';

import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/styles_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../data/models/note_model.dart';

class NoteCard extends StatelessWidget {
  final NoteModel note;
  final bool showDetails;
  final bool onlyNotes;
  const NoteCard(
    this.note, {
    super.key,
    this.showDetails = false,
    this.onlyNotes = false,
  });

  @override
  Widget build(BuildContext context) {
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
          color: ColorManager.secondary,
          child: InkWell(
            onTap: showDetails
                ? null
                : () {
                    Get.to(
                      () => NoteDetailsScreen(note: note),
                      transition: Transition.fadeIn,
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
                    // style: const TextStyle(color: ColorManager.white),
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
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.access_time_rounded,
                        size: 10,
                      ),
                      const SizedBox(width: DistancesManager.gap1),
                      Text(
                        note.time.substring(0, 5),
                        style: const TextStyle(
                          fontSize: 10,
                        ),
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
