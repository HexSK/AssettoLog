import 'package:flutter/material.dart';
import 'package:flutter_titled_container/flutter_titled_container.dart';

void main() => runApp(const AssettoLogApp());

class AssettoLogApp extends StatelessWidget {
  const AssettoLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const AssettoLogNav(),
      theme: ThemeData.dark().copyWith(
        // Main background
        scaffoldBackgroundColor: Colors.grey[900],

        // NavigationBar theme
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.grey[850],
          indicatorColor: Colors.greenAccent[400],
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(
              color: Colors.greenAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Icon theme
        iconTheme: const IconThemeData(color: Colors.greenAccent, size: 28),

        // Text theme
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.greenAccent),
          bodyLarge: TextStyle(color: Colors.greenAccent),
        ),

        // Badge theme (if using badges from material 3)
        badgeTheme: const BadgeThemeData(
          backgroundColor: Colors.greenAccent,
          textColor: Colors.black,
        ),
      ),
    );
  }
}

class AssettoLogNav extends StatefulWidget {
  const AssettoLogNav({super.key});

  @override
  State<AssettoLogNav> createState() => _AssettoLogNavState();
}

class _AssettoLogNavState extends State<AssettoLogNav> {
  int currentPageIndex = 0;
  int pastSessionsAmount = 67;
  var telemetryData = {
    "speed": 123.3,
    "RPM": 5700,
    "gear": 3,
    "fuelLeft": 35.8,
    "litersPerLap": 2.5,
    "lapNumber": 21,
    "currentLapTime": 83.534,
    "bestLapTime": 82.342,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Define the pages
    final List<Widget> pages = [
      /// Live Data Page
      Center( //Center EVERYTHING
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${telemetryData['speed']}",
              style: TextStyle(
                fontSize: 120.0,
                fontFamily: '7 Segments'
              ),
            ),
            Text(
              "${telemetryData["gear"]}-${telemetryData['RPM']}",
              style: TextStyle(
                fontSize: 120.0,
                fontFamily: '7 Segments'
              )
            )
          ],
        ),
      ),

      /// Past Sessions Page
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: Icon(Icons.folder, color: Colors.greenAccent[400]),
                title: Text('Session 1', style: theme.textTheme.bodyLarge),
                subtitle: Text(
                  'Details about session 1',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.folder, color: Colors.greenAccent[400]),
                title: Text('Session 2', style: theme.textTheme.bodyLarge),
                subtitle: Text(
                  'Details about session 2',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),

      /// Settings Page
      Center(
        child: Text(
          "Settings",
          style: theme.textTheme.titleLarge!.copyWith(
            color: Colors.greenAccent[400],
          ),
        ),
      ),
    ];

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        backgroundColor: theme.navigationBarTheme.backgroundColor,
        indicatorColor: theme.navigationBarTheme.indicatorColor,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            selectedIcon: Icon(Icons.wifi, color: Colors.grey[850]),
            icon: Icon(Icons.wifi, color: Colors.greenAccent[400]),
            label: "Live Data",
          ),
          NavigationDestination(
            selectedIcon: Badge(
              label: Text(pastSessionsAmount.toString()),
              child: Icon(Icons.folder_open, color: Colors.grey[850]),
            ),
            icon: Badge(
              label: Text(pastSessionsAmount.toString()),
              child: Icon(Icons.folder_copy, color: Colors.greenAccent[400]),
            ),
            label: "Past Sessions",
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings, color: Colors.grey[850]),
            icon: Icon(Icons.settings_outlined, color: Colors.greenAccent[400]),
            label: "Settings",
          ),
        ],
      ),
      body: pages[currentPageIndex], // <-- pick the page
    );
  }
}
