import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/styles_manager.dart';
import '../../../../../core/utils/values_manager.dart';

import 'notes_add_button.dart';
import 'notes_search_bar.dart';
import 'notes_sort_button.dart';

class NotesControls extends StatelessWidget {
  const NotesControls({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "notes".tr,
              style: TextStylesManager.headline,
            ),
            NotesAddButton(),
          ],
        ),
        const SizedBox(height: DistancesManager.gap5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            NotesSearchBar(),
            NotesSortButton(),
          ],
        )
      ],
    );
  }
}
