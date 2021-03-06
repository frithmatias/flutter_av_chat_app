import 'package:chat/helpers/mostrar_alerta.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/widgets/custom_button.dart';
import 'package:chat/widgets/custom_input.dart';
import 'package:chat/widgets/login_labels.dart';
import 'package:chat/widgets/login_logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: const Color(0xfff2f2f2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            // height: MediaQuery.of(context).size.height * .9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const <Widget> [  
                Logo( titulo: 'Login'), // como no cambia lo voy a extraer en un StatelesWidget
                _Form(),
                Labels( ruta: 'register' ),
                Text('Terminos y condiciones de uso', style: TextStyle( fontWeight: FontWeight.w200))
              ]
            ),
          ),
        ),
      ),
   );
  }
}

class _Form extends StatefulWidget {
  const _Form({ Key? key }) : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),

      child: Column(  
        children: <Widget> [  
          CustomInput(
            icon:  Icons.mail_outline, 
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailController,
          ),
          CustomInput(
            icon:  Icons.lock_outline, 
            placeholder: 'Clave',
            keyboardType: TextInputType.emailAddress,
            textController: passwordController,
            isPassword: true,
          ),
          
          CustomButton(
            icon: Icons.login_outlined, 
            text: 'Entrar', 
            onPressed: authService.waiting ? null : () async {
              FocusScope.of(context).unfocus(); // quita el teclado
              final loginOk = await authService.login(emailController.text.trim(), passwordController.text.trim());
              if(loginOk){
                // Navegar al chat 
                // pushReplacement porque no quiero que vuelvan al 'login' entonces voy a reemplazarlo
                socketService.connect();
                Navigator.pushReplacementNamed(context, 'usuarios');
              } else {
                mostrarAlerta(context, 'Error en el login', 'error');
              }
          })
        ]
      )
    );
  }
}

