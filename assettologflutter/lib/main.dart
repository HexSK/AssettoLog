import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'dart:async';

String lf = '7 Segments';

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
  WebSocketChannel? channel;
  Timer? reconnectionTimer;
  final Duration reconnectDelay = const Duration(seconds: 1);

  void connectToServer() {
    try {
      channel = WebSocketChannel.connect(
        Uri.parse('ws://0.0.0.0:44148')
      );
      
      channel!.stream.listen(
        (message) {
          setState(() {
            telemetryData = Map<String, dynamic>.from(jsonDecode(message));
          });
        },
        onDone: () {
          print('WebSocket connection closed. Attempting to reconnect...');
          scheduleReconnection();
        },
        onError: (error) {
          print('WebSocket error: $error');
          scheduleReconnection();
        },
      );
    } catch (e) {
      print('Connection attempt failed: $e');
      scheduleReconnection();
    }
  }

  void scheduleReconnection() {
    setState(() {
      telemetryData['serverRunning'] = 0;
    });
    
    reconnectionTimer?.cancel();
    reconnectionTimer = Timer(reconnectDelay, connectToServer);
  }

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  @override
  void dispose() {
    reconnectionTimer?.cancel();
    channel?.sink.close();
    super.dispose();
  }
  int currentPageIndex = 0;
  int pastSessionsAmount = 67;
  Map<String, dynamic> telemetryData = {
    "speed": 123.3,
    "RPM": 5700,
    "gear": 3,
    "fuelLeft": 35.8,
    "litersPerLap": 2.5,
    "lapNumber": 21,
    "currentLapTime": 83.534,
    "bestLapTime": 82.342,
    "serverRunning": 0
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Define the pages
    List<Widget> pages = [
      /// Live Data Page
      telemetryData['serverRunning'] == 1 ?
      Center(
        //Center EVERYTHING
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "LAP ${telemetryData['lapNumber']}",
              style: TextStyle(
                fontSize: 50.0,
                fontFamily: lf
              ),
            ),
            Text(
              "${telemetryData['speed']}",
              style: TextStyle(
                fontSize: 100.0,
                fontFamily: lf
              ),
            ),
            Text(
              "${telemetryData["gear"]}-${telemetryData['RPM']}",
              style: TextStyle(
                fontSize: 100.0,
                fontFamily: lf
              ),
            ),
            Text(
              "${(telemetryData['currentLapTime']! / 60).toStringAsFixed(0)}:${(telemetryData['currentLapTime']! % 60).toStringAsFixed(3)} // ${(telemetryData['bestLapTime']! / 60).toStringAsFixed(0)}:${(telemetryData['bestLapTime']! % 60).toStringAsFixed(3)}",
              style: TextStyle(
                fontSize: 50.0, 
                fontFamily: lf
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${telemetryData['fuelLeft']}L // ",
                  style: TextStyle(
                    fontSize: 50.0,
                    fontFamily: lf
                  )
                ),
                
                Text(
                  "${telemetryData['litersPerLap']}L/LAP",
                  style: TextStyle(
                    fontSize: 50.0,
                    fontFamily: lf
                  )
                ),
              ],
            ),
          ],
        ),
      ) : const AlertDialog(
        title: Text("Server offline"),
        content: Text("Please check server is running on your computer and you're on the same network as the computer!")
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
