import 'package:flutter/material.dart';
import 'main2.dart'; // แทนที่ด้วยไฟล์หน้าหลักของคุณ
import 'user.dart'; // แทนที่ด้วยไฟล์หน้าผู้ใช้ของคุณ

class Edithistory1 extends StatefulWidget {
  const Edithistory1({super.key});

  @override
  _Edithistory1State createState() => _Edithistory1State();
}

class _Edithistory1State extends State<Edithistory1> {
  bool isChecked1 = false;
  bool isChecked2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5F2),
      appBar: AppBar(
        title: const Text(
          'แก้ไขการทานยา',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFFFF9800),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            // วันที่
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "19 กุมภาพันธ์ 2568",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            // กล่องข้อมูลยา
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First medication
                  Row(
                    children: const [
                      Text('เวลา :', style: TextStyle(fontSize: 18)),
                      SizedBox(width: 8),
                      Text('20:49 น.', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  CheckboxListTile(
                    title: const Text(
                      '1. aspirin EC',
                      style: TextStyle(fontSize: 18), // เพิ่มขนาดฟอนต์ตรงนี้
                    ),
                    value: isChecked1,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked1 = value ?? false;
                      });
                    },
                  ),

                  // Second medication
                  const SizedBox(height: 5),

                  CheckboxListTile(
                    title: const Text(
                      '2. Metformin TAB 500 MG',
                      style: TextStyle(fontSize: 18), // เพิ่มขนาดฟอนต์ตรงนี้
                    ),
                    value: isChecked2,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked2 = value ?? false;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ปุ่มบันทึก
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add functionality for saving the changes
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text(
                  'บันทึก',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),

      // แถบนำทางด้านล่าง
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
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
                MaterialPageRoute(
                  builder: (context) => const Main2(),
                ),
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
