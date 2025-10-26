import 'package:flutter/material.dart';

void main() => runApp(const AssettoLogApp());

class AssettoLogApp extends StatelessWidget {
  const AssettoLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: AssettoLogNav());
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.deepPurple,
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            icon: Icon(Icons.wifi),
            label: "Live Data"
          ),
          NavigationDestination(
            icon: Badge(
              label: Text(pastSessionsAmount.toString()),
              child: Icon(Icons.folder_copy)
            ),
            label: "Past Sessions"
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: "Settings"
          ),
        ],//we go get food brr
      ),
    );
  }
}