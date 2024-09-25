const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const mongoose = require('./db');
const Student = require('./models/Student');

const app = express();
app.use(bodyParser.json());
app.use(cors());

// Create a new student
app.post('/students', async (req, res) => {
  const student = new Student(req.body);
  await student.save();
  res.send(student);
});

// Get all students
app.get('/students', async (req, res) => {
  const students = await Student.find();
  res.send(students);
});

// Get a student by ID
app.get('/students/:id', async (req, res) => {
  const student = await Student.findById(req.params.id);
  res.send(student);
});

// Update a student
app.put('/students/:id', async (req, res) => {
  const student = await Student.findByIdAndUpdate(req.params.id, req.body, {
    new: true,
  });
  res.send(student);
});

// Delete a student
app.delete('/students/:id', async (req, res) => {
  await Student.findByIdAndDelete(req.params.id);
  res.send({ message: 'Student deleted' });
});

app.listen(3000, () => {
  console.log('Server started on port 3000');
});