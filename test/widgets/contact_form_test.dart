import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_book_app/screens/contact_form.dart';

void main() {
  testWidgets('Contact form validation', (WidgetTester tester) async {
    // Define mock callbacks
    bool onContactAddedCalled = false;
    bool onContactUpdatedCalled = false;

    void onContactAdded(dynamic _) {
      onContactAddedCalled = true;
    }

    void onContactUpdated(dynamic _) {
      onContactUpdatedCalled = true;
    }

    // Build the ContactForm widget with mock callbacks
    await tester.pumpWidget(
      MaterialApp(
        home: ContactForm(
          onContactAdded: onContactAdded,
          onContactUpdated: onContactUpdated,
        ),
      ),
    );

    // Enter invalid data into form fields
    await tester.enterText(find.byKey(const Key('nameField')), '');
    await tester.enterText(find.byKey(const Key('phoneNumberField')), '');

    // Trigger form validation
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Expect to find validation error messages
    expect(find.text('Please enter a name'), findsOneWidget);
    expect(find.text('Please enter a phone number'), findsOneWidget);

    // Enter valid data into form fields
    await tester.enterText(find.byKey(const Key('nameField')), 'John Doe');
    await tester.enterText(
        find.byKey(const Key('phoneNumberField')), '+1234567890');

    // Trigger form validation
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Expect no validation error messages
    expect(find.text('Please enter a name'), findsNothing);
    expect(find.text('Please enter a phone number'), findsNothing);

    // Verify that onContactAdded is called when adding a new contact
    expect(onContactAddedCalled, true);

    // Verify that onContactUpdated is not called when adding a new contact
    expect(onContactUpdatedCalled, false);
  });
}
