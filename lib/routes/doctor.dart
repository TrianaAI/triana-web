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
    r.child(
      '/diagnosis/:id/:doctorId',
      child: (context) {
        final id = Modular.args.params['id'];
        final doctorId = Modular.args.params['doctorId'];
        return BlocProvider(
          create: (_) => DoctorDiagnosisCubit()..fetchDiagnosis(id!, doctorId!),
          child: const DoctorDiagnosisView(),
        );
      },
    );
  }
}
