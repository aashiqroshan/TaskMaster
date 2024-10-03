import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:taskmaster/Pages/homescreen.dart';
import 'package:taskmaster/bloc/to_do_bloc.dart';
import 'package:taskmaster/db/db_functions.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:taskmaster/models/model.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await requestNotificationPermission();
  await Hive.initFlutter();
  Hive.registerAdapter(ToDoAdapter());
  Hive.registerAdapter(PrioritysAdapter());
  await Hive.openBox<ToDo>('Box');
  await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelKey: 'reminder_channel',
            channelName: 'Reminder Notifications',
            channelDescription: 'Notification channel for task reminders',
            importance: NotificationImportance.Max,
            channelShowBadge: true)
      ],
      debug: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final taskDb = TaskDb();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ToDoBloc(taskDb),
      child: MaterialApp(
        title: 'TaskMaster',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.deepOrange),
        home: const Homescreen(),
      ),
    );
  }
}

Future<void> requestNotificationPermission() async {
  print('request notification permisop');
  var status = await Permission.notification.status;
  if (!status.isGranted) {
    await Permission.notification.request();
  } else if (status.isGranted) {
    print('status granted');
  } else {
    print('notification perimission denied');
  }
}
