import 'package:taqwim/features/notes_screen/data/models/task_model.dart';

import '../models/note_model.dart';
import '../source/notes_remote_datasource.dart';

class NotesRepo {
  final NotesRemoteDataSource noteDataSource;

  NotesRepo(this.noteDataSource);

  //************* RETRIEVE ALL NOTES *****************/
  Future<List<NoteModel>> showAllNotes() async {
    final notes = await noteDataSource.showAllNotes();
    return notes;
  }

  //************* CREATE NEW NOTE *****************/
  Future<void> createNewNote({
    required String title,
    required String date,
    required String time,
    required String description,
    required List<String> tasks,
  }) async {
    await noteDataSource.createNewNote(
      title: title,
      date: date,
      time: time,
      description: description,
      tasks: tasks,
    );
  }

  //************* UPDATE NOTE *****************/
  Future<NoteModel> updateNote({
    required String id,
    required String title,
    required String date,
    required String time,
    required String description,
    required List<TaskModel> tasks,
  }) async {
    final note = await noteDataSource.updateNote(
      id: id,
      title: title,
      date: date,
      time: time,
      description: description,
    );
    return note;
  }

  //************* DELETE NOTE *****************/
  Future<void> deleteNote({
    required String id,
  }) async {
    await noteDataSource.deleteNote(
      id: id,
    );
  }
}
