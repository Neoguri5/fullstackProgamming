import 'package:http/http.dart' as http;
import 'dart:convert';

final String apiKey = 'd7e2c0c5a903a93afcfd18bd4e520a9a';
final String baseUrl = 'https://api.themoviedb.org/3';

Future<String> fetchPosterPath(String movieName) async {
  final url = '$baseUrl/search/movie?api_key=$apiKey&query=$movieName';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data['results'] != null && data['results'].isNotEmpty) {
      final posterPath = data['results'][0]['poster_path'];
      if (posterPath != null) {
        return 'https://image.tmdb.org/t/p/w500$posterPath';
      }
    }
  }
  return 'https://via.placeholder.com/150'; // 포스터를 찾지 못한 경우의 기본 이미지
}
