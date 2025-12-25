import 'package:flutter/material.dart';
import 'package:frontmain/screens/time1.dart';

class TimePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5F2),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "19 : 00 น.",
              style: TextStyle(
                  fontSize: 46, fontWeight: FontWeight.bold), // ขนาดใหญ่ขึ้น
            ),
            SizedBox(height: 30), // เพิ่มระยะห่าง
            CircleAvatar(
              radius: 120, // เพิ่มขนาดรูป
              backgroundImage: AssetImage('assets/images/drug.jpg'),
            ),
            SizedBox(height: 30), // เพิ่มระยะห่าง
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9800),
                padding: EdgeInsets.symmetric(
                    horizontal: 50, vertical: 20), // ปรับขนาดปุ่ม
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // ปรับให้โค้งมนขึ้น
                ),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Time1Page()));
              },
              child: Text(
                "ตรวจสอบ",
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold), // ขนาดตัวหนังสือใหญ่ขึ้น
              ),
            ),
          ],
        ),
      ),
    );
  }
}
