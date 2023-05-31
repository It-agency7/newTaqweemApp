import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/values_manager.dart';
import '../../controller/notes_cubit/notes_cubit.dart';

class NotesSearchBar extends StatefulWidget {
  const NotesSearchBar({
    super.key,
  });

  @override
  State<NotesSearchBar> createState() => _NotesSearchBarState();
}

class _NotesSearchBarState extends State<NotesSearchBar> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: DistancesManager.gap2,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: Colors.grey,
          ),
          const SizedBox(width: DistancesManager.gap1),
          SizedBox(
            width: 60,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                hintText: "date".tr,
                border: InputBorder.none,
              ),
              onChanged: (searchText) {
                BlocProvider.of<NotesCubit>(context).searchNotes(
                  searchText.trim(),
                );
              },
              onTap: () {
                setState(() {});
                final cursorPosition = controller.selection.baseOffset + 1;
                controller.text =
                    "${Directionality.of(context) == TextDirection.rtl ? controller.text.trimRight() : controller.text.trimLeft()} ";
                controller.selection = TextSelection.collapsed(
                  offset: min(cursorPosition, controller.text.length),
                );
              },
              onTapOutside: (event) {
                controller.text =
                    Directionality.of(context) == TextDirection.rtl
                        ? controller.text.trimRight()
                        : controller.text.trimLeft();
                FocusScope.of(context).unfocus();
                setState(() {});
              },

            ),
          ),
          //const SizedBox(width: DistancesManager.gap1),
          IconButton(
            onPressed: () {
              controller.clear();
              BlocProvider.of<NotesCubit>(context).searchNotes("");
            },
            icon: const Icon(
              Icons.clear,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
