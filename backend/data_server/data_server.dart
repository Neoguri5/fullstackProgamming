import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> fetchExternalData() async {
  final response = await http.get(Uri.parse('https://api.example.com/data'));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to fetch data from external API');
  }
}

Future<Response> handleRequest(Request request) async {
  try {
    final data = await fetchExternalData();
    return Response.ok(json.encode(data),
        headers: {'Content-Type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(
        body: 'Failed to fetch data from external API');
  }
}

void main() async {
  final handler =
      const Pipeline().addMiddleware(logRequests()).addHandler(handleRequest);

  final server = await io.serve(handler, 'localhost', 8081);
  print('Data Server listening on port ${server.port}');
}
