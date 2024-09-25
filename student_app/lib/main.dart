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
        appBar: AppBar(title: const Text('List Of Enrollees')),
        body: FutureBuilder<List<Student>>(
          future: students,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: snapshot.data!
                    .map((student) => ListTile(
                          title:
                              Text('${student.firstName} ${student.lastName}'),
                          subtitle: Text(student.course),
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
                        ))
                    .toList(),
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text('No student records at the moment'));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const StudentDetailScreen()),
            );
            setState(() {
              students = apiService.getStudents();
            });
          },
          child: const Icon(Icons.add),
        ));
  }
}
