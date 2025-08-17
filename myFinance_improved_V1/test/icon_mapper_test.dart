import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myfinance_improved/core/constants/icon_mapper.dart';

void main() {
  group('IconMapper Tests', () {
    test('should return default icon when iconKey is null', () {
      final result = IconMapper.getIcon(null);
      expect(result, equals(FontAwesomeIcons.circleQuestion));
    });

    test('should return default icon when iconKey is empty', () {
      final result = IconMapper.getIcon('');
      expect(result, equals(FontAwesomeIcons.circleQuestion));
    });

    test('should return correct icon for wallet iconKey', () {
      final result = IconMapper.getIcon('wallet');
      expect(result, equals(FontAwesomeIcons.wallet));
    });

    test('should return correct icon for dashboard iconKey', () {
      final result = IconMapper.getIcon('dashboard');
      expect(result, equals(FontAwesomeIcons.chartLine));
    });

    test('should return correct icon for userCircle iconKey', () {
      final result = IconMapper.getIcon('userCircle');
      expect(result, equals(FontAwesomeIcons.userCircle));
    });

    test('should return default icon for unknown iconKey', () {
      final result = IconMapper.getIcon('unknown_icon_key');
      expect(result, equals(FontAwesomeIcons.circleQuestion));
    });

    test('should return correct icon for chartLine iconKey', () {
      final result = IconMapper.getIcon('chartLine');
      expect(result, equals(FontAwesomeIcons.chartLine));
    });

    test('should return correct icon for cashRegister iconKey', () {
      final result = IconMapper.getIcon('cashRegister');
      expect(result, equals(FontAwesomeIcons.cashRegister));
    });

    test('should get all icon keys without error', () {
      final keys = IconMapper.getAllIconKeys();
      expect(keys, isNotEmpty);
      expect(keys, contains('wallet'));
      expect(keys, contains('dashboard'));
      expect(keys, contains('userCircle'));
    });

    test('should get icon color for financial icons', () {
      final walletColor = IconMapper.getIconColor('wallet');
      expect(walletColor, isNotNull);
    });

    test('should get default color for unknown iconKey', () {
      final unknownColor = IconMapper.getIconColor('unknown');
      expect(unknownColor, isNotNull);
    });
  });
}