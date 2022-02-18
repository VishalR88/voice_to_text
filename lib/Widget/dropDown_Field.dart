import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class DropDownField extends StatefulWidget {
   DropDownField({Key? key,this.selectedValue,required this.onselectGender}) : super(key: key);
  String? selectedValue;
  Function onselectGender;
  @override
  _DropDownFieldState createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<DropDownField> {

  List<String> items = [
    'Male',
    'Female',
    'Prefer not to say',
  ];
  List<IconData> icons = [Icons.male, Icons.female, Icons.transgender];

  @override
  Widget build(BuildContext context) {
    return Stack(children: [

      Container(
        decoration:  BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.black38,
          ),
          // color: Colors.transparent,
        ),
        padding: const EdgeInsets.only(left: 32.0),
        // margin: const EdgeInsets.only(top: 64.0, left: 16.0, right: 16.0),
        height: MediaQuery.of(context).size.height * 0.079,
        width: MediaQuery.of(context).size.width,
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            isExpanded: true,
            hint: Text(
              'Select Gender',
              style: TextStyle(
                  fontSize: 16,
                  // fontWeight: FontWeight.w300,
                  color: Colors.grey.withOpacity(0.4)),
              overflow: TextOverflow.ellipsis,
            ),
            items: items
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                .toList(),
            value: widget.selectedValue,
            onChanged: (value) {
              widget.onselectGender(value);
            },
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
            ),
            iconSize: 30,
            iconEnabledColor: Colors.black,
            iconDisabledColor: Colors.grey,
            buttonHeight: 50,
            buttonWidth: 160,
            buttonPadding: const EdgeInsets.only(left: 14, right: 14),

            itemHeight: 40,
            itemPadding: const EdgeInsets.only(left: 14, right: 14),
            dropdownMaxHeight: 200,

            dropdownPadding: null,
            dropdownDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.grey[200],
            ),

            scrollbarRadius: const Radius.circular(40),
            scrollbarThickness: 6,
            scrollbarAlwaysShow: true,

          ),
        ),
      ),
      const Positioned(
        left: 15,
        top: 20,
        child:  Icon(
          Icons.transgender,
          color: Colors.grey,
          size: 20.0,
        ),
      ),

    ]);
  }
}
