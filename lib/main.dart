import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:taskmaster/Pages/homescreen.dart';
import 'package:taskmaster/bloc/to_do_bloc.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:taskmaster/model.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await requestNotificationPermission();
  await initNotifications();
  await AwesomeNotifications().initialize(null,[
    NotificationChannel(
    channelKey: 'reminder_channel',
    channelName: 'Reminder Notifications',
    channelDescription: 'Notification channel for task reminders',
    importance: NotificationImportance.Max,
    channelShowBadge: true)
  ] ,debug: true);
  await Hive.initFlutter();
  Hive.registerAdapter(ToDoAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ToDoBloc(),
      child: MaterialApp(
        title: 'TaskMaster',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        home: const Homescreen(),
      ),
    );
  }
}

Future<void> initNotifications() async {
  print('this is inside the initnotification');
  const AndroidInitializationSettings initializationSettingsAndriod =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndriod);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
      '2', 'aashiq channel',
      description: 'this is used for task reminders',
      importance: Importance.max);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  print('it should work here');
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
