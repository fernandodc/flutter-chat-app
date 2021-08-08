import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  final String text;

  final void Function()? onPressed;
  final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20, color: Colors.red),
      shape: StadiumBorder());

  BotonAzul({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: style,
        onPressed: this.onPressed,
        child: Container(
          width: double.infinity,
          height: 55,
          child: Center(
            child: Text(
              this.text,
              //style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ));
  }
}
