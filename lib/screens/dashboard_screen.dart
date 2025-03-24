import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  User? user;
  Map<String, dynamic>? healthData;
  Map<String, dynamic>? patientInfo;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    if (user != null) {
      fetchPatientInfo();
      fetchHealthData();
    }
  }

  void fetchHealthData() {
    _dbRef
        .child("patients")
        .child(user!.uid)
        .child("health_data")
        .onValue
        .listen((event) {
          if (event.snapshot.value != null) {
            setState(() {
              healthData = Map<String, dynamic>.from(
                event.snapshot.value as Map,
              );
            });
          }
        });
  }

  Future<void> fetchPatientInfo() async {
    final snapshot = await _dbRef.child("patients").child(user!.uid).get();
    if (snapshot.exists) {
      setState(() {
        patientInfo = Map<String, dynamic>.from(snapshot.value as Map);
      });
    }
  }

  int calculateAge() {
    if (patientInfo == null || patientInfo!['dob'] == null) return 0;
    DateTime birthDate = DateFormat("yyyy-MM-dd").parse(patientInfo!['dob']);
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Widget buildHealthCheck() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Health Check",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          SizedBox(height: 15),
          buildStatusRow(
            "SpO₂ (Oxygen Saturation)",
            "${healthData?['SpO2'] ?? 'N/A'}%",
            "95 - 100%",
          ),
          buildStatusRow(
            "Heart Rate",
            "${healthData?['heart_rate'] ?? 'N/A'} BPM",
            "60 - 100 BPM",
          ),
          buildStatusRow(
            "Body Temperature",
            "${healthData?['temperature'] ?? 'N/A'}°C",
            "36.1 - 37.2°C",
          ),
        ],
      ),
    );
  }

  Widget buildPatientInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Patient Information",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          SizedBox(height: 15),

          buildInfoRow("Name", patientInfo?['name'] ?? 'N/A'),
          buildInfoRow(
            "Age",
            patientInfo != null ? "${calculateAge()} years" : 'N/A',
          ),
          buildInfoRow("Sex", patientInfo?['sex'] ?? 'N/A'),
          buildInfoRow("Weight", "${patientInfo?['weight'] ?? 'N/A'} kg"),
          buildInfoRow("Height", "${patientInfo?['height'] ?? 'N/A'} cm"),
          buildInfoRow("Blood Type", patientInfo?['blood_type'] ?? 'N/A'),
          buildInfoRow(
            "Fitness Level",
            formatFitnessLevel(patientInfo?['fitness_level'] ?? 'N/A'),
          ),
        ],
      ),
    );
  }

  Widget buildLogs() {
    return StreamBuilder(
      stream: _dbRef.child("patients").child(user!.uid).child("logs").onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
          return Center(child: Text("No previous logs found"));
        }

        var rawData = snapshot.data!.snapshot.value;
        print("Raw Data: $rawData");

        if (rawData is! Map) {
          return Center(child: Text("Unexpected data format"));
        }

        Map<dynamic, dynamic> logs = rawData;
        if (logs.isEmpty) {
          return Center(child: Text("No previous logs found"));
        }

        List<Map<String, dynamic>> logList =
            logs.entries.map((entry) {
              var log = Map<String, dynamic>.from(entry.value);

              return {
                "timestamp": int.tryParse(log['timestamp'].toString()) ?? 0,
                "heart_rate": int.tryParse(log['heart_rate'].toString()) ?? 0,
                "temperature":
                    double.tryParse(log['temperature'].toString()) ?? 0.0,
                "SpO2": int.tryParse(log['SpO2'].toString()) ?? 0,
                "issues_detected": List<String>.from(
                  log['issues_detected'] ?? [],
                ), // ✅ Ensure it's a List<String>
              };
            }).toList();

        // Sorting logs by timestamp (newest first)
        logList.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: logList.length,
          itemBuilder: (context, index) {
            var log = logList[index];

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              color: Colors.red.shade50,
              child: ListTile(
                title: Text(
                  "⚠️ Abnormal Vitals Detected",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "🕒 Date: ${DateTime.fromMillisecondsSinceEpoch(log['timestamp'])}",
                    ),
                    Divider(color: Colors.red.shade300),
                    Text("❤️ Heart Rate: ${log['heart_rate']} BPM"),
                    Text("🌡 Temperature: ${log['temperature']}°C"),
                    Text("🩸 SpO₂: ${log['SpO2']}%"),
                    Text(
                      "🚨 Issues Detected:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          log['issues_detected']
                              .map<Widget>(
                                (issue) => Text(
                                  "• $issue",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildStatusRow(String title, String actualValue, String range) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 238, 241, 240),
          ),
        ),
        SizedBox(height: 5),
        Text(
          "Current: $actualValue",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: const Color.fromARGB(221, 248, 246, 246),
          ),
        ),
        Text(
          "Ideal Range: $range",
          style: TextStyle(
            fontSize: 16,
            color: const Color.fromARGB(255, 244, 244, 244),
          ),
        ),
        Divider(
          color: const Color.fromARGB(255, 89, 150, 220).withOpacity(0.3),
        ),
      ],
    );
  }

  Widget buildInfoRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        "$title: $value",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: const Color.fromARGB(221, 252, 251, 251),
        ),
      ),
    );
  }

  String formatFitnessLevel(String level) {
    switch (level) {
      case "sedentary":
        return "Sedentary";
      case "active":
        return "Active";
      case "very_active":
        return "Very Active";
      case "athlete":
        return "Athlete";
      default:
        return "Unknown";
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: Text("Health Dashboard"),
        backgroundColor: const Color.fromARGB(255, 125, 178, 247),
      ),
      body:
          _selectedIndex == 0
              ? buildHealthCheck()
              : _selectedIndex == 1
              ? buildPatientInfo()
              : buildLogs(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Health Check",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Patient Info",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Logs"),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
