// ignore_for_file: avoid_positional_boolean_parameters

import 'package:auth/core/mogodb_manage.dart';
import 'package:auth/models/tasks/task_model.dart';
import 'package:mongo_dart/mongo_dart.dart';

class TaskRepository {
  Future<TaskModel> addTask(String itemId, String taskDescription, bool isDone,
      int numOfHours, String createdAt,) async {
    final db = await DataBase.createDb();
    final taskId = const Uuid().v1();
    final tasksCollection = db.collection('tasks');

    final task = TaskModel(
      itemId: itemId,
      taskId: taskId,
      taskDescription: taskDescription,
      createdAt: createdAt,
      isDone: isDone,
      numOfHours: numOfHours,
    );

    await tasksCollection.insertOne(task.toJson());
    await db.close();
    return task;
  }

  Future<List<Map<String, dynamic>>> getTasksByItemId(String itemId) async {
    final db = await DataBase.createDb();
    final tasksCollection = db.collection('tasks');
    final tasks =
        await tasksCollection.find(where.eq('itemId', itemId)).toList();
    await db.close();
    return tasks;
  }

  Future<void> deleteAllTasks(String itemId) async {
    final db = await DataBase.createDb();
    final tasksCollection = db.collection('tasks');
    await tasksCollection.deleteMany(where.eq('itemId', itemId));
    await db.close();
  }

  Future<Map<String, dynamic>?> updateTaskbyId(
      String taskId, bool isDone, String itemId) async {
    final db = await DataBase.createDb();
    final tasksCollection = db.collection('tasks');
    final result = await tasksCollection.updateOne(
      where.eq('taskId', taskId).and(where.eq('itemId', itemId)),
      modify.set('isDone', isDone),
    );
    final upatedTask = result.document;
    await db.close();
    return upatedTask;
  }

  Future<void> deleteTaskById(String taskId,String itemId) async{
  final db = await DataBase.createDb();
  final tasksCollection = db.collection('tasks');
  await tasksCollection.remove(where.eq('taskId', taskId).and(where.eq('itemId', itemId)));
  await db.close();
}

}
