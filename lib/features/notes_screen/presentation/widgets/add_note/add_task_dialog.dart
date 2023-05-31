import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/color_manager.dart';
import '../../../../../core/utils/strings_manager.dart';
import '../../../../../core/utils/values_manager.dart';

class AddTaskDialog extends StatelessWidget {
  final Function(String task) onSave;
  AddTaskDialog({
    super.key,
    required this.onSave,
  });

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(
          DistancesManager.screenPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${StringsManager.add.tr} ${StringsManager.task.tr}",
              style: const TextStyle(fontSize: 25),
            ),
            TextField(
              controller: controller,
              decoration:
                  InputDecoration(hintText: StringsManager.taskTitle.tr),
            ),
            const SizedBox(height: DistancesManager.gap4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    onSave(controller.text);
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: ColorManager.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(StringsManager.save.tr),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: ColorManager.primary,
                    backgroundColor: Colors.white,
                  ),
                  child: Text(StringsManager.cancel.tr),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
