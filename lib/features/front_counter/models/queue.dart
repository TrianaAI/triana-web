class QueueResponse {
  final QueueData? currentQueue;
  final String message;
  final String nextAction;
  final QueueData? queue;
  final String? reply;
  final String sessionId;

  QueueResponse({
    this.currentQueue,
    required this.message,
    required this.nextAction,
    this.queue,
    this.reply,
    required this.sessionId,
  });

  factory QueueResponse.fromJson(Map<String, dynamic> json) {
    return QueueResponse(
      currentQueue:
          json['current_queue'] is Map<String, dynamic>
              ? QueueData.fromJson(json['current_queue'])
              : null,
      message: json['message'] ?? 'No message provided',
      nextAction: json['next_action'] ?? 'NO_ACTION',
      queue:
          json['queue'] is Map<String, dynamic>
              ? QueueData.fromJson(json['queue'])
              : null,
      reply: json['reply'] ?? 'No reply available',
      sessionId: json['session_id'] ?? 'No session ID',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_queue': currentQueue?.toJson(),
      'message': message,
      'next_action': nextAction,
      'queue': queue?.toJson(),
      'reply': reply,
      'session_id': sessionId,
    };
  }
}

class QueueData {
  final String id;
  final String doctorId;
  final Doctor? doctor;
  final String sessionId;
  final SessionData? sessionData;
  final int number;

  QueueData({
    required this.id,
    required this.doctorId,
    this.doctor,
    required this.sessionId,
    this.sessionData,
    required this.number,
  });

  factory QueueData.fromJson(Map<String, dynamic> json) {
    return QueueData(
      id: json['id'] ?? '',
      doctorId: json['doctor_id'] ?? '',
      doctor:
          json['doctor'] is Map<String, dynamic>
              ? Doctor.fromJson(json['doctor'])
              : null,
      sessionId: json['session_id'] ?? '',
      sessionData:
          json['session'] is Map<String, dynamic>
              ? SessionData.fromJson(json['session'])
              : null,
      number: json['number'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctor_id': doctorId,
      'doctor': doctor?.toJson(),
      'session_id': sessionId,
      'session': sessionData?.toJson(),
      'number': number,
    };
  }
}

class Doctor {
  final String id;
  final String name;
  final String email;
  final String specialty;
  final String roomNo;

  Doctor({
    required this.id,
    required this.name,
    required this.email,
    required this.specialty,
    required this.roomNo,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? 'Unknown',
      specialty: json['specialty'] ?? 'Unknown',
      roomNo: json['roomno'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'specialty': specialty,
      'roomno': roomNo,
    };
  }
}

class SessionData {
  final String id;
  final String userId;
  final User user;
  final int weight;
  final int height;
  final int heartrate;
  final double bodyTemp;
  final String? preDiagnosis;
  final String doctorDiagnosis;

  SessionData({
    required this.id,
    required this.userId,
    required this.user,
    required this.weight,
    required this.height,
    required this.heartrate,
    required this.bodyTemp,
    this.preDiagnosis,
    required this.doctorDiagnosis,
  });

  factory SessionData.fromJson(Map<String, dynamic> json) {
    return SessionData(
      id: json['id'],
      userId: json['user_id'],
      user: User.fromJson(json['user']),
      weight: json['weight'],
      height: json['height'],
      heartrate: json['heartrate'],
      bodyTemp: (json['bodytemp'] as num).toDouble(),
      preDiagnosis: json['prediagnosis'],
      doctorDiagnosis: json['doctor_diagnosis'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user': user.toJson(),
      'weight': weight,
      'height': height,
      'heartrate': heartrate,
      'bodytemp': bodyTemp,
      'prediagnosis': preDiagnosis,
      'doctor_diagnosis': doctorDiagnosis,
    };
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String nationality;
  final String dob;
  final String gender;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.nationality,
    required this.dob,
    required this.gender,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      nationality: json['nationality'],
      dob: json['dob'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'nationality': nationality,
      'dob': dob,
      'gender': gender,
    };
  }
}
