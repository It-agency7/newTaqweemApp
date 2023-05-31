import 'package:bloc/bloc.dart';
import '../../../data/repo/holiday_times_repo.dart';
import 'holiday_times_states.dart';

class HolidayTimesCubit extends Cubit<HolidayTimesState> {
  final HolidayTimesRepository _holidayTimesRepository;

  HolidayTimesCubit(this._holidayTimesRepository) : super(HolidayTimesLoadingInProgress()) {
    _loadHolidayTimes();
  }

  void _loadHolidayTimes() async {
    final holidayTimes = await _holidayTimesRepository.getAllHolidays();
    final noteModel = await _holidayTimesRepository.getServerNotes();
    emit(HolidayTimesLoadingSuccess(holidayTimes, noteModel));
  }
}
