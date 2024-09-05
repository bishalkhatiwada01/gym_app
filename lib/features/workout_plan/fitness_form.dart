import 'package:flutter/material.dart';

class FitnessInputForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  const FitnessInputForm({Key? key, required this.onSubmit}) : super(key: key);

  @override
  _FitnessInputFormState createState() => _FitnessInputFormState();
}

class _FitnessInputFormState extends State<FitnessInputForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'age': '',
    'weight': '',
    'height': '',
    'gender': '',
    'activityLevel': '',
    'fitnessGoal': '',
  };

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSubmit(_formData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Fitness Information'),
              TextFormField(
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your age' : null,
                onSaved: (value) => _formData['age'] = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your weight' : null,
                onSaved: (value) => _formData['weight'] = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Height (cm)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your height' : null,
                onSaved: (value) => _formData['height'] = value,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Gender'),
                items: ['Male', 'Female'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) =>
                    value == null ? 'Please select your gender' : null,
                onChanged: (value) =>
                    setState(() => _formData['gender'] = value),
                onSaved: (value) => _formData['gender'] = value,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Activity Level'),
                items: ['Sedentary', 'Moderately Active', 'Very Active']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) =>
                    value == null ? 'Please select your activity level' : null,
                onChanged: (value) =>
                    setState(() => _formData['activityLevel'] = value),
                onSaved: (value) => _formData['activityLevel'] = value,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Fitness Goal'),
                items: ['Lose Weight', 'Build Muscle', 'Stay Fit']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) =>
                    value == null ? 'Please select your fitness goal' : null,
                onChanged: (value) =>
                    setState(() => _formData['fitnessGoal'] = value),
                onSaved: (value) => _formData['fitnessGoal'] = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
