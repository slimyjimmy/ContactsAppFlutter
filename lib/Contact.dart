class Contact {
  int id;
  String name, number, pathToPhoto;

  Contact(this.id, this.name, this.number, this.pathToPhoto);

  Contact.empty();


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'number': number,
      'pathToPhoto': pathToPhoto
    };
  }
}