import '../../../data/models/note_model.dart';

abstract class NotesState {}

class NotesLoadingInProgress extends NotesState {}

class NotesLoadingFail extends NotesState {
  final String message;

  NotesLoadingFail(this.message);
}

class NotesLoadingSuccess extends NotesState {
  final List<NoteModel> notes;

  NotesLoadingSuccess(this.notes);
}

class NotesAddInProgress extends NotesLoadingSuccess {
  NotesAddInProgress(super.notes);
}

class NotesAddSuccess extends NotesLoadingSuccess {
  NotesAddSuccess(super.notes);
}

class NotesAddFail extends NotesLoadingSuccess {
  final String message;
  NotesAddFail(super.notes, this.message);
}

class NotesDeleteInProgress extends NotesLoadingSuccess {
  NotesDeleteInProgress(super.notes);
}

class NotesDeleteSuccess extends NotesLoadingSuccess {
  NotesDeleteSuccess(super.notes);
}

class NotesDeleteFail extends NotesLoadingSuccess {
  final String message;
  NotesDeleteFail(super.notes, this.message);
}
