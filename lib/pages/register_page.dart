import 'package:chat/helpers/mostrar_alerta.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/widgets/custom_button.dart';
import 'package:chat/widgets/custom_input.dart';
import 'package:chat/widgets/login_labels.dart';
import 'package:chat/widgets/login_logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

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
                Logo(titulo: 'Registro'), // como no cambia lo voy a extraer en un StatelesWidget
                _Form(),
                Labels( ruta: 'login' ),
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

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);


    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),

      child: Column(  
        children: <Widget> [  
          CustomInput(
            icon:  Icons.verified_user_outlined, 
            placeholder: 'Nombre',
            keyboardType: TextInputType.text,
            textController: nameController,
          ),
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
              final registerOk = await authService.register(
                nameController.text.trim(), 
                emailController.text.trim(), 
                passwordController.text.trim(),
              );
              if(registerOk){
                // Navegar al chat 
                // pushReplacement porque no quiero que vuelvan al 'login' entonces voy a reemplazarlo
                Navigator.pushReplacementNamed(context, 'usuarios');
              } else {
                mostrarAlerta(context, 'Error en el registro', 'error');
              }
          })
        ]
      )
    );
  }
}

