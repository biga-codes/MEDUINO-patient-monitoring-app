import 'package:flutter/material.dart';
// import 'patient_vitals_screen.dart';
import 'patient_logs_screen.dart';
import 'search_info_screen.dart';

class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  _DoctorDashboardScreenState createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    // const PatientVitalsScreen(),
    const PatientLogsScreen(),
    const SearchInfoScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 99, 121, 227),
      appBar: AppBar(
        title: const Text("Doctor Dashboard"),
        backgroundColor: const Color.fromARGB(255, 104, 160, 229),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          // BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Patients"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Logs"),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Patient Search and Info",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
