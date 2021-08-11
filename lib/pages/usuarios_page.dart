import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/usuarios_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:chat_app/models/usuario.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_service.dart';

class UsuariosPage extends StatefulWidget {
  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final usuariosService = new UsuariosService();
  List<Usuario> usuarios = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    this._cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    final user = authService.usuario;
    return Scaffold(
        backgroundColor: Color(0xffeeeeee),
        appBar: AppBar(
            title: Text(
              user.nombre,
              style: TextStyle(color: Colors.black54),
            ),
            elevation: 1,
            backgroundColor: Colors.white,
            actions: [
              Container(
                  margin: EdgeInsets.only(right: 30),
                  child: (socketService.serverStatus == ServerStatus.Online)
                      ? Icon(
                          Icons.check_circle,
                          color: Colors.blue.shade400,
                        )
                      : (Icon(
                          Icons.offline_pin,
                          color: Colors.red.shade400,
                        ))),
            ],
            leading: IconButton(
              onPressed: () {
                socketService.disconnect();
                AuthService.deleteToken();
                Navigator.popAndPushNamed(context, 'login');
              },
              icon: Icon(Icons.exit_to_app),
              color: Colors.black54,
            )),
        body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: _cargarUsuarios,
          onLoading: _onLoading,
          header: WaterDropHeader(
            waterDropColor: Colors.blue[400]!,
            complete: Icon(Icons.check, color: Colors.blue[400]),
          ),
          child: _listViewUsuarios(),
        ));
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, i) => _usuarioListTile(usuarios[i]),
        separatorBuilder: (_, i) => Divider(),
        itemCount: usuarios.length);
  }

  //METODO..............................................
  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        //foregroundColor: Colors.white60,
        child: Text(usuario.nombre.substring(0, 2)),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: usuario.online ? Colors.green[300] : Colors.red[300]),
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usuarioPara = usuario;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }

  void _cargarUsuarios() async {
    this.usuarios = await usuariosService.getUsuarios();
    setState(() {});
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    usuarios.add((new Usuario(
        uid: '4', online: false, nombre: 'Camelia', email: 'came@yahoo.com')));
    print('pase por el onLoading $mounted');
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }
}
