// ignore_for_file: avoid_print
import 'package:flutter_test/flutter_test.dart';
import 'package:playverseadmin/utils/validators.dart';

int totalCases = 0;
int passedCases = 0;
int failedCases = 0;

void runTest(String description, dynamic Function() body) {
  totalCases++;
  test(description, () async {
    print('Running Test: $description');
    try {
      await body();
      passedCases++;
      print('Passed Test: $description');
    } catch (e) {
      failedCases++;
      print('Failed Test: $description - Error: $e');
      rethrow;
    }
  });
}

void main() {
  tearDownAll(() {
    print('\n=======================================');
    print('VALIDATORS UNIT TEST SUMMARY:');
    print('Total Cases: $totalCases');
    print('Passed Cases: $passedCases');
    print('Failed Cases: $failedCases');
    print('=======================================\n');
  });

  group('Validators - validateEmail', () {
    runTest('returns error message if email is null', () {
      final result = Validators.validateEmail(null);
      expect(result, 'Please enter your email');
    });

    runTest('returns error message if email is empty', () {
      final result = Validators.validateEmail('');
      expect(result, 'Please enter your email');
    });

    runTest('returns error message if email is whitespace', () {
      final result = Validators.validateEmail('   ');
      expect(result, 'Please enter your email');
    });

    runTest('returns error message if email format is invalid', () {
      final result = Validators.validateEmail('invalid-email');
      expect(result, 'Please enter a valid email address');
    });

    runTest('returns null for a valid email', () {
      final result = Validators.validateEmail('admin@playverse.com');
      expect(result, isNull);
    });

    runTest('returns null for valid email with leading/trailing spaces', () {
      final result = Validators.validateEmail('  admin@playverse.com  ');
      expect(result, isNull);
    });
  });

  group('Validators - validatePassword', () {
    runTest('returns error message if password is null', () {
      final result = Validators.validatePassword(null);
      expect(result, 'Please enter your password');
    });

    runTest('returns error message if password is empty', () {
      final result = Validators.validatePassword('');
      expect(result, 'Please enter your password');
    });

    runTest('returns error message if password is less than 6 characters', () {
      final result = Validators.validatePassword('12345');
      expect(result, 'Password must be at least 6 characters');
    });

    runTest('returns null for a valid password of 6 or more characters', () {
      final result = Validators.validatePassword('123456');
      expect(result, isNull);
    });
  });
}
