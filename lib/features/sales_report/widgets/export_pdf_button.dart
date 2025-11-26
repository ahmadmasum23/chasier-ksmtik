import 'package:flutter/material.dart';

class ExportPdfButton extends StatelessWidget {
  const ExportPdfButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Export PDF ",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}