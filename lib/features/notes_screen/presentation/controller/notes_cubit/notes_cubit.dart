import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taqwim/features/notes_screen/data/models/task_model.dart';
import 'package:taqwim/features/notes_screen/data/repos/tasks_repo.dart';
import '../../../data/models/note_model.dart';
import '../../../data/repos/notes_repo.dart';
import 'notes_cubit_states.dart';

class NotesCubit extends Cubit<NotesState> {
  final NotesRepo _notesRepo;
  final TasksRepo _tasksRepo;
  var _initialLoad = true;
  List<NoteModel> _loadedNotes = [];

  NotesCubit(this._notesRepo, this._tasksRepo)
      : super(NotesLoadingInProgress()) {
    loadNotes();
  }

  void loadNotes() async {
    if (!_initialLoad) {
      emit(NotesLoadingInProgress());
    } else {
      _initialLoad = false;
    }

    try {
      _loadedNotes = await _notesRepo.showAllNotes();

      _loadedNotes.sort((note1, note2) {
        return -note1.date.compareTo(note2.date);
      });

      emit(NotesLoadingSuccess(_loadedNotes));
    } catch (e) {
      developer.log('$e');
      emit(NotesLoadingFail(e.toString()));
    }
  }

  void searchNotes(String searchText) async {
    if (searchText.trim().isEmpty) {
      emit(NotesLoadingSuccess(_loadedNotes));
      return;
    }

    emit(NotesLoadingInProgress());

    final tokens = searchText.split(" ");

    var notes = _loadedNotes.where((note) {
      for (final token in tokens) {
        if (token.isEmpty) continue;

        if (note.title.contains(token)) {
          return true;
        }

        if (note.description.contains(token)) {
          return true;
        }

        for (final task in note.tasks) {
          if (task.title.contains(token)) {
            return true;
          }
        }
      }
      return false;
    }).toList();

    emit(NotesLoadingSuccess(notes));
  }

  void createNewNote({
    required String title,
    required String date,
    required String time,
    required String description,
    required List<String> tasks,
  }) async {
    emit(NotesAddInProgress(_loadedNotes));

    try {
      await _notesRepo.createNewNote(
        title: title,
        date: date,
        time: time,
        description: description,
        tasks: tasks,
      );
      emit(NotesAddSuccess(_loadedNotes));
      loadNotes();
    } catch (e) {
      developer.log('$e');
      emit(NotesAddFail(_loadedNotes, e.toString()));
    }
  }

  void deleteNote(int noteId) async {
    emit(NotesDeleteInProgress(_loadedNotes));
    try {
      await _notesRepo.deleteNote(id: noteId.toString());
      _loadedNotes.removeWhere((note) => note.id == noteId);
      emit(NotesDeleteSuccess(_loadedNotes));
    } catch (e) {
      developer.log('$e');
      emit(NotesDeleteFail(_loadedNotes, e.toString()));
    }
  }

  void updateTask({required TaskModel newTask}) async {
    try {
      await _tasksRepo.updateTask(newTask);
    } catch (e) {
      developer.log('$e');
    }
  }

  void sort(bool ascending) async {
    emit(NotesLoadingInProgress());

    _loadedNotes.sort((note1, note2) {
      final comparisonResult = note1.date.compareTo(
        note2.date,
      );
      return ascending ? comparisonResult : -comparisonResult;
    });
      _loadedNotes = _loadedNotes.reversed.toList();
    emit(NotesLoadingSuccess(_loadedNotes));
  }
}
