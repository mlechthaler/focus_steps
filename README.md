# focus_steps

A Flutter application for breaking down tasks into ADHD-friendly steps.

## Features

### 1. Task Management
- Break down tasks into micro-tasks (5-10 minute steps)
- Track task status (pending, in progress, completed, parked)
- Store tasks locally with SharedPreferences

### 2. Daily Summary View (Dopamin-Loop)
The app includes a **SummaryView** that visualizes daily achievements to strengthen the dopamine loop:
- Shows count of completed micro-tasks for the day
- Animated success icon with elastic animation
- Motivational messages based on achievement level
- Progress bar showing daily goal (10 tasks)
- Color-coded visual feedback

### 3. End-of-Day Parked Tasks Dialog
The app asks users at the end of the day about parked tasks:
- Automatically triggers in the evening (after 18:00)
- Shows when app is closing or paused
- Asks: "Möchtest du die geparkten Aufgaben für morgen speichern?"
- Options:
  - **Ja, speichern**: Keep parked tasks for tomorrow
  - **Nein, löschen**: Clear parked tasks

### 4. App Lifecycle Management
- Monitors app lifecycle (paused, resumed, detached)
- Detects new day and resets dialog state
- Manual trigger option for testing

## Architecture

### Models
- **Task**: Represents a micro-task with status, timestamps, and metadata
- **DailyProgress**: Tracks daily completion statistics

### Services
- **ApiService**: Integration with OpenAI for task breakdown
- **StorageService**: Local persistence using SharedPreferences
- **AppLifecycleService**: Manages app lifecycle and end-of-day logic

### Views
- **SummaryView**: Displays daily achievements with animations
- **ParkedTasksDialog**: Dialog for end-of-day parked task management

## Getting Started

### Prerequisites
- Flutter SDK >=3.0.0
- Dart SDK >=3.0.0

### Installation

```bash
flutter pub get
```

### Running the App

```bash
flutter run
```

### Running Tests

```bash
flutter test
```

## Usage

### Viewing Daily Summary
1. Click the assessment icon in the app bar, or
2. Click "Meine Erfolge heute" button on the home screen

### Testing End-of-Day Dialog
Click the "Tagesabschluss (Test)" button to manually trigger the parked tasks dialog.

### Automatic End-of-Day Trigger
The dialog automatically appears:
- When the app is paused or closed after 18:00
- Once per day (resets at midnight)

## Dependencies

- `flutter`: Flutter SDK
- `http`: HTTP client for API calls
- `shared_preferences`: Local data persistence

## Development

### Adding New Task Statuses
Edit `lib/models/task.dart` and add to the `TaskStatus` enum.

### Customizing Motivational Messages
Edit the `_getMotivationalMessage()` method in `lib/views/summary_view.dart`.

### Adjusting End-of-Day Time
Modify the `isEvening` check in `lib/services/app_lifecycle_service.dart` (currently set to 18:00).

## License

This project is part of the Focus Steps application for ADHD task management.