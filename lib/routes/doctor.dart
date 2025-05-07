part of 'routes.dart';

class DoctorModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child('/', child: (_) => const DoctorHomeView());
    r.child('/diagnosis', child: (_) => const DoctorDiagnosisView());
  }
}
