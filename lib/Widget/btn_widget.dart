import 'package:flutter/material.dart';
import 'package:voice_to_text/Widget/progress_indicator.dart';

class BtnWidget extends StatefulWidget {
  BtnWidget({required this.ontap, required this.lable,required this.isLoading}) ;
  Function ontap;
  String lable;
  bool isLoading;

  @override
  _BtnWidgetState createState() => _BtnWidgetState();
}

class _BtnWidgetState extends State<BtnWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.ontap();
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          border: Border.all(color: Colors.black87.withOpacity(0.1)),
        ),
        padding: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.only(left: 5),
          child:widget.isLoading? const CircilarprogressIndicator(): Text(
            widget.lable,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }
}
