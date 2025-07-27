// ignore: file_names
class TodoModal {
  int? id;
  String title;
  String description;
  String date;

  TodoModal(
      {
        required this.date,
        required this.description,
        required this.title,
        this.id
        });

  Map<String, dynamic> todoMap() {
    return {"title": title, "description": description, "date": date, "id":id};
  }
}
