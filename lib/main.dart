import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:triana_web/features/front_counter/cubit/bluetooth/bluetooth_cubit.dart';
import 'package:triana_web/features/front_counter/cubit/chat/chat_cubit.dart';
import 'package:triana_web/features/front_counter/cubit/identity_form/identity_form_cubit.dart';
import 'package:triana_web/features/front_counter/cubit/queue/queue_cubit.dart';
import 'package:triana_web/routes/routes.dart';
import 'package:triana_web/services/network.dart';
import 'package:triana_web/services/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ModularApp(module: MainRoutes(), child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute('/front_counter');

    final bluetoothService = BluetoothService();
    final networkService = NetworkService();
    // final serialService = SerialService();
    // final serialCubit = SerialCubit(serialService);
    final bluetoothCubit = BluetoothCubit(bluetoothService);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ChatCubit(networkService)),
        BlocProvider(
          create:
              (context) => IdentityFormCubit(bluetoothCubit: bluetoothCubit),
        ),
        BlocProvider(create: (context) => QueueCubit()),
        BlocProvider(create: (context) => bluetoothCubit),
        // BlocProvider(create: (context) => serialCubit),
      ],
      child: MaterialApp.router(
        title: 'Triana',
        routeInformationParser: Modular.routeInformationParser,
        routerDelegate: Modular.routerDelegate,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFF6F8FA),
          primaryColor: Colors.black,
          colorScheme: ColorScheme.light(
            primary: Colors.black,
            secondary: Colors.grey,
            onPrimary: Colors.white,
            onSecondary: Colors.black,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF6F8FA),
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.black),
            bodyMedium: TextStyle(color: Colors.black),
            bodySmall: TextStyle(color: Colors.black),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFCFD4D9)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFCFD4D9)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFCFD4D9)),
            ),
            labelStyle: const TextStyle(color: Colors.blue),
            hintStyle: const TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
