import 'dart:convert';
import 'package:http/http.dart' as http;

class TMDBApi {
  final String apiKey = 'd7e2c0c5a903a93afcfd18bd4e520a9a';

  Future<List<dynamic>> fetchUpcomingExpensiveMovies() async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey&language=en-US'));

    if (response.statusCode == 200) {
      final List<dynamic> movies = json.decode(response.body)['results'];
      List<dynamic> filteredMovies = [];
      for (var movie in movies) {
        final movieDetails = await fetchMovieDetails(movie['id']);
        if (movieDetails['budget'] > 50000000) {
          filteredMovies.add(movieDetails);
        }
      }
      return filteredMovies;
    } else {
      throw Exception('Failed to load upcoming movies');
    }
  }

  Future<Map<String, dynamic>> fetchMovieDetails(int movieId) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey&language=en-US'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load movie details');
    }
  }
}
