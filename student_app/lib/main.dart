// main.dart
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'models/student.dart';
import 'services/api_service.dart';
import 'student_detail.dart';

void main() => runApp(const StudentApp());

class StudentApp extends StatelessWidget {
  const StudentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Student App',
      debugShowCheckedModeBanner: false,
      home: StudentListScreen(),
    );
  }
}

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  ApiService apiService = ApiService();
  late Future<List<Student>> students;

  @override
  void initState() {
    super.initState();
    students = apiService.getStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enrolled Students'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Student>>(
        future: students,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              padding: const EdgeInsets.all(8.0),
              children: snapshot.data!
                  .map((student) => Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          title: Text(
                            '${student.firstName} ${student.lastName}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            student.course,
                            style: const TextStyle(fontSize: 16),
                          ),
                          trailing: const Icon(Icons.arrow_forward),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    StudentDetailScreen(studentId: student.id),
                              ),
                            );
                            setState(() {
                              students = apiService.getStudents();
                            });
                          },
                        ),
                      ))
                  .toList(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('No student records at the moment'),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: TextButton(
  onPressed: () async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StudentDetailScreen()),
    );
    setState(() {
      students = apiService.getStudents();
    });
  },
  style: TextButton.styleFrom(
    backgroundColor: Colors.purple, // Optional: set background color
    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0), // Adjust padding as needed
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0), // Optional: set rounded corners
    ),
  ),
  child: const Text(
    'Add New Record', // The new button text
    style: TextStyle(
      fontSize: 16,
      color: Colors.white,
    ),
  ),
),
    );
  }
}
