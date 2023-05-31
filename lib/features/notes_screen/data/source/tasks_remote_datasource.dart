import '../../../../core/client/dio_client.dart';
import '../../../../core/client/endpoints.dart';
import '../models/task_model.dart';

class TasksRemoteDataSource {
  final DioClient _dioClient;
  TasksRemoteDataSource(this._dioClient);

  Future<List<TaskModel>> showAllTasks() async {
    final response = await _dioClient.get(path: Endpoints.tasksEP);
    final tasks = response.data['data'] as List;
    return tasks.map((task) => TaskModel.fromJson(task)).toList();
  }

  Future<TaskModel> createTask(TaskModel task) async {
    final response = await _dioClient.post(
      path: Endpoints.tasksEP,
      data: task.toJson(),
    );
    return TaskModel.fromJson(response.data);
  }

  //************* NOT WORK *****************/
  Future<TaskModel> updateTask(TaskModel task) async {
    final response = await _dioClient.put(
      path: '${Endpoints.tasksEP}/change-status',
      data: {
        "task_id": int.parse(task.id),
        'status': task.isFinished ? 1 : 2,
      },
    );
    return TaskModel.fromJson(response.data);
  }

  Future<void> deleteTask(String id) async {
    await _dioClient.delete(path: '${Endpoints.tasksEP}/$id');
  }
}
