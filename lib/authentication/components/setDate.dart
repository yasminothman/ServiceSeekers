import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the selected date

class DatePickerTextFieldWidget extends StatefulWidget {
  
  final String hintText;
  

  const DatePickerTextFieldWidget({
    super.key,
    required this.hintText,
    
    });

  @override
  _DatePickerTextFieldWidgetState createState() =>
      _DatePickerTextFieldWidgetState();
}

class _DatePickerTextFieldWidgetState extends State<DatePickerTextFieldWidget> {
  DateTime? selectedDate; // The selected date

  TextEditingController dobController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dobController.text = DateFormat('dd-MM-yyyy').format(selectedDate!);
      });
    }
  }

@override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: dobController,
                  onTap: () => _selectDate(context),
                    decoration: InputDecoration(
                    enabledBorder:  OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1.5,),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal.shade100),
                    ),
                    fillColor: Colors.teal.shade100,
                    filled: true,
                    hintText: 'Date of Birth',
                    hintStyle: TextStyle(color: Colors.teal.shade400,),
                    suffixIcon: IconButton(
                        onPressed: () => _selectDate(context),
                        icon: Icon(Icons.calendar_today),
                  ),
                )
                )
                );
  }
  /*@override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: dobController,
      onTap: () => _selectDate(context),
      decoration: InputDecoration(
        labelText: 'Date',
        suffixIcon: IconButton(
          onPressed: () => _selectDate(context),
          icon: Icon(Icons.calendar_today),
        ),
      ),
    );
  }*/
}


