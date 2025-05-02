import 'package:equatable/equatable.dart';

class IdentityFormModel extends Equatable {
  final String name;
  final String email;
  final String phoneNumber;
  final double weight;
  final double height;
  final int age;
  final bool isMale;
  final double heartRate;
  final double bodyTemperature;
  final String nationality;

  const IdentityFormModel({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.weight,
    required this.height,
    required this.age,
    required this.isMale,
    required this.heartRate,
    required this.bodyTemperature,
    required this.nationality,
  });

  @override
  List<Object?> get props => [
    name,
    email,
    phoneNumber,
    weight,
    height,
    age,
    isMale,
    heartRate,
    bodyTemperature,
    nationality,
  ];

  factory IdentityFormModel.fromJson(Map<String, dynamic> json) {
    return IdentityFormModel(
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      weight: (json['weight'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      age: json['age'] as int,
      isMale: json['isMale'] as bool,
      heartRate: (json['heartRate'] as num).toDouble(),
      bodyTemperature: (json['bodyTemperature'] as num).toDouble(),
      nationality: json['nationality'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'weight': weight,
      'height': height,
      'age': age,
      'isMale': isMale,
      'heartRate': heartRate,
      'bodyTemperature': bodyTemperature,
      'nationality': nationality,
    };
  }

  IdentityFormModel copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    double? weight,
    double? height,
    int? age,
    bool? isMale,
    double? heartRate,
    double? bodyTemperature,
    String? nationality,
  }) {
    return IdentityFormModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      age: age ?? this.age,
      isMale: isMale ?? this.isMale,
      heartRate: heartRate ?? this.heartRate,
      bodyTemperature: bodyTemperature ?? this.bodyTemperature,
      nationality: nationality ?? this.nationality,
    );
  }
}
