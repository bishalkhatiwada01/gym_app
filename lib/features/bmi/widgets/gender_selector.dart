import 'package:flutter/material.dart';

class GenderSelector extends StatefulWidget {
  final String selectedGender;
  final ValueChanged<String> onChanged;

  const GenderSelector(
      {super.key, required this.selectedGender, required this.onChanged});

  @override
  _GenderSelectorState createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  List<String> genders = ['Male', 'Female'];

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      isSelected:
          genders.map((gender) => gender == widget.selectedGender).toList(),
      onPressed: (index) {
        widget.onChanged(genders[index]);
      },
      borderRadius: BorderRadius.circular(8.0),
      selectedColor: Colors.white,
      fillColor: Colors.teal,
      borderColor: Colors.teal,
      color: Colors.teal,
      constraints: const BoxConstraints(minHeight: 40.0, minWidth: 100.0),
      children: genders
          .map((gender) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(child: Text(gender)),
              ))
          .toList(),
    );
  }
}
