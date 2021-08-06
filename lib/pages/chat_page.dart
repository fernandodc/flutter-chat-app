import 'dart:io';

import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();
  List<ChatMessage> _messages = [];
  bool _estaEscribiendo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        title: Column(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              maxRadius: 12,
              child: Text('Te',
                  style: TextStyle(
                    fontSize: 12,
                  )),
            ),
            SizedBox(
              height: 3,
            ),
            Text('Melissa Flores',
                style: TextStyle(color: Colors.black87, fontSize: 12))
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
                child: ListView.builder(
                    reverse: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: _messages.length,
                    itemBuilder: (_, i) => _messages[i])),
            Divider(
              height: 1,
            ),
            Container(
              //height: 100,
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
          child: Row(
            children: <Widget>[
              Flexible(
                  child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                onSubmitted: _handleSubmit,
                onChanged: (String text) {
                  //TODO:ver que escribe

                  setState(() {
                    (text.trim().length > 0)
                        ? _estaEscribiendo = true
                        : _estaEscribiendo = false;
                  });
                },
                decoration:
                    InputDecoration.collapsed(hintText: 'enviar mensaje'),
              )),
              //Boton
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconTheme(
                      data: IconThemeData(color: Colors.blue[400]),
                      child: IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        onPressed: _estaEscribiendo
                            ? () => _handleSubmit(_textController.text.trim())
                            : null,
                        icon: Icon(Icons.send),
                        //color: Colors.blue[400],
                      ),
                    ),
                  )),
            ],
          ),
          margin: EdgeInsets.symmetric(horizontal: 8.0)),
    );
  }

  _handleSubmit(String texto) {
    if (texto.length == 0) return;
    _focusNode.requestFocus();
    _textController.clear();
    final newMessage = ChatMessage(
      texto: texto,
      uuid: '123',
      animationCrtl: AnimationController(
          vsync: this, duration: Duration(milliseconds: 300)),
    );

    this._messages.insert(0, newMessage);
    newMessage.animationCrtl.forward();
    setState(() {
      _estaEscribiendo = false;
    });
  }

  @override
  void dispose() {
    //TODO: off del socket
    for (ChatMessage message in _messages) {
      message.animationCrtl.dispose();
    }
    super.dispose();
  }
}
