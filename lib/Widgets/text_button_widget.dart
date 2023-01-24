import 'package:flutter/material.dart';

class TextButtonWidget extends StatelessWidget {
  final VoidCallback? onpressed;
  final String btnname;
  const TextButtonWidget({Key? key,this.onpressed, required this.btnname}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onpressed,
        style: TextButton.styleFrom(
            primary: Colors.white,
            elevation: 15,
            backgroundColor: Colors.cyan,
            shadowColor: Colors.red,
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
            )),
        child: Text(
          btnname,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
            fontStyle: FontStyle.italic,
          ),
        ));
  }
}
