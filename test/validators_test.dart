import 'package:flutter_test/flutter_test.dart';
import 'package:playverseadmin/utils/validators.dart';

void main() {
  group('Validators - validateEmail', () {
    test('returns error message if email is null', () {
      final result = Validators.validateEmail(null);
      expect(result, 'Please enter your email');
    });

    test('returns error message if email is empty', () {
      final result = Validators.validateEmail('');
      expect(result, 'Please enter your email');
    });

    test('returns error message if email is whitespace', () {
      final result = Validators.validateEmail('   ');
      expect(result, 'Please enter your email');
    });

    test('returns error message if email format is invalid', () {
      final result = Validators.validateEmail('invalid-email');
      expect(result, 'Please enter a valid email address');
    });

    test('returns null for a valid email', () {
      final result = Validators.validateEmail('admin@playverse.com');
      expect(result, isNull);
    });

    test('returns null for valid email with leading/trailing spaces', () {
      final result = Validators.validateEmail('  admin@playverse.com  ');
      expect(result, isNull);
    });
  });

  group('Validators - validatePassword', () {
    test('returns error message if password is null', () {
      final result = Validators.validatePassword(null);
      expect(result, 'Please enter your password');
    });

    test('returns error message if password is empty', () {
      final result = Validators.validatePassword('');
      expect(result, 'Please enter your password');
    });

    test('returns error message if password is less than 6 characters', () {
      final result = Validators.validatePassword('12345');
      expect(result, 'Password must be at least 6 characters');
    });

    test('returns null for a valid password of 6 or more characters', () {
      final result = Validators.validatePassword('123456');
      expect(result, isNull);
    });
  });
}
