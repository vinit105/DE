import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:reminder_app_2/controllers/reminder_controller.dart';
import 'package:reminder_app_2/helpers/db_helper.dart';
import 'package:reminder_app_2/helpers/notification_helper.dart';
import 'package:reminder_app_2/modals/reminder.dart';

addReminder(context) {
  ReminderController reminderController = Get.find();

  final key = GlobalKey<FormState>();
  String title = "";
  String description = "";

  Get.bottomSheet(
    BottomSheet(
      enableDrag: true,
      onClosing: () {
        reminderController.clearDateTime();
      },
      builder: (context) => Container(
        padding: const EdgeInsets.only(right: 10, left: 10, top: 20),
        child: Form(
          key: key,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Add Reminder",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  autofocus: true,
                  decoration: textFiledDecoration(
                      label: "Title", hint: "Enter Reminder title hear"),
                  validator: (val) =>
                      (val!.isEmpty) ? "Enter Title First" : null,
                  onSaved: (val) {
                    title = val!;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
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
                        dateTimePicker(context, reminderController);
                      },
                      icon: const Icon(Icons.watch_later_outlined),
                    ),
                    // Text("data"),
                    Expanded(
                      child: Obx(
                        () => (reminderController.hour.value != 0)
                            ? Text(
                                "${(reminderController.hour.value > 12) ? reminderController.hour.value - 12 : reminderController.hour.value}:${reminderController.minute.value} ${(reminderController.hour.value > 12) ? "PM" : "AM"}",
                                style: Theme.of(context).textTheme.titleMedium,
                              )
                            : const Text(""),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (key.currentState!.validate()) {
                          key.currentState!.save();

                          if (reminderController.hour.value != 0) {
                            Reminder reminder = Reminder(
                                title: title,
                                description: description,
                                hour: reminderController.hour.value,
                                minute: reminderController.minute.value);
                            NotificationHelper.notificationHelper
                                .scheduleNotification(reminder: reminder);
                            DBHelper.dbHelper.insertRecord(reminder: reminder);
                            reminderController.clearDateTime();
                            Get.back();
                          }
                        }
                      },
                      child: const Text("Add"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

dateTimePicker(context, reminderController) {
  // showDatePicker(
  //   context: context,
  //   initialDate: DateTime.now(),
  //   firstDate: DateTime.now(),
  //   lastDate: DateTime(2030),
  // ).then((DateTime? value) {
  //   // print(value!.month);
  //   // print(value.day);
  //   // print(value.year);
  //   if (value != null) {
  showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  ).then((TimeOfDay? value1) {
    if (value1 != null) {
      reminderController.setDateTime(
          // yearVal: value.year,
          // monthVal: value.month,
          // dayVal: value.day,
          hourVal: value1.hour,
          minuteVal: value1.minute);
    }

    // print(value!.hourOfPeriod);
    // print(value.minute);
    // DateTime(2022, 1, 12, 15, 10);
    // print(DateTime(2022, 1, 12, 15, 10));
  });
  //   }
  // });
}

textFiledDecoration({required String label, required String hint}) {
  return InputDecoration(
    label: Text(label),
    contentPadding: const EdgeInsets.all(15),
    hintText: hint,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  );
}
