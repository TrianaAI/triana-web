import 'package:flutter_modular/flutter_modular.dart';
import 'package:triana_web/features/front_counter/models/form.dart';
import 'package:triana_web/features/front_counter/views/chat.dart';
import 'package:triana_web/features/front_counter/views/config_blue.dart';
import 'package:triana_web/features/front_counter/views/config_serial.dart';
import 'package:triana_web/features/front_counter/views/identity_form.dart';
import 'package:triana_web/features/front_counter/views/queue.dart';

import 'package:triana_web/features/doctor/views/diagnosis.dart';
import 'package:triana_web/features/doctor/views/home.dart';
import 'package:triana_web/features/doctor/cubit/doctor_home_cubit.dart';
import 'package:triana_web/features/doctor/cubit/doctor_diagnosis_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:triana_web/features/splash.dart';

part 'front_counter.dart';
part 'doctor.dart';

class MainRoutes extends Module {
  @override
  void routes(RouteManager r) {
    r.child('/', child: (_) => const SplashScreen());
    r.module('/front_counter', module: FrontCounterModule());
    r.module('/doctor', module: DoctorModule());
  }
}
