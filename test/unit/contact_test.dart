import 'package:flutter_test/flutter_test.dart';
import 'package:phone_book_app/models/contact.dart';

void main() {
  test('Contact Model Test', () {
    final contact = Contact(
      id: '1',
      name: 'John Doe',
      phoneNumber: '+1234567890',
      avatar: 'https://example.com/avatar.jpg',
    );

    expect(contact.id, '1');
    expect(contact.name, 'John Doe');
    expect(contact.phoneNumber, '+1234567890');
    expect(contact.avatar, 'https://example.com/avatar.jpg');
  });
}
