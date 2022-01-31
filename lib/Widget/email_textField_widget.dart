import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class EmailFieldWidget extends StatefulWidget {
  final TextEditingController controller;
   IconData icon;
   String hint;
   bool obscuretxt;
   int? maxlength;
  TextInputType? keyboardTYPE;
  final FormFieldValidator<String> validators;

   EmailFieldWidget({

     required this.controller,required this.icon,required this.hint, required this.validators,required this.keyboardTYPE,required this.obscuretxt,this.maxlength
  });

  @override
  _EmailFieldWidgetState createState() => _EmailFieldWidgetState();
}

class _EmailFieldWidgetState extends State<EmailFieldWidget> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(onListen);
  }

  @override
  void dispose() {
    widget.controller.removeListener(onListen);

    super.dispose();
  }

  void onListen() => setState(() {});

  @override
  Widget build(BuildContext context) => SizedBox(
    // height: 56,
    child: TextFormField(
        controller: widget.controller,
         validator: widget.validators,
        maxLength: widget.maxlength,
        decoration: InputDecoration(
          // helperText: 'Email',
          counterText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),

          prefixIcon:  Icon(widget.icon),

          hintText: widget.hint,
          hintStyle: TextStyle(fontSize: 16.0, color: Colors.grey.withOpacity(0.4)),
          suffixIcon: widget.controller.text.isEmpty
              ? Container(width: 0)
              : IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => widget.controller.clear(),
                ),
        ),
        obscureText: widget.obscuretxt,
        keyboardType: widget.keyboardTYPE,
        autofillHints: const [AutofillHints.email],

        ),
  );
}
