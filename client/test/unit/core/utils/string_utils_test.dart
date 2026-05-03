import 'package:flutter_test/flutter_test.dart';
import 'package:persona_path/core/utils/string_utils.dart';

void main() {
  group('resolveFallbackName', () {
    test('returns name before at symbol', () {
      expect(resolveFallbackName('jane.doe@example.com'), 'jane.doe');
    });

    test('returns default when there is no email', () {
      expect(resolveFallbackName(null), 'Traveler');
    });

    test('trims whitespace and uses default when nothing meaningful found', () {
      expect(resolveFallbackName('   '), 'Traveler');
      expect(resolveFallbackName('no-at-symbol'), 'Traveler');
    });
  });
}
