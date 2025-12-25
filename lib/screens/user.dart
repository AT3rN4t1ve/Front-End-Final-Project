import 'package:flutter/material.dart';
import 'package:frontmain/screens/main2.dart';
import 'package:frontmain/screens/editprofile.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<User> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5F2),
      appBar: AppBar(
        automaticallyImplyLeading: false, // ปิดการแสดงปุ่มกลับอัตโนมัติ
        backgroundColor: const Color(0xFFFF9800),
        elevation: 0,
      ),
      body: Column(
        children: [
          // ส่วนบน
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFFF9800),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: const [
                SizedBox(height: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      AssetImage('assets/images/pe.jpg'), // ใส่รูปภาพแทน
                  backgroundColor: Colors.white, // สีพื้นหลังขอบ
                ),
                SizedBox(height: 10),
                Text(
                  " สมชาย บุญมา",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),

          const SizedBox(height: 20),
          // รายละเอียดต่าง ๆ
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                ProfileField(
                  icon: Icons.person,
                  label: "สมชาย บุญมา",
                ),
                ProfileField(
                  icon: Icons.cake,
                  label: "4 มีนาคม 2487",
                ),
                ProfileField(
                  icon: Icons.scale,
                  label: "77 กิโลกรัม",
                ),
                ProfileField(
                  icon: Icons.straighten,
                  label: "170 เซนติเมตร",
                ),
                ProfileField(
                  icon: Icons.sentiment_very_dissatisfied,
                  label: "โรคประจำตัว : เบาหวาน",
                ),

                const SizedBox(height: 20),
                // ปุ่ม Edit Profile
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // ไปยังหน้า EditProfilePage เมื่อกดปุ่ม
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfilePage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: const Color(0xFFFF9800),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "แก้ไขโปร์ไฟล์",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), // ทำให้มุมซ้ายบนมน
          topRight: Radius.circular(20), // ทำให้มุมขวาบนมน
        ),
        child: Container(
          height: 60, // เพิ่มความสูงของแถบเมนูให้ใหญ่ขึ้น
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.arrow_back),
                label: '', // ลบข้อความออก
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '', // ลบข้อความออก
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: '', // ลบข้อความออก
              ),
            ],
            onTap: (index) {
              if (index == 0) {
                Navigator.pop(context); // ย้อนกลับ
              } else if (index == 1) {
                // ไปยังหน้า Main2 และไม่สามารถกลับไปหน้าเดิมได้
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Main2(),
                  ),
                );
              } else if (index == 2) {
                // ไม่ต้องเปิดหน้า ProfilePage อีกครั้ง เพราะคุณอยู่ในหน้านั้นแล้ว
              }
            },
            unselectedLabelStyle: const TextStyle(
              fontSize: 0, // ทำให้ข้อความไม่แสดง
            ),
            selectedLabelStyle: const TextStyle(
              fontSize: 0, // ทำให้ข้อความไม่แสดง
            ),
            iconSize: 35, // ขยายขนาดไอคอนให้ใหญ่ขึ้น
            backgroundColor: const Color(0xFFFF9800), // สีพื้นหลังของบาร์
            selectedItemColor: Colors.white, // สีของไอคอนที่ถูกเลือก
            unselectedItemColor:
                Colors.white.withOpacity(0.6), // สีของไอคอนที่ไม่ถูกเลือก
            type: BottomNavigationBarType
                .fixed, // ใช้แบบ Fixed เพื่อให้ไอคอนทั้งหมดแสดง
            elevation: 10, // เพิ่มเงาให้บาร์ดูเด่นขึ้น
          ),
        ),
      ),
    );
  }
}

class ProfileField extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPassword;

  const ProfileField({
    super.key,
    required this.icon,
    required this.label,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFF9800)),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          if (isPassword) const Icon(Icons.visibility, color: Colors.grey),
        ],
      ),
    );
  }
}
