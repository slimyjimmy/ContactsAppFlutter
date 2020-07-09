import 'package:flutter/material.dart';

import 'Contact.dart';
import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:contacts_flutter/resources/values/app_colors.dart';
import 'package:contacts_flutter/resources/values/app_strings.dart';
import 'package:contacts_flutter/TakePictureScreen.dart';
import 'package:contacts_flutter/Contact.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;



class NewContact extends StatefulWidget {
  final void Function(Contact) callback;


  /*const NewContact(void Function(Contact addedContact) callback, {
    Key key
  }) : super(key: key);*/
  const NewContact(this.callback);
  /*const NewContact(void Function(Contact) , {
    Key key,
    @required this.callback,
  }) : super(key: key);*/

  @override
  _NewContactState createState() => _NewContactState();
}

class _NewContactState extends State<NewContact> {
  Contact _newContact = Contact.empty();
  TextEditingController nameController;
  TextEditingController numberController;
  CameraDescription firstCamera;

  _NewContactState() {
    initialize();
  }

  void initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    var Cameras = await availableCameras();
    firstCamera = Cameras.first;
  }

  Widget _nameTextField() {
    nameController = new TextEditingController(text: _newContact.name);
    return TextFormField(
      decoration: InputDecoration(labelText: AppStrings.new_contact_name),
        controller: nameController,);
  }

  Widget _numberTextField() {
    numberController = new TextEditingController(text: _newContact.number);
    return TextFormField(
      decoration: InputDecoration(labelText: AppStrings.new_contact_number),
      controller: numberController,);
  }

  void updateNewContact(Contact contact) {
    if (contact.pathToPhoto != null) {
      _newContact.pathToPhoto = contact.pathToPhoto;
    }
    if (contact.name != null) {
      _newContact.name = contact.name;
    }
    if (contact.number != null) {
      _newContact.number = contact.number;
    }
    if (!(_newContact.number == "" || _newContact.number == null) && !(_newContact.name == "" || _newContact.name == null))
    widget.callback(_newContact);
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
          body: Container(
              child: Column(
                children: [
                  IconButton(icon: Icon(Icons.camera_alt), onPressed: () => _takePicture(firstCamera),
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
                    },
                    child: Text(AppStrings.button_save),
                  )
                ],
              )
          )
      );
  }

  void _takePicture(CameraDescription camera) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (BuildContext context) {
      return Scaffold(
        body: TakePictureScreen(camera, updateNewContact),
      );
    }));
  }
}
