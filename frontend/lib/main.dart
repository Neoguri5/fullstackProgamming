import 'package:flutter/material.dart';
import 'movie_list.dart';
import 'upcoming_movies.dart';
import 'upcoming_kr_mv.dart';
import 'recommended_movies.dart';
import 're_release_movies.dart';
import 'critic_recommendations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('무비 Scope'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('오늘의 예매율 TOP3',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              MovieList(),
              Text('할리우드 기대작',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              HollywoodSection(),
              Text('한국영화 기대작',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              KoreanSection(),
              Text('재개봉 영화',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ReReleaseMovies(),
              Text('tmdb 추천 영화',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              RecommendedMovies(),
              Text('이동진 평론가 추천 영화(평점 4.5 이상)',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              CriticRecommendations(),
            ],
          ),
        ),
      ),
    );
  }
}
