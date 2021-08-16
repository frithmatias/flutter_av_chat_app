// ignore_for_file: avoid_print

import 'dart:io';
import 'package:chat/models/mensaje.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode(); // al enviar quiero hacer foco en el texto
  bool _hayData = false;
  final List<BubbleMessage> _messages = [];

  late AuthService authService;
  late ChatService chatService;
  late SocketService socketService;

  @override
  void initState() {
    super.initState();
    authService = Provider.of<AuthService>(context, listen: false); // aca tengo mi usuario (no sería necesario porque lo recibo en el token)
    chatService = Provider.of<ChatService>(context, listen: false); // aca tengo el usuario a quien le quiero enviar
    socketService = Provider.of<SocketService>(context, listen: false); // aca tengo el emit
    _loadMessagesHistory();
    socketService.socket.on('mensaje-privado', _escucharMensaje);
  }


  void _loadMessagesHistory() async {

    List<Message> mensajes = await chatService.getMessages();

    for (var mensaje in mensajes) {

      BubbleMessage chatMessage = BubbleMessage(
          text: mensaje.txMessage,
          uid: mensaje.idFrom,
          animationController: AnimationController(
              vsync: this, duration: const Duration(milliseconds: 400)
          )
      );
      
      _messages.insert(0, chatMessage);

      chatMessage.animationController
          .forward()
          .then((_) => {chatMessage.animationController.dispose()});

    }
    setState(() {});

  }

  _escucharMensaje(dynamic payload) {
    // Creo una nueva burbuja de mensaje y la agrego a mi stack de mensajes
    BubbleMessage message = BubbleMessage(
        text: payload['mensaje'],
        uid: payload['de'],
        animationController: AnimationController(
            vsync: this, duration: const Duration(milliseconds: 400)));

    _messages.insert(0, message);

    // luego de insertar el mensaje activo la animación
    message.animationController
        .forward()
        .then((_) => {message.animationController.dispose()});

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // final chatService = Provider.of<ChatService>(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 1,
          title: Column(children: <Widget>[
            CircleAvatar(
              child: Text(chatService.usuarioPara.txName.substring(0, 2),
                  style: const TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue.shade100,
              maxRadius: 14,
            ),
            const SizedBox(height: 3),
            Text(chatService.usuarioPara.txName,
                style: const TextStyle(color: Colors.black87, fontSize: 10))
          ]),
        ),
        body: Column(children: <Widget>[
          Flexible(
            // widget que sea capaz de expandirse
            child: ListView.builder(
              itemCount: _messages.length,
              physics: const BouncingScrollPhysics(),
              reverse: true,
              itemBuilder: (BuildContext context, int index) {
                return _messages[index];
              },
            ),
          ),
          const Divider(), // espacio abajo de toda la lista
          Container(color: Colors.white, child: _inputMessage())
        ]));
  }

  Widget _inputMessage() {
    return SafeArea(
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _textController,
                    onSubmitted: _handleSubmit,
                    onChanged: (String texto) {
                      // si hay texto tengo que habilitar el boton para enviar
                      setState(() {
                        if (texto.isEmpty) {
                          _hayData = false;
                        } else {
                          _hayData = true;
                        }
                      });
                    },
                    decoration:
                        const InputDecoration.collapsed(hintText: 'Enviar'),
                    focusNode: _focusNode,
                  ),
                ),
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Platform.isIOS
                        ? CupertinoButton(
                            child: const Text('Enviar'),
                            onPressed: _hayData
                                ? () =>
                                    _handleSubmit(_textController.text.trim())
                                : null)
                        : Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: IconTheme(
                              // (*) si seteo el color del icono desde aca, cuando seteo onPressed en null queda grisado
                              data: IconThemeData(color: Colors.blue.shade300),
                              child: IconButton(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors
                                      .transparent, // quito el efecto splash
                                  icon: const Icon(Icons
                                      .send), // ya no seteo a fuerza el color del icono desde aca (*)
                                  onPressed: _hayData
                                      ? () => _handleSubmit(
                                          _textController.text.trim())
                                      : null),
                            )))
              ],
            )));
  }

  _handleSubmit(String text) {
    if (text.isEmpty) return;
    BubbleMessage newMessage = BubbleMessage(
      uid: authService.usuario.txUid,
      text: text,
      animationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 400)),
    );

    // Inserto el mensaje en el stack de mensajes
    //_messages.add(newMessage);
    _messages.insert(0, newMessage);

    // luego de insertar el mensaje activo la animación
    newMessage.animationController
        .forward()
        .then((_) => {newMessage.animationController.dispose()});

    // Redibujo el Widget
    setState(() {
      _hayData = false;
    });

    // Envío el mensaje
    socketService.emit('mensaje-privado', {
      'de': authService.usuario.txUid,
      'para': chatService.usuarioPara.txUid,
      'mensaje': text
    });

    // Elimino el mensaje en el input y quito el foco
    _textController.clear();
    _focusNode.requestFocus();
  }

  // 'dis' snippet para disponse, aca voy a limpiar varias cosas
  @override
  void dispose() {
    socketService.socket.off('mensaje-privado');
    super.dispose();
  }
}
