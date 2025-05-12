import 'package:flutter/material.dart';
import 'package:triana_web/features/doctor/cubit/doctor_home_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DoctorHomeView extends StatefulWidget {
  const DoctorHomeView({super.key});

  @override
  State<DoctorHomeView> createState() => _DoctorHomeViewState();
}

class _DoctorHomeViewState extends State<DoctorHomeView> {
  late final String doctorId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Home')),
      body: BlocBuilder<DoctorHomeCubit, DoctorHomeState>(
        builder: (context, state) {
          if (state is DoctorHomeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DoctorHomeLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello, ${state.doctor.doctor["name"]}",
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "\"Medicines Cure Dieseases\nBut Only Doctors\nCan Cure Patients\"\n  - Carl Jung",
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Specialization",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          state.doctor.doctor["specialty"],
                          style: TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 16),
                        const Text("Room", style: TextStyle(fontSize: 16)),
                        Text(
                          state.doctor.doctor["room"],
                          style: TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Appointments Today",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          state.doctor.dailyAppointmentCount.toString(),
                          style: TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "All Appointments",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          state.doctor.allTimeAppointmentCount.toString(),
                          style: TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is DoctorHomeError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
