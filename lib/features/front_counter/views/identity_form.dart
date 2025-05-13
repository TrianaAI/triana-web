import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:triana_web/features/front_counter/cubit/identity_form/identity_form_cubit.dart';
import 'package:triana_web/features/front_counter/models/form.dart';
import 'package:triana_web/utils/country_list.dart';
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
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _heartRateController = TextEditingController();
  final _bodyTemperatureController = TextEditingController();
  DateTime? _dateOfBirth;
  bool? _isMale;
  String? _selectedCountry;
  bool _isFormSubmitted = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Colors that adapt to light/dark theme
    final borderColor = isDarkMode ? Colors.grey[600]! : Colors.grey[400]!;
    final focusedBorderColor = theme.colorScheme.primary;
    final errorBorderColor = theme.colorScheme.error;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final hintColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    final radioColor = theme.colorScheme.primary;
    final requiredColor = theme.colorScheme.error;

    return Scaffold(
      body: BlocListener<IdentityFormCubit, IdentityFormState>(
        listener: (context, state) {
          if (state is IdentityFormLoading) {
            LoadingOverlay.show(
              context,
              const Center(child: CircularProgressIndicator()),
            );
          } else if (state is IdentityFormSuccess) {
            LoadingOverlay.hide();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Loading successful!')),
            );
          } else if (state is IdentityFormFailure) {
            LoadingOverlay.hide();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.error}')));
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Form title
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome to Triana',
                        style: theme.textTheme.headlineLarge!.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      Text(
                        'Please fill in your details',
                        style: theme.textTheme.headlineSmall!.copyWith(
                          color: textColor.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                spacerHeight(32),

                // Name field (required)
                _buildWebLikeTextField(
                  label: 'Full Name',
                  isRequired: true,
                  controller: _nameController,
                  hintText: 'John Doe',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    } else if (value.length < 3) {
                      return 'Name must be at least 3 characters long';
                    }
                    return null;
                  },
                  borderColor: borderColor,
                  focusedBorderColor: focusedBorderColor,
                  errorBorderColor: errorBorderColor,
                  textColor: textColor,
                  hintColor: hintColor,
                  requiredColor: requiredColor,
                ),
                const SizedBox(height: 20),

                // Email field (required)
                _buildWebLikeTextField(
                  label: 'Email',
                  isRequired: true,
                  controller: _emailController,
                  hintText: 'john@mail.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(
                      r'^[^@]+@[^@]+\.[^@]+',
                    ).hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  borderColor: borderColor,
                  focusedBorderColor: focusedBorderColor,
                  errorBorderColor: errorBorderColor,
                  textColor: textColor,
                  hintColor: hintColor,
                  requiredColor: requiredColor,
                ),
                const SizedBox(height: 20),

                // Weight (required) and Height (required) in a row
                Row(
                  children: [
                    Expanded(
                      child: _buildWebLikeTextField(
                        label: 'Weight',
                        isRequired: true,
                        controller: _weightController,
                        hintText: '70 kg',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*$'),
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
                        borderColor: borderColor,
                        focusedBorderColor: focusedBorderColor,
                        errorBorderColor: errorBorderColor,
                        textColor: textColor,
                        hintColor: hintColor,
                        requiredColor: requiredColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildWebLikeTextField(
                        label: 'Height',
                        isRequired: true,
                        controller: _heightController,
                        hintText: '175 cm',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*$'),
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
                        borderColor: borderColor,
                        focusedBorderColor: focusedBorderColor,
                        errorBorderColor: errorBorderColor,
                        textColor: textColor,
                        hintColor: hintColor,
                        requiredColor: requiredColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Date of Birth (required) and Nationality (required)
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabelWithRequired(
                            label: 'Date of Birth',
                            isRequired: true,
                            textColor: textColor,
                            requiredColor: requiredColor,
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (selectedDate != null) {
                                setState(() {
                                  _dateOfBirth = selectedDate;
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color:
                                      _isFormSubmitted && _dateOfBirth == null
                                          ? errorBorderColor
                                          : borderColor,
                                  width:
                                      _isFormSubmitted && _dateOfBirth == null
                                          ? 1.5
                                          : 1,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 18,
                                    color: hintColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _dateOfBirth == null
                                        ? 'Select date'
                                        : '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}',
                                    style: TextStyle(
                                      color:
                                          _dateOfBirth == null
                                              ? hintColor
                                              : textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (_isFormSubmitted && _dateOfBirth == null)
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 4.0,
                                left: 10,
                              ),
                              child: Text(
                                'Please select date of birth',
                                style: TextStyle(
                                  color: errorBorderColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabelWithRequired(
                            label: 'Nationality',
                            isRequired: true,
                            textColor: textColor,
                            requiredColor: requiredColor,
                          ),
                          const SizedBox(height: 4),
                          DropdownButtonFormField<String>(
                            value: _selectedCountry,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                  color:
                                      _isFormSubmitted &&
                                              _selectedCountry == null
                                          ? errorBorderColor
                                          : borderColor,
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                  color:
                                      _isFormSubmitted &&
                                              _selectedCountry == null
                                          ? errorBorderColor
                                          : borderColor,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                  color: focusedBorderColor,
                                  width: 1.5,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                  color: errorBorderColor,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            hint: Text(
                              'Select country',
                              style: TextStyle(color: hintColor),
                            ),
                            items:
                                countries.map((String country) {
                                  return DropdownMenuItem<String>(
                                    value: country,
                                    child: Text(
                                      country,
                                      style: TextStyle(color: textColor),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedCountry = newValue;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select your country';
                              }
                              return null;
                            },
                            style: TextStyle(color: textColor),
                            dropdownColor:
                                isDarkMode ? Colors.grey[900] : Colors.white,
                            icon: Icon(Icons.arrow_drop_down, color: hintColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Heart Rate (required) and Temperature (required)
                Row(
                  children: [
                    Expanded(
                      child: _buildWebLikeTextField(
                        label: 'Heart Rate',
                        isRequired: true,
                        controller: _heartRateController,
                        hintText: '75 bpm',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*$'),
                          ),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your heart rate';
                          } else if (double.tryParse(value) == null) {
                            return 'Please enter a valid heart rate';
                          }
                          return null;
                        },
                        onTap:
                            () async => context
                                .read<IdentityFormCubit>()
                                .getBPM(context, _heartRateController),
                        readOnly: true,
                        borderColor: borderColor,
                        focusedBorderColor: focusedBorderColor,
                        errorBorderColor: errorBorderColor,
                        textColor: textColor,
                        hintColor: hintColor,
                        requiredColor: requiredColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildWebLikeTextField(
                        label: 'Body Temperature',
                        isRequired: true,
                        controller: _bodyTemperatureController,
                        hintText: '37.5 °C',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*$'),
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
                        onTap:
                            () async =>
                                context.read<IdentityFormCubit>().getBodyTemp(
                                  context,
                                  _bodyTemperatureController,
                                ),
                        readOnly: true,
                        borderColor: borderColor,
                        focusedBorderColor: focusedBorderColor,
                        errorBorderColor: errorBorderColor,
                        textColor: textColor,
                        hintColor: hintColor,
                        requiredColor: requiredColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Gender selection (required)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabelWithRequired(
                      label: 'Gender',
                      isRequired: true,
                      textColor: textColor,
                      requiredColor: requiredColor,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildWebLikeRadioButton(
                          value: true,
                          groupValue: _isMale,
                          label: 'Male',
                          onChanged: (value) {
                            setState(() {
                              _isMale = value;
                            });
                          },
                          radioColor: radioColor,
                          textColor: textColor,
                        ),
                        const SizedBox(width: 24),
                        _buildWebLikeRadioButton(
                          value: false,
                          groupValue: _isMale,
                          label: 'Female',
                          onChanged: (value) {
                            setState(() {
                              _isMale = value;
                            });
                          },
                          radioColor: radioColor,
                          textColor: textColor,
                        ),
                      ],
                    ),
                    if (_isFormSubmitted && _isMale == null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0, left: 10),
                        child: Text(
                          'Please select your gender',
                          style: TextStyle(
                            color: errorBorderColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 32),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      setState(() {
                        _isFormSubmitted = true;
                      });

                      if (_formKey.currentState!.validate()) {
                        if (_dateOfBirth == null ||
                            _selectedCountry == null ||
                            _isMale == null) {
                          return;
                        }

                        final identityForm = IdentityFormModel(
                          name: _nameController.text,
                          email: _emailController.text,
                          weight: double.parse(_weightController.text),
                          height: double.parse(_heightController.text),
                          heartRate: double.parse(_heartRateController.text),
                          bodyTemperature: double.parse(
                            _bodyTemperatureController.text,
                          ),
                          isMale: _isMale!,
                          nationality: _selectedCountry!,
                          dateOfBirth: _dateOfBirth!,
                        );
                        BlocProvider.of<IdentityFormCubit>(
                          context,
                        ).submitForm(identityForm, context);
                      }
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWebLikeTextField({
    required String label,
    bool isRequired = false,
    required TextEditingController controller,
    String? hintText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    VoidCallback? onTap,
    bool readOnly = false,
    required Color borderColor,
    required Color focusedBorderColor,
    required Color errorBorderColor,
    required Color textColor,
    required Color hintColor,
    required Color requiredColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabelWithRequired(
          label: label,
          isRequired: isRequired,
          textColor: textColor,
          requiredColor: requiredColor,
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: hintColor),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: borderColor, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: borderColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: focusedBorderColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: errorBorderColor, width: 1.5),
            ),
          ),
          style: TextStyle(color: textColor),
          validator: validator,
          onTap: onTap,
          readOnly: readOnly,
        ),
      ],
    );
  }

  Widget _buildLabelWithRequired({
    required String label,
    bool isRequired = false,
    required Color textColor,
    required Color requiredColor,
  }) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: TextStyle(
              fontSize: 14,
              color: textColor.withOpacity(0.8),
              fontWeight: FontWeight.w700,
            ),
          ),
          if (isRequired)
            TextSpan(
              text: ' *',
              style: TextStyle(
                fontSize: 14,
                color: requiredColor,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWebLikeRadioButton({
    required bool value,
    required bool? groupValue,
    required String label,
    required ValueChanged<bool?> onChanged,
    required Color radioColor,
    required Color textColor,
  }) {
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: groupValue == value ? radioColor : Colors.grey,
                width: 1.5,
              ),
            ),
            child: Icon(
              Icons.circle,
              size: 14,
              color: groupValue == value ? radioColor : Colors.transparent,
            ),
          ),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: textColor)),
        ],
      ),
    );
  }
}
