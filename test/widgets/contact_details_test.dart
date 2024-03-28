import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_book_app/models/contact.dart';
import 'package:phone_book_app/screens/contact_details.dart';
import 'package:phone_book_app/screens/contact_form.dart';

void main() {
  testWidgets('Contact details page', (WidgetTester tester) async {
    // Create a mock contact
    final contact = Contact(
      id: '1',
      name: 'John Doe',
      phoneNumber: '+1234567890',
      avatar: 'https://example.com/avatar.jpg',
    );

    // Define flags to track whether callbacks are called
    bool onDeleteCalled = false;
    bool onUpdateCalled = false;

    // Define callbacks
    void onDelete(Contact contact) {
      onDeleteCalled = true;
    }

    void onUpdate(Contact contact) {
      onUpdateCalled = true;
    }

    // Build the ContactDetailsPage widget with defined callbacks
    await tester.pumpWidget(
      MaterialApp(
        home: ContactDetailsPage(
          contact: contact,
          onDelete: onDelete,
          onUpdate: onUpdate,
        ),
      ),
    );

    // Verify that contact details are displayed
    expect(find.text('Name: ${contact.name}'), findsOneWidget);
    expect(find.text('Phone Number: ${contact.phoneNumber}'), findsOneWidget);

    // Tap on edit icon and verify navigation
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();
    expect(find.byType(ContactForm), findsOneWidget);

    // Verify that onDelete callback is called when delete icon is tapped
    await tester.tap(find.byIcon(Icons.delete));
    expect(onDeleteCalled, true);

    // Verify that onUpdate callback is called when save button is tapped
    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(onUpdateCalled, true);
  });
}
