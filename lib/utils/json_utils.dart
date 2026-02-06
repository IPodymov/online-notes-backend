import 'dart:convert';
import 'package:shelf/shelf.dart';

Response jsonResponse(Object? body, {int statusCode = 200}) {
  return Response(
    statusCode,
    body: jsonEncode(body),
    headers: {'content-type': 'application/json'},
  );
}

Response errorResponse(String message, {int statusCode = 400}) {
  return jsonResponse({'error': message}, statusCode: statusCode);
}
