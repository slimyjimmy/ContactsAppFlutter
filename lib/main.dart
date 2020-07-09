import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:contacts_flutter/NewContact.dart';
import 'package:contacts_flutter/ShowContact.dart';
import 'package:flutter/material.dart';
import 'package:contacts_flutter/resources/values/app_colors.dart';
import 'package:contacts_flutter/resources/values/app_strings.dart';
import 'package:contacts_flutter/TakePictureScreen.dart';
import 'package:contacts_flutter/Contact.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'package:contacts_flutter/DatabaseHelper.dart';

void main() async {
  DatabaseHelper.instantiateDatabase();
  runApp(MyApp());
}
/*Future<void> main() async {
  runApp(MyApp());
}*/

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.app_name,
      theme: ThemeData(
        primaryColor: AppColors.PRIMARY_COLOR,
      ),
      home: ContactsList(),
    );
  }
}

class ContactsList extends StatefulWidget {
  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  var _contacts = <Contact>[];
  final _biggerFont = TextStyle(fontSize: 18.0);

  void _refreshContacts() async {
    var tempContactList = await DatabaseHelper.contacts();
    setState(() {
      _contacts = tempContactList;
    });
  }

  Widget _getContacts() {
    _refreshContacts();
    return ListView.separated(
      itemCount: _contacts.length,
      itemBuilder: (context, i) {
        return _buildRow(_contacts[i]);
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  Widget _buildRow(Contact contact) {
    return ListTile(
      leading: (contact.pathToPhoto != null) ?  Image.file(File(contact.pathToPhoto)) : Icon(Icons.account_circle),
      title: Text(
        contact.name,
        style: _biggerFont,
      ),
      onTap: () => (Navigator.of(context).push(MaterialPageRoute<void>(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: Text(AppStrings.app_name),),
          body: ShowContact(contact),
        );
      }))),
    );
  }

  void _getPhoto() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
  }

  void callback(Contact addedContact) async {
    var nextId = (_contacts.length > 0) ? _contacts.last.id + 1 : 1;
    addedContact.id = nextId;
    DatabaseHelper.insertContact(addedContact);
    _refreshContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.app_name),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: _getContacts(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => (Navigator.of(context).push(MaterialPageRoute<void>(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(title: Text(AppStrings.app_name)),
            body: NewContact(callback),
          );}))),
        child: Icon(Icons.add),
        backgroundColor: AppColors.PRIMARY_COLOR,
      ),
    );
  }
}
