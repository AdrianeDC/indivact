// student_detail.dart
import 'package:flutter/material.dart';
import 'models/student.dart';
import 'services/api_service.dart';

class StudentDetailScreen extends StatefulWidget {
  final String? studentId;

  const StudentDetailScreen({super.key, this.studentId});

  @override
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
      Student newStudent = Student(
        id: student?.id ?? '',
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        course: courseController.text,
        year: year,
        enrolled: enrolled,
      );

      try {
        if (isEditing) {
          await apiService.updateStudent(newStudent);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Student updated successfully')),
          );
        } else {
          await apiService.createStudent(newStudent);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Student created successfully')),
          );
        }
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save student: $e')),
        );
      }
    }
  }

  void deleteStudent() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Student'),
        content: const Text('Are you sure you want to delete this student?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await apiService.deleteStudent(student!.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Student deleted successfully')),
      );
      Navigator.pop(context);
    }
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
                  TextFormField(
                    controller: firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty ? 'Enter first name' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty ? 'Enter last name' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: courseController,
                    decoration: const InputDecoration(
                      labelText: 'Course',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty ? 'Enter course' : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: year,
                    items: [
                      'First Year',
                      'Second Year',
                      'Third Year',
                      'Fourth Year',
                      'Fifth Year'
                    ]
                        .map((label) => DropdownMenuItem(value: label, child: Text(label)))
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
                  SwitchListTile(
                    title: const Text('Enrolled'),
                    value: enrolled,
                    onChanged: (bool value) {
                      setState(() {
                        enrolled = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20), // Added spacing before buttons
                  ElevatedButton(
                    onPressed: saveStudent,
                    child: Text(isEditing ? 'Update' : 'Save'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // Rounded corners
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (isEditing)
                    ElevatedButton(
                      onPressed: deleteStudent,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0), // Rounded corners
                        ),
                      ),
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
