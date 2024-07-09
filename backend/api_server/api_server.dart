import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Response> handleRequest(Request request) async {
  final response = await http.get(Uri.parse('http://localhost:8081/data'));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return Response.ok(json.encode(data),
        headers: {'Content-Type': 'application/json'});
  } else {
    return Response.internalServerError(
        body: 'Failed to fetch data from data server');
  }
}

void main() async {
  final handler =
      const Pipeline().addMiddleware(logRequests()).addHandler(handleRequest);

  final server = await io.serve(handler, 'localhost', 8080);
  print('API Server listening on port ${server.port}');
}
