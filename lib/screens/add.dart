import 'package:flutter/material.dart';
import 'package:frontmain/screens/edit.dart'; // นำเข้าหน้า edit
import 'package:frontmain/screens/history.dart';
import 'package:frontmain/screens/notification.dart';
import 'package:frontmain/screens/user.dart';
import 'package:frontmain/screens/scan_medicine.dart';

class Main2 extends StatelessWidget {
  const Main2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5F2),
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable automatic back button
        backgroundColor: Color(0xFFFF9800),
        elevation: 0, // No shadow for smooth transition
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF9800),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(height: 4),
                      Text(
                        "Hello",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Welcome to MedCare",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Editpage(), // แก้ไขจาก Addpage เป็น Editpage
                          ),
                        );
                      },
                      child: _buildTaskCard(
                        context,
                        "เพิ่มข้อมูลยา",
                        "จัดการข้อมูลยา",
                        Icons.add,
                        Colors.purple,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // เพิ่มการ์ดสแกนซองยา
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ScanMedicinePage(),
                          ),
                        );
                      },
                      child: _buildTaskCard(
                        context,
                        "สแกนซองยา",
                        "วิเคราะห์ข้อมูลจากซองยา",
                        Icons.document_scanner,
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationPage(),
                          ),
                        );
                      },
                      child: _buildTaskCard(
                        context,
                        "รายงานแจ้งเตือน",
                        "ดูแจ้งเตือนที่สำคัญ",
                        Icons.notifications,
                        Colors.redAccent,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HistoryPage(),
                          ),
                        );
                      },
                      child: _buildTaskCard(
                        context,
                        "ประวัติการทานยา",
                        "ดูบันทึกการทานยา",
                        Icons.history,
                        Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Container(
                height: 60,
                child: BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.arrow_back),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.account_circle),
                      label: '',
                    ),
                  ],
                  onTap: (index) {
                    if (index == 0) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Main2()),
                      );
                    } else if (index == 1) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Main2()),
                      );
                    } else if (index == 2) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const User(),
                        ),
                      );
                    }
                  },
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 0,
                  ),
                  selectedLabelStyle: const TextStyle(
                    fontSize: 0,
                  ),
                  iconSize: 35,
                  backgroundColor: const Color(0xFFFF9800),
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.white.withOpacity(0.6),
                  type: BottomNavigationBarType.fixed,
                  elevation: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, String title, String subtitle,
      IconData icon, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}