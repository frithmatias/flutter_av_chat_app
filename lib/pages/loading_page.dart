// ignore_for_file: avoid_print

import 'package:chat/pages/usuarios_page.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      body: FutureBuilder( 
        future: checkLogged(context),
        builder: ( context,  snapshot) {
        return const Center(
          child: Text('Hola Mundo'),
          );
        },
      ),
   );
  }

  Future checkLogged(context) async {

    final authService = Provider.of<AuthService>(context);
    final logged = await authService.isLogged();

    print('LOGGED: $logged');

    if(logged){
      // Navigator.pushReplacementNamed(context, 'usuarios');
      // Navigator podría hacer un efecto de swipe que yo no quiero, y para evitarlo puedo usar PageRouteBuilder
      Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: (_,__,___) => const UsuariosPage(), 
        transitionDuration: const Duration(milliseconds: 0)
      ));
    } else {
      Navigator.pushReplacementNamed(context, 'login');
    }
  }

}