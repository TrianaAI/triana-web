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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(92),
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Row(
            children: [
              Image.asset(
                'assets/images/triana-logo.png',
                height: 70, // Adjust size as needed
              ),
              const SizedBox(width: 16), // Spacing between logo and text
              Text(
                'Doctor Home',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 30,
                              child: Center(
                                child: Icon(
                                  Icons.person,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Hello, ${state.doctor.doctor["name"]}",
                              style: TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              state.doctor.doctor["email"],
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 30,
                              child: Center(
                                child: Icon(
                                  Icons.medical_services,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
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
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 30,
                              child: Center(
                                child: Icon(
                                  Icons.room,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Room",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    state.doctor.doctor["roomno"],
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 30,
                              child: Center(
                                child: Icon(
                                  Icons.today,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Appointments Today",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    state.doctor.dailyAppointmentCount
                                        .toString(),
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 30,
                              child: Center(
                                child: Icon(
                                  Icons.calendar_month,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "All Appointments",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    state.doctor.allTimeAppointmentCount
                                        .toString(),
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // show current queue as button
                        if (state.doctor.currentQueue != null) ...[
                          Text("Current Queue"),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 32,
                              ),
                            ),
                            onPressed: () {
                              Modular.to.pushNamed(
                                '/doctor/diagnosis/${state.doctor.currentQueue?["session"]["user_id"]}',
                              );
                            },
                            child: Text(
                              state.doctor.currentQueue?["number"]
                                      ?.toString() ??
                                  '',
                            ),
                          ),
                        ],
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
