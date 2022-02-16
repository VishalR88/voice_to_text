import 'package:flutter/material.dart';

class PlayBtnWidget extends StatefulWidget {
  PlayBtnWidget({Key? key,  required this.ontap, required this.lable}) : super(key: key) ;
  Function ontap;
  String lable;

  @override
  _BtnWidgetState createState() => _BtnWidgetState();
}

class _BtnWidgetState extends State<PlayBtnWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.ontap();
      },
      child: Container(
        height: 50,
        width: 80,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          border: Border.all(color: Colors.black87.withOpacity(0.1)),
        ),
        padding: const EdgeInsets.all(10),
        child: Text(
          widget.lable,
          style: const TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
