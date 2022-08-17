import 'package:flutter/material.dart';

class DemoCell extends StatefulWidget {
  final String name;
  const DemoCell({Key? key, required this.name}) : super(key: key);

  @override
  State<DemoCell> createState() => _DemoCellState();
}

class _DemoCellState extends State<DemoCell> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 100,
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
          ),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(1),
            ),
            border: Border.all(
              color: Colors.black,
            ),
          ),
          child: Text(
            widget.name.toString(),
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
          ),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: const Text(
            "000/###",
          ),
        )
      ],
    );
  }
}
