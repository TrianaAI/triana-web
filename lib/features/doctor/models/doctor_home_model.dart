class Doctor {
  final Map<String, dynamic> doctor;
  final int dailyAppointmentCount;
  final int allTimeAppointmentCount;
  final Map<String, dynamic>? currentQueue;

  Doctor({
    required this.doctor,
    required this.dailyAppointmentCount,
    required this.allTimeAppointmentCount,
    this.currentQueue,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      doctor: json['doctor'],
      dailyAppointmentCount: json['appointment_count_daily'],
      allTimeAppointmentCount: json['appointment_count_all_time'],
      currentQueue:
          json['current_queue'] != null
              ? Map<String, dynamic>.from(json['current_queue'])
              : null,
    );
  }
}
