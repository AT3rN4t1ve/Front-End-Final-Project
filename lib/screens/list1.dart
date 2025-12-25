import 'package:flutter/material.dart';
import 'package:frontmain/screens/main2.dart'; // อย่าลืม import หน้าหลักถ้าใช้
import 'package:frontmain/screens/user.dart';

class Listnoti1Page extends StatefulWidget {
  const Listnoti1Page(
      {super.key}); // แก้ชื่อจาก ListnotiPage เป็น Listnoti1Page

  @override
  State<Listnoti1Page> createState() => _Listnoti1PageState();
}

class _Listnoti1PageState extends State<Listnoti1Page> {
  // สร้าง TextEditingController สำหรับแต่ละฟิลด์
  final TextEditingController medicineNameController = TextEditingController();
  final TextEditingController pillCountController = TextEditingController();
  final TextEditingController drugUsesController = TextEditingController();
  final TextEditingController intakeTimeController = TextEditingController();

  // Add FocusNode to control focus
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5F2), // เปลี่ยนพื้นหลัง
      appBar: AppBar(
        title: const Text(
          'รายละเอียดยาที่ต้องทาน',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Color(0xFFFF9800),
        automaticallyImplyLeading: false,
      ),
      body: GestureDetector(
        onTap: () {
          // Dismiss the keyboard when tapping outside the TextField
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ListView(
            children: [
              SizedBox(height: 50),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProfileField(
                            controller: medicineNameController,
                            label: "ชื่อยา",
                            focusNode: focusNode,
                          ),
                          const SizedBox(height: 10),
                          ProfileField(
                            controller: pillCountController,
                            label: "จำนวนเม็ด",
                            focusNode: focusNode,
                          ),
                          const SizedBox(height: 10),
                          ProfileField(
                            controller: drugUsesController,
                            label: "เวลาในการทาน",
                            focusNode: focusNode,
                          ),
                          const SizedBox(height: 10),
                          ProfileField(
                            controller: intakeTimeController,
                            label: "สรรพคุณของยา",
                            focusNode: focusNode,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ClipRRect(
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
      ),
    );
  }
}

class ProfileField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final FocusNode focusNode;

  const ProfileField({
    super.key,
    required this.controller,
    required this.label,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: true, // Makes the TextField non-editable
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        isDense: true,
      ),
    );
  }
}
