const mongoose = require('mongoose');

const StudentSchema = new mongoose.Schema({
  firstName: String,
  lastName: String,
  course: String,
  year: String,
  enrolled: Boolean,
});

// Check if the model already exists; if so, use it, otherwise create it
module.exports = mongoose.models.Student || mongoose.model('Student', StudentSchema);
