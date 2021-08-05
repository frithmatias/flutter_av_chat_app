import 'dart:io';

import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  
  final _textController = TextEditingController();
  final _focusNode = FocusNode(); // al enviar quiero hacer foco en el texto
  bool _hayData = false;
  final List<ChatMessage> _messages = [];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 1,
          title: Column(children: <Widget>[
            CircleAvatar(
              child: const Text('Te', style: TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue.shade100,
              maxRadius: 14,
            ),
            const SizedBox(height: 3),
            const Text('Diego Lopez',
                style: TextStyle(color: Colors.black87, fontSize: 10))
          ]),
        ),
        body: Column(
          children: <Widget>[
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
                      setState((){  
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
                            child: const Text('Enviar'), onPressed: _hayData ? () => _handleSubmit(_textController.text.trim()) : null)
                        : Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: IconTheme(
                              // (*) si seteo el color del icono desde aca, cuando seteo onPressed en null queda grisado
                              data: IconThemeData(color: Colors.blue.shade300),
                              child: IconButton(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors
                                      .transparent, // quito el efecto splash
                                  icon: const Icon(Icons.send), // ya no seteo a fuerza el color del icono desde aca (*)
                                  onPressed: _hayData ? () => _handleSubmit(_textController.text.trim()) : null
                              ),
                            )))
              ],
            )));
  }
  
  _handleSubmit(String text) {
    if(text.isEmpty) return;
    ChatMessage newMessage = ChatMessage(
      uid: '123', 
      text: text,
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 400)),
    );

    //_messages.add(newMessage);
    _messages.insert(0, newMessage);
    // luego de insertar el mensaje activo la animación 
    newMessage.animationController.forward().then((_) => {
      print('DESTRUIR'),
      newMessage.animationController.dispose()
    });
    setState((){  
      _hayData = false;
    });

    _textController.clear();
    _focusNode.requestFocus();
  }


  // 'dis' snippet para disponse, aca voy a limpiar varias cosas
  @override
  void dispose() { 
    // todo: off del socket  
    // for (ChatMessage msg in _messages){
    //   msg.animationController.dispose();
    // }
    super.dispose();
  }
}
