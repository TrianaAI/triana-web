import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:triana_web/features/front_counter/models/form.dart';
import 'package:triana_web/utils/country_list.dart';
import 'package:triana_web/utils/mqtt.dart';
import 'package:triana_web/utils/utils.dart';

class IdentityForm extends StatefulWidget {
  const IdentityForm({super.key});

  @override
  State<IdentityForm> createState() => _IdentityFormState();
}

class _IdentityFormState extends State<IdentityForm> {
  final mqttService = MqttService();
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

  @override
  void initState() {
    super.initState();
    _connectMqtt();
  }

  Future<void> _connectMqtt() async {
    Future.delayed(const Duration(seconds: 1), () {
      LoadingOverlay.hide();
    });
    LoadingOverlay.show(
      context,
      Center(
        child: Container(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),
      ),
    );
    mqttService.connect().then((_) {
      if (mqttService.client.connectionStatus?.state ==
          MqttConnectionState.connected) {
        print('MQTT client connected');
      } else {
        print(
          'MQTT client connection failed - status: ${mqttService.client.connectionStatus}',
        );
        mqttService.client.disconnect();
      }
    });
    LoadingOverlay.hide();
  }

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
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\+?[0-9]*$')),
              ],
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
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(
                          r'^\d*\.?\d*$',
                        ), // Allow numbers with optional decimal point
                      ),
                    ],
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
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(
                          r'^\d*\.?\d*$',
                        ), // Allow numbers with optional decimal point
                      ),
                    ],
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
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*$'), // Allow only digits
                      ),
                    ],
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
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(
                          r'^\d*\.?\d*$',
                        ), // Allow numbers with optional decimal point
                      ),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your heart rate';
                      } else if (int.tryParse(value) == null) {
                        return 'Please enter a valid heart rate';
                      }
                      return null;
                    },
                    onTap: () {
                      LoadingOverlay.show(
                        context,
                        GestureDetector(
                          onTap: () {
                            LoadingOverlay.hide();
                          },
                          child: Container(
                            width: 400,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: const Center(
                              child: Text(
                                'Put your finger on the sensor below',
                              ),
                            ),
                          ),
                        ),
                      );
                      mqttService.subscribe('triana/device/1/bloodrate');
                      mqttService.publish(
                        'triana/device/1/bloodrate',
                        'Hello from Flutter!',
                      );
                      // Custom onTap logic for Heart Rate
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(
                      //     content: Text(
                      //       'Heart Rate is connected to IoT device',
                      //     ),
                      //   ),
                      // );
                    },
                    readOnly: true, // Make the field non-editable
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
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(
                          r'^\d*\.?\d*$',
                        ), // Allow numbers with optional decimal point
                      ),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your body temperature';
                      } else if (double.tryParse(value) == null) {
                        return 'Please enter a valid body temperature';
                      }
                      return null;
                    },
                    onTap: () {
                      LoadingOverlay.show(
                        context,
                        GestureDetector(
                          onTap: () {
                            LoadingOverlay.hide();
                          },
                          child: Container(
                            width: 400,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: const Center(
                              child: Text(
                                'Put your finger on the sensor below',
                              ),
                            ),
                          ),
                        ),
                      );
                      // Custom onTap logic for Body Temperature
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(
                      //     content: Text(
                      //       'Body Temperature is connected to IoT device',
                      //     ),
                      //   ),
                      // );
                    },
                    readOnly: true, // Make the field non-editable
                  ),
                ),
              ],
            ),
            spacerHeight(20),
            _buildCountryDropdown(
              label: 'Nationality:',
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
                    // Modular.to.pushNamed('/front_counter/chat');
                    final dummyIdentityForm = IdentityFormModel(
                      name: 'John Doe',
                      email: 'sdfa@jfdsl.com',
                      phoneNumber: '+1234567890',
                      weight: 70.0,
                      height: 175.0,
                      age: 25,
                      heartRate: 75.0,
                      bodyTemperature: 37.5,
                      isMale: true,
                      nationality: 'USA',
                    );
                    showOtpDialog(context, dummyIdentityForm);
                    // if (_formKey.currentState?.validate() ?? false) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //       content: Text('Form submitted successfully'),
                    //     ),
                    //   );
                    //   // final identityForm = IdentityFormModel(
                    //   //   name: _nameController.text,
                    //   //   email: _emailController.text,
                    //   //   phoneNumber: _phoneController.text,
                    //   //   weight: double.parse(_weightController.text),
                    //   //   height: double.parse(_heightController.text),
                    //   //   age: int.parse(_ageController.text),
                    //   //   heartRate: double.parse(_heartRateController.text),
                    //   //   bodyTemperature: double.parse(
                    //   //     _bodyTemperatureController.text,
                    //   //   ),
                    //   //   isMale: _isMale!,
                    //   //   nationality: _selectedCountry!,
                    //   // );
                    //   // showOtpDialog(context, identityForm);
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
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? hint,
    required TextEditingController controller,
    String? Function(String?)? validator,
    VoidCallback? onTap,
    bool readOnly = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: labelWidth, child: Text(label, style: labelStyle)),
        spacerWidth(20),
        Expanded(
          child: TextFormField(
            controller: controller,
            // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey),
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
            onTap: onTap,
            readOnly: readOnly,
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
          width: 500,
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
            hint: const Text('Select Nationality'),
            items:
                countries.map((String country) {
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
