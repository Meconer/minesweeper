import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class GameButton extends StatefulWidget {
  const GameButton({
    Key? key,
    required this.icon,
    required this.callback,
  }) : super(key: key);

  final IconData icon;
  final Function callback;

  @override
  State<GameButton> createState() => _GameButtonState();
}

class _GameButtonState extends State<GameButton> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    double blur = isPressed ? 3.0 : 5.0;
    Offset ofsDist = Offset(blur, blur);
    return Listener(
      onPointerDown: ((_) {
        setState(() {
          isPressed = true;
        });
        widget.callback();
      }),
      onPointerUp: (_) {
        setState(() {
          isPressed = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 60),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.grey[300],
          boxShadow: [
            BoxShadow(
              blurRadius: blur,
              offset: -ofsDist,
              color: Colors.white54,
              inset: isPressed,
            ),
            BoxShadow(
                blurRadius: 5.0,
                offset: ofsDist,
                color: Colors.black38,
                inset: isPressed),
          ],
        ),
        child: Icon(
          widget.icon,
          color: Colors.black38,
          size: 50,
        ),
      ),
    );
  }
}
