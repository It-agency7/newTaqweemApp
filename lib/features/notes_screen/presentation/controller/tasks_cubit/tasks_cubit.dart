import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/task_model.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(TasksInitial());
}
