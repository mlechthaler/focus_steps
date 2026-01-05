import 'package:flutter_test/flutter_test.dart';
import 'package:focus_steps/services/inbox_service.dart';
import 'package:focus_steps/models/inbox_item.dart';

void main() {
  group('InboxService', () {
    test('can be instantiated', () {
      final service = InboxService();
      expect(service, isNotNull);
    });

    test('starts with empty items', () {
      final service = InboxService();
      expect(service.items, isEmpty);
      expect(service.itemCount, equals(0));
    });

    test('addItem adds an item to the inbox', () {
      final service = InboxService();
      final item = InboxItem(
        id: '1',
        title: 'Test Task',
        createdAt: DateTime.now(),
      );
      
      service.addItem(item);
      
      expect(service.itemCount, equals(1));
      expect(service.items, contains(item));
    });

    test('addItem notifies listeners', () {
      final service = InboxService();
      var notified = false;
      
      service.addListener(() {
        notified = true;
      });
      
      final item = InboxItem(
        id: '1',
        title: 'Test Task',
        createdAt: DateTime.now(),
      );
      
      service.addItem(item);
      
      expect(notified, isTrue);
    });

    test('removeItem removes an item by id', () {
      final service = InboxService();
      final item1 = InboxItem(
        id: '1',
        title: 'Test Task 1',
        createdAt: DateTime.now(),
      );
      final item2 = InboxItem(
        id: '2',
        title: 'Test Task 2',
        createdAt: DateTime.now(),
      );
      
      service.addItem(item1);
      service.addItem(item2);
      
      service.removeItem('1');
      
      expect(service.itemCount, equals(1));
      expect(service.items, isNot(contains(item1)));
      expect(service.items, contains(item2));
    });

    test('removeItem notifies listeners', () {
      final service = InboxService();
      var notified = false;
      
      final item = InboxItem(
        id: '1',
        title: 'Test Task',
        createdAt: DateTime.now(),
      );
      
      service.addItem(item);
      
      service.addListener(() {
        notified = true;
      });
      
      service.removeItem('1');
      
      expect(notified, isTrue);
    });

    test('clearAll removes all items', () {
      final service = InboxService();
      
      service.addItem(InboxItem(
        id: '1',
        title: 'Test Task 1',
        createdAt: DateTime.now(),
      ));
      service.addItem(InboxItem(
        id: '2',
        title: 'Test Task 2',
        createdAt: DateTime.now(),
      ));
      
      service.clearAll();
      
      expect(service.itemCount, equals(0));
      expect(service.items, isEmpty);
    });

    test('clearAll notifies listeners', () {
      final service = InboxService();
      var notified = false;
      
      service.addItem(InboxItem(
        id: '1',
        title: 'Test Task',
        createdAt: DateTime.now(),
      ));
      
      service.addListener(() {
        notified = true;
      });
      
      service.clearAll();
      
      expect(notified, isTrue);
    });

    test('getItemById returns correct item', () {
      final service = InboxService();
      final item = InboxItem(
        id: '1',
        title: 'Test Task',
        createdAt: DateTime.now(),
      );
      
      service.addItem(item);
      
      final found = service.getItemById('1');
      
      expect(found, equals(item));
    });

    test('getItemById returns null for non-existent id', () {
      final service = InboxService();
      
      final found = service.getItemById('non-existent');
      
      expect(found, isNull);
    });

    test('items returns unmodifiable list', () {
      final service = InboxService();
      final item = InboxItem(
        id: '1',
        title: 'Test Task',
        createdAt: DateTime.now(),
      );
      
      service.addItem(item);
      
      final items = service.items;
      
      expect(items, isA<List<InboxItem>>());
      expect(() => items.add(item), throwsUnsupportedError);
    });
  });
}
