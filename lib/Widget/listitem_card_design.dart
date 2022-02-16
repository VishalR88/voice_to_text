import 'package:flutter/material.dart';
import 'package:voice_to_text/Widget/playbtn_widget.dart';

class ListItemCard extends StatefulWidget {
  ListItemCard(
      {required Key key,
      required this.inputname,
      required this.inputtitle,
      required this.outputname,
      required this.outputtitle,
      this.inputisplaying = false,
      this.outputisplaying = false,
      required this.inputontap,
      required this.ontapofinputicon,
      required this.ontapofoutputicon,
      required this.outputontap})
      : super(key: key);
  String inputtitle;
  String inputname;
  String outputtitle;
  String outputname;
  Function inputontap;
  Function outputontap;
  Function ontapofinputicon;
  Function ontapofoutputicon;
  bool inputisplaying;
  bool outputisplaying;

  @override
  State<ListItemCard> createState() => _ListItemCardState();
}

class _ListItemCardState extends State<ListItemCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          build_row(widget.inputtitle, widget.inputname, () {
            widget.inputontap();
          }, () {
            widget.ontapofinputicon();
          }),
          const Divider(
            color: Colors.black26,
            height: 5,
          ),
          build_row(widget.outputtitle, widget.outputname, () {
            widget.outputontap();
          }, () {
            widget.ontapofoutputicon();
          }),
        ],
      ),
    );
  }

  Row build_row(
    String title,
    String name,
    Function ontap,
    Function ontapoficon,
    // bool isPlaying,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            InkWell(
              onTap: ontapoficon(),
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(width: 2, color: Colors.black)),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w300),
                ),
                Text(
                  name,
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w300),
                )
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: PlayBtnWidget(
            lable: "Play",
            ontap: () {
              ontap();
            },
          ),
        )
      ],
    );
  }
}
