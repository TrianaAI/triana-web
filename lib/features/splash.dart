import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigate() {
    Modular.to.navigate('/front_counter');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _navigate,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFF161619),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Lottie.asset(
                'assets/triana-splash.json',
                fit: BoxFit.cover,
                controller: _controller,
                onLoaded: (composition) {
                  _controller
                    ..duration =
                        composition.duration *
                        1.5 // slow it down
                    ..repeat();
                },
              ),
              Positioned(
                bottom: 50,
                child: Text(
                  'Press anywhere to start!',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
