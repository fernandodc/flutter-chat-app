import 'package:chat_app/global/enviroment.dart';
import 'package:chat_app/models/usuario.dart';
import 'package:chat_app/models/usuario_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:http/http.dart' as http;

class UsuariosService {
  Future<List<Usuario>> getUsuarios() async {
    try {
      final url = Uri.parse('${Enviromment.apiUrl}/usuarios');
      final token = await AuthService.getToken();
      final resp = await http.get(
        url,
        headers: {'content-type': 'application/json', 'x-token': token!},
      );
      final usuariosResponse = usuarioResponseFromJson(resp.body);
      return usuariosResponse.usuarios;
    } catch (e) {
      return [];
    }
  }
}
