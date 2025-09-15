import 'dart:math';

// Read about Base 32 here:
// https://www.connect2id.com/blog/how-to-generate-human-friendly-identifiers

/// Helper class for generating random IDs
abstract class IdHelper {
  static final List<String> _base64chars =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-_'
          .split('');

  static final _random = Random();

  /// Generates a random base64 string of the given length
  static String getBase64(int length) {
    final sb = StringBuffer();
    for (var i = 0; i < length; i++) {
      sb.write(_base64chars[_random.nextInt(64)]);
    }
    return sb.toString();
  }

  /// Generates a random base62 string of the given length
  static String getBase62(int length) {
    final sb = StringBuffer();
    for (var i = 0; i < length; i++) {
      sb.write(_base64chars[_random.nextInt(62)]);
    }
    return sb.toString();
  }

  /// Generates a random base36 string of the given length
  static String getBase36(int length) {
    final sb = StringBuffer();
    for (var i = 0; i < length; i++) {
      sb.write(_base64chars[_random.nextInt(36)]);
    }
    return sb.toString();
  }

  /// Generates a random ID of length 10
  static String randomId() {
    // Probability of collision: 1 / (62 ^ 10).
    // Shouldn't be a problem in our case.
    return IdHelper.getBase62(10);
  }

  /// Generates a random ID of length 6
  static String randomIdShort() {
    // Probability of collision: 1 / (62 ^ 6).
    // Shouldn't be a problem in our case.
    return IdHelper.getBase62(6);
  }
}
