import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class EmailFieldWidget extends StatefulWidget {
  final TextEditingController controller;
   IconData icon;
   String hint;
  final FormFieldValidator<String> validators;

   EmailFieldWidget({

     required this.controller,required this.icon,required this.hint, required this.validators
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
  Widget build(BuildContext context) => TextFormField(
      controller: widget.controller,
       validator: widget.validators,
      decoration: InputDecoration(
        // helperText: 'Email',

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
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],

      );
}
