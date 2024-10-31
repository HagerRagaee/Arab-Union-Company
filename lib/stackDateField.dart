// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class StakeDateField extends StatefulWidget {
  StakeDateField({
    super.key,
    required this.label,
    this.showTime = false,
    this.showDate = false,
    required this.controller,
    this.size = 0.0,
    this.numberType = false,
    required this.validator,
    this.readOnly = false,
  });

  String? label;
  final bool showTime;
  final bool showDate;
  final double? size;
  final bool numberType;
  final bool readOnly;

  TextEditingController? controller = TextEditingController();
  String? Function(String?)? validator;

  @override
  State<StakeDateField> createState() => _StakeDateFieldState();
}

class _StakeDateFieldState extends State<StakeDateField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end, // Align children to the start
      children: [
        Text(
          widget.label!,
          style: TextStyle(
            color: widget.readOnly
                ? const Color.fromARGB(255, 148, 148, 148)
                : Colors.black,
            fontSize: widget.size == 0.0 ? 15 : widget.size!,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
            height:
                4), // Add some spacing between the label and the dashed line
        Row(
          children: [
            Expanded(
              child: Stack(
                children: [
                  const Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '..........................................................................................................................................................................................................................................................',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  TextFormField(
                    readOnly: widget.readOnly,
                    validator: widget.readOnly ? null : widget.validator,
                    controller: widget.controller,
                    maxLines: 4,
                    minLines: 1,
                    keyboardType: widget.numberType
                        ? TextInputType.datetime
                        : TextInputType.multiline,
                    textAlign: TextAlign.right,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
