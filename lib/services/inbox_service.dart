import 'package:flutter/foundation.dart';
import '../models/inbox_item.dart';

/// Service for managing inbox items (parked or later tasks)
class InboxService extends ChangeNotifier {
  final List<InboxItem> _items = [];

  /// Gets all inbox items
  List<InboxItem> get items => List.unmodifiable(_items);

  /// Gets the count of items in the inbox
  int get itemCount => _items.length;

  /// Adds a new item to the inbox
  void addItem(InboxItem item) {
    _items.add(item);
    notifyListeners();
  }

  /// Removes an item from the inbox by ID
  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  /// Clears all items from the inbox
  void clearAll() {
    _items.clear();
    notifyListeners();
  }

  /// Gets an item by ID
  InboxItem? getItemById(String id) {
    final matches = _items.where((item) => item.id == id);
    return matches.isEmpty ? null : matches.first;
  }
}
