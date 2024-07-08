import 'dart:convert';
import 'package:http/http.dart' as http;

class KOFICApi {
  final String apiKey = '8f500ab7f8f2bb1226ebce46532423f3'; // 영화진흥원 API 키
  final String tmdbApiKey = 'd7e2c0c5a903a93afcfd18bd4e520a9a'; // TMDB API 키

  Future<List<dynamic>> fetchUpcomingKoreanMovies() async {
    final now = DateTime.now();
    final sixMonthsLater = DateTime(now.year, now.month + 6, now.day);
    final String startDate = now.toIso8601String().substring(0, 10);
    final String endDate = sixMonthsLater.toIso8601String().substring(0, 10);

    final url =
        'http://www.kobis.or.kr/kobisopenapi/webservice/rest/movie/searchMovieList.json?key=$apiKey';

    final response = await http.get(Uri.parse(url));

    print('API URL: $url'); // 디버깅을 위한 로그 출력
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('movieListResult') &&
          responseData['movieListResult'].containsKey('movieList')) {
        final List<dynamic> movies =
            responseData['movieListResult']['movieList'];

        // "장편" 영화만 필터링하고 성인 영화, 개봉 예정이 아닌 영화 및 한국 영화가 아닌 영화 제외
        final filteredMovies = movies
            .where((movie) =>
                movie['typeNm'] == '장편' &&
                movie['prdtStatNm'] == '개봉예정' &&
                movie['repNationNm'] == '한국' &&
                movie['repGenreNm'] != '공연' &&
                !isAdultGenre(movie['repGenreNm']) &&
                isWithinDateRange(movie['openDt'], startDate, endDate))
            .toList();

        // 추가할 영화 목록
        final List<Map<String, String>> additionalMovies = [
          {'name': '행복의 나라', 'openDt': '2024-08-14'},
          {'name': '왕을 찾아서', 'openDt': '2024-10-01'},
          {'name': '1승', 'openDt': '2024-10-01'},
          {'name': '하얼빈', 'openDt': '2024-12-18'}
        ];

        for (var movieInfo in additionalMovies) {
          final additionalMovie = await fetchAdditionalMovie(
              movieInfo['name']!, movieInfo['openDt']!);
          if (additionalMovie != null) {
            filteredMovies.add(additionalMovie);
          }
        }

        // 개봉일 기준으로 정렬 (이른 순으로 정렬)
        filteredMovies.sort((a, b) => compareDates(a['openDt'], b['openDt']));

        // TMDB API를 사용하여 포스터 이미지 가져오기
        for (var movie in filteredMovies) {
          final posterPath = await fetchMoviePoster(movie['movieNm']);
          movie['poster_path'] = posterPath;
          // 날짜 형식을 yyyy-mm-dd로 변환
          movie['openDt'] = formatDate(movie['openDt']);
        }

        return filteredMovies;
      } else {
        throw Exception('Invalid response structure');
      }
    } else {
      print('Failed to load movies: ${response.statusCode}'); // 디버깅을 위한 로그 출력
      throw Exception('Failed to load movies');
    }
  }

  bool isAdultGenre(String genre) {
    // 성인 영화로 간주되는 장르 목록
    final adultGenres = ['멜로/로맨스', '드라마', '성인물(에로)'];
    return adultGenres.contains(genre);
  }

  bool isWithinDateRange(String openDt, String startDate, String endDate) {
    if (openDt.isEmpty) return false;
    final openDate = DateTime.tryParse(openDt);
    if (openDate == null) return false;
    final start = DateTime.parse(startDate);
    final end = DateTime.parse(endDate);
    return openDate.isAfter(start) && openDate.isBefore(end);
  }

  Future<Map<String, dynamic>?> fetchAdditionalMovie(
      String movieName, String openDt) async {
    final url =
        'https://api.themoviedb.org/3/search/movie?api_key=$tmdbApiKey&query=${Uri.encodeComponent(movieName)}&language=ko-KR&region=KR';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body)['results'];
      if (results.isNotEmpty) {
        final movie = results[0];
        return {
          'movieNm': movie['title'],
          'openDt': openDt.isNotEmpty ? openDt : movie['release_date'] ?? '',
          'poster_path': movie['poster_path'] ?? '',
          'repGenreNm': movie['genre_ids'].join(', '),
          'prdtStatNm': '개봉예정',
          'typeNm': '장편'
        };
      } else {
        print('No additional movie found for: $movieName'); // 디버깅 로그 추가
        return null;
      }
    } else {
      print('Failed to load additional movie: $movieName');
      return null;
    }
  }

  Future<String> fetchMoviePoster(String movieName) async {
    final url =
        'https://api.themoviedb.org/3/search/movie?api_key=$tmdbApiKey&query=${Uri.encodeComponent(movieName)}&language=ko-KR&region=KR';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body)['results'];
      if (results.isNotEmpty) {
        for (var result in results) {
          final posterPath = result['poster_path'];
          if (posterPath != null) {
            return 'https://image.tmdb.org/t/p/w500$posterPath';
          }
        }
        print('No valid poster path available for movie: $movieName');
        return 'https://via.placeholder.com/150';
      } else {
        print('No poster found for movie: $movieName'); // 디버깅 로그 추가
        return 'https://via.placeholder.com/150';
      }
    } else {
      throw Exception('Failed to load movie poster');
    }
  }

  int compareDates(String date1, String date2) {
    final parsedDate1 = parseDate(date1);
    final parsedDate2 = parseDate(date2);

    return parsedDate1.compareTo(parsedDate2);
  }

  DateTime parseDate(String date) {
    if (date.contains('-')) {
      return DateTime.parse(date); // yyyy-mm-dd 형식
    } else {
      // yyyymmdd 형식
      final year = int.parse(date.substring(0, 4));
      final month = int.parse(date.substring(4, 6));
      final day = int.parse(date.substring(6, 8));
      return DateTime(year, month, day);
    }
  }

  String formatDate(String date) {
    final parsedDate = parseDate(date);
    return '${parsedDate.year.toString().padLeft(4, '0')}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';
  }
}
