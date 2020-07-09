import 'package:contacts_flutter/DatabaseHelper.dart';
import 'package:contacts_flutter/resources/values/app_strings.dart';
import 'package:flutter/material.dart';

import 'Contact.dart';

class EditContact extends StatefulWidget {
  Contact editContact;
  final void Function(Contact) callback;

  EditContact(this.editContact, this.callback);

  @override
  _EditContactState createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {
  TextEditingController nameController;
  TextEditingController numberController;

  void updateNewContact(Contact contact) {
    if (contact.pathToPhoto != null) {
      widget.editContact.pathToPhoto = contact.pathToPhoto;
    }
    if (contact.name != null) {
      widget.editContact.name = contact.name;
    }
    if (contact.number != null) {
      widget.editContact.number = contact.number;
    }
    if (!(widget.editContact.number == "" || widget.editContact.number == null) && !(widget.editContact.name == "" || widget.editContact.name == null))
      widget.callback(widget.editContact);
  }

  Widget _nameTextField() {
    nameController = new TextEditingController(text: widget.editContact.name);
    return TextFormField(
      decoration: InputDecoration(labelText: AppStrings.new_contact_name),
      controller: nameController,);
  }

  Widget _numberTextField() {
    numberController = new TextEditingController(text: widget.editContact.number);
    return TextFormField(
      decoration: InputDecoration(labelText: AppStrings.new_contact_number),
      controller: numberController,);
  }

  void _handleClick(String value) {
    switch(value) {
      case "Delete":
        DatabaseHelper.deleteContact(widget.editContact.id);
        Navigator.pop(context);
        Navigator.pop(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit contact'),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: _handleClick,
              itemBuilder: (BuildContext context) {
                return {'Share', 'Delete'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Container(
            child: Column(
              children: [
                IconButton(icon: Icon(Icons.camera_alt), /*onPressed: () => _takePicture(firstCamera),*/
                ),
                _nameTextField(),
                _numberTextField(),
                RaisedButton(
                  onPressed: () {
//                      setState(() {
                    updateNewContact(Contact(-1, nameController.text, numberController.text, null));
                    //widget.callback(_newContact);
//                      });
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text(AppStrings.button_save),
                )
              ],
            )
        )
    );
  }
}
