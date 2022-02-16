
import 'package:flutter/material.dart';


class TextformField extends StatefulWidget {
   TextformField({Key? key,this.validators,this.keyboardTYPE,this.controller,this.hint,this.icon}) : super(key: key);

   final TextEditingController? controller;
   IconData? icon;
   String? hint;
   TextInputType? keyboardTYPE;
  final FormFieldValidator<String>? validators;

  @override
  _TextformFieldState createState() => _TextformFieldState();
}

class _TextformFieldState extends State<TextformField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // margin: EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width / 1.2,
     // height: MediaQuery.of(context).size.height*0.06455,
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardTYPE,
        style: const TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 18,
        ),
        validator: widget.validators,
        decoration:  InputDecoration(
            border:  const OutlineInputBorder(
              borderRadius:
               BorderRadius.all(Radius.circular(15)),
            ),
            prefixIcon:  Icon(
              widget.icon,
              // color: Color(0xFF00abff),
            ),
            suffixIcon: widget.controller!.text.isEmpty
                ? Container(width: 0)
                : IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => widget.controller!.clear(),
            ),
            // hintText: 'Username',
            hintText: widget.hint,
          hintStyle: TextStyle(fontSize: 16.0, color: Colors.grey.withOpacity(0.4)),),
      ),
    );
  }
}
