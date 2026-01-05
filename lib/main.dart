import 'package:flutter/material.dart';
import 'services/inbox_service.dart';

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
  final InboxService _inboxService = InboxService();
  
  // TODO: This will be set to true when a task is actively being worked on.
  // For now, defaults to false to show inbox button when items exist.
  bool _hasActiveTask = false;

  @override
  void initState() {
    super.initState();
    _inboxService.addListener(_onInboxChanged);
  }

  @override
  void dispose() {
    _inboxService.removeListener(_onInboxChanged);
    _inboxService.dispose();
    super.dispose();
  }

  void _onInboxChanged() {
    setState(() {});
  }

  void _showInbox() {
    // TODO: Navigate to inbox screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_inboxService.itemCount} tasks in inbox'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Focus Steps - ADHD Task Breakdown',
            ),
          ],
        ),
      ),
      floatingActionButton: !_hasActiveTask && _inboxService.itemCount > 0
          ? FloatingActionButton.extended(
              onPressed: _showInbox,
              icon: const Icon(Icons.inbox),
              label: Text('${_inboxService.itemCount}'),
              tooltip: 'Inbox',
            )
          : null,
    );
  }
}
