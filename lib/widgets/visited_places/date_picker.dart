import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({
    super.key,
    required this.date,
    required this.onPickDate,
  });

  final DateTime date;
  final void Function(DateTime pickedDate) onPickDate;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  void _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.date,
      firstDate: DateTime(2000, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != widget.date) {
      setState(() {
        widget.onPickDate(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton.icon(
          onPressed: () {
            _pickDate(context);
          },
          label: const Text('Pick a date'),
          icon: const Icon(Icons.calendar_today),
          style: OutlinedButton.styleFrom(
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 18,
            ),
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1,
            ),
          ),
        ),
        const SizedBox(width: 40),
        Text(
          widget.date.toString().split(' ')[0].replaceAll("-", "/"),
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
