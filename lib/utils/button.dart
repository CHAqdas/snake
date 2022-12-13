import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  String text;
  VoidCallback onPressesd;
  bool started;
  MyButton(
      {super.key,
      required this.text,
      required this.onPressesd,
      required this.started});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => (started) ? () {} : onPressesd(),
      color: (started) ? Colors.grey : Colors.pink[300],
      child: Text(text),
    );
  }
}
