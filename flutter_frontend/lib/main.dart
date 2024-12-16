import 'package:flutter/material.dart';

// The main entry point of the Flutter app. The `runApp()` function inflates 
// the given widget (`MyApp`) and attaches it to the screen.
void main() {
  runApp(MyApp());
}

// The root widget of the app. Extends `StatelessWidget` because it doesn't need to maintain any state.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // `MaterialApp` is the top-level widget for apps using Material Design. 
    // It provides theming, routing, and other global app configurations.
    return MaterialApp(
      title: 'Watcha', // App title, useful for debugging and platform integration.
      theme: ThemeData(
        primarySwatch: Colors.lightBlue, // Sets the primary color for the app.
        visualDensity: VisualDensity.adaptivePlatformDensity, // Adjusts visual density for the current platform.
      ),
      home: HomeScreen(), // The default screen (or route) displayed by the app.
    );
  }
}

// A stateful widget to manage the app's main screen with navigation.
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// The state class for `HomeScreen`, responsible for maintaining and updating UI changes.
class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1; // Index of the currently selected page. Defaults to "Find New".

  // Static list of widgets corresponding to the pages for navigation.
  static const List<Widget> _pages = <Widget>[
    WatchListPage(), // First tab: Watch List
    FindNewPage(),   // Second tab: Find New
    SettingsPage(),  // Third tab: Settings
  ];

  // Updates `_selectedIndex` when a tab is tapped, triggering a UI rebuild.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // `Scaffold` provides a standard layout structure with app bar, body, and navigation.
      appBar: AppBar(
        // Custom app bar containing a logo inside a colored rectangle for contrast.
        title: Container(
          width: double.infinity, // Makes the container stretch across the screen.
          color: Colors.lightBlueAccent, // Background color for contrast.
          padding: EdgeInsets.all(10), // Adds spacing around the logo.
          child: Image.asset(
            'assets/images/watcha_logo.png', // Loads the logo from the assets folder.
            height: 300, // Adjusts logo height.
          ),
        ),
        centerTitle: true, // Centers the title content in the app bar.
      ),
      // The main content of the screen, determined by the selected page.
      body: Center(
        child: _pages.elementAt(_selectedIndex), // Displays the current page widget.
      ),
      // Bottom navigation bar for switching between pages.
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Highlights the selected tab.
        onTap: _onItemTapped, // Calls the function to update the selected index.
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list), // Icon for the first tab.
            label: 'Watch List',    // Label for the first tab.
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search), // Icon for the second tab.
            label: 'Find New',        // Label for the second tab.
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings), // Icon for the third tab.
            label: 'Settings',          // Label for the third tab.
          ),
        ],
      ),
    );
  }
}

// The page that displays the user's watch list.
class WatchListPage extends StatelessWidget {
  const WatchListPage({Key? key}) : super(key: key); // Constructor with `const` for optimization.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Watch List')), // App bar with the page title.
      body: Center(
        child: Text('Your watched list will go here'), // Placeholder text.
      ),
    );
  }
}

// The page for discovering new movies or shows (e.g., swiping functionality).
class FindNewPage extends StatelessWidget {
  const FindNewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find New')), // App bar with the page title.
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centers content vertically.
        children: [
          // Placeholder for a thumbnail of a movie or TV show.
          Container(
            height: 450, // Height of the placeholder.
            width: 300,  // Width of the placeholder.
            color: Colors.grey[300], // Background color of the placeholder.
            child: const Center(child: Text('Thumbnail Placeholder')), // Text inside the placeholder.
          ),
          const SizedBox(height: 15), // Adds vertical spacing.
          // Row with "Check" and "X" buttons for swiping actions.
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Centers the buttons horizontally.
            children: [
              CircleAvatar(
                radius: 40, // Button size.
                backgroundColor: Colors.green, // Green background for "Check" button.
                child: IconButton(
                  icon: Icon(Icons.check, color: Colors.white), // Checkmark icon.
                  onPressed: () {
                    // Handle checkmark action here.
                  },
                ),
              ),
              SizedBox(width: 100), // Adds spacing between buttons.
              CircleAvatar(
                radius: 40, // Button size.
                backgroundColor: Colors.red, // Red background for "X" button.
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white), // "X" icon.
                  onPressed: () {
                    // Handle X action here.
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// The page for user settings or app preferences.
class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')), // App bar with the page title.
      body: Center(
        child: Text('Settings and Information will go here'), // Placeholder text.
      ),
    );
  }
}
