// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class PatientVitalsScreen extends StatelessWidget {
//   final String? patientId;

//   const PatientVitalsScreen({super.key, this.patientId});

//   @override
//   Widget build(BuildContext context) {
//     User? doctor = FirebaseAuth.instance.currentUser;

//     if (doctor == null) {
//       return const Center(child: Text("Doctor not logged in."));
//     }

//     // If patientId is provided, fetch only that patient's data
//     if (patientId != null) {
//       return Scaffold(
//         body: FutureBuilder<DataSnapshot>(
//           future: FirebaseDatabase.instance.ref('patients/$patientId').get(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (!snapshot.hasData || snapshot.data?.value == null) {
//               return const Center(child: Text("Patient data not found."));
//             }

//             Map<String, dynamic>? patientData;
//             try {
//               patientData = Map<String, dynamic>.from(
//                 snapshot.data!.value as Map,
//               );
//             } catch (e) {
//               return const Center(child: Text("Error parsing patient data."));
//             }

//             String patientName = patientData['name'] ?? "Unknown";

//             if (patientData['health_data'] == null) {
//               return Center(child: Text("$patientName - No vitals available"));
//             }

//             Map<String, dynamic> vitals = Map<String, dynamic>.from(
//               patientData['health_data'],
//             );
//             return Card(
//               margin: const EdgeInsets.all(16),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Name: $patientName",
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     Text("Heart Rate: ${vitals['heart_rate']} BPM"),
//                     Text("Temperature: ${vitals['temperature']} °C"),
//                     Text("SpO2: ${vitals['SpO2']}%"),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       );
//     }

//     // If no patientId, fetch all patients for the doctor
//     return Scaffold(
//       appBar: AppBar(title: const Text("Patient Vitals")),
//       body: FutureBuilder<DataSnapshot>(
//         future:
//             FirebaseDatabase.instance
//                 .ref('doctors/${doctor.uid}/patients')
//                 .get(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data?.value == null) {
//             return const Center(
//               child: Text("No patients found for this doctor."),
//             );
//           }

//           List<String> patientIds = List<String>.from(
//             (snapshot.data!.value as List?) ?? [],
//           );
//           if (patientIds.isEmpty) {
//             return const Center(
//               child: Text("No patients associated with this doctor."),
//             );
//           }

//           return ListView.builder(
//             itemCount: patientIds.length,
//             itemBuilder: (context, index) {
//               return FutureBuilder<DataSnapshot>(
//                 future:
//                     FirebaseDatabase.instance
//                         .ref('patients/${patientIds[index]}')
//                         .get(),
//                 builder: (context, patientSnapshot) {
//                   if (patientSnapshot.connectionState ==
//                       ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   if (!patientSnapshot.hasData ||
//                       patientSnapshot.data?.value == null) {
//                     return ListTile(
//                       title: Text(
//                         "Patient data not found for ID: ${patientIds[index]}",
//                       ),
//                     );
//                   }

//                   Map<String, dynamic>? patientData;
//                   try {
//                     patientData = Map<String, dynamic>.from(
//                       patientSnapshot.data!.value as Map,
//                     );
//                   } catch (e) {
//                     return ListTile(
//                       title: Text(
//                         "Error parsing patient data for ID: ${patientIds[index]}",
//                       ),
//                     );
//                   }

//                   String patientName = patientData['name'] ?? "Unknown";

//                   if (patientData['health_data'] == null) {
//                     return ListTile(
//                       title: Text("$patientName - No vitals available"),
//                     );
//                   }

//                   Map<String, dynamic> vitals = Map<String, dynamic>.from(
//                     patientData['health_data'],
//                   );
//                   return Card(
//                     margin: const EdgeInsets.all(8),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Name: $patientName",
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           Text("Heart Rate: ${vitals['heart_rate']} BPM"),
//                           Text("Temperature: ${vitals['temperature']} °C"),
//                           Text("SpO2: ${vitals['SpO2']}%"),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
