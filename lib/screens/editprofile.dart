import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:frontmain/screens/main2.dart'; // นำเข้า Main2 ไปที่นี่ถ้าต้องการใช้
import 'package:frontmain/screens/user.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _diseaseController =
      TextEditingController(); // เพิ่ม Controller สำหรับโรคประจำตัว

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  // ฟังก์ชันเพื่อเลือกภาพจากแกลเลอรี่หรือกล้อง
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _diseaseController.dispose(); // เพิ่มการ dispose สำหรับโรคประจำตัว
    super.dispose();
  }

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
            // ส่วนบนที่มีโปรไฟล์และพื้นหลังเหมือนใน ProfilePage
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
                children: [
                  const SizedBox(
                      height: 20), // เพิ่มความสูงระหว่างแถบด้านบนและโปรไฟล์
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : const AssetImage('assets/images/pe.jpg')
                                  as ImageProvider,
                          backgroundColor: Colors.white,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: const Icon(
                                Icons.camera_alt,
                                size: 15,
                                color: Color(0xFFFF9800),
                              ),
                              onPressed: _pickImage,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                  // ตั้งชื่อในโปรไฟล์
                  const Text(
                    "สมชาย บุญมา",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            const SizedBox(height: 20), // เพิ่มพื้นที่ระหว่างภาพโปรไฟล์และฟอร์ม

            // ฟอร์มสำหรับกรอกข้อมูล
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "ชื่อ",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: _dobController,
                    decoration: const InputDecoration(
                      labelText: "วันเกิด",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.cake),
                    ),
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: _weightController,
                    decoration: const InputDecoration(
                      labelText: "น้ำหนัก(kg)",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.scale),
                    ),
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: _heightController,
                    decoration: const InputDecoration(
                      labelText: "ส่วนสูง (cm)",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.straighten),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ฟอร์มสำหรับโรคประจำตัว
                  TextFormField(
                    controller: _diseaseController,
                    decoration: const InputDecoration(
                      labelText: "โรคประจำตัว",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons
                          .sentiment_very_dissatisfied), // ใช้ไอคอนที่เหมาะสม
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ปุ่มบันทึกข้อมูล
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // บันทึกข้อมูลที่แก้ไข
                        final name = _nameController.text;
                        final dob = _dobController.text;
                        final weight = _weightController.text;
                        final height = _heightController.text;
                        final disease = _diseaseController.text;

                        // คุณสามารถใช้ข้อมูลเหล่านี้เพื่อบันทึกหรืออัพเดตข้อมูลโปรไฟล์ของผู้ใช้ในฐานข้อมูล
                        print(
                            "Name: $name, DOB: $dob, Weight: $weight, Height: $height, Disease: $disease");

                        // ปิดหน้าหลังจากบันทึกข้อมูล
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: const Color(0xFFFF9800),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "บันทึก",
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
            topLeft: Radius.circular(20), // มุมซ้ายบน
            topRight: Radius.circular(20), // มุมขวาบน
          ),
          child: Container(
            height: 60, // ความสูงของแถบเมนู
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Main2()), // ไปยังหน้าหลัก
                  );
                } else if (index == 2) {
                  // เปิดหน้าโปรไฟล์
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const User(), // ชื่อหน้าโปรไฟล์
                    ),
                  );
                }
              },
              unselectedLabelStyle: const TextStyle(
                fontSize: 0, // ทำให้ข้อความไม่แสดง
              ),
              selectedLabelStyle: const TextStyle(
                fontSize: 0, // ทำให้ข้อความไม่แสดง
              ),
              iconSize: 35, // ขยายขนาดไอคอนให้ใหญ่ขึ้น
              backgroundColor:
                  const Color(0xFFFF9800), // เปลี่ยนสีพื้นหลังของบาร์
              selectedItemColor: Colors.white, // สีของไอคอนที่ถูกเลือก
              unselectedItemColor:
                  Colors.white.withOpacity(0.6), // สีของไอคอนที่ไม่ถูกเลือก
              type: BottomNavigationBarType
                  .fixed, // ใช้แบบ Fixed เพื่อให้ไอคอนทั้งหมดแสดง
              elevation: 10, // เพิ่มเงาให้บาร์ดูเด่นขึ้น
            ),
          ),
        ));
  }
}
