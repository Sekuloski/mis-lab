import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  final String _answerText;
  final Function() _tapped;
  const AnswerButton(this._tapped, this._answerText, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: _tapped,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
        ),
        child: Text(
          _answerText,
          style: const TextStyle(
            fontSize: 22,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
