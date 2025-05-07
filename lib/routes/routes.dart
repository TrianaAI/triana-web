import 'package:flutter_modular/flutter_modular.dart';
import 'package:triana_web/features/front_counter/models/form.dart';
import 'package:triana_web/features/front_counter/views/chat.dart';
import 'package:triana_web/features/front_counter/views/identity_form.dart';
import 'package:triana_web/features/front_counter/views/queue.dart';

import 'package:triana_web/features/doctor/views/diagnosis.dart';
import 'package:triana_web/features/doctor/views/home.dart';

part 'front_counter.dart';
part 'doctor.dart';

class MainRoutes extends Module {
  @override
  void routes(RouteManager r) {
    r.redirect('/', to: '/front_counter');
    r.module('/front_counter', module: FrontCounterModule());
    r.module('/doctor', module: DoctorModule());
  }
}
