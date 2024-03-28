import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/contact.dart';
import 'contact_details.dart';
import 'contact_form.dart';
import '../utils/theme_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Contact> _contacts;
  late List<Contact> _filteredContacts;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = true; // Always show search by default

  @override
  void initState() {
    super.initState();
    _loadContacts().then((_) {
      setState(() {
        _filteredContacts = List.from(_contacts);
      });
    });
  }

  Future<void> _loadContacts() async {
    String jsonData = '''
      [
        {
          "id": "1",
          "name": "Alice Johnson",
          "phoneNumber": "+1234567890",
          "avatar": "https://picsum.photos/200/300"
        },
        {
          "id": "2",
          "name": "Bob Smith",
          "phoneNumber": "+0987654321",
          "avatar": "https://picsum.photos/200/300"
        },
        {
          "id": "3",
          "name": "Charlie Brown",
          "phoneNumber": "+1122334455",
          "avatar": "https://picsum.photos/200/300"
        },
        {
          "id": "4",
          "name": "David Williams",
          "phoneNumber": "+5566778899",
          "avatar": "https://picsum.photos/200/300"
        },
        {
          "id": "5",
          "name": "Eva Green",
          "phoneNumber": "+2244668800",
          "avatar": "https://picsum.photos/200/300"
        }
      ]
    ''';

    List<dynamic> jsonList = json.decode(jsonData);
    setState(() {
      _contacts = jsonList.map((json) => Contact.fromJson(json)).toList();
      _filteredContacts = List.from(_contacts);
    });
  }

  void _filterContacts(String query) {
    setState(() {
      _filteredContacts = _contacts
          .where((contact) =>
              contact.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Book'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_4),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterContacts,
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 0.001), // Adjust the color and w
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Expanded(
              child: _filteredContacts.isEmpty
                  ? Center(
                      child: _contacts.isEmpty
                          ? CircularProgressIndicator()
                          : Text('No results found'),
                    )
                  : ListView.builder(
                      itemCount: _filteredContacts.length,
                      itemBuilder: (BuildContext context, int index) {
                        Contact contact = _filteredContacts[index];
                        return ListTile(
                          title: Text(contact.name),
                          subtitle: Text(contact.phoneNumber),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(contact.avatar),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red, // Or any other color you prefer
                            onPressed: () {
                              _deleteContact(contact);
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContactDetailsPage(
                                  contact: contact,
                                  onDelete: (deletedContact) {
                                    setState(() {
                                      _contacts.removeWhere(
                                          (c) => c.id == deletedContact.id);
                                      _filteredContacts.removeWhere(
                                          (c) => c.id == deletedContact.id);
                                    });
                                  },
                                  onUpdate: (updatedContact) {
                                    setState(() {
                                      _contacts[_contacts.indexWhere((c) =>
                                              c.id == updatedContact.id)] =
                                          updatedContact;
                                      _filteredContacts[_filteredContacts
                                              .indexWhere((c) =>
                                                  c.id == updatedContact.id)] =
                                          updatedContact;
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ContactForm(
                      onContactAdded: (newContact) {
                        setState(() {
                          _contacts.add(newContact);
                          _filteredContacts.add(newContact);
                        });
                      },
                      onContactUpdated: (updatedContact) {
                        setState(() {
                          _contacts[_contacts.indexWhere(
                                  (c) => c.id == updatedContact.id)] =
                              updatedContact;
                          _filteredContacts[_filteredContacts.indexWhere(
                                  (c) => c.id == updatedContact.id)] =
                              updatedContact;
                        });
                      },
                    )),
          );
        },
        tooltip: 'Add Contact',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _deleteContact(Contact contact) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Contact'),
          content: Text('Are you sure you want to delete ${contact.name}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _confirmDelete(contact);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(Contact contact) {
    setState(() {
      _contacts.remove(contact);
      _filteredContacts.removeWhere((c) => c.id == contact.id);
    });
  }
}
