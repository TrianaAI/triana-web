class Diagnosis {
  final Map<String, dynamic> user;
  final Map<String, dynamic> currentSession;
  final List<dynamic> historySession;

  Diagnosis({
    required this.user,
    required this.currentSession,
    required this.historySession,
  });

  factory Diagnosis.fromJson(Map<String, dynamic> json) {
    return Diagnosis(
      user: json['user'] ?? {},
      currentSession: json['current_session'] ?? {},
      historySession: json['history_sessions'] ?? [],
    );
  }
}
