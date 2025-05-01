import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:triana_web/utils/utils.dart';

class IdentityForm extends StatefulWidget {
  const IdentityForm({super.key});

  @override
  State<IdentityForm> createState() => _IdentityFormState();
}

class _IdentityFormState extends State<IdentityForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();
  final _heartRateController = TextEditingController();
  final _bodyTemperatureController = TextEditingController();
  bool _isLoading = false;
  bool? _isMale;
  String? _selectedCountry;

  // List of countries for the dropdown
  final List<String> _countries = [
    'Select Country',
    'USA',
    'Canada',
    'UK',
    'India',
    'Australia',
    'Germany',
    'France',
    'Japan',
    'Brazil',
  ];

  @override
  Widget build(BuildContext context) {
    const labelWidth = 120.0; // Fixed width for all labels
    const labelStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
    const fieldPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);

    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            _buildLabeledField(
              label: 'Full Name:',
              labelWidth: labelWidth,
              labelStyle: labelStyle,
              hint: 'John Doe',
              controller: _nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                } else if (value.length < 3) {
                  return 'Name must be at least 3 characters long';
                }
                return null;
              },
            ),
            spacerHeight(20),
            _buildLabeledField(
              label: 'Email:',
              labelWidth: labelWidth,
              labelStyle: labelStyle,
              hint: 'john@mail.com',
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            spacerHeight(20),
            _buildLabeledField(
              label: 'Phone:',
              labelWidth: labelWidth,
              labelStyle: labelStyle,
              hint: '+1234567890',
              controller: _phoneController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                } else if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
            ),
            spacerHeight(20),
            Row(
              children: [
                Expanded(
                  child: _buildLabeledField(
                    label: 'Weight:',
                    labelWidth: labelWidth,
                    labelStyle: labelStyle,
                    hint: '70 kg',
                    controller: _weightController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your weight';
                      } else if (double.tryParse(value) == null) {
                        return 'Please enter a valid weight';
                      }
                      return null;
                    },
                  ),
                ),
                spacerWidth(20),
                Expanded(
                  child: _buildLabeledField(
                    label: 'Height:',
                    labelWidth: labelWidth,
                    labelStyle: labelStyle,
                    hint: '175 cm',
                    controller: _heightController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your height';
                      } else if (double.tryParse(value) == null) {
                        return 'Please enter a valid height';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            spacerHeight(20),
            Row(
              children: [
                Expanded(
                  child: _buildLabeledField(
                    label: 'Age:',
                    labelWidth: labelWidth,
                    labelStyle: labelStyle,
                    hint: '25',
                    controller: _ageController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your age';
                      } else if (int.tryParse(value) == null) {
                        return 'Please enter a valid age';
                      }
                      return null;
                    },
                  ),
                ),
                spacerWidth(20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: labelWidth,
                          child: Text('Sex:', style: labelStyle),
                        ),
                        spacerWidth(20),
                        Radio<bool>(
                          value: true,
                          groupValue: _isMale,
                          onChanged: (value) {
                            setState(() {
                              _isMale = value;
                            });
                          },
                        ),
                        const Text('Male'),
                        spacerWidth(20),
                        Radio<bool>(
                          value: false,
                          groupValue: _isMale,
                          onChanged: (value) {
                            setState(() {
                              _isMale = value;
                            });
                          },
                        ),
                        const Text('Female'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            spacerHeight(20),
            Row(
              children: [
                Expanded(
                  child: _buildLabeledField(
                    label: 'Heart Rate:',
                    labelWidth: labelWidth,
                    labelStyle: labelStyle,
                    hint: '75 bpm',
                    controller: _heartRateController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your heart rate';
                      } else if (int.tryParse(value) == null) {
                        return 'Please enter a valid heart rate';
                      }
                      return null;
                    },
                  ),
                ),
                spacerWidth(20),
                Expanded(
                  child: _buildLabeledField(
                    label: 'Body Temperature:',
                    labelWidth: labelWidth,
                    labelStyle: labelStyle,
                    hint: '37.5 °C',
                    controller: _bodyTemperatureController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your body temperature';
                      } else if (double.tryParse(value) == null) {
                        return 'Please enter a valid body temperature';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            spacerHeight(20),
            _buildCountryDropdown(
              label: 'Country:',
              labelWidth: labelWidth,
              labelStyle: labelStyle,
              fieldPadding: fieldPadding,
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value == 'Select Country') {
                  return 'Please select your country';
                }
                return null;
              },
            ),
            spacerHeight(30),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 140.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    Modular.to.pushNamed('/front_counter/chat');
                    // if (_formKey.currentState?.validate() ?? false) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //       content: Text('Form submitted successfully'),
                    //     ),
                    //   );
                    // }
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabeledField({
    required String label,
    required double labelWidth,
    required TextStyle labelStyle,
    String? hint,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: labelWidth, child: Text(label, style: labelStyle)),
        spacerWidth(20),
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.blue, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.blue, width: 2.0),
              ),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }

  Widget _buildCountryDropdown({
    required String label,
    required double labelWidth,
    required TextStyle labelStyle,
    required EdgeInsets fieldPadding,
    required String? Function(String?)? validator,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: labelWidth, child: Text(label, style: labelStyle)),
        spacerWidth(20),
        SizedBox(
          width: 300,
          child: DropdownButtonFormField<String>(
            value: _selectedCountry,
            decoration: InputDecoration(
              contentPadding: fieldPadding,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.blue, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.blue, width: 2.0),
              ),
            ),
            hint: const Text('Select Country'),
            items:
                _countries.map((String country) {
                  return DropdownMenuItem<String>(
                    value: country,
                    child: Text(country),
                  );
                }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCountry = newValue;
              });
            },
            validator: validator,
          ),
        ),
      ],
    );
  }
}
