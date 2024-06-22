import 'dart:async';
import 'dart:io';

import 'package:auth/core/exception.dart';
import 'package:auth/core/jwt_manage.dart';
import 'package:auth/repository/items%20repository/items_repo.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) {
  return switch (context.request.method) {
    HttpMethod.post => addItem(context),
    HttpMethod.get => getItems(context),
    _ => Future.value(Response(body: 'bad request'))
  };
}

Future<Response> addItem(RequestContext context) async {
  try {
    final categoryRepository = context.read<ItemRepository>();
    final json = (await context.request.json()) as Map<String, dynamic>;
    final itemName = json['itemName'] as String?;
    final backGroundColor = json['backGroundColor'] as String?;

    final accessToken =
        context.request.headers['Authorization']?.split(' ').last;

    if (accessToken == null ||
        !JwtManage.verifyAccessToken(accessToken: accessToken)) {
      return Response.json(
        statusCode: 401,
        body: {'message': Exceptions.unauthorized},
      );
    }

    if (itemName == null || backGroundColor == null) {
      return Response.json(
        body: {
          'message': Exceptions.fieldsRequired,
        },
      );
    }
    final userId = JwtManage.getUserIdFromToken(accessToken);
    final item =
        await categoryRepository.addItem(itemName, backGroundColor, userId);

    return Response.json(
      body: {
        'message': 'Item added successfully',
        'item': item,
      },
    );
  } catch (e) {
    return Response(
    statusCode: HttpStatus.internalServerError,
    body: e.toString(),);
  }
}

Future<Response> getItems(RequestContext context) async {
  try {
    final categoryRepository = context.read<ItemRepository>();
    final accessToken =
        context.request.headers['Authorization']?.split(' ').last;

    if (accessToken == null ||
        !JwtManage.verifyAccessToken(accessToken: accessToken)) {
      return Response.json(
        statusCode: 401,
        body: {'message': Exceptions.unauthorized},
      );
    }

    final userId = JwtManage.getUserIdFromToken(accessToken);

    final items = await categoryRepository.getItemsByUserId(userId);
    if (items.isEmpty) {
      return Response(body: 'No Items');
    }
    return Response.json(
      body: {
        'items': items,
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
