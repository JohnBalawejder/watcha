import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Watcha',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1; // Default selected page (Find New)

  // List of pages for navigation
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
            height: 300
          ),
      
        ),
        centerTitle: true,
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
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

// Watch List Page (For ranking movies/tv shows watched)
class WatchListPage extends StatelessWidget {
  const WatchListPage({Key? key}) : super(key: key);  // Added const

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Watch List')),
      body: Center(
        child: Text('Your watched list will go here'),
      ),
    );
  }
}

// Find New Page (Main page with swiping functionality)
class FindNewPage extends StatelessWidget {
  const FindNewPage({Key? key}) : super(key: key);  // Added const

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find New')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Placeholder for movie or tv show thumbnail
          Container(
            height: 200,
            width: 150,
            color: Colors.grey[300],
            child: const Center(child: Text('Thumbnail Placeholder')),
          ),
          const SizedBox(height: 20),
          // Checkmark or X Button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.green,
                child: IconButton(
                  icon: Icon(Icons.check, color: Colors.white),
                  onPressed: () {
                    // Handle checkmark action here
                  },
                ),
              ),
              SizedBox(width: 20),
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.red,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    // Handle X action here
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

// Settings Page (For user settings and info)
class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);  // Added const

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(
        child: Text('Settings and Information will go here'),
      ),
    );
  }
}
