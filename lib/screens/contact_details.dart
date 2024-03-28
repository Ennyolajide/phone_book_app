import 'dart:io';
import 'package:flutter/material.dart';
import '../models/contact.dart';
import 'contact_form.dart';

class ContactDetailsPage extends StatefulWidget {
  final Contact contact;
  final Function(Contact) onDelete;
  final Function(Contact) onUpdate;
  final File? imageFile;

  ContactDetailsPage({
    Key? key,
    required this.contact,
    required this.onDelete,
    required this.onUpdate,
    this.imageFile,
  }) : super(key: key);

  @override
  _ContactDetailsPageState createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  late Contact _updatedContact;

  @override
  void initState() {
    super.initState();
    _updatedContact = widget.contact;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _updatedContact.avatar != null
                ? Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey),
                        image: DecorationImage(
                          image: NetworkImage(_updatedContact.avatar!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : Container(
                    child: const Text('Avatar Image Not Available'),
                  ),
            const SizedBox(height: 28.0),
            Text(
              'Name: ${_updatedContact.name}',
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Phone Number: ${_updatedContact.phoneNumber}',
              style: const TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactForm(
                      contact: _updatedContact,
                      onContactAdded: (_) {},
                      onContactUpdated: (updatedContact) {
                        setState(() {
                          _updatedContact = updatedContact;
                        });
                        widget.onUpdate(updatedContact);
                      },
                    ),
                  ),
                );
              },
              child: const Text('Edit'),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Delete Contact'),
                      content:
                          Text('Are you sure you want to delete this contact?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Delete',
                              style: TextStyle(color: Colors.red)),
                          onPressed: () {
                            widget.onDelete(_updatedContact);
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.orange),
              ),
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
