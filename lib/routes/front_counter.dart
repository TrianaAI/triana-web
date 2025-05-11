part of 'routes.dart';

class FrontCounterModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child('/', child: (_) => const IdentityForm());
    r.child(
      '/chat/:session',
      child: (_) => ChatView(session: r.args.params['session']),
    );
    // r.child('/chat', child: (_) => const ChatView());
    r.child('/queue', child: (_) => const QueueNumber());
    r.child('/config', child: (_) => const ConfigBlueView());
  }
}
