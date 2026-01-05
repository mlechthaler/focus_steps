import 'package:flutter/material.dart';
import 'views/summary_view.dart';
import 'services/app_lifecycle_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Focus Steps',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Focus Steps'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AppLifecycleService? _lifecycleService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize lifecycle service after context is available
    _lifecycleService ??= AppLifecycleService(context);
  }

  @override
  void dispose() {
    _lifecycleService?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.assessment),
            tooltip: 'Erfolge anzeigen',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SummaryView(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Focus Steps - ADHD Task Breakdown',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SummaryView(),
                  ),
                );
              },
              icon: const Icon(Icons.assessment),
              label: const Text('Meine Erfolge heute'),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () async {
                await _lifecycleService?.showEndOfDayDialog();
              },
              icon: const Icon(Icons.nightlight_round),
              label: const Text('Tagesabschluss (Test)'),
            ),
          ],
        ),
      ),
    );
  }
}
