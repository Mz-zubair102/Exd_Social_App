import 'package:flutter/material.dart';


class TextInputField extends StatelessWidget {
  final double? width;
  final double? height;
  final String hinttext;
  final String label;
  final bool isobscure;
  final int maxline;
  final String? Function(String?)? validator;
  final TextEditingController mycontroller;
  const TextInputField({
    Key? key,
    this.height,
    this.width,
    this.hinttext = '',
    this.label='',
    this.validator,
    this.isobscure=false,
    this.maxline=1,
    required this.mycontroller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: EdgeInsets.only(top: 8,bottom: 8),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 10)
      ]),
      child: Center(
        child: TextFormField(
          validator: validator,
          obscureText: isobscure,
          maxLines: maxline,
          controller: mycontroller,
          decoration: InputDecoration(
              hintText: hinttext,
              fillColor: Colors.white,
              filled: true,
              label: Text(
                label,
                // style: TextStyle(fontSize: 17, color: Color(0xff5D5D5D)),
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.lightBlueAccent,
                    fontWeight: FontWeight.bold),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(color: Colors.cyan),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(color: Colors.cyan),
              )),
        ),
      ),
    );
  }
}
