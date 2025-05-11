import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:triana_web/features/front_counter/models/form.dart';
import 'package:triana_web/services/network.dart';
import 'package:triana_web/utils/constants.dart';

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
  final netowrkService = NetworkService();
  bool _isLoading = false;

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
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            const SizedBox.shrink(),
          ElevatedButton(
            onPressed: () {
              // Modular.to.pushNamed(
              //   '/front_counter/chat/32e77e93-dde5-4999-a73c-75c1b55afa17',
              // );
              //32e77e93-dde5-4999-a73c-75c1b55afa17
              if (otpController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter the OTP')),
                );
                return;
              }
              _isLoading = true;
              final otp = otpController.text;
              final data = identityForm.copyWith(otp: otp);

              print(data.toJson());

              netowrkService
                  .post(kVerifyOTPUrl, data: data.toJson())
                  .then((response) {
                    if (response.statusCode == 200) {
                      final responseData = response.data['session']['id'];
                      print(responseData);
                      // final session =
                      //     responseData['session']['id']
                      //         as String; // Extract session ID

                      // print('Session ID: $session');
                      _isLoading = false;
                      Modular.to.pop(); // Close the dialog
                      Modular.to.pushNamed('/front_counter/chat/$responseData');
                      // Modular.to.pushNamed(
                      //   '/front_counter/chat',
                      //   // arguments: responseData,
                      // );
                    } else {
                      _isLoading = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Invalid OTP. Please try again.'),
                        ),
                      );
                    }
                  })
                  .catchError((error) {
                    print(error);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Network error. Please try again.'),
                      ),
                    );
                  });
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
