import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:triana_web/features/front_counter/models/form.dart';

SizedBox spacerHeight(double height) {
  return SizedBox(height: height);
}

SizedBox spacerWidth(double width) {
  return SizedBox(width: width);
}

double getRandomDoubleInRange(double min, double max) {
  final random = Random();
  return min + (random.nextDouble() * (max - min));
}

void showOtpDialog(BuildContext context, IdentityFormModel identityForm) {
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
              // Navigator.of(context).pop(); // Close the dialog
              Modular.to.pop(); // Close the dialog
              Modular.to.pushNamed(
                '/front_counter/chat',
                arguments: identityForm,
              ); // Pass OTP to the next screen
            },
            child: const Text('Submit'),
          ),
        ],
      );
    },
  );
}

class LoadingOverlay {
  static OverlayEntry? _overlayEntry;

  static void show(BuildContext context, Widget child) {
    if (_overlayEntry != null) return; // Prevent multiple overlays

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Scaffold(
            backgroundColor: Colors.black54,
            body: GestureDetector(
              onTap: hide, // Hide the overlay when tapped
              child: Center(child: child),
            ),
          ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final overlay = Overlay.of(context);
      if (overlay != null) {
        overlay.insert(_overlayEntry!);
      }
    });
  }

  static void hide() {
    if (_overlayEntry != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _overlayEntry!.remove();
        _overlayEntry = null;
      });
    }
  }
}
