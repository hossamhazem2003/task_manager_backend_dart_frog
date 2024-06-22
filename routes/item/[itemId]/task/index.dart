import 'dart:async';
import 'dart:io';

import 'package:auth/core/exception.dart';
import 'package:auth/repository/task%20repository/task_repo.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(
  RequestContext context,
  String itemId,
) {
  return switch (context.request.method) {
    HttpMethod.post => addTasks(context, itemId),
    HttpMethod.get => getTasks(context, itemId),
    HttpMethod.delete => deleteAllTasks(context, itemId),
    _ => Future.value(
        Response(body: 'bad request', statusCode: HttpStatus.badRequest),
      )
  };
}

Future<Response> addTasks(RequestContext context, String itemId) async {
  try {
    final taskRepository = context.read<TaskRepository>();
    final json = (await context.request.json()) as Map<String, dynamic>;
    final taskDescription = json['taskDescription'] as String?;
    final isDone = json['isDone'] as bool?;
    final numOfHours = json['numOfHours'] as int?;
    final createdAt = json['createdAt'] as String?;

    if (taskDescription == null ||
        isDone == null ||
        numOfHours == null ||
        createdAt == null) {
      return Response.json(
        body: {
          'message': Exceptions.allParametarsRequired,
        },
      );
    }

    final task = await taskRepository.addTask(
      itemId,
      taskDescription,
      isDone,
      numOfHours,
      createdAt,
    );
    return Response.json(
      body: {
        'message': 'Task added succesfully',
        'task': task.toJson(),
      },
    );
  } catch (e) {
    return Response.json(
    statusCode: HttpStatus.internalServerError,
    body: {'message': e.toString()},);
  }
}

Future<Response> getTasks(RequestContext context, String itemId) async {
  try {
    final taskRepository = context.read<TaskRepository>();
    final tasks = await taskRepository.getTasksByItemId(itemId);
    if (tasks.isEmpty) {
      return Response(body: 'No tasks yet');
    }

    return Response.json(body: {'tasks': tasks});
  } catch (e) {
    return Response.json(body: {'message': e.toString()});
  }
}

Future<Response> deleteAllTasks(RequestContext context, String itemId) async {
  try {
    final taskRepository = context.read<TaskRepository>();
    await taskRepository.deleteAllTasks(itemId);
    return Response.json(body: {'message': 'All tasks deleted successfully'});
  } catch (e) {
    return Response.json(
    statusCode: HttpStatus.internalServerError,
    body: {'message': e.toString()},);
  }
}
