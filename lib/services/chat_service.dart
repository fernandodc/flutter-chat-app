import 'package:chat_app/global/enviroment.dart';
import 'package:chat_app/models/mensaje_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app/models/usuario.dart';

class ChatService with ChangeNotifier {
  late Usuario usuarioPara;
  Future<List<Mensaje>> getChat(String usuarioID) async {
    final url = Uri.parse('${Enviromment.apiUrl}/mensajes/$usuarioID');
    final token = await AuthService.getToken();
    final resp = await http.get(
      url,
      headers: {'content-type': 'application/json', 'x-token': token!},
    );
    final mensajesResponse = mensajesResponseFromJson(resp.body);
    return mensajesResponse.mensajes;
  }
}
