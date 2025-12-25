import 'package:flutter/material.dart';
import 'package:frontmain/screens/home.dart'; // ไฟล์ HomeScreen.dart
import 'package:frontmain/screens/login.dart';
import 'screens/register.dart';
import 'screens/login.dart';
import 'screens/main2.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // เริ่มต้น locale data สำหรับภาษาไทย
  await initializeDateFormatting('th_TH', null);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedCare',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(), // หรือหน้าแรกของคุณ
      debugShowCheckedModeBanner: false,
    );
  }
}
