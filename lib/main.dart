import 'package:flutter/material.dart';

import 'models/question.dart';
import 'widget/answer_button.dart';
import 'widget/clothing_question.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  void _iWasTapped() {
    setState(() {
      if (_questionIndex < questions.length - 1) {
        _questionIndex += 1;
      }
    });
    print('I was tapped');
  }

  var questions = [
    Question(
      questionText: "Select gender",
      answers: [
        'Male',
        'Female',
      ],
    ),
    Question(
      questionText: "Select size",
      answers: [
        'S',
        'M',
        'L',
      ],
    ),
    Question(
      questionText: "Select clothing type",
      answers: [
        'Shirt',
        'Pants',
        'Trousers',
      ],
    ),
    Question(
      questionText: "Select colors",
      answers: [
        'White',
        'Black',
        'Blue',
        'Green',
        'Any',
      ],
    ),
  ];
  var _questionIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Lab 02",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Lab 02"),
        ),
        body: Column(
          children: [
            ClothingQuestion(questions[_questionIndex].questionText),
            ...(questions[_questionIndex].answers).map((answer) {
              return AnswerButton(_iWasTapped, answer);
            }),
          ],
        ),
      ),
    );
  }
}
