import 'package:flutter/material.dart';

class CircilarprogressIndicator extends StatelessWidget {
  const CircilarprogressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 25,
        width: 25,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(
          color: Colors.black38,
        ));
  }
}
