import 'package:flutter/material.dart';
import 'kofic_api.dart'; // 영화진흥원 API 클래스 임포트

class KoreanSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: KOFICApi().fetchUpcomingKoreanMovies(),
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
                final posterPath = movie['poster_path'] != ''
                    ? 'https://image.tmdb.org/t/p/w500${movie['poster_path']}'
                    : 'https://via.placeholder.com/150';

                return Container(
                  width: 160.0,
                  margin: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Image.network(
                        posterPath, // 포스터 URL
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 8),
                      Text(
                        movie['movieNm'], // 한국어 제목 사용
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '개봉일: ${movie['openDt']}',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
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
