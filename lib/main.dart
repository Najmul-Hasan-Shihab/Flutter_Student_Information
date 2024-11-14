import 'package:flutter/material.dart';
import 'package:flutter_student_information/edit_student.dart';
import 'package:flutter_student_information/splash_screen.dart';
import 'package:flutter_student_information/student_list.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return GetMaterialApp(
          title: 'Student Info Manager',
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          themeMode: themeProvider.themeMode,
          defaultTransition: Transition.fadeIn,
          initialRoute: '/',
          getPages: [
            GetPage(name: '/student_list', page: () => StudentListPage()),
            GetPage(name: '/edit_student', page: () => AddEditStudentPage()),
          ],
          home: SplashScreen(),
        );
      },
    );
  }
}
