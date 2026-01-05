# focus_steps

A Flutter application designed to help people with ADHD break down tasks into manageable, ADHD-friendly micro-steps.

## Features

### Task Breakdown
- **Immediate Breakdown**: Enter a task and have it immediately broken down into 5-10 minute micro-steps using AI (OpenAI API)
- **Inbox for Later**: Save tasks to process later when you have more time
- **Smart Organization**: Broken-down tasks are automatically inserted at the top of your current tasks list

### User Interface
- **Two-Tab Layout**: 
  - Current Tasks: Active tasks broken down into steps
  - Inbox: Tasks saved for later breakdown
- **Task Cards**: Visual preview of tasks with step count and estimated time
- **Easy Management**: Delete tasks with a single tap

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- OpenAI API Key (for task breakdown feature)

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Set your OpenAI API key as an environment variable:
   ```bash
   flutter run --dart-define=OPENAI_API_KEY=your_api_key_here
   ```

### Running Tests

```bash
flutter test
```

## Architecture

The app uses:
- **Riverpod** for state management
- **flutter_riverpod** for reactive UI updates
- **http** package for API communication
- **OpenAI API** for intelligent task breakdown

### Project Structure

```
lib/
├── main.dart                 # App entry point and main UI
├── models/
│   └── task.dart            # Task and TaskStep models
├── providers/
│   └── tasks_provider.dart  # Riverpod providers for state management
├── services/
│   └── api_service.dart     # OpenAI API integration
├── utils/
│   └── id_generator.dart    # Utility for generating unique IDs
└── widgets/
    ├── add_task_bottom_sheet.dart  # Bottom sheet for adding tasks
    └── task_card.dart              # Widget for displaying tasks
```

## Usage

1. **Add a Task**: Tap the "Neue Aufgabe" (New Task) button
2. **Choose an Option**:
   - **Sofort einschieben** (Insert Immediately): Breaks down the task using AI and adds it to your current tasks
   - **Später zerlegen** (Break Down Later): Saves the task to your inbox for later processing
3. **View Tasks**: Switch between "Aktuelle Aufgaben" (Current Tasks) and "Inbox" tabs
4. **Delete Tasks**: Tap the delete icon on any task card

## Contributing

This is an ADHD-friendly task management tool. Contributions are welcome!

## License

This project is licensed under the MIT License.