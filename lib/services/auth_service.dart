import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:chat_app/models/register_response.dart';
import 'package:chat_app/global/enviroment.dart';
import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/models/usuario.dart';

class AuthService extends ChangeNotifier {
  late final Usuario usuario;
  bool _autenticando = false;
// Create storage
  final _storage = new FlutterSecureStorage();

  //get & set
  bool get autenticando => this._autenticando;
  set autenticando(value) {
    this._autenticando = value;
    notifyListeners();
  }

  // get static Token
  static Future<String?> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  // set static Token
  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  //-----------------------------------------------------------------//
  //Funcion de Login
  Future<bool> login(String email, String password) async {
    this.autenticando = true;
    final Map<String, dynamic> data = {"email": email, "password": password};

    final url = Uri.parse('${Enviromment.apiUrl}/login');
    print('url::$url');
    try {
      final resp = await http.post(
        url,
        headers: {'content-type': 'application/json'},
        body: json.encode(data),
      );
      print(resp.body);
      this.autenticando = false;
      if (resp.statusCode == 200) {
        final LoginResponse loginResponse = loginResponseFromJson(resp.body);
        this.usuario = loginResponse.usuario;
        await this._guardarToken(loginResponse.token);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error peticion::$e');
    }
    return true;
  }

  //-----------------------------------------------------------------//
  //Funcion de Login
  Future register(String name, String email, String password) async {
    this.autenticando = true;
    final Map<String, dynamic> data = {
      "nombre": name,
      "email": email,
      "password": password
    };

    final url = Uri.parse('${Enviromment.apiUrl}/login/new');

    try {
      final resp = await http.post(
        url,
        headers: {'content-type': 'application/json'},
        body: json.encode(data),
      );

      this.autenticando = false;
      if (resp.statusCode == 200) {
        final RegisterResponse registerResponse =
            registerResponseFromJson(resp.body);
        this.usuario = registerResponse.usuario;
        await this._guardarToken(registerResponse.token);
        return true;
      } else {
        final respBody = jsonDecode(resp.body);
        return respBody['msg'];
      }
    } catch (e) {
      print('Error peticion::$e');
    }
    return true;
  }

  //-----------------------------------------------------------------//

  Future<bool> isLoggedIn() async {
    final token = await this._storage.read(key: 'token');

    final url = Uri.parse('${Enviromment.apiUrl}/login/renew');

    try {
      final resp = await http.get(
        url,
        headers: {'content-type': 'application/json', 'x-token': '$token'},
      );
      print(resp.body);
      if (resp.statusCode == 200) {
        final LoginResponse loginResponse = loginResponseFromJson(resp.body);
        print("REnew Ok");
        this.usuario = loginResponse.usuario;
        await this._guardarToken(loginResponse.token);
        return true;
      } else {
        print("SAliendo...");
        this._logout();
        return false;
      }
    } catch (e) {
      print('Error peticion::$e');
      return false;
    }
  }

  //-----------------------------------------------------------------//
  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  //-----------------------------------------------------------------//
  Future _logout() async {
    await _storage.delete(key: 'token');
  }
}
