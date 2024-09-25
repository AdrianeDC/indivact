const mongoose = require('mongoose');

mongoose.connect('mongodb://localhost:27017/studentdb')
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.error('MongoDB connection error:', err));

// Define Student schema
const studentSchema = new mongoose.Schema({
  firstName: String,
  lastName: String,
  course: String,
  year: String,
  enrolled: Boolean,
});

const Student = mongoose.model('Student', studentSchema);

// Fetch all students (optional for initial debugging)
async function fetchStudents() {
  const students = await Student.find();
  console.log(students);
}

fetchStudents();

module.exports = mongoose;
