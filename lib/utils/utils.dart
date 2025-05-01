import 'package:flutter/material.dart';

SizedBox spacerHeight(double height) {
  return SizedBox(height: height);
}

SizedBox spacerWidth(double width) {
  return SizedBox(width: width);
}

void showOtpDialog(BuildContext context) {
  final TextEditingController otpController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Enter OTP'),
        content: TextField(
          controller: otpController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'OTP',
            hintText: 'Enter the OTP sent to your phone',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final otp = otpController.text;
              // Handle OTP submission logic here
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Submit'),
          ),
        ],
      );
    },
  );
}
