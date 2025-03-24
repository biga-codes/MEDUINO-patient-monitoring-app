import 'package:flutter/material.dart';
import 'doctor_auth_screen.dart';
import 'patient_auth_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PatientAuthScreen()),
                );
              },
              child: const Text("Login as Patient"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DoctorAuthScreen()),
                );
              },
              child: const Text("Login as Doctor"),
            ),
          ],
        ),
      ),
    );
  }
}
