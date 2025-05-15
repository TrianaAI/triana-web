// filepath: /Users/dzin/Adzin/Program/triana-web/lib/features/front_counter/views/identity_form.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart' show Modular;
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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _heartRateController.dispose();
    _bodyTemperatureController.dispose();
    super.dispose();
  }

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
      // appBar: AppBar(title: Image.asset('assets/images/triana-logo.png')),
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
                Image.asset(
                  'assets/images/triana-logo.png',
                  // width: 120,
                  height: 70,
                  // fit: BoxFit.cover,
                ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWebLikeTextField({
    required String label,
    required bool isRequired,
    required TextEditingController controller,
    required String hintText,
    required Color borderColor,
    required Color focusedBorderColor,
    required Color errorBorderColor,
    required Color textColor,
    required Color hintColor,
    required Color requiredColor,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
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
          maxLines: maxLines,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.transparent,
            hintText: hintText,
            hintStyle: TextStyle(color: hintColor),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: focusedBorderColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: errorBorderColor),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: errorBorderColor, width: 2),
            ),
          ),
          validator: _isFormSubmitted ? validator : null,
        ),
      ],
    );
  }

  Widget _buildLabelWithRequired({
    required String label,
    required bool isRequired,
    required Color textColor,
    required Color requiredColor,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        if (isRequired)
          Text(
            ' *',
            style: TextStyle(
              color: requiredColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
      ],
    );
  }

  Widget spacerHeight(double height) {
    return SizedBox(height: height);
  }
}
