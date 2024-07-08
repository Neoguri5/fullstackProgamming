import 'package:flutter/material.dart';
import 'tmdb_api.dart'; // TMDB API 클래스 임포트

class RecommendedMovies extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: TMDBApi().fetchTopRatedMovies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print('Error: ${snapshot.error}'); // 디버깅을 위한 로그 출력
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          print('No data found'); // 디버깅을 위한 로그 출력
          return Center(child: Text('No data found'));
        } else {
          final movies = snapshot.data!;
          print('Movies found: ${movies.length}'); // 디버깅을 위한 로그 출력
          return Container(
            margin: EdgeInsets.symmetric(vertical: 20.0),
            height: 250.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                final posterPath = movie['poster_path'] != null
                    ? 'https://image.tmdb.org/t/p/w500${movie['poster_path']}'
                    : 'https://via.placeholder.com/150';

                // 평점 반올림하여 소수점 첫째 자리까지 표시 (셋째 자리에서 반올림)
                final rating = (movie['vote_average'] * 100).round() / 100;

                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Container(
                    width: 160.0,
                    child: Column(
                      children: [
                        Image.network(posterPath, height: 150),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            movie['title'],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text('평점: $rating'),
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
