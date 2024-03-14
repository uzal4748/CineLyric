import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cinelyric/elements/appbar.dart';
import 'package:cinelyric/elements/bottombar.dart';
import 'package:cinelyric/elements/movie.dart';
import 'movie_info.dart';

class MovieResult extends StatefulWidget {
  final String query;

  MovieResult({required this.query});

  @override
  _MovieResultState createState() => _MovieResultState();
}

enum SortOption { dateAscending, dateDescending, popularity }

class _MovieResultState extends State<MovieResult> {
  String token = "";
  List<Movie> movies = [];
  List<Movie> defaultOrderMovies = []; // Store the default order

  late Future<void> dataFetchingFuture;
  SortOption selectedSortOption = SortOption.popularity;

  void onSortOptionChanged(SortOption? value) {
    if (value != null) {
      setState(() {
        selectedSortOption = value;
        sortMovies();
      });
    }
  }

  void sortMovies() {
    switch (selectedSortOption) {
      case SortOption.dateAscending:
        movies.sort((a, b) => a.year.compareTo(b.year));
        break;
      case SortOption.dateDescending:
        movies.sort((a, b) => b.year.compareTo(a.year));
        break;
      case SortOption.popularity:
        // Reset to the default order
        movies = List.from(defaultOrderMovies);
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    dataFetchingFuture = getDataFromSharedPreferences().then((_) {
      return getMovies();
    });
  }

  Future<void> getDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString('token');
    token = stringValue!;
    print('String value: $token');
  }

  Future<void> getMovies() async {
    // String apiUrl =
    //     'https://8cd5-2400-1a00-b040-5496-7491-c660-170c-1ab5.ngrok-fre/movie/';
    String apiUrl = 'http://10.0.2.2:8000/api/movie/';
    Map<String, String> headers = {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> requestBody = {
      'quote': widget.query,
    };
    String jsonBody = jsonEncode(requestBody);
    try {
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        List<dynamic> decodedData = jsonDecode(response.body);

        movies = decodedData.map((data) => Movie.fromJson(data)).toList();
        defaultOrderMovies = List.from(movies); // Store the default order

        print('Movies: $movies');
      } else {
        print('Failed with status code: ${response.statusCode}');
        print('Response: ${response.body}');
        Map<String, dynamic> jasonBody = jsonDecode(response.body);
        String message = jasonBody['message'];
        print(message);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Api response: $message'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Builder(
        builder: (context) {
          return FutureBuilder<void>(
            future: dataFetchingFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                // Sort movies based on the selected option
                sortMovies();
                return Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Results for your input:',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Dropdown menu for sorting options
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<SortOption?>(
                        value: selectedSortOption,
                        items: [
                          DropdownMenuItem(
                            value: SortOption.dateAscending,
                            child: Text('Date Ascending'),
                          ),
                          DropdownMenuItem(
                            value: SortOption.dateDescending,
                            child: Text('Date Descending'),
                          ),
                          DropdownMenuItem(
                            value: SortOption.popularity,
                            child: Text('Popularity'),
                          ),
                        ],
                        onChanged: onSortOptionChanged,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          Movie movie = movies[index];
                          return Card(
                            margin: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text('Name: ${movie.movie}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Type: ${movie.type}'),
                                  Text('Release Date: ${movie.year}'),
                                  Text('Movie quote: ${movie.quote}'),
                                  Text('Your query: "${widget.query}"'),
                                ],
                              ),
                              leading: movie.poster_link == ""
                                  ? Image.network(
                                      'https://icons.iconarchive.com/icons/designbolts/free-multimedia/512/Film-icon.png',
                                      width: 80.0,
                                      height: 280.0,
                                      fit: BoxFit.contain,
                                    )
                                  : FadeInImage.assetNetwork(
                                      placeholder:
                                          'assets/placeholder/Film-icon.png', // Placeholder image
                                      image: movie.poster_link,
                                      width: 80.0,
                                      height: 150.0,
                                      fit: BoxFit.cover,
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/placeholder/Film-icon.png', // Error placeholder image
                                          width: 80.0,
                                          height: 500.0,
                                          fit: BoxFit.fill,
                                        );
                                      },
                                    ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MovieInfo(movie: movie),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
            },
          );
        },
      ),
      bottomNavigationBar: const MyAppBottomBar(currentPageIndex: 1),
    );
  }
}
