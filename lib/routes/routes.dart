import 'package:flutter_modular/flutter_modular.dart';
import 'package:triana_web/features/front_counter/views/chat.dart';
import 'package:triana_web/features/front_counter/views/identity_form.dart';

part 'front_counter.dart';

class MainRoutes extends Module {
  @override
  void routes(RouteManager r) {
    r.redirect('/', to: '/front_counter');
    r.module('/front_counter', module: FrontCounterModule());
  }
}
