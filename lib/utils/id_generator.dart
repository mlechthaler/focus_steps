/// Utility class for generating unique IDs
class IdGenerator {
  /// Generates a unique ID based on the current timestamp
  static String generate() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
