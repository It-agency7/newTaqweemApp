import 'package:taqwim/features/notes_screen/data/models/task_model.dart';

import '../../../../core/client/dio_client.dart';
import '../../../../core/client/endpoints.dart';
import '../models/note_model.dart';

class NotesRemoteDataSource {
  final DioClient _dioClient;
  NotesRemoteDataSource(this._dioClient);

  Future<List<NoteModel>> showAllNotes() async {
    final response = await _dioClient.get(path: Endpoints.notesEP);
    if (response.statusCode == 200) {
      final notes = response.data['data']["data"] as List;
      return notes.map((note) => NoteModel.fromJson(note)).toList();
    } else {
      throw Exception('Failed to load notes');
    }
  }

  Future<void> createNewNote({
    required String title,
    required String date,
    required String time,
    required String description,
    required List<String> tasks,
  }) async {
    final body = {
      'title': title,
      'date': date,
      'time': time,
      'notes': description,
      'tasks_names': tasks.join(","),
    };
    final response = await _dioClient.post(
      path: Endpoints.notesEP,
      data: body,
    );
    if (response.statusCode == 200) {
      final note = response.data['data'];
    } else {
      throw Exception('Failed to create note');
    }
  }

  Future<NoteModel> updateNote({
    required String id,
    required String title,
    required String date,
    required String time,
    required String description,
  }) async {
    final body = {
      'title': title,
      'date': date,
      'time': time,
      'description': description,
    };
    final response = await _dioClient.put(
      path: '${Endpoints.notesEP}/$id',
      data: body,
    );
    if (response.statusCode == 200) {
      final note = response.data['data'];
      return NoteModel.fromJson(note);
    } else {
      throw Exception('Failed to update note');
    }
  }

  Future<void> deleteNote({
    required String id,
  }) async {
    final response = await _dioClient.delete(
      path: '${Endpoints.notesEP}/$id',
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete note');
    }
  }
}
