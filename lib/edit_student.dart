import 'package:flutter/material.dart';
import 'package:flutter_student_information/student_list.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'database_helper.dart';
import 'theme_provider.dart';

class AddEditStudentPage extends StatefulWidget {
  final Map<String, dynamic>? student;

  const AddEditStudentPage({Key? key, this.student}) : super(key: key);

  @override
  _AddEditStudentPageState createState() => _AddEditStudentPageState();
}

class _AddEditStudentPageState extends State<AddEditStudentPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final studentIDController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      nameController.text = widget.student!['name'] ?? '';
      studentIDController.text = widget.student!['studentID'].toString();
      phoneController.text = widget.student!['phone'] ?? '';
      emailController.text = widget.student!['email'] ?? '';
      locationController.text = widget.student!['location'] ?? '';
    }
  }

  Future<void> saveStudent() async {
    if (_formKey.currentState!.validate()) {
      final student = {
        'name': nameController.text,
        'studentID': studentIDController.text,
        'phone': phoneController.text,
        'email': emailController.text,
        'location': locationController.text,
      };

      if (widget.student == null) {
        try {
          await DatabaseHelper.instance.addStudent(student);
        } catch (e) {
          print('Error saving student: $e');
        }
      } else {
        student['id'] = widget.student!['id'].toString();
        try {
          await DatabaseHelper.instance.updateStudent(student);
          print('Update successful');
        } catch (e) {
          print('Error updating student: $e');
        }
      }

      Get.snackbar('Success', 'Student information saved successfully');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => StudentListPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student == null ? 'Add Student' : 'Edit Student'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Provider.of<ThemeProvider>(context).themeMode == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            buildStyledTextField(context, nameController, 'Full Name', Icons.person),
            const SizedBox(height: 15),
            buildStyledTextField(context, studentIDController, 'Student ID', Icons.badge),
            const SizedBox(height: 15),
            buildStyledTextField(context, phoneController, 'Phone', Icons.phone),
            const SizedBox(height: 15),
            buildStyledTextField(context, emailController, 'Email', Icons.email),
            const SizedBox(height: 15),
            buildStyledTextField(context, locationController, 'Location', Icons.location_on),
            const SizedBox(height: 20),
            buildSaveButton(context),
          ],
        ),
      ),
    );
  }

  Widget buildStyledTextField(BuildContext context, TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
      ),
    );
  }

  Widget buildSaveButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: saveStudent,
      child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 18)),
    );
  }
}
