import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/get_utils.dart';
import '../../controller/notes_cubit/notes_cubit.dart';

class NotesSortButton extends StatefulWidget {
  const NotesSortButton({
    super.key,
  });

  @override
  State<NotesSortButton> createState() => _NotesSortButtonState();
}

class _NotesSortButtonState extends State<NotesSortButton> {
  var _ascending = false;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        setState(() {
          _ascending = !_ascending;
        });
        BlocProvider.of<NotesCubit>(context).sort(_ascending);
      },
      icon: Icon(
          _ascending ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
      label: Text(
        "date".tr,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
