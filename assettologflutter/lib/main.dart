import 'package:flutter/material.dart';

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
  int speedKmh = 123;
  int rpm = 5400;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "$speedKmh",
                      style: TextStyle(
                        fontFamily: '7 Segments',
                        fontSize: 150,
                        fontWeight: FontWeight.w700,
                        color: Colors.greenAccent[400],
                      ),
                    ),
                    WidgetSpan(
                      child: Transform.translate(
                        offset: const Offset(0, 17), // tweak vertical position
                        child: Text(
                          "km/h",
                          style: TextStyle(
                            fontSize: 50,
                            color: Colors.greenAccent[400],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${rpm.toString()} RPM",
                style: TextStyle(
                  fontFamily: '7 Segments',
                  fontSize: 75.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.greenAccent[400],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
