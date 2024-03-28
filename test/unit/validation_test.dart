// validation_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_book_app/utils/validation.dart';

void main() {
  test('Phone Number Validation Test', () {
    // Test valid phone number
    expect(Validation.validatePhoneNumber('+1234567890'), null);

    // Test empty phone number
    expect(Validation.validatePhoneNumber(''), 'Please enter a phone number');

    // Test invalid phone number format
    expect(Validation.validatePhoneNumber('+1'),
        'Please enter a valid phone number');
    expect(Validation.validatePhoneNumber('123456'),
        'Please enter a valid phone number');
    expect(Validation.validatePhoneNumber('+1234abc'),
        'Please enter a valid phone number');
  });
}
