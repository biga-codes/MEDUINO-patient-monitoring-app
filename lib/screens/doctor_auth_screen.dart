import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'doctor_dashboard_screen.dart';

class DoctorAuthScreen extends StatefulWidget {
  const DoctorAuthScreen({super.key});

  @override
  _DoctorAuthScreenState createState() => _DoctorAuthScreenState();
}

class _DoctorAuthScreenState extends State<DoctorAuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = "";

  void signIn() async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const DoctorDashboardScreen()));
    } catch (e) {
      setState(() {
        errorMessage = "Login failed: ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Doctor Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            if (errorMessage.isNotEmpty)
              Text(errorMessage, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: signIn, child: const Text("Login"))
          ],
        ),
      ),
    );
  }
}
