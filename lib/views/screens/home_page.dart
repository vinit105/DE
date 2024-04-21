import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:reminder_app_2/controllers/reminder_controller.dart';
import 'package:reminder_app_2/helpers/db_helper.dart';
import 'package:reminder_app_2/views/components/add_reminder.dart';
import '../../controllers/theme_controller.dart';
import '../../helpers/notification_helper.dart';
import '../components/edit_reminder.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ThemeController themeController = Get.put(ThemeController());

  ReminderController reminderController = Get.put(ReminderController());

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('mipmap/launcher_icon');
    var initializationSettingsIOs = const DarwinInitializationSettings();
    var initSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOs);

    NotificationHelper.flutterLocalNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Reminder",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),),
        actions: [
          Obx(
            () => IconButton(
              onPressed: () {
                themeController.changeTheme();
              },
              icon: Icon((themeController.isDark.value)
                  ? Icons.light_mode
                  : Icons.dark_mode),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addReminder(context);
        },
        child: const Icon(Icons.add),
      ),
      body: Obx(

        () => SingleChildScrollView(
          child: Column(
            children: reminderController.reminders
                .map(
                  (e) => Container(
                    padding: const EdgeInsets.all(20),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.07),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            e.title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        SizedBox(height: 5),
                        Divider(endIndent: 10, indent: 10),
                        SizedBox(height: 5),
                        Text("Desc : ${e.description}"),
                        Row(
                          children: [
                            Text(
                                "Time : ${(e.hour > 12) ? e.hour - 12 : e.hour} : ${e.minute}  ${(e.hour > 12) ? "PM" : "AM"}",
                                style: Theme.of(context).textTheme.titleMedium),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                editReminder(reminder: e, context: context);
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                Get.dialog(
                                  AlertDialog(
                                    title: const Text("Delete Reminder"),
                                    content: const Text(
                                      "Are you sure want to Delete?",
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
                                          DBHelper.dbHelper
                                              .deleteReminder(id: e.id);
                                          Get.back();
                                        },
                                        child: const Text("Delete"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
