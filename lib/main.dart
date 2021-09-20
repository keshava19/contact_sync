import 'package:flutter/material.dart';

import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact Sync',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Contact Sync Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<bool> _hasContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    return permission == PermissionStatus.granted;
  }

  Future<bool> _requestContactPermission() async {
    await Permission.contacts.request();
    return _hasContactPermission();
  }

  void _addNewContact() async {
    bool contactPermission = await _hasContactPermission();
    if (!contactPermission) {
      bool didGetPermission = await _requestContactPermission();
      if (didGetPermission) {
        _createContact();
      }
    } else {
      _createContact();
    }
  }

  void _createContact() async {
    
    var phone = Item(label: "Mobile", value: "9563156485");
    var phones = [phone];
    Iterable<Item> test = phones;
    var newContact = Contact(givenName: 'Test', familyName: 'Contact', phones: test);
    await ContactsService.addContact(newContact);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Push Button to create new contact.'),
            ElevatedButton(
                onPressed: _addNewContact, child: Text('Create New Contact'))
          ],
        ),
      ),
    );
  }
}
