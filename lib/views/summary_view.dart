import 'package:flutter/material.dart';
import '../services/storage_service.dart';

/// View that shows a summary of completed micro-tasks for the day
/// Provides visual feedback to strengthen the dopamine loop
class SummaryView extends StatefulWidget {
  const SummaryView({super.key});

  @override
  State<SummaryView> createState() => _SummaryViewState();
}

class _SummaryViewState extends State<SummaryView>
    with SingleTickerProviderStateMixin {
  /// Daily goal for number of tasks to complete
  static const int dailyTaskGoal = 10;

  int _completedTasksCount = 0;
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
    _loadCompletedTasks();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadCompletedTasks() async {
    final storage = await StorageService.create();
    final count = await storage.getCompletedTasksToday();
    setState(() {
      _completedTasksCount = count;
      _isLoading = false;
    });
    _animationController.forward();
  }

  String _getMotivationalMessage() {
    if (_completedTasksCount == 0) {
      return 'Starte jetzt und schaffe deinen ersten Schritt!';
    } else if (_completedTasksCount < 3) {
      return 'Guter Start! Weiter so!';
    } else if (_completedTasksCount < 5) {
      return 'Wow, du bist auf Erfolgskurs!';
    } else if (_completedTasksCount < 10) {
      return 'Fantastisch! Du rockst das heute!';
    } else {
      return 'Unglaublich! Du bist eine Produktivitäts-Maschine!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deine Erfolge heute'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    
                    // Animated success icon
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle,
                          size: 80,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Task count display
                    Text(
                      '$_completedTasksCount',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Text(
                      _completedTasksCount == 1
                          ? 'Micro-Task geschafft!'
                          : 'Micro-Tasks geschafft!',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.grey.shade700,
                          ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Motivational message card
                    Card(
                      elevation: 4,
                      color: Colors.purple.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              size: 40,
                              color: Colors.purple.shade700,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _getMotivationalMessage(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: Colors.purple.shade900,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Progress indicators
                    if (_completedTasksCount > 0)
                      Column(
                        children: [
                          const Text(
                            'Dein Fortschritt',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildProgressBar(context),
                        ],
                      ),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    // Visual progress bar based on task count
    final progress = (_completedTasksCount / dailyTaskGoal).clamp(0.0, 1.0);
    
    return Column(
      children: [
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
          minHeight: 10,
        ),
        const SizedBox(height: 8),
        Text(
          'Ziel: $dailyTaskGoal Tasks pro Tag',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
