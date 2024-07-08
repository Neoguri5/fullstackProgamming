import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// 포스터 URL을 가져오는 함수 정의
Future<String> fetchPosterPath(String title) async {
  final apiKey = 'd7e2c0c5a903a93afcfd18bd4e520a9a'; // TMDB API 키
  final url =
      'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&language=ko-KR&query=${Uri.encodeComponent(title)}';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data['results'].isNotEmpty) {
      return 'https://image.tmdb.org/t/p/w500${data['results'][0]['poster_path']}';
    }
  }
  return 'https://via.placeholder.com/150'; // 포스터를 찾을 수 없는 경우 기본 이미지 URL
}

// API에서 영화 데이터를 가져오는 함수
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

// 영화 데이터를 가공하는 함수
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

class MovieList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: getMovies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data found'));
        } else {
          final movies = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: movies.map((movie) {
                return Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${movie['rank']}위: ${movie['percentage']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Image.network(
                        movie['image'] != 'N/A'
                            ? movie['image']
                            : 'https://via.placeholder.com/150',
                        height: 150,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(movie['status']),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}