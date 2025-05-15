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
  void initState() {
    super.initState();
    doctorId = Modular.args.params['doctorId'] ?? '';
    BlocProvider.of<DoctorHomeCubit>(
      context,
    ).fetchDoctor(doctorId); // Fetch doctor data when the page is opened
  }

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
                        const SizedBox(height: 16),
                        const Text(
                          "Welcome to your home page.\nHere you can find all the information you need.",
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Quote of the day",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
                            onPressed: () async {
                              final doctorIdFromState =
                                  state
                                      .doctor
                                      .doctor['id']; // Directly access doctor ID from state
                              if (doctorIdFromState == null ||
                                  doctorIdFromState.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Invalid doctor ID'),
                                  ),
                                );
                                return;
                              }

                              // Show loading indicator
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              );

                              // Fetch the latest data
                              await BlocProvider.of<DoctorHomeCubit>(
                                context,
                              ).fetchDoctor(doctorIdFromState);
                              final updatedState =
                                  BlocProvider.of<DoctorHomeCubit>(
                                    context,
                                  ).state;
                              Navigator.of(
                                context,
                              ).pop(); // Dismiss the loading indicator

                              // Show dialog to process the current queue from the newest state
                              if (updatedState is DoctorHomeLoaded) {
                                final queueNumber =
                                    updatedState.doctor.currentQueue?['number'];
                                final userId =
                                    updatedState
                                        .doctor
                                        .currentQueue?['session']['user_id'];
                                if (queueNumber != null && userId != null) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                          'Process Current Queue',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Queue Number: $queueNumber',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Patient ID: $userId',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.red,
                                              textStyle: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            onPressed:
                                                () =>
                                                    Navigator.of(context).pop(),
                                            child: const Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 12,
                                                    horizontal: 24,
                                                  ),
                                              textStyle: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Modular.to.pushNamed(
                                                '/doctor/diagnosis/$userId/$doctorIdFromState',
                                              );
                                            },
                                            child: const Text('Proceed'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                          'No Current Queue',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        content: const Text(
                                          'The doctor does not have a queue at the moment.',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        actions: [
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.blue,
                                              textStyle: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            onPressed:
                                                () =>
                                                    Navigator.of(context).pop(),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Failed to fetch the latest state',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              "Check Queue",
                            ), // Updated button text to "Check Queue"
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
