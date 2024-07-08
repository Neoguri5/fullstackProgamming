import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReReleaseMovies extends StatefulWidget {
  @override
  _ReReleaseMoviesState createState() => _ReReleaseMoviesState();
}

class _ReReleaseMoviesState extends State<ReReleaseMovies> {
  final String tmdbApiKey = 'd7e2c0c5a903a93afcfd18bd4e520a9a';
  final List<Map<String, String>> reReleaseMovies = [
    {'title': '듄 1', 'releaseDate': '2024-07-03 ~ 2024-07-14', 'cinema': 'CGV'},
    {'title': '듄 2', 'releaseDate': '2024-07-03 ~ 2024-07-14', 'cinema': 'CGV'},
    {'title': '가장 따뜻한 색, 블루', 'releaseDate': '2024-07-10', 'cinema': 'CGV'},
    {'title': '비포 선라이즈', 'releaseDate': '2024-07-17', 'cinema': '롯데시네마'},
    {'title': '포드 v 페라리', 'releaseDate': '2024-07-17', 'cinema': '메가박스'},
    {'title': '위대한 쇼맨', 'releaseDate': '2024-07-17', 'cinema': '메가박스'},
  ];

  Future<List<Map<String, String>>> fetchMoviePosters() async {
    List<Map<String, String>> moviesWithPosters = [];

    for (var movie in reReleaseMovies) {
      final response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/search/movie?api_key=$tmdbApiKey&query=${movie['title']}&language=ko-KR&region=KR'));
      if (response.statusCode == 200) {
        final results = json.decode(response.body)['results'];
        if (results.isNotEmpty) {
          movie['posterUrl'] =
              'https://image.tmdb.org/t/p/w500${results[0]['poster_path']}';
        } else {
          movie['posterUrl'] = 'https://via.placeholder.com/150';
        }
      } else {
        movie['posterUrl'] = 'https://via.placeholder.com/150';
      }
      moviesWithPosters.add(movie);
    }
    return moviesWithPosters;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, String>>>(
      future: fetchMoviePosters(),
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
          return Container(
            margin: EdgeInsets.symmetric(vertical: 20.0),
            height: 250.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                final posterPath =
                    movie['posterUrl'] ?? 'https://via.placeholder.com/150';

                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Container(
                    width: 160.0,
                    child: Column(
                      children: [
                        Image.network(posterPath,
                            height: 150, fit: BoxFit.cover),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            movie['title']!,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text('상영일: ${movie['releaseDate']}'),
                        Text('극장: ${movie['cinema']}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
