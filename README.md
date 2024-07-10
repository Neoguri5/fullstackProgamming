 1. Project Overview
- Project Name: Movie Scope
- Description: Movie Scope is an app that provides information on movie ticket sales, anticipated Hollywood releases, anticipated Korean movie releases, re-released movies, TMDB recommended movies, and movie recommendations by critic Dong-jin Lee.

 2. Project Goals
- Provide users with the latest movie information
- Implement a rating-based personalized movie recommendation feature
- Allow easy access to various movie information in one place

 3. Tech Stack
- Frontend: Flutter
- Backend: Dart (Shelf package)
- Data Sources: TMDB API, Korean Film Council (KOFIC) API

 4. Client Structure

 4.1. Directory Structure
 main.dart
 ├── movie_list.dart
 ├── upcoming_movies.dart
 ├── upcoming_kr_mv.dart
 ├── recommended_movies.dart
 ├── re_release_movies.dart
 └── critic_recommendations.dart
 
 4.2. Code Locations and Roles
- movie_list.dart: Manages the data for the top 3 ticket sales
- upcoming_movies.dart: Manages the data for anticipated Hollywood releases
- upcoming_kr_mv.dart: Manages the data for anticipated Korean movie releases
- critic_recommendations.dart: Manages the data for movie recommendations by critic Dong-jin Lee
- re_release_movies.dart: Manages the data for re-released movies

 4.3. Description of Methods in Each File

movie_list.dart
- fetchPosterPath(String title): Retrieves the poster URL for a movie title using the TMDB API.
- fetchMoviesFromAPI(): Retrieves movie data for the last 7 days from the Korean Film Council API.
- getMovies(): Processes the data from the API to generate the top 3 ticket sales data.
- MovieList.build(BuildContext context): Builds the widget to display the top 3 ticket sales data.

upcoming_movies.dart
- TMDBApi.fetchUpcomingExpensiveMovies(): Retrieves anticipated Hollywood releases for the next 6 months from the TMDB API.
- HollywoodSection.build(BuildContext context): Builds the widget to display the data from the TMDB API.

upcoming_kr_mv.dart
- KOFICApi.fetchUpcomingKoreanMovies(): Retrieves anticipated Korean movie releases for the next 6 months from the Korean Film Council API.
- KOFICApi.isAdultGenre(String genre): Checks if the movie genre is adult content.
- KOFICApi.isWithinDateRange(String openDt, String startDate, String endDate): Checks if the movie release date is within a specific date range.
- KOFICApi.fetchAdditionalMovie(String movieName, String openDt): Retrieves additional movie information from the TMDB API.
- KOFICApi.fetchMoviePoster(String movieName): Retrieves the movie poster from the TMDB API.
- KOFICApi.compareDates(String date1, String date2): Compares two dates.
- KOFICApi.parseDate(String date): Converts a date string to a DateTime object.
- KOFICApi.formatDate(String date): Converts a date format to yyyy-mm-dd.
- KoreanSection.build(BuildContext context): Builds the widget to display the data from the Korean Film Council API.

critic_recommendations.dart
- _CriticRecommendationsState.fetchMoviePosters(List<Map<String, String>> selectedMovies): Retrieves the poster URLs for selected movies using the TMDB API.
- _CriticRecommendationsState.getRandomMovies(): Selects 5 random movies from critic Dong-jin Lee's recommendations.
- _CriticRecommendationsState.build(BuildContext context): Builds the widget to display the recommended movies.

re_release_movies.dart
- _ReReleaseMoviesState.fetchMoviePosters(): Retrieves the poster URLs for re-released movies using the TMDB API.
- _ReReleaseMoviesState.build(BuildContext context): Builds the widget to display the re-released movies.

recommended_movies.dart
- TMDBApi.fetchTopRatedMovies(): Retrieves top-rated movies from the TMDB API.
- RecommendedMovies.build(BuildContext context): Builds the widget to display the data from the TMDB API.

 5. Server Structure

 5.1. Diagram
 backend/
 ├── api_server/
 │   └── api_server.dart
 └── data_server/
     └── data_server.dart

 
 5.2. Code Locations and Roles
- api_server.dart: Receives requests from the client, collects data from the data server, and responds.
- data_server.dart: Collects data from external APIs (TMDB, Korean Film Council) and provides it to the API server.

 5.3. Description of Methods in Each Server File

api_server.dart
- handleRequest(Request request): Main handler of the API server that processes client requests. This method sends HTTP requests to the data server to collect data and returns it to the client.
- main(): Entry point of the API server. Sets up the `handleRequest` handler and starts the server.

data_server.dart
- fetchExternalData(): Collects data from external APIs (e.g., TMDB, Korean Film Council). This method sends HTTP GET requests and returns the responses as JSON.
- handleRequest(Request request): Main handler of the data server that processes client requests. This method calls `fetchExternalData` to collect data and responds to the API server with JSON data.
- main(): Entry point of the data server. Sets up the `handleRequest` handler and starts the server.

 6. Data Flow

 6.1. Client-Server Data Transmission
- The client requests ticket sales, anticipated releases, and re-released movie data from the API server.
- The API server requests data from the data server.
- The data server collects data from external APIs and returns it to the API server.
- The API server responds to the client with the collected data.

 7. Algorithms Used
- Rating-Based Movie Recommendation Algorithm: Uses TMDB rating data to recommend movies with high ratings.
- Release Date Sorting Algorithm: Sorts movies by release date to provide the latest movie information.

 8. UI/UX Design
- Card Layout: Provides intuitive information display.
- Horizontal Scrolling: Offers various movie lists.

 9. Conclusion
- Movie Scope provides various movie information, allowing users to easily access it.
- Efficiently separates client and server structure to enhance data reliability and scalability.
- Offers personalized experience through user-tailored movie recommendations.
