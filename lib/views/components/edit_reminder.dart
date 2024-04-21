import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reminder_app_2/modals/reminder.dart';

import '../../controllers/reminder_controller.dart';
import '../../helpers/db_helper.dart';
import '../../helpers/notification_helper.dart';
import 'add_reminder.dart';

editReminder(
    {required ReminderDB reminder, required BuildContext context}) async {
  ReminderController reminderController = Get.find();

  final key = GlobalKey<FormState>();
  String title = "";
  String description = "";

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  reminderController.setDateTime(
      hourVal: reminder.hour, minuteVal: reminder.minute);
  titleController.text = reminder.title;
  descController.text = reminder.description;

  Get.dialog(
    AlertDialog(
      scrollable: true,
      title: const Text("Update Reminder"),
      content: Form(
        key: key,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            TextFormField(
              controller: titleController,
              decoration: textFiledDecoration(
                  label: "Title", hint: "Enter Reminder title hear"),
              validator: (val) => (val!.isEmpty) ? "Enter Title First" : null,
              onSaved: (val) {
                title = val!;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: descController,
              decoration: textFiledDecoration(
                  label: "Description", hint: "Enter Description hear"),
              validator: (val) =>
                  (val!.isEmpty) ? "Enter Description First" : null,
              onSaved: (val) {
                description = val!;
              },
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    dateTimePickerEdit(context, reminderController);
                  },
                  icon: const Icon(Icons.watch_later_outlined),
                ),
                // Text("data"),
                Expanded(
                  child: Obx(
                    () => (reminderController.hour.value != 0)
                        ? Text(
                            "${(reminderController.hour.value > 12) ? reminderController.hour.value - 12 : reminderController.hour.value}:${reminderController.minute.value} ${(reminderController.hour.value > 12) ? "PM" : "AM"}",
                            style: Theme.of(context).textTheme.titleMedium)
                        : const Text(""),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () {
            Get.back();
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (key.currentState!.validate()) {
              key.currentState!.save();

              if (reminderController.hour.value != 0) {
                ReminderDB reminderDB = ReminderDB(
                    id: reminder.id,
                    title: title,
                    description: description,
                    hour: reminderController.hour.value,
                    minute: reminderController.minute.value);

                Reminder reminder2 = Reminder(
                    title: title,
                    description: description,
                    hour: reminderController.hour.value,
                    minute: reminderController.minute.value);

                NotificationHelper.notificationHelper
                    .scheduleNotification(reminder: reminder2);
                DBHelper.dbHelper.updateReminder(reminder: reminderDB);
                reminderController.clearDateTime();
                Get.back();
              }
            }
          },
          child: const Text("Update"),
        ),
      ],
    ),
  );
}

dateTimePickerEdit(context, ReminderController reminderController) {
  showTimePicker(
    context: context,
    initialTime: TimeOfDay(
        minute: reminderController.minute.value,
        hour: reminderController.hour.value),
  ).then((TimeOfDay? value1) {
    if (value1 != null) {
      reminderController.setDateTime(
          hourVal: value1.hour, minuteVal: value1.minute);
    }
  });
}
