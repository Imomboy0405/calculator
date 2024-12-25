import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

BoxShadow myBoxShadow(Size size) {
  return BoxShadow(
    color: Colors.black.withAlpha(25),
    blurRadius: size.height * .008,
    spreadRadius: 0,
    offset: Offset(0, 0),
    blurStyle: BlurStyle.outer,
  );
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.size,
    required this.theme,
    required this.onPressed,
    this.transparentColor = false,
  });

  final Size size;
  final ThemeData theme;
  final String text;
  final Function onPressed;
  final bool transparentColor;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () => onPressed(),
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.zero,
      child: Container(
        height: size.height * .08,
        width: size.height * .08,
        decoration: BoxDecoration(
          color: transparentColor ? Colors.transparent : theme.primaryColorLight.withAlpha(76),
          shape: BoxShape.circle,
          boxShadow: transparentColor ? null : [myBoxShadow(size)],
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: size.height * .03,
            fontWeight: FontWeight.w900,
            color: theme.primaryColorDark,
          ),
        ),
      ),
    );
  }
}
