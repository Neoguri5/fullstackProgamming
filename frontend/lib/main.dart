import 'package:flutter/material.dart';
import 'movie_list.dart'; // MovieList 클래스를 임포트
import 'upcoming_movies.dart'; // HollywoodSection 클래스를 임포트

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
        title: Text('예매율 TOP3 및 할리우드 기대작'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 예매율 TOP3 섹션
            MovieList(),
            // 새로운 할리우드 기대작 섹션
            HollywoodSection(),
          ],
        ),
      ),
    );
  }
}
