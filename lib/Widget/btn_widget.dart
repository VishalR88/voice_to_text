import 'package:flutter/material.dart';

class BtnWidget extends StatefulWidget {
  BtnWidget({required this.ontap, required this.lable}) ;
  Function ontap;
  String lable;

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
          padding: EdgeInsets.only(left: 5),
          child: Text(
            "${widget.lable}",
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }
}
