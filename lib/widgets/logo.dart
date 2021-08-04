import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String src;
  final String title;
  const Logo({required this.src, required this.title});
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      width: 170,
      child: Column(
        children: [
          Image(
            image: AssetImage(this.src),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            this.title,
            style: TextStyle(fontSize: 30),
          )
        ],
      ),
    ));
  }
}
