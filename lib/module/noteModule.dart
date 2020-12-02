class NoteModule {
  String title;
  String description;
  DateTime dateTime;
  String imageUrl;

  NoteModule(this.title, this.description, this.dateTime, this.imageUrl);

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "dateTime": dateTime,
      'imageUrl': imageUrl,
    };
  }
}
