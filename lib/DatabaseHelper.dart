import 'dart:async';

import 'package:contacts_flutter/Contact.dart';
import 'package:flutter/widgets.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database database;

  static void instantiateDatabase() async {
    // Avoid errors caused by flutter upgrade.
    // Importing 'package:flutter/widgets.dart' is required.
    WidgetsFlutterBinding.ensureInitialized();
    database = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'Contacts_database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE Contacts(id INTEGER PRIMARY KEY, name TEXT, number TEXT, pathToPhoto TEXT)",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

    static Future<void> insertContact(Contact contact) async {
      // Get a reference to the database.
      final Database db = /*await*/ database;

      // Insert the Dog into the correct table. Also specify the
      // `conflictAlgorithm`. In this case, if the same dog is inserted
      // multiple times, it replaces the previous data.
      await db.insert(
        'Contacts',
        contact.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    static Future<List<Contact>> contacts() async {
      // Get a reference to the database.
      final Database db = /*await*/ database;

      // Query the table for all The Dogs.
      final List<Map<String, dynamic>> maps = await db.query('Contacts');

      // Convert the List<Map<String, dynamic> into a List<Dog>.
      return List.generate(maps.length, (i) {
        /*return Contact(
        id: maps[i]['id'],
        name: maps[i]['name'],
        number: maps[i]['number'],
        pathToPhoto: maps[i]['pathToPhoto'],
      );*/
        return Contact(maps[i]['id'], maps[i]['name'], maps[i]['number'],
            maps[i]['pathToPhoto']);
      });
    }

    static Future<void> updateContact(Contact contact) async {
      // Get a reference to the database.
      final db = /*await*/ database;

      // Update the given Dog.
      await db.update(
        'Contacts',
        contact.toMap(),
        // Ensure that the Dog has a matching id.
        where: "id = ?",
        // Pass the Dog's id as a whereArg to prevent SQL injection.
        whereArgs: [contact.id],
      );
    }

    static Future<void> deleteContact(int id) async {
      // Get a reference to the database.
      final db = /*await*/ database;

      // Remove the Dog from the database.
      await db.delete(
        'Contacts',
        // Use a `where` clause to delete a specific dog.
        where: "id = ?",
        // Pass the Dog's id as a whereArg to prevent SQL injection.
        whereArgs: [id],
      );
    }
  //}
}

  /*var fido = Dog(
    id: 0,
    name: 'Fido',
    age: 35,
  );*/

  // Insert a dog into the database.
  //await insertDog(fido);

  // Print the list of dogs (only Fido for now).
  //print(await dogs());

  //await updateDog(fido);

  // Print Fido's updated information.
  //print(await dogs());

  // Delete Fido from the database.
  //await deleteDog(fido.id);

  // Print the list of dogs (empty).
  //print(await dogs());
