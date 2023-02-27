import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// import './student.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Midterms and Exams',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Midterms and Exams',
        names: [],
        dates: [],
        times: [],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final List<String> names;
  final List<String> dates;
  final List<String> times;
  const MyHomePage(
      {super.key,
      required this.title,
      required this.names,
      required this.dates,
      required this.times});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final nameController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // The title text which will be shown on the action bar
          title: Text(widget.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.add_a_photo),
              onPressed: () => {
                _addToList(),
              },
            ),
          ],
        ),
        body: Column(children: [
          Expanded(
              child: ListView.builder(
                  itemCount: widget.names.length,
                  itemBuilder: (contx, index) {
                    return Card(
                        elevation: 2,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  margin: const EdgeInsets.all(10),
                                  padding: const EdgeInsets.all(10),
                                  child: Column(children: [
                                    Text(widget.names[index],
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Theme.of(contx)
                                                .primaryColorLight,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        "${widget.dates[index]} - ${widget.times[index]}",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.grey)),
                                  ]))
                            ]));
                  })),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: 'Enter exam name',
            ),
          ),
          SizedBox(height: 16.0),
          TextField(
              controller: dateController,
              decoration: InputDecoration(
                hintText: 'Enter a date',
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100));

                if (pickedDate != null) {
                  print(
                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                  print(formattedDate);
                  setState(() {
                    dateController.text = formattedDate;
                  });
                } else {}
              }),
          TextField(
              controller: timeController,
              decoration: InputDecoration(
                hintText: 'Enter time',
              ),
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(
                      hour: DateTime.now().hour, minute: DateTime.now().minute),
                );
                setState(() {
                  timeController.text =
                      "${pickedTime?.hour.toString().padLeft(2, '0')}:${pickedTime?.minute.toString().padLeft(2, '0')}";
                });
              })
        ]));
  }

  @override
  void dispose() {
    nameController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }

  void _addToList() {
    String name = nameController.text;
    String date = dateController.text;
    String time = timeController.text;

    setState(() {
      widget.names.add(name);
      widget.dates.add(date);
      widget.times.add(time);
      nameController.clear();
      dateController.clear();
      timeController.clear();
    });
  }
}
