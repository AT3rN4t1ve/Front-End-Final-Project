import 'package:flutter/material.dart';
import 'package:frontmain/screens/history3.dart';
import 'package:frontmain/screens/main2.dart'; // หน้าหลัก
import 'package:frontmain/screens/user.dart'; // หน้าโปรไฟล์
import 'package:frontmain/screens/history1.dart';
import 'package:frontmain/screens/history2.dart';
import 'package:flutter/material.dart';
import 'package:frontmain/screens/main2.dart';
import 'package:frontmain/screens/user.dart';
import 'package:frontmain/screens/drugDetails.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5F2), //
      appBar: AppBar(
        title: const Text(
          'ประวัติการทานยา',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFFFF9800),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // รายการประวัติยา
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(left: 25, right: 15),
              children: [
                HistoryItem(date: "17 กุมภาพันธ์ 2567", context: context),
                HistoryItem(date: "18 กุมภาพันธ์ 2567", context: context),
                HistoryItem(date: "19 กุมภาพันธ์ 2567", context: context),
                HistoryItem(date: "20 กุมภาพันธ์ 2567", context: context),
                HistoryItem(date: "21 กุมภาพันธ์ 2567", context: context),
                HistoryItem(date: "22 กุมภาพันธ์ 2567", context: context),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context), // ✅ แถบด้านล่าง
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
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
              Navigator.pop(context);
            } else if (index == 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Main2()),
              );
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const User()),
              );
            }
          },
          unselectedLabelStyle: const TextStyle(fontSize: 0),
          selectedLabelStyle: const TextStyle(fontSize: 0),
          iconSize: 35,
          backgroundColor: const Color(0xFFFF9800),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.6),
          type: BottomNavigationBarType.fixed,
          elevation: 10,
        ),
      ),
    );
  }
}

// ✅ Widget แสดงรายการประวัติการทานยา
class HistoryItem extends StatelessWidget {
  final String date;
  final BuildContext context;

  const HistoryItem({super.key, required this.date, required this.context});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (date == "17 กุมภาพันธ์ 2567") {
          // ✅ กดแล้วเปิดหน้า History1
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const History1()),
          );
        } else if (date == "18 กุมภาพันธ์ 2567") {
          // ✅ กดแล้วเปิดหน้า History2
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const History2()),
          );
        } else if (date == "19 กุมภาพันธ์ 2567") {
          // ✅ กดแล้วเปิดหน้า History2
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const History3()),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12, width: 1)),
          color: Colors.white, // ✅ พื้นหลังรายการเป็นสีขาว
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(date, style: const TextStyle(fontSize: 18)),
            const Icon(Icons.medication,
                size: 30, color: Colors.red), // ✅ ไอคอนยา
          ],
        ),
      ),
    );
  }
}
