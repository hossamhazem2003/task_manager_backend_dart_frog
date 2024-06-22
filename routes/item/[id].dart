import 'dart:async';
import 'dart:io';

import 'package:auth/repository/items%20repository/items_repo.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) {
  return switch (context.request.method) {
    HttpMethod.delete => deleteItem(context, id),
    _ => Future.value(Response(statusCode: HttpStatus.badRequest,body: 'bad request'))
  };
}

Future<Response> deleteItem(RequestContext context, String id) async {
  try {
    final itemRepository = context.read<ItemRepository>();

    await itemRepository.deleteItemById(id);

    return Response.json(
      body: {
        'message': 'This item deleted correctly',
      },
    );
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {
        'error': e.toString(),
      },
    );
  }
}
