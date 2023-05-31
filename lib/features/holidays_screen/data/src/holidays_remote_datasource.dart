import 'dart:developer';
import '../../../../core/client/dio_client.dart';
import '../../../notes_screen/data/models/note_model.dart';
import '../models/holiday_times_model.dart';
import '../../../../core/client/endpoints.dart';


class HolidaysRemoteDataSource {
  final DioClient _dioClient;

  HolidaysRemoteDataSource(this._dioClient);

  Future<HolidayTimesModel> getAllHolidays() async {
    final response = await _dioClient.get(path: Endpoints.holidaysEP);
    // final json = jsonDecode(response.data);
    if (response.statusCode == 200) {
      final model = HolidayTimesModel.fromJson(response.data);
      log('HOLIDAYS MODEL: $model.statusCode = ${response.statusCode}.statusCode');
      return model;
    } else {
      throw Exception('Failed to load holidays: ${response.statusCode}');
    }
  }

  Future<List<NoteModel>> getServerNotes() async {
    final response = await _dioClient.get(path: Endpoints.serverNotes);
    List<NoteModel> notes = [];
    if (response.statusCode == 200) {
      final json = response.data;
      for (var item in json['data']['data']) {
        notes.add(NoteModel.fromJson(item));
      }
      return notes;
    } else {
      throw Exception('Failed to load notes: ${response.statusCode}');
    }
  }
}
