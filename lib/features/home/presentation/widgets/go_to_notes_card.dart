import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/routes/routes_manager.dart';
import '../../../../core/utils/styles_manager.dart';

import '../../../../core/utils/values_manager.dart';

class GoToNotesCard extends StatelessWidget {
  const GoToNotesCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorManager.secondary,
      borderRadius: BorderRadius.circular(
        DistancesManager.cardBorderRadius,
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => Get.toNamed(RoutesManager.notes),
        child: Container(
          width: double.infinity,
          height: 100,
          padding: const EdgeInsets.all(DistancesManager.gap2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "ملاحظاتك",
                    style: TextStylesManager.cardTitle,
                  ),
                  Text(
                    "اعرض الملاحظات التي قمت بتدوينها",
                  ),
                ],
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: ColorManager.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
