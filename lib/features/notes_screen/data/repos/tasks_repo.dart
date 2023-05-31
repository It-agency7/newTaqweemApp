import '../source/tasks_remote_datasource.dart';

import '../models/task_model.dart';

class TasksRepo {
  final TasksRemoteDataSource _tasksRemoteDataSource;
  TasksRepo(this._tasksRemoteDataSource);

  Future<List<TaskModel>> showAllTasks() async {
    return await _tasksRemoteDataSource.showAllTasks();
  }

  Future<TaskModel> createTask(TaskModel task) async {
    return await _tasksRemoteDataSource.createTask(task);
  }

  Future<TaskModel> updateTask(TaskModel task) async {
    return await _tasksRemoteDataSource.updateTask(task);
  }

  Future<void> deleteTask(String id) async {
    return await _tasksRemoteDataSource.deleteTask(id);
  }
}
