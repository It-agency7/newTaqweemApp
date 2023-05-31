import '../../../notes_screen/data/models/note_model.dart';
import '../models/holiday_times_model.dart';
import '../src/holidays_remote_datasource.dart';

class HolidayTimesRepository {
  final HolidaysRemoteDataSource _holidaysRemoteDataSource;

  HolidayTimesRepository(this._holidaysRemoteDataSource);
  Future<HolidayTimesModel> getAllHolidays() async {
    return await _holidaysRemoteDataSource.getAllHolidays();
  }

  Future<List<NoteModel>> getServerNotes() async {
    return await _holidaysRemoteDataSource.getServerNotes();
  }
}
