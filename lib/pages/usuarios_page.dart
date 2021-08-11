import 'package:chat/models/usuario.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class UsuariosPage extends StatefulWidget {
  const UsuariosPage({Key? key}) : super(key: key);

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  
  final List<Usuario> usuarios = [
    Usuario( txUid: '1', txName: 'Matias', txEmail: 'asdf@asdf.com', blOnline: true),
    Usuario( txUid: '2', txName: 'Diego', txEmail: 'diego@asdf.com', blOnline: true),
  ];

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final usuario = authService.usuario;

    return Scaffold(
      appBar: AppBar(  
        title: Text('Hola ${usuario.txName}!', style: const TextStyle( color: Colors.black87)), 
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(  
          onPressed: (){
            // todo desconectarnos del socket server 
            Navigator.pushReplacementNamed(context, 'login');
            // puedo llamar a mis métodos estáticos directamente.
            AuthService.deleteToken(); // import 'package:chat/services/auth_service.dart';
          },
          icon: const Icon( Icons.exit_to_app,  color: Colors.black87 )
        ), 
        actions: [  
          Container(  
            margin: const EdgeInsets.only( right: 10 ),
            child: Icon( Icons.check_circle, color: Colors.blue.shade400 )
          )
        ],
      ),
    
      body: SmartRefresher(
        child: _usersListView(), 
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _cargarUsuarios, // Tarea asíncrona que se ejecuta luego del pull to refresh
        header: WaterDropHeader(
            complete: Icon( Icons.check, color: Colors.blue.shade400 ),
            waterDropColor: Colors.blue.shade400,
        )
      ),
   );
  }

  ListView _usersListView() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: usuarios.length,
      separatorBuilder: (_, i) => const Divider(),
      itemBuilder: (BuildContext context, int i) {
      return _userListTile(usuarios[i]);
     },
    );
  }

  ListTile _userListTile(Usuario usuario) {
    return ListTile(  
          title: Text(usuario.txName), 
          subtitle: Text(usuario.txEmail), 
          leading: CircleAvatar(  
            child: Text( usuario.txName.substring(0,2)), 
            backgroundColor: Colors.blue.shade300,
          ), 
          trailing: Container(  
            width: 10, 
            height: 10, 
            decoration: BoxDecoration(  
              color: usuario.blOnline ? Colors.green.shade300 : Colors.red.shade300, 
              borderRadius: BorderRadius.circular(100)
            ),
          ),
      );
  }



  _cargarUsuarios() async {
       await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted(); // COMPLETED
  }
}