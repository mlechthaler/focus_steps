import 'package:flutter_test/flutter_test.dart';
import 'package:focus_steps/models/inbox_item.dart';

void main() {
  group('InboxItem', () {
    test('can be instantiated with required parameters', () {
      final now = DateTime.now();
      final item = InboxItem(
        id: '1',
        title: 'Test Task',
        createdAt: now,
      );
      
      expect(item.id, equals('1'));
      expect(item.title, equals('Test Task'));
      expect(item.description, isNull);
      expect(item.createdAt, equals(now));
    });

    test('can be instantiated with optional description', () {
      final now = DateTime.now();
      final item = InboxItem(
        id: '1',
        title: 'Test Task',
        description: 'Test description',
        createdAt: now,
      );
      
      expect(item.description, equals('Test description'));
    });

    test('toJson serializes correctly', () {
      final now = DateTime(2024, 1, 1, 12, 0);
      final item = InboxItem(
        id: '1',
        title: 'Test Task',
        description: 'Test description',
        createdAt: now,
      );
      
      final json = item.toJson();
      
      expect(json['id'], equals('1'));
      expect(json['title'], equals('Test Task'));
      expect(json['description'], equals('Test description'));
      expect(json['createdAt'], equals(now.toIso8601String()));
    });

    test('fromJson deserializes correctly', () {
      final json = {
        'id': '1',
        'title': 'Test Task',
        'description': 'Test description',
        'createdAt': '2024-01-01T12:00:00.000',
      };
      
      final item = InboxItem.fromJson(json);
      
      expect(item.id, equals('1'));
      expect(item.title, equals('Test Task'));
      expect(item.description, equals('Test description'));
      expect(item.createdAt, equals(DateTime.parse('2024-01-01T12:00:00.000')));
    });

    test('fromJson handles null description', () {
      final json = {
        'id': '1',
        'title': 'Test Task',
        'description': null,
        'createdAt': '2024-01-01T12:00:00.000',
      };
      
      final item = InboxItem.fromJson(json);
      
      expect(item.description, isNull);
    });

    test('equality works based on id', () {
      final now = DateTime.now();
      final item1 = InboxItem(
        id: '1',
        title: 'Test Task',
        createdAt: now,
      );
      final item2 = InboxItem(
        id: '1',
        title: 'Different Title',
        createdAt: now,
      );
      final item3 = InboxItem(
        id: '2',
        title: 'Test Task',
        createdAt: now,
      );
      
      expect(item1, equals(item2));
      expect(item1, isNot(equals(item3)));
    });

    test('hashCode is based on id', () {
      final now = DateTime.now();
      final item1 = InboxItem(
        id: '1',
        title: 'Test Task',
        createdAt: now,
      );
      final item2 = InboxItem(
        id: '1',
        title: 'Different Title',
        createdAt: now,
      );
      
      expect(item1.hashCode, equals(item2.hashCode));
    });
  });
}
