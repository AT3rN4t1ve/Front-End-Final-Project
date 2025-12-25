import 'package:flutter/material.dart';
import 'package:frontmain/screens/main2.dart';
import 'package:frontmain/screens/user.dart';

class History2 extends StatelessWidget {
  const History2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5F2),
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(height: 50),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "18 กุมภาพันธ์ 2567",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      children: [
                        TextSpan(text: "เวลา : "),
                        TextSpan(
                          text: "11:36 น.",
                          style: TextStyle(color: Colors.orangeAccent),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      children: [
                        TextSpan(text: "ความถี่ : "),
                        TextSpan(
                          text: "ทุกวัน",
                          style: TextStyle(color: Colors.orangeAccent),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.orange),
                  // ใส่ไว้ให้พร้อมสำหรับการดึงข้อมูล
                  const MedicineItem(
                    name: "", // ไม่มีข้อมูลยา
                    amount: "", // ไม่มีข้อมูลจำนวน
                    note: "", // ไม่มีข้อมูลเวลาทาน
                    properties: "", // ไม่มีข้อมูลสรรพคุณ
                    name2: "", // ข้อมูลยา 2 ว่าง
                    amount2: "", // ข้อมูลจำนวนยา 2 ว่าง
                    note2: "", // ข้อมูลเวลาทานยา 2 ว่าง
                    properties2: "", // ข้อมูลสรรพคุณยา 2 ว่าง
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
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

class MedicineItem extends StatelessWidget {
  final String name;
  final String amount;
  final String note;
  final String properties;
  final String name2; // เพิ่มข้อมูลยา 2
  final String amount2; // เพิ่มจำนวนเม็ดยา 2
  final String note2; // เพิ่มเวลาทานยา 2
  final String properties2; // เพิ่มสรรพคุณยา 2

  const MedicineItem({
    super.key,
    required this.name,
    required this.amount,
    required this.note,
    required this.properties,
    required this.name2, // รับข้อมูลยา 2
    required this.amount2, // รับจำนวนยา 2
    required this.note2, // รับเวลาทานยา 2
    required this.properties2, // รับสรรพคุณยา 2
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ข้อมูลยา 1 (ไม่มีข้อมูล)
          Text("ชื่อยา: $name", style: const TextStyle(fontSize: 18)),
          Text("จำนวนเม็ด: $amount", style: const TextStyle(fontSize: 18)),
          Text("ทานเมื่อ: $note", style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 5),
          Text("สรรพคุณของยา: $properties",
              style: const TextStyle(fontSize: 18)),

          const SizedBox(height: 20), // เพิ่มระยะห่างระหว่างยา 1 และยา 2

          // ข้อมูลยา 2 (ไม่มีข้อมูล)
          Text("ชื่อยา: $name2", style: const TextStyle(fontSize: 18)),
          Text("จำนวนเม็ด: $amount2", style: const TextStyle(fontSize: 18)),
          Text("ทานเมื่อ: $note2", style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 5),
          Text("สรรพคุณของยา: $properties2",
              style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
