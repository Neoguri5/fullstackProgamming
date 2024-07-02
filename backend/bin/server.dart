import 'package:alfred/alfred.dart';
import '../lib/db.dart';

void main() async {
  final app = Alfred();

  app.get('/movies', (req, res) async {
    try {
      final movies = await getMovies();
      return movies;
    } catch (e) {
      print('Error fetching movies: $e');
      return {'error': 'Failed to load movies'};
    }
  });

  await app.listen(8080);
  print('Server is running on http://localhost:8080');
}
