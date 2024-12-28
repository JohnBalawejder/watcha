import 'package:flutter/material.dart';
import 'package:flutter_frontend/login_screen.dart';
import 'package:flutter_frontend/register_screen.dart';
import 'api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Watcha',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;

  static const List<Widget> _pages = <Widget>[
    WatchListPage(),
    FindNewPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          color: Colors.lightBlueAccent,
          padding: EdgeInsets.all(10),
          child: Image.asset(
            'assets/images/watcha_logo.png',
            height: 300, // Adjusted for web
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width > 800
              ? 800
              : MediaQuery.of(context).size.width, // Limit max width for web
          child: _pages.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Watch List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Find New',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class WatchListPage extends StatefulWidget {
  const WatchListPage({Key? key}) : super(key: key);

  @override
  _WatchListPageState createState() => _WatchListPageState();
}

class _WatchListPageState extends State<WatchListPage> {
  List<dynamic> watchedMovies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  void fetchMovies() async {
    try {
      final token = ApiService.jwtToken;

      if (token == null || token.isEmpty) {
        throw Exception("User is not logged in. Please login first.");
      }

      List<dynamic> movies = await ApiService.fetchWatchedMovies(token);

      // Sort movies by ranking
      movies.sort((a, b) => b["ranking"].compareTo(a["ranking"]));

      setState(() {
        watchedMovies = movies;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching movies: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void removeMovie(int movieId) async {
    try {
      final token = ApiService.jwtToken;

      if (token == null || token.isEmpty) {
        throw Exception("User is not logged in. Please login first.");
      }

      await ApiService.removeMovieFromWatchlist(token, movieId);

      // Refresh the list after removing the movie
      setState(() {
        watchedMovies.removeWhere((movie) => movie["id"] == movieId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Movie removed from your watchlist")),
      );
    } catch (e) {
      print("Error removing movie: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to remove movie")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Watched Movies"),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width > 800
              ? 800
              : MediaQuery.of(context).size.width,
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: watchedMovies.length,
                  itemBuilder: (context, index) {
                    final movie = watchedMovies[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: ListTile(
                        leading: movie["poster"] != "N/A"
                            ? Image.network(
                                movie["poster"],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.movie, size: 50),
                        title: Text(
                          movie["title"],
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: Text(
                          "Ranking: ${movie["ranking"]}",
                          style: TextStyle(fontSize: 14),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => removeMovie(movie["id"]),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchPage()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }
}




class FindNewPage extends StatelessWidget {
  const FindNewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate dynamic sizes for thumbnail and buttons
    final thumbnailHeight = screenHeight * 0.4; // 40% of screen height
    final buttonRadius = screenHeight * 0.05; // 6% of screen height
    final buttonSpacing = screenWidth * 0.05; // 8% of screen width

    return Scaffold(
      appBar: AppBar(title: const Text('Swipe to Find New Titles!')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Thumbnail Placeholder
            Container(
              height: thumbnailHeight,
              width: thumbnailHeight * 0.75, // Maintain a 4:3 aspect ratio
              color: Colors.grey[300],
              child: const Center(
                child: Text('Thumbnail Placeholder'),
              ),
            ),
            const SizedBox(height: 20),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: buttonRadius,
                  backgroundColor: Colors.green,
                  child: IconButton(
                    icon: Icon(Icons.check, color: Colors.white),
                    onPressed: () {
                      // Handle check action
                    },
                  ),
                ),
                SizedBox(width: buttonSpacing),
                CircleAvatar(
                  radius: buttonRadius,
                  backgroundColor: Colors.red,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      // Handle close action
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  void logout(BuildContext context) {
    // Clear the token
    ApiService.jwtToken = null;

    // Navigate back to the login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Logged out successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine screen size for responsiveness
    final isWideScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Center(
        child: Container(
          width: isWideScreen ? 600 : MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              Text(
                "Settings",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Horizontal list for options
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Login/Logout button
                  ElevatedButton(
                    onPressed: () {
                      if (ApiService.jwtToken != null) {
                        logout(context);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      textStyle: TextStyle(fontSize: 14),
                    ),
                    child: Text(ApiService.jwtToken != null ? "Logout" : "Login"),
                  ),
                  const SizedBox(width: 20),
                  // Placeholder for future options
                  ElevatedButton(
                    onPressed: () {
                      // Placeholder action
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Feature coming soon!")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      textStyle: TextStyle(fontSize: 14),
                    ),
                    child: Text("Other Option"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> searchResults = [];
  bool isLoading = false;

  void searchMovies() async {
    final query = _searchController.text;

    if (query.isEmpty) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final token = ApiService.jwtToken;
      if (token == null || token.isEmpty) {
        throw Exception("User is not logged in. Please login first.");
      }

      final results = await ApiService.searchMovies(token, query);
      setState(() {
        searchResults = results;
        isLoading = false;
      });
    } catch (e) {
      print("Error searching movies: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void addToWatchlist(dynamic movie) async {
    final TextEditingController _rankingController = TextEditingController();

    // Show a dialog to get the ranking
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Ranking for ${movie['title']}"),
          content: TextField(
            controller: _rankingController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Ranking (1-10)",
              hintText: "Enter a ranking between 1 and 10",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Cancel action
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Confirm action
              },
              child: Text("Submit"),
            ),
          ],
        );
      },
    );

    // Get the entered ranking
    final ranking = double.tryParse(_rankingController.text);

    if (ranking == null || ranking < 1 || ranking > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid ranking. Please enter a value between 1 and 10.")),
      );
      return;
    }

    try {
      final token = ApiService.jwtToken;
      if (token == null || token.isEmpty) {
        throw Exception("User is not logged in. Please login first.");
      }

      // Add the ranking to the movie data
      final movieData = {
        "title": movie["title"],
        "type": movie["type"] ?? "movie", // Default to "movie" if type is missing
        "ranking": ranking,
      };

      await ApiService.addMovieToWatchlist(token, movieData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${movie["title"]} added to your watchlist')),
      );
    } catch (e) {
      print("Error adding to watchlist: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add movie to watchlist')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search Movies/TV Shows")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Search",
                hintText: "Enter movie or TV show name",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: searchMovies,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            if (isLoading)
              Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final movie = searchResults[index];
                    return ListTile(
                      leading: movie["poster"] != "N/A"
                          ? Image.network(
                              movie["poster"],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.movie, size: 50),
                      title: Text(movie["title"]),
                      subtitle: Text(movie["genre"] ?? "Unknown Genre"),
                      trailing: IconButton(
                        icon: Icon(Icons.add, color: Colors.lightBlue),
                        onPressed: () => addToWatchlist(movie),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
