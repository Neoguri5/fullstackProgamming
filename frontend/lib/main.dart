import 'package:flutter/material.dart';
import 'movie_list.dart'; // MovieList 클래스를 임포트
import 'upcoming_movies.dart'; // HollywoodSection 클래스를 임포트
import 'upcoming_kr_mv.dart'; // KoreanSection 클래스를 임포트

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('예매율 TOP3 및 기대작'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '오늘의 예매율 TOP3',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            MovieList(), // 예매율 TOP3 섹션
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: Text(
                '할리우드 기대작',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            HollywoodSection(), // 할리우드 기대작 섹션
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: Text(
                '한국영화 기대작',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            KoreanSection(), // 한국영화 기대작 섹션
          ],
        ),
      ),
    );
  }
}
