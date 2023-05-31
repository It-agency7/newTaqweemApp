import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../../core/controllers/main_cubit/main_cubit.dart';
import '../../../../../core/helpers/cache_helper.dart';
import '../../../../../core/routes/routes_manager.dart';
import '../../../../../core/service/service_locator.dart';
import '../../../../../core/utils/color_manager.dart';

class NotesAddButton extends StatelessWidget {
  const NotesAddButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mainCubit = context.read<MainCubit>();
    return TextButton.icon(
      onPressed: () {
        if (sl<TaqwimPref>().getToken() == null) {
          mainCubit.showBottomSheet(context);
        } else {
          Get.toNamed(RoutesManager.addNote);
        }
      },
      icon: const Icon(Icons.add_circle),
      label: Text(
        "addnote".tr,
        style: TextStyle(
          fontWeight: FontWeight.normal,
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: ColorManager.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}
