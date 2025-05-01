part of 'routes.dart';

class FrontCounterModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child('/', child: (_) => const IdentityForm());
    r.child('/chat', child: (_) => const ChatView());
  }
}
