part of 'routes.dart';

class DoctorModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(
      '/:id',
      child: (context) {
        final id = Modular.args.params['id'];
        return BlocProvider(
          create: (_) => DoctorHomeCubit()..fetchDoctor(id!),
          child: const DoctorHomeView(),
        );
      },
    );
    r.child('/diagnosis', child: (_) => const DoctorDiagnosisView());
  }
}
