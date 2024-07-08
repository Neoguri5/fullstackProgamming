import 'dart:convert';
import 'package:http/http.dart' as http;

class TMDBApi {
  final String apiKey = 'd7e2c0c5a903a93afcfd18bd4e520a9a';

  // 할리우드 영화 가져오기
  Future<List<dynamic>> fetchUpcomingExpensiveMovies() async {
    final now = DateTime.now();
    final sixMonthsLater = DateTime(now.year, now.month + 6, now.day);
    final String startDate = now.toIso8601String().substring(0, 10);
    final String endDate = sixMonthsLater.toIso8601String().substring(0, 10);

    final url = 'https://api.themoviedb.org/3/discover/movie?'
        'api_key=$apiKey&language=ko-KR&sort_by=popularity.desc&'
        'primary_release_date.gte=$startDate&primary_release_date.lte=$endDate&'
        'with_original_language=en';

    final response = await http.get(Uri.parse(url));

    print('API URL: $url'); // 디버깅을 위한 로그 출력
    if (response.statusCode == 200) {
      final List<dynamic> movies = json.decode(response.body)['results'];
      movies.sort((a, b) =>
          a['release_date'].compareTo(b['release_date'])); // 개봉일 기준으로 정렬
      return movies;
    } else {
      print(
          'Failed to load upcoming movies: ${response.statusCode}'); // 디버깅을 위한 로그 출력
      throw Exception('Failed to load upcoming movies');
    }
  }

  // 한국 영화 가져오기
  Future<List<dynamic>> fetchUpcomingKoreanMovies() async {
    final now = DateTime.now();
    final sixMonthsLater = DateTime(now.year, now.month + 6, now.day);
    final String startDate = now.toIso8601String().substring(0, 10);
    final String endDate = sixMonthsLater.toIso8601String().substring(0, 10);

    final url = 'https://api.themoviedb.org/3/discover/movie?'
        'api_key=$apiKey&language=ko-KR&sort_by=popularity.desc&'
        'primary_release_date.gte=$startDate&primary_release_date.lte=$endDate&'
        'with_original_language=ko';

    final response = await http.get(Uri.parse(url));

    print('API URL: $url'); // 디버깅을 위한 로그 출력
    if (response.statusCode == 200) {
      final List<dynamic> movies = json.decode(response.body)['results'];
      movies.sort((a, b) =>
          a['release_date'].compareTo(b['release_date'])); // 개봉일 기준으로 정렬
      return movies;
    } else {
      print(
          'Failed to load upcoming Korean movies: ${response.statusCode}'); // 디버깅을 위한 로그 출력
      throw Exception('Failed to load upcoming Korean movies');
    }
  }

  Future<Map<String, dynamic>> fetchMovieDetails(int movieId) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey&language=ko-KR'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  Future<List<dynamic>> fetchTopRatedMovies() async {
    final url =
        'https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey&language=ko-KR';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> movies = responseData['results'];

      // 평점 7.5 이상인 영화 필터링
      final filteredMovies = movies.where((movie) {
        final double rating = movie['vote_average'];
        return rating >= 7.5;
      }).toList();

      // 영화 목록을 랜덤으로 섞고, 상위 5개 영화 반환
      filteredMovies.shuffle();
      return filteredMovies.take(5).toList();
    } else {
      throw Exception('Failed to load top-rated movies');
    }
  }
}
