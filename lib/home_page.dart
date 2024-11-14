import 'package:flutter/material.dart';
import 'package:flutter_student_information/theme_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'edit_student.dart';
import 'student_list.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Information'),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildStyledButton(
              context,
              'Add Student',
              onPressed: () => Get.to(() => AddEditStudentPage()),
            ),
            const SizedBox(height: 20),
            buildStyledButton(
              context,
              'View All Students',
              onPressed: () => Get.to(() => StudentListPage()),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStyledButton(BuildContext context, String text,
      {required VoidCallback onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
