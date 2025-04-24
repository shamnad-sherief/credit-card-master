import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../utils/constants.dart';

class DatePickerField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final bool isDarkMode;
  final String? initialDate;
  final String? Function(String?)? validator;

  const DatePickerField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.isDarkMode,
    this.initialDate,
    this.validator,
  });

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      try {
        _selectedDate = DateFormat('MMM yyyy').parseStrict(widget.initialDate!);
      } catch (e) {
        _selectedDate = DateTime.now();
      }
    }
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2050),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: kPrimaryColor,
              onPrimary: Colors.grey,
              onSurface: Colors.blue,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        widget.controller.text = DateFormat('MMM yyyy').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: true,
      onTap: _selectDate,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        labelStyle: TextStyle(
          color: widget.isDarkMode ? Colors.white70 : Colors.grey[800],
        ),
        hintStyle: TextStyle(
          color: widget.isDarkMode ? Colors.white54 : Colors.grey[600],
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: widget.isDarkMode
            ? Colors.white.withOpacity(0.1)
            : Colors.white.withOpacity(0.3),
      ),
      style: TextStyle(
        color: widget.isDarkMode ? Colors.white : Colors.black87,
      ),
      validator: widget.validator,
    );
  }
}
