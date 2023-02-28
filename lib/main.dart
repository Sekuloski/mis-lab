import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab/views/login_view.dart';
import 'package:table_calendar/table_calendar.dart';

// import './student.dart';

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

void main() => runApp(MaterialApp(
      title: 'Midterms and Exams',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(
        title: 'Midterms and Exams',
      ),
      routes: {
        '/login/': (context) => const LoginView(title: "Login"),
        '/register/': (context) =>
            // ignore: todo
            const LoginView(title: "Login"), // TODO - Map to Register
      },
    ));

class User {
  final String username;
  final List<String> names = [];
  final List<String> dates = [];
  final List<String> times = [];

  User(this.username);
}

class Exam {
  final String name;
  final DateTime date;
  final String time;

  Exam(this.name, this.date, this.time);
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    super.key,
    required this.title,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final nameController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final usernameController = TextEditingController();
  final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late final ValueNotifier<List<Exam>> _selectedEvents;

  final List<User> users = [User('Bojan'), User('Stefan')];
  final Map<String, List<Exam>> userToExam = {
    'Bojan': [
      Exam('MIS', DateTime.now(), "12:00"),
      Exam('SKIT', DateTime.now(), "12:00"),
      Exam('PNVI', DateTime.now().add(const Duration(days: 2)), "13:00"),
      Exam('KIII', DateTime.now().add(const Duration(days: 5)), "11:00")
    ],
    'Stefan': [
      Exam('AI', DateTime.now().add(const Duration(days: 1)), "12:00"),
      Exam('VIS', DateTime.now().add(const Duration(days: 2)), "12:00")
    ]
  };
  String currentUser = 'Bojan';

  Future<void> setup() async {
    // #1
    const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSetting = IOSInitializationSettings();

    // #2
    const initSettings =
        InitializationSettings(android: androidSetting, iOS: iosSetting);

    // #3
    await _localNotificationsPlugin.initialize(initSettings).then((_) {
      debugPrint('setupPlugin: setup success');
    }).catchError((Object error) {
      debugPrint('Error: $error');
    });
  }

  @override
  void initState() {
    super.initState();
    setup();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    nameController.dispose();
    dateController.dispose();
    timeController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  void _login() {
    setState(() {
      currentUser = usernameController.text;
      if (!userToExam.containsKey(currentUser)) {
        User newUser = User(currentUser);
        users.add(newUser);
        userToExam[currentUser] = [];
      }
      usernameController.clear();
    });
  }

  void _addToList() {
    String name = nameController.text;
    String date = dateController.text;
    String time = timeController.text;

    setState(() {
      if (name != "" && date != "" && time != "") {
        Exam newExam = Exam(name, DateTime.parse(date), time);
        userToExam[currentUser]?.add(newExam);
      }

      nameController.clear();
      dateController.clear();
      timeController.clear();
    });
  }

  void _removeFromList(int index) {
    setState(() {
      userToExam[currentUser]?.removeAt(index);

      nameController.clear();
      dateController.clear();
      timeController.clear();
    });
  }

  List<Exam> _getEventsForDay(DateTime day) {
    List<Exam> results = [];
    for (Exam exam in userToExam[currentUser] ?? []) {
      if (isSameDay(day, exam.date)) {
        results.add(exam);
        addNotification(
          'Notification Title',
          'Notification Body',
          DateTime.now().millisecondsSinceEpoch + 1000,
          'testing',
        );
      }
    }
    return results;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void addNotification(
      String title, String body, int endTime, String channel) async {
    tzData.initializeTimeZones();
    final scheduleTime =
        tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, endTime);

    final androidDetail = AndroidNotificationDetails(
      channel, // channel Id
      channel, // channel Name
    );

    final iosDetail = IOSNotificationDetails();

    final noticeDetail = NotificationDetails(
      iOS: iosDetail,
      android: androidDetail,
    );

// #3
    final id = 0;

// #4
    await _localNotificationsPlugin.zonedSchedule(
      id,
      "",
      "",
      scheduleTime,
      noticeDetail,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // The title text which will be shown on the action bar
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            Text("Logged in as: $currentUser"),
            Expanded(
                child: ListView.builder(
                    itemCount:
                        _getEventsForDay(_selectedDay ?? DateTime.now()).length,
                    itemBuilder: (contx, index) {
                      return Card(
                          elevation: 1,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    margin: const EdgeInsets.all(5),
                                    padding: const EdgeInsets.all(5),
                                    child: Column(children: [
                                      Row(children: [
                                        Center(
                                          child: Text(
                                              _getEventsForDay(_selectedDay ??
                                                      DateTime.now())
                                                  .elementAt(index)
                                                  .name,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Theme.of(contx)
                                                      .primaryColorLight,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 100),
                                            child: IconButton(
                                              icon: const Icon(Icons.remove),
                                              onPressed: () =>
                                                  {_removeFromList(index)},
                                            ))
                                      ]),
                                      Text(
                                          "${DateFormat('yyyy-MM-dd').format(_getEventsForDay(_selectedDay ?? DateTime.now()).elementAt(index).date)} - ${_getEventsForDay(_selectedDay ?? DateTime.now()).elementAt(index).time}",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey)),
                                    ]))
                              ]));
                    })),
            TableCalendar<Exam>(
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              eventLoader: _getEventsForDay,
              onDaySelected: _onDaySelected,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'Enter exam name',
              ),
            ),
            TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  hintText: 'Enter a date',
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100));

                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    setState(() {
                      dateController.text = formattedDate;
                    });
                  } else {}
                }),
            TextField(
                controller: timeController,
                decoration: const InputDecoration(
                  hintText: 'Enter time',
                ),
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                        hour: DateTime.now().hour,
                        minute: DateTime.now().minute),
                  );
                  setState(() {
                    timeController.text =
                        "${pickedTime?.hour.toString().padLeft(2, '0')}:${pickedTime?.minute.toString().padLeft(2, '0')}";
                  });
                }),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: TextButton(
                onPressed: () => {
                  _addToList(),
                },
                child: const Text("Add Exam"),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  hintText: 'Enter username',
                )),
            TextButton(
                onPressed: () {
                  _login();
                },
                child: const Text('Change User'))
          ],
        ));
  }
}
