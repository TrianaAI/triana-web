class Doctor {
  final Map<String, dynamic> doctor;
  final int dailyAppointmentCount;
  final int allTimeAppointmentCount;

  Doctor({
    required this.doctor,
    required this.dailyAppointmentCount,
    required this.allTimeAppointmentCount,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      doctor: json['doctor'],
      dailyAppointmentCount: json['daily_appointment_count'],
      allTimeAppointmentCount: json['all_time_appointment_count'],
    );
  }
}
