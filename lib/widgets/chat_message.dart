import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {

  final String text;
  final String uid;
  
  final AnimationController animationController;

  // En mi Widget burbuja le adjunto un animationController que voy a recibir como argumento al momento 
  // de crear o instanciar el Widget
  const ChatMessage({ 
    Key? key, 
    required this.text, 
    required this.uid,
    required this.animationController // <-
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(  
          parent: animationController, curve: Curves.easeOut
        ),
        child: Container(
          child: uid == '123' 
          ? _myMessage()
          : _othersMessage()
        ),
      ),
    );
  }



  _myMessage() {
    return Align(  
      alignment: Alignment.centerRight,
      child: Container(  
        padding: const EdgeInsets.all(8.0), 
        margin: const EdgeInsets.only(  
          bottom: 5, 
          right: 20
        ),
        child: Text(text), 
        decoration: BoxDecoration(  
          color: Colors.red.shade200,
          borderRadius: BorderRadius.circular(5)
        )
      )
    );
  }

  _othersMessage() {
    return Align(  
      alignment: Alignment.centerLeft,
      child: Container(  
        padding: const EdgeInsets.all(8.0), 
        margin: const EdgeInsets.only(  
          bottom: 5, 
          left: 20
        ),
        child: Text(text), 
        decoration: BoxDecoration(  
          color: Colors.blueAccent.shade100,
          borderRadius: BorderRadius.circular(5)
        )
      )
    );
  }
}