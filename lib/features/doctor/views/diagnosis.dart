import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:triana_web/features/doctor/cubit/doctor_diagnosis_cubit.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:triana_web/features/doctor/cubit/doctor_home_cubit.dart';

class DoctorDiagnosisView extends StatefulWidget {
  const DoctorDiagnosisView({super.key});

  @override
  State<DoctorDiagnosisView> createState() => _DoctorDiagnosisViewState();
}

class _DoctorDiagnosisViewState extends State<DoctorDiagnosisView> {
  final TextEditingController _diagnosisController = TextEditingController();

  void _finishAppointment(String sessionId, String doctorId) async {
    final diagnosis = _diagnosisController.text;
    if (diagnosis.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Diagnosis cannot be empty")),
      );
      return;
    }

    final Dio dio = Dio();

    // Call the API to finish the appointment
    try {
      final response = await dio.post(
        'https://apidev-triana.sportsnow.app/session/$sessionId/diagnose',
        data: {"diagnosis": diagnosis},
      );

      if (response.statusCode == 200 && doctorId.isNotEmpty) {
        // Show success pop-up
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Success"),
              content: const Text("Appointment finished successfully."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Modular.to.pushNamedAndRemoveUntil(
                      '/doctor/${Modular.args.params['doctorId']}', // Navigate back to the doctor page with the doctorId
                      (route) => false, // Clear the navigation stack
                    );
                    Modular.get<DoctorHomeCubit>().fetchDoctor(
                      Modular.args.params['doctorId'],
                    ); // Refresh data on the doctor page
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        print(response.data);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to finish appointment")),
        );
        return;
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to finish appointment")),
      );
      return;
    }
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
                'Doctor Diagnosis',
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
      body: BlocBuilder<DoctorDiagnosisCubit, DoctorDiagnosisState>(
        builder: (context, state) {
          if (state is DoctorDiagnosisLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DoctorDiagnosisLoaded) {
            return Stack(
              children: [
                Padding(
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
                            const Text("Patient's data"),

                            const SizedBox(height: 8),
                            const Text(
                              "Queue Number",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '#${state.diagnosis.currentSession["queue"]["number"]}'
                                  .toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 8),
                            Text(
                              "Name",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${state.diagnosis.user["name"]}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Wrap grid-like summary
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                _infoCard(
                                  "Sex",
                                  state.diagnosis.user["gender"],
                                ),
                                _infoCard(
                                  "Age",
                                  RegExp(r'(\d+)\s+years')
                                          .firstMatch(
                                            state.diagnosis.user["age"],
                                          )
                                          ?.group(0) ??
                                      '',
                                ),
                                _infoCard(
                                  "Weight",
                                  "${state.diagnosis.currentSession["weight"].toString()} kg",
                                ),
                                _infoCard(
                                  "Height",
                                  "${state.diagnosis.currentSession["height"].toString()} cm",
                                ),
                                _infoCard(
                                  "Heart Rate",
                                  "${state.diagnosis.currentSession["heartrate"].toString()} BPM",
                                ),
                                _infoCard(
                                  "Temperature",
                                  "${state.diagnosis.currentSession["bodytemp"].toString()} °C",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      Container(
                        padding: EdgeInsets.all(16),
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
                            const Text("Prediagnosis"),
                            const SizedBox(height: 8),
                            Text(
                              state.diagnosis.currentSession["prediagnosis"],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      if (state.diagnosis.historySession.isEmpty)
                        const Center(child: Text("No previous records"))
                      else ...[
                        Container(
                          padding: EdgeInsets.all(16),
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
                                "Previous Records",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Expanded(
                                    child: Text(
                                      "Date",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Weight",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Height",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Heart Rate",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Temp",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(thickness: 1),
                              ...state.diagnosis.historySession.map((record) {
                                return ExpansionTile(
                                  tilePadding: EdgeInsets.zero,
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          DateFormat('d MMMM yyyy').format(
                                            DateTime.parse(
                                              record['created_at'],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          record['weight'].toString(),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          record['height'].toString(),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          record['heartrate'].toString(),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          record['bodytemp'].toString(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                        vertical: 8.0,
                                      ),
                                      child: Text(record['prediagnosis'] ?? ''),
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 16),

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
                            const Text("Diagnosis"),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _diagnosisController,
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 32,
                          ),
                        ),
                        onPressed: () {
                          _finishAppointment(
                            state
                                .diagnosis
                                .currentSession["queue"]["session_id"]
                                .toString(),
                            Modular.args.params['doctorId'],
                          );
                        },
                        child: const Text("Finish"),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is DoctorDiagnosisError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}

Widget _infoCard(String label, String value) {
  return Container(
    width: 150,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}
