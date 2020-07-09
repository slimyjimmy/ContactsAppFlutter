import 'dart:io';
import 'package:contacts_flutter/DatabaseHelper.dart';
import 'package:contacts_flutter/EditContact.dart';
import 'package:contacts_flutter/resources/values/app_colors.dart';
import 'package:contacts_flutter/resources/values/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Contact.dart';

class ShowContact extends StatefulWidget {
  final Contact contact;

  const ShowContact(this.contact);

  @override
  _ShowContactState createState() => _ShowContactState();
}

class _ShowContactState extends State<ShowContact> {

  void _dialNumber(String number) async {
    var url = "tel:" + number;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _textSms(String number) async {
    var url = "sms:" + number;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void updateContact(Contact contact) {
    DatabaseHelper.updateContact(contact);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Center(
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: (widget.contact.pathToPhoto != null) ? FileImage(File(widget.contact.pathToPhoto)) : AssetImage(('assets/images/defaultAvatar.png')),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            widget.contact.name,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 36.0,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.call),
              onPressed: () => _dialNumber(widget.contact.number),
            ),
            IconButton(
              icon: Icon(Icons.textsms),
              onPressed: () => _textSms(widget.contact.number),
            ),
            IconButton(
              icon: Icon(Icons.video_call),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.all((15.0)),
        child: Text(widget.contact.number,
            textAlign: TextAlign.left, style: TextStyle(fontSize: 30.0))
        )
      ],
    ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        backgroundColor: AppColors.PRIMARY_COLOR,
        onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (BuildContext context) {
          return Scaffold(
            body: EditContact(widget.contact, updateContact)
          );
          EditContact(widget.contact, updateContact);
        }))//EditContact(widget.contact, updateContact),
      ),
    );
  }
}
