import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:taskmaster/bloc/to_do_bloc.dart';
import 'package:taskmaster/main.dart';
import 'package:taskmaster/model.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AddTask extends StatefulWidget {
  AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final titleController = TextEditingController();

  final descriptionController = TextEditingController();

  Prioritys selectedPriority = Prioritys.normal;

  DateTime? selectedDueDate;
  DateTime? seletedRemainder;

  Future<void> selectDueDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context, firstDate: DateTime.now(), lastDate: DateTime(2060));
    if (pickedDate != null && pickedDate != selectedDueDate) {
      setState(() {
        selectedDueDate = pickedDate;
      });
    }
  }

  Future<void> _selectRemainder(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
        initialDate: selectedDueDate);
    if (pickedDate != null) {
      final TimeOfDay? pickedTime =
          await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if (pickedTime != null) {
        setState(() {
          seletedRemainder = DateTime(pickedDate.year, pickedDate.month,
              pickedDate.day, pickedTime.hour, pickedTime.minute);
        });
      }
    }
  }

  Future<void> scheduleReminder(DateTime reminderDateTime, String title) async {
    // Convert the reminderDateTime to the local timezone
    final localReminderDateTime =
        tz.TZDateTime.from(reminderDateTime, tz.local);

    try {
      print('the notification should start');
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0, // Unique Notification ID
        title,
        'Reminder for your task: $title',
        localReminderDateTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            '2', // Ensure this matches the created channel ID
            'aashiq channel', // Channel name
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            icon: '@mipmap/ic_launcher', // Ensure the icon is correct
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
      );
    } catch (e) {
      print("Error scheduling notification: $e");
    }
  }

  Future<void> scheduleImmediateNotification(String title, String body) async {
    // Create a unique notification ID
    int notificationId =
        DateTime.now().millisecondsSinceEpoch.remainder(100000);

    // Set the scheduled time to 1 minute from now
    final scheduledTime = DateTime.now().add(Duration(minutes: 1));

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            '2', // Ensure this matches the created channel ID
            'aashiq channel', // Channel name
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            icon: '@mipmap/ic_launcher', // Ensure the icon is correct
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
      );

      print("Notification scheduled for $scheduledTime");
    } catch (e) {
      print("Error scheduling notification: $e");
    }
  }

  final List<DropdownMenuItem<Prioritys>> dropdownitems = Prioritys.values
      .map(
        (priority) => DropdownMenuItem(
            value: priority, child: Text(priorityToString(priority))),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(label: Text('Title')),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(label: Text('Description')),
              ),
              const SizedBox(
                height: 20,
              ),
              DropdownButtonFormField<Prioritys>(
                decoration: const InputDecoration(labelText: 'Priority Level'),
                value: selectedPriority,
                items: dropdownitems,
                onChanged: (value) => setState(() {
                  selectedPriority = value!;
                }),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedDueDate == null
                            ? 'Select Due Date'
                            // :
                            : 'Due Date: ${DateFormat('dd/MM/yyyy').format(selectedDueDate!)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton.icon(
                          onPressed: () => selectDueDate(context),
                          icon: const Icon(Icons.calendar_month),
                          label: const Text('Pick Date')),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        seletedRemainder != null
                            ? 'Reminding on : ${DateFormat('dd/MM/yyyy HH:mm').format(seletedRemainder!)}'
                            : 'Select Reminder  :',
                        style: const TextStyle(fontSize: 16),
                      ),
                      ElevatedButton.icon(
                          onPressed: () => _selectRemainder(context),
                          icon: const Icon(Icons.alarm_add),
                          label: const Text('Set remainder')),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    final todo = ToDo(
                        title: titleController.text,
                        completed: false,
                        priority: selectedPriority,
                        description: descriptionController.text,
                        dueDate: selectedDueDate!,
                        reminder: seletedRemainder);
                    context.read<ToDoBloc>().add(CreateTask(todo));
                    if (seletedRemainder != null) {
                      if (seletedRemainder != null) {
                        context.read<ToDoBloc>().add(
                            ScheduleReminder(seletedRemainder!, todo.title));
                      }
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Add Task')),
              ElevatedButton(
                onPressed: () {
                  scheduleImmediateNotification(
                      "Test Notification", "This is a test notification.");
                },
                child: const Text('Show Notification'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String priorityToString(Prioritys priority) {
  switch (priority) {
    case Prioritys.normal:
      return 'Normal';
    case Prioritys.important:
      return 'Important';
    case Prioritys.veryImportant:
      return 'Very Important';
    default:
      return 'Normal';
  }
}
