class Reminder {
  final String title;
  final String description;
  final int hour;
  final int minute;

  Reminder({
    required this.title,
    required this.description,
    required this.hour,
    required this.minute,
  });
}

class ReminderDB {
  final int id;
  final String title;
  final String description;
  final int hour;
  final int minute;

  ReminderDB({
    required this.id,
    required this.title,
    required this.description,
    required this.hour,
    required this.minute,
  });

  factory ReminderDB.fromData({required Map data}) {
    return ReminderDB(
      id: data["id"],
      title: data["title"],
      description: data["description"],
      hour: data["hour"],
      minute: data["minute"],
    );
  }
}
