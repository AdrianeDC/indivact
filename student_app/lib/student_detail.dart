// Updated student_detail.dart

import 'package:flutter/material.dart';
import 'models/student.dart';
import 'services/api_service.dart';

class StudentDetailScreen extends StatefulWidget {
  final String? studentId;

  const StudentDetailScreen({super.key, this.studentId});

  @override
  // ignore: library_private_types_in_public_api
  _StudentDetailScreenState createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  late bool isEditing;
  Student? student;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController courseController = TextEditingController();
  String year = 'First Year';
  bool enrolled = false;

  @override
  void initState() {
    super.initState();
    isEditing = widget.studentId != null;
    if (isEditing) {
      apiService.getStudentById(widget.studentId!).then((value) {
        setState(() {
          student = value;
          firstNameController.text = student!.firstName;
          lastNameController.text = student!.lastName;
          courseController.text = student!.course;
          year = student!.year;
          enrolled = student!.enrolled;
        });
      });
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    courseController.dispose();
    super.dispose();
  }

  void saveStudent() async {
  if (_formKey.currentState!.validate()) {
    // Create a new Student instance with the provided data
    Student newStudent = Student(
      id: student?.id ?? '',
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      course: courseController.text,
      year: year,
      enrolled: enrolled,
    );

    try {
      // Attempt to save the student
      if (isEditing) {
        await apiService.updateStudent(newStudent);
        print('Student updated: ${newStudent.toJson()}');
      } else {
        await apiService.createStudent(newStudent);
        print('Student created: ${newStudent.toJson()}');
      }
      // Navigate back to the previous screen
      Navigator.pop(context);
    } catch (e) {
      print('Error saving student: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save student: $e')),
      );
    }
  } else {
    print('Form is not valid');
  }
}
  void deleteStudent() async {
    await apiService.deleteStudent(student!.id);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (isEditing && student == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Student' : 'Add Student'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  // First Name
                  TextFormField(
                    controller: firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter first name' : null,
                  ),
                  const SizedBox(height: 12),
                  // Last Name
                  TextFormField(
                    controller: lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty ? 'Enter last name' : null,
                  ),
                  const SizedBox(height: 12),
                  // Course
                  TextFormField(
                    controller: courseController,
                    decoration: const InputDecoration(
                      labelText: 'Course',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty ? 'Enter course' : null,
                  ),
                  const SizedBox(height: 12),
                  // Year Dropdown
                  DropdownButtonFormField<String>(
                    value: year,
                    items: [
                      'First Year',
                      'Second Year',
                      'Third Year',
                      'Fourth Year',
                      'Fifth Year'
                    ]
                        .map((label) =>
                            DropdownMenuItem(value: label, child: Text(label)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        year = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Year',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Enrolled Switch
                  SwitchListTile(
                    title: const Text('Enrolled'),
                    value: enrolled,
                    onChanged: (bool value) {
                      setState(() {
                        enrolled = value;
                      });
                    },
                  ),
                  // Save Button
                  ElevatedButton(
                    onPressed: saveStudent,
                    child: Text(isEditing ? 'Update' : 'Save'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  ),
                  // Delete Button (only in edit mode)
                  if (isEditing)
                    ElevatedButton(
                      onPressed: deleteStudent,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Delete'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
