import '../../../../notes_screen/data/models/note_model.dart';
import '../../../data/models/holiday_times_model.dart';

abstract class HolidayTimesState {}

class HolidayTimesLoadingInProgress extends HolidayTimesState {}

class HolidayTimesLoadingSuccess extends HolidayTimesState {
  final HolidayTimesModel holidayTimesModel;
  final List<NoteModel> noteModel;
  HolidayTimesLoadingSuccess(this.holidayTimesModel, this.noteModel);
}

class HolidayTimesLoadingFail extends HolidayTimesState {}
