# Architecture Overview

## Feature 1: Daily Summary View (Dopamine Loop)

```
┌─────────────────────────────────────────────────────────────┐
│                        SummaryView                          │
│  ┌───────────────────────────────────────────────────────┐  │
│  │  ┌──────────────┐                                     │  │
│  │  │   ✓ Icon     │  Animated check mark                │  │
│  │  │  (animated)  │                                     │  │
│  │  └──────────────┘                                     │  │
│  │                                                        │  │
│  │         7 Micro-Tasks geschafft!                      │  │
│  │                                                        │  │
│  │  ┌────────────────────────────────────────────────┐   │  │
│  │  │  ⭐ Fantastisch! Du rockst das heute!         │   │  │
│  │  └────────────────────────────────────────────────┘   │  │
│  │                                                        │  │
│  │  Dein Fortschritt                                     │  │
│  │  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━    │  │
│  │  Ziel: 10 Tasks pro Tag                              │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### Data Flow:
```
StorageService.getCompletedTasksToday()
    ↓
Count tasks with status=completed AND completedAt=today
    ↓
Display count with animation
    ↓
Show motivational message based on count
```

## Feature 2: End-of-Day Parked Tasks Dialog

```
┌─────────────────────────────────────────────────────────────┐
│               🌙 Ende des Tages                             │
│                                                             │
│  Du hast 3 geparkte Aufgaben.                              │
│                                                             │
│  Möchtest du die geparkten Aufgaben                        │
│  für morgen speichern?                                     │
│                                                             │
│  Wenn du "Ja" wählst, bleiben die Aufgaben für            │
│  morgen erhalten. Bei "Nein" werden sie gelöscht.          │
│                                                             │
│  ┌─────────────────┐    ┌─────────────────┐               │
│  │ Nein, löschen   │    │  Ja, speichern  │               │
│  └─────────────────┘    └─────────────────┘               │
└─────────────────────────────────────────────────────────────┘
```

### Lifecycle Flow:
```
App Lifecycle State Change
    ↓
AppLifecycleService.didChangeAppLifecycleState()
    ↓
Is it evening (≥18:00)? AND state is paused/detached?
    ↓ Yes
Check for parked tasks
    ↓
Show ParkedTasksDialog
    ↓
User selects: Yes (keep) or No (delete)
    ↓
If No: StorageService.clearParkedTasks()
```

## Component Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         Main App                            │
│  ┌───────────────────────────────────────────────────────┐  │
│  │              MyHomePage (StatefulWidget)              │  │
│  │  - Initializes AppLifecycleService                    │  │
│  │  - Navigation to SummaryView                          │  │
│  │  - Test button for end-of-day dialog                  │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                          │
        ┌─────────────────┼─────────────────┐
        ↓                 ↓                 ↓
┌───────────────┐ ┌──────────────┐ ┌──────────────────┐
│  SummaryView  │ │ Parked Tasks │ │ App Lifecycle    │
│               │ │    Dialog    │ │    Service       │
│ - Load count  │ │ - Check for  │ │ - Monitor state  │
│ - Animate     │ │   parked     │ │ - Trigger dialog │
│ - Motivate    │ │ - User choice│ │ - Handle time    │
└───────────────┘ └──────────────┘ └──────────────────┘
        │                 │                 │
        └─────────────────┴─────────────────┘
                          ↓
                ┌──────────────────┐
                │  StorageService  │
                │                  │
                │ - Save/Load      │
                │   tasks          │
                │ - Get completed  │
                │ - Manage parked  │
                └──────────────────┘
                          ↓
                ┌──────────────────┐
                │ SharedPreferences│
                │   (Local Storage)│
                └──────────────────┘
```

## Models

```
Task {
  - id: String
  - title: String
  - description: String?
  - estimatedMinutes: int
  - status: TaskStatus (pending, inProgress, completed, parked)
  - createdAt: DateTime
  - completedAt: DateTime?
}

DailyProgress {
  - date: DateTime
  - completedTasksCount: int
  - totalEstimatedMinutes: int
}
```

## Key Design Decisions

1. **Local Storage with SharedPreferences**
   - Simple key-value storage for tasks and progress
   - JSON serialization for complex objects
   - No external database dependency

2. **Lifecycle Management**
   - Uses WidgetsBindingObserver for app lifecycle events
   - Tracks evening time (18:00) for automatic dialog trigger
   - Resets daily based on date changes

3. **Visual Feedback (Dopamine Loop)**
   - Animated check icon with elastic curve
   - Color-coded motivational messages
   - Progress bar toward daily goal
   - Large, bold numbers for impact

4. **User Experience**
   - Non-dismissible dialog (requires explicit choice)
   - Clear options (save or delete)
   - Test button for developers/testing
   - Immediate visual feedback
