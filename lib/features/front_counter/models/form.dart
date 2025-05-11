// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class IdentityFormModel extends Equatable {
  final String name;
  final String email;
  // final String phoneNumber;
  final double weight;
  final double height;
  final bool isMale;
  final double heartRate;
  final double bodyTemperature;
  final String nationality;
  final DateTime dateOfBirth;
  String? otp;

  IdentityFormModel({
    required this.name,
    required this.email,
    required this.weight,
    required this.height,
    required this.isMale,
    required this.heartRate,
    required this.bodyTemperature,
    required this.nationality,
    required this.dateOfBirth,
    this.otp,
  });

  @override
  List<Object?> get props => [
    name,
    email,
    // phoneNumber,
    weight,
    height,
    isMale,
    heartRate,
    bodyTemperature,
    nationality,
    dateOfBirth,
    otp,
    // age,
  ];

  factory IdentityFormModel.fromJson(Map<String, dynamic> json) {
    return IdentityFormModel(
      name: json['name'] as String,
      email: json['email'] as String,
      // phoneNumber: json['phoneNumber'] as String,
      weight: (json['weight'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      isMale: json['isMale'] == "Male" ? true : false,
      heartRate: (json['heartRate'] as num).toDouble(),
      bodyTemperature: (json['bodyTemperature'] as num).toDouble(),
      nationality: json['nationality'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      // 'phoneNumber': phoneNumber,
      'weight': weight,
      'height': height,
      'gender': isMale ? "Male" : "Female",
      'heartrate': heartRate,
      'bodytemp': bodyTemperature,
      'nationality': nationality,
      'dob': dateOfBirth.toIso8601String(),
      'otp': otp, // Added otp field
    };
  }

  IdentityFormModel copyWith({
    String? name,
    String? email,
    // String? phoneNumber,
    double? weight,
    double? height,
    // int? age,
    bool? isMale,
    double? heartRate,
    double? bodyTemperature,
    String? nationality,
    DateTime? dateOfBirth,
    String? otp,
  }) {
    return IdentityFormModel(
      name: name ?? this.name,
      email: email ?? this.email,
      // phoneNumber: phoneNumber ?? this.phoneNumber,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      // age: age ?? this.age,
      isMale: isMale ?? this.isMale,
      heartRate: heartRate ?? this.heartRate,
      bodyTemperature: bodyTemperature ?? this.bodyTemperature,
      nationality: nationality ?? this.nationality,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      otp: otp ?? this.otp,
    );
  }
}
