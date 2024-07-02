import 'package:http/http.dart' as http;
import 'dart:convert';
import 'tmdb_api.dart';

Future<List<dynamic>> fetchMoviesFromAPI() async {
  final apiKey = '8f500ab7f8f2bb1226ebce46532423f3';

  DateTime now = DateTime.now();
  List<dynamic> movieList = [];

  for (int i = 0; i < 7; i++) {
    final String formattedDate =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final url =
        'http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=$apiKey&targetDt=$formattedDate';
    final response = await http.get(Uri.parse(url));

    print('Fetching movies from API: $url'); // 디버깅을 위한 로그 출력

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      movieList = data['boxOfficeResult']['dailyBoxOfficeList'];
      if (movieList.isNotEmpty) {
        print('Movies fetched: ${movieList.length}'); // 디버깅을 위한 로그 출력
        break;
      }
    } else {
      print(
          'Failed to fetch movies. Status code: ${response.statusCode}'); // 디버깅을 위한 로그 출력
    }

    now = now.subtract(Duration(days: 1));
  }

  if (movieList.isEmpty) {
    throw Exception('Failed to load movies from API for the past 7 days');
  }

  return movieList;
}

Future<List<Map<String, dynamic>>> getMovies() async {
  final movies = await fetchMoviesFromAPI();
  final List<Map<String, dynamic>> movieDataList = [];

  for (final movie in movies.take(3)) {
    final rank = movie['rank'] ?? 'N/A';
    final title = movie['movieNm'] ?? 'N/A';
    final salesShare = movie['salesShare'] ?? '0';
    final openDt = movie['openDt'] ?? 'N/A';

    final releaseDate = DateTime.tryParse(openDt);
    final today = DateTime.now();
    String status = 'N/A';
    if (releaseDate != null) {
      if (releaseDate.isAfter(today)) {
        final daysUntilRelease = releaseDate.difference(today).inDays;
        status = 'D-$daysUntilRelease';
      } else {
        final audiAcc = movie['audiAcc'] ?? '0';
        status = '${(int.parse(audiAcc) / 10000).floor()}만';
      }
    }

    final posterUrl = await fetchPosterPath(title);
    print('Movie: $title, Poster URL: $posterUrl'); // 디버깅을 위한 로그 출력

    movieDataList.add({
      'rank': rank,
      'title': title,
      'percentage': '$salesShare%',
      'image': posterUrl,
      'status': status,
    });
  }

  return movieDataList;
}
