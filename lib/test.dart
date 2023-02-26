import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Input Form Example',
      home: InputForm(),
    );
  }
}

class InputForm extends StatefulWidget {
  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final nameController = TextEditingController();
  final dateController = TextEditingController();
  List<Map<String, dynamic>> dataList = [];

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    dateController.dispose();
    super.dispose();
  }

  void _addToList() {
    String name = nameController.text;
    String date = dateController.text;

    setState(() {
      dataList.add({'name': name, 'date': date});
      nameController.clear();
      dateController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Form Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Enter your name',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: dateController,
              decoration: InputDecoration(
                hintText: 'Enter a date',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addToList,
              child: Text('Add to List'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(dataList[index]['name']),
                    subtitle: Text(dataList[index]['date']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
