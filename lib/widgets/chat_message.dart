import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String texto;
  final String uuid;
  final AnimationController animationCrtl;

  const ChatMessage(
      {required this.texto, required this.uuid, required this.animationCrtl});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationCrtl,
      child: SizeTransition(
          sizeFactor:
              CurvedAnimation(parent: animationCrtl, curve: Curves.easeOut),
          child: Container(
              child: this.uuid == '123' ? _miMessage() : _notMyMessage())),
    );
  }

  Widget _miMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(bottom: 5, right: 5, left: 50),
        child: Text(
          this.texto,
          style: TextStyle(color: Colors.white),
        ),
        decoration: BoxDecoration(
          color: Color(0xff409EF6),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget _notMyMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(bottom: 5, right: 50, left: 5),
        child: Text(
          this.texto,
          style: TextStyle(color: Colors.black87),
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
