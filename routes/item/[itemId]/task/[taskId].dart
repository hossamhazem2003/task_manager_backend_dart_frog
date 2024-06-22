import 'dart:async';
import 'dart:io';
import 'package:auth/core/exception.dart';
import 'package:auth/repository/task%20repository/task_repo.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(
    RequestContext context, String itemId, String taskId,) {
  return switch (context.request.method) {
    HttpMethod.delete => deleteTask(context, taskId, itemId),
    HttpMethod.put => updateTaskById(context, taskId, itemId),
    _ => Future.value(
        Response(body: 'Bad Request', statusCode: HttpStatus.badRequest),
      ),
  };
}

Future<Response> deleteTask(
  RequestContext context,
  String taskId,
  String itemId,
) async {
  try {
    final taskRepository = context.read<TaskRepository>();
    await taskRepository.deleteTaskById(taskId, itemId);
    return Response.json(
      body: {
        'message': 'Task deleted successfully',
      },
    );
  } catch (e) {
    return Response.json(
      body: {'message': e.toString()},
      statusCode: HttpStatus.internalServerError,
    );
  }
}

Future<Response> updateTaskById(
  RequestContext context,
  String taskId,
  String itemId,
) async {
  try {
    final taskRepository = context.read<TaskRepository>();
    final json = (await context.request.json()) as Map<String, dynamic>;
    final isDone = json['isDone'] as bool?;

    if (isDone == null) {
      return Response.json(
      statusCode: HttpStatus.notAcceptable,
      body: {
        'message': Exceptions.allParametarsRequired,
      },);
    }

    await taskRepository.updateTaskbyId(taskId, isDone, itemId);
    return Response.json(
      body: {
        'message': 'Task updated successfully',
      },
    );
  } catch (e) {
    return Response.json(
      body: {'message': e.toString()},
      statusCode: HttpStatus.internalServerError,
    );
  }
}
