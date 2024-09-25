import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student.dart';

class ApiService {
  final String apiUrl = 'http://localhost:3000/students';

  Future<List<Student>> getStudents() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((student) => Student.fromJson(student)).toList();
    } else {
      throw Exception('Failed to load students: ${response.body}');
    }
  }

  Future<Student> getStudentById(String id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));
    if (response.statusCode == 200) {
      return Student.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load student: ${response.body}');
    }
  }

  Future<Student> createStudent(Student student) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(student.toJson()),
    );
    
    if (response.statusCode == 201) { // Successful creation
      return Student.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create student: ${response.body}');
    }
  }

  Future<Student> updateStudent(Student student) async {
    final response = await http.put(
      Uri.parse('$apiUrl/${student.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(student.toJson()),
    );

    if (response.statusCode == 200) { // Successful update
      return Student.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update student: ${response.body}');
    }
  }

  Future<void> deleteStudent(String id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));
    if (response.statusCode != 204) { // Successful deletion (204 No Content)
      throw Exception('Failed to delete student: ${response.body}');
    }
  }
}
