import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/widgets/boton_azul.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/labels.dart';
import 'package:chat_app/widgets/logo.dart';
import 'package:chat_app/helpers/mostrar_alerta.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_service.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF2F2F2),
        body: SingleChildScrollView(
          // physics: BouncingScrollPhysics(),
          child: SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Logo(src: 'assets/tag-logo.png', title: 'Login'),
                  _Form(),
                  Labels(
                      text1: '¿No tienes cuenta',
                      text2: 'Crea una ahora',
                      ruta: 'register'),
                  Text('términos y condiciones de uso',
                      style: TextStyle(fontWeight: FontWeight.w200))
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            isPassword: true,
            //keyboardType: TextInputType.emailAddress,
            textController: passwordCtrl,
          ),
          BotonAzul(
              text: 'ingrese',
              onPressed: authService.autenticando
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      final loginOk = await authService.login(
                          emailCtrl.text.trim(), passwordCtrl.text.trim());
                      if (loginOk) {
                        socketService.connect();
                        Navigator.pushReplacementNamed(context, 'usuarios');
                      } else {
                        //Mostrar alerta
                        mostrarAlerta(context, 'login incorrecto',
                            'revise sus credenciales');
                      }
                    }),
        ],
      ),
    );
  }
}
