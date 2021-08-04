import 'package:chat_app/widgets/boton_azul.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/labels.dart';
import 'package:chat_app/widgets/logo.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF2F2F2),
        body: SingleChildScrollView(
          // physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Logo(src: 'tag-logo.png', title: 'Register'),
                _Form(),
                Labels(
                    text1: '¿Ya tienes cuenta?',
                    text2: 'Ingresa a tu cuenta',
                    ruta: 'login'),
                Text('términos y condiciones de uso',
                    style: TextStyle(fontWeight: FontWeight.w200))
              ],
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
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity,
            placeholder: 'Nombre',
            //keyboardType: TextInputType.emailAddress,
            textController: nameCtrl,
          ),
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
              text: 'registrar',
              onPressed: () {
                print(nameCtrl.text);
                print(emailCtrl.text);
                print(passwordCtrl.text);
              })
        ],
      ),
    );
  }
}
