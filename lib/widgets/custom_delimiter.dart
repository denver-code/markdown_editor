import 'package:flutter/material.dart';

class CustomDelimiter extends StatelessWidget {
  const CustomDelimiter({Key? key, this.color = Colors.white})
      : super(key: key);
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1.5,
      child: Center(
        child: Container(
          margin: const EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
          color: color.withOpacity(0.3),
        ),
      ),
    );
  }
}

class CustomVerticalDelimiter extends StatelessWidget {
  const CustomVerticalDelimiter({Key? key, this.color = Colors.white})
      : super(key: key);
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.5,
      child: Center(
        child: Container(
          margin: const EdgeInsetsDirectional.only(top: 1.0, bottom: 1.0),
          color: color.withOpacity(0.3),
        ),
      ),
    );
  }
}
