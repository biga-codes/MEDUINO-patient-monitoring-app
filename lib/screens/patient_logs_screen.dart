import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PatientLogsScreen extends StatelessWidget {
  const PatientLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? doctor = FirebaseAuth.instance.currentUser;

    if (doctor == null) {
      return const Center(child: Text("Doctor not logged in."));
    }

    return Scaffold(
      body: FutureBuilder<DataSnapshot>(
        future:
            FirebaseDatabase.instance
                .ref('doctors/${doctor.uid}/patients')
                .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data?.value == null) {
            return const Center(
              child: Text("No patients found for this doctor."),
            );
          }

          List<String> patientIds = [];
          if (snapshot.data!.value is List) {
            patientIds = List<String>.from(snapshot.data!.value as List);
          } else if (snapshot.data!.value is Map) {
            patientIds =
                (snapshot.data!.value as Map<Object?, Object?>).values
                    .cast<String>()
                    .toList();
          } else {
            return const Center(child: Text("Invalid patient data format."));
          }

          return FutureBuilder<List<Map<String, dynamic>>>(
            future: _fetchAllPatientLogs(patientIds),
            builder: (context, logsSnapshot) {
              if (logsSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!logsSnapshot.hasData || logsSnapshot.data!.isEmpty) {
                return const Center(
                  child: Text("No logs found for any patients."),
                );
              }

              // Sort all logs by timestamp in descending order
              final logs = logsSnapshot.data!;
              logs.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

              return ListView.builder(
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[index];
                  DateTime time = DateTime.fromMillisecondsSinceEpoch(
                    log['timestamp'],
                  );
                  List<dynamic> issues = log['issues_detected'] ?? [];
                  String patientName = log['patient_name'] ?? "Unknown";

                  return Card(
                    margin: const EdgeInsets.all(8),
                    color: Colors.red[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Patient: $patientName",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text("Heart Rate: ${log['heart_rate']} BPM"),
                          Text("Temperature: ${log['temperature']} °C"),
                          Text("SpO2: ${log['SpO2']}%"),
                          Text("Time: $time"),
                          Text("Contact Details: 991-111-234"),
                          if (issues.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "⚠ Issues Detected:",
                                  style: TextStyle(color: Colors.red),
                                ),
                                ...issues.map<Widget>(
                                  (issue) => Text(" - ⚠ $issue"),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchAllPatientLogs(
    List<String> patientIds,
  ) async {
    List<Map<String, dynamic>> allLogs = [];

    for (String patientId in patientIds) {
      DataSnapshot patientSnapshot =
          await FirebaseDatabase.instance.ref('patients/$patientId').get();
      if (patientSnapshot.exists) {
        final patientData =
            (patientSnapshot.value as Map<Object?, Object?>)
                .cast<String, dynamic>();
        String patientName = patientData['name'] ?? "Unknown";

        if (patientData['logs'] != null) {
          final logs =
              (patientData['logs'] as Map<Object?, Object?>)
                  .cast<String, dynamic>();
          logs.forEach((key, value) {
            final logData =
                (value as Map<Object?, Object?>).cast<String, dynamic>();
            logData['timestamp'] = int.parse(logData['timestamp'].toString());
            logData['patient_name'] = patientName;
            allLogs.add(logData);
          });
        }
      }
    }

    return allLogs;
  }
}
