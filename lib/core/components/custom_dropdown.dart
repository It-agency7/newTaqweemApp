import 'package:flutter/material.dart';

import '../utils/color_manager.dart';
import '../utils/icon_broken.dart';

class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    super.key,
    required this.initialValue,
    this.onChanged,
    required this.items,
  });

  final String initialValue;
  final Function(String?)? onChanged;
  final List<DropdownMenuItem<String>> items;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: initialValue,
      items: items,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(color: ColorManager.primary),
      onChanged: onChanged,
      icon: const Icon(
        IconBroken.Arrow_Down_2,
        color: ColorManager.primary,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: ColorManager.lightGrey,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      ),
    );
  }
}
