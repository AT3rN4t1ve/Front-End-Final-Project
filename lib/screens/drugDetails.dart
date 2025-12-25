import 'package:flutter/material.dart';
import 'package:frontmain/screens/main2.dart';
import 'package:frontmain/screens/user.dart';
import 'package:frontmain/models/medicine_record.dart';
import 'package:frontmain/screens/notification.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DrugDetailspage extends StatefulWidget {
  final MedicineRecord medicineData;

  const DrugDetailspage({
    Key? key,
    required this.medicineData,
  }) : super(key: key);

  @override
  State<DrugDetailspage> createState() => _DrugDetailspageState();
}

class _DrugDetailspageState extends State<DrugDetailspage> {
  bool _isLoading = false;
  static const String baseUrl = 'http://192.168.1.7:5000/api';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5F2),
      appBar: AppBar(
        title: const Text(
          'รายละเอียดยาที่ต้องทาน',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFFFF9800),
        automaticallyImplyLeading: false,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildRichText("ชื่อยา :", "${widget.medicineData.name}"),
                            const SizedBox(height: 20),
                            _buildRichText("จำนวนเม็ด :", "${widget.medicineData.dosage}"),
                            const SizedBox(height: 20),
                            _buildRichText("ทานเมื่อ :", "${widget.medicineData.intakeTime}"),
                            const SizedBox(height: 20),
                            _buildRichText("สรรพคุณของยา :", "${widget.medicineData.drugUses}"),
                            const SizedBox(height: 20),
                            _buildRichText("เวลา :", "${widget.medicineData.intakeTime}"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveMedicineData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : const Text(
                          'ยืนยันและบันทึก',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildRichText(String title, String content) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black, fontSize: 18),
        children: [
          TextSpan(
              text: "$title ",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 10, 70, 120))),
          TextSpan(text: "\n$content", style: const TextStyle(height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Container(
        height: 60,
        child: BottomNavigationBar(
          items: const [
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

  Future<void> _saveMedicineData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print('เริ่มบันทึกข้อมูลยา: ${widget.medicineData.name}');
      
      // ดึง token สำหรับการยืนยันตัวตน
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token') ?? prefs.getString('auth_token');
      
      if (token == null || token.isEmpty) {
        throw Exception('ไม่พบ token กรุณาเข้าสู่ระบบอีกครั้ง');
      }

      // ทดลองส่งข้อมูลไปยังหลาย endpoint เพื่อหาว่า endpoint ไหนทำงานได้
      final endpoints = [
        '$baseUrl/medicines',
        '$baseUrl/records',
        '$baseUrl/medicine-records'
      ];
      
      Map<String, dynamic>? responseBody;
      int responseStatus = 0;
      
      // เตรียมข้อมูลที่จะส่งไป API
      final medicineData = {
        'name': widget.medicineData.name,
        'dosage': widget.medicineData.dosage,
        'intakeTime': widget.medicineData.intakeTime,  // ใช้ชื่อฟิลด์ตรงกับ API
        'drugUses': widget.medicineData.drugUses,      // ใช้ชื่อฟิลด์ตรงกับ API
        'isDiabetesMedicine': widget.medicineData.isDiabetesMedicine,
      };
      
      print('ข้อมูลที่ส่งไป API: ${jsonEncode(medicineData)}');
      
      // ลองทีละ endpoint
      for (final endpoint in endpoints) {
        try {
          print('กำลังลองส่งข้อมูลไปยัง $endpoint');
          
          final response = await http.post(
            Uri.parse(endpoint),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(medicineData),
          );
          
          print('คำตอบจาก $endpoint: ${response.statusCode}, ${response.body}');
          
          if (response.statusCode == 200 || response.statusCode == 201) {
            responseStatus = response.statusCode;
            
            // ถ้า response body เป็น JSON ที่ถูกต้อง
            try {
              responseBody = jsonDecode(response.body);
              print('ส่งข้อมูลไปยัง $endpoint สำเร็จ');
              break; // ออกจาก loop เมื่อส่งสำเร็จ
            } catch (e) {
              print('ไม่สามารถแปลง response body เป็น JSON ได้: $e');
              // ถ้าไม่สามารถแปลงเป็น JSON ได้แต่ status code ถูกต้อง ก็ถือว่าสำเร็จ
              responseBody = {'success': true};
              break;
            }
          }
        } catch (e) {
          print('เกิดข้อผิดพลาดเมื่อส่งข้อมูลไปยัง $endpoint: $e');
          // ทำต่อและลอง endpoint ถัดไป
        }
      }
      
      setState(() {
        _isLoading = false;
      });
      
      // ถ้ามีการตอบกลับที่ถูกต้อง
      if (responseStatus == 200 || responseStatus == 201) {
        // บันทึกข้อมูลสำเร็จ
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('บันทึกข้อมูลยาสำเร็จ'),
            backgroundColor: Colors.green,
          ),
        );
        
        // สร้างการแจ้งเตือนสำหรับยานี้
        await _createNotificationForMedicine(widget.medicineData);
        
        // ไปยังหน้าแจ้งเตือน
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const NotificationPage(),
            ),
          );
        });
      } else {
        // บันทึกล้มเหลว
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ไม่สามารถบันทึกข้อมูลได้ กรุณาลองใหม่อีกครั้ง'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาด: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // สร้างการแจ้งเตือนสำหรับยาที่บันทึก
  Future<void> _createNotificationForMedicine(MedicineRecord medicine) async {
    try {
      // ดึง token สำหรับยืนยันตัวตน
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token') ?? prefs.getString('auth_token');
      
      if (token == null || token.isEmpty) {
        print('ไม่พบ token ไม่สามารถสร้างการแจ้งเตือนได้');
        return;
      }
      
      print('กำลังสร้างการแจ้งเตือนสำหรับยา: ${medicine.name}');
      
      // กำหนดเวลาในการแจ้งเตือน โดยดูจากข้อมูลเวลาทานยา
      final intakeTime = medicine.intakeTime.toLowerCase();
      List<DateTime> notificationTimes = [];
      
      final now = DateTime.now();
      final tomorrow = DateTime(now.year, now.month, now.day + 1);
      
      // กำหนดเวลาแจ้งเตือนตามช่วงเวลาของยา
      if (intakeTime.contains('เช้า')) {
        final morningTime = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 8, 0);
        notificationTimes.add(morningTime);
      }
      
      if (intakeTime.contains('กลางวัน')) {
        final noonTime = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 12, 0);
        notificationTimes.add(noonTime);
      }
      
      if (intakeTime.contains('เย็น')) {
        final eveningTime = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 18, 0);
        notificationTimes.add(eveningTime);
      }
      
      if (intakeTime.contains('ก่อนนอน')) {
        final bedtimeTime = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 21, 0);
        notificationTimes.add(bedtimeTime);
      }
      
      // ถ้าไม่พบช่วงเวลาใดๆ ใช้เวลาปัจจุบัน + 1 ชั่วโมง
      if (notificationTimes.isEmpty) {
        notificationTimes.add(now.add(const Duration(hours: 1)));
      }
      
      // สร้างการแจ้งเตือนสำหรับแต่ละเวลา
      for (var notificationTime in notificationTimes) {
        // ใช้ ID ยาถ้ามี หรือสร้าง ID ชั่วคราว
        final medicineId = medicine.id ?? DateTime.now().millisecondsSinceEpoch;
        
        // ข้อมูลการแจ้งเตือน
        final notificationData = {
          'medicineId': medicineId.toString(),
          'title': 'ถึงเวลาทานยา${medicine.name}',
          'message': 'ได้เวลาทานยา${medicine.name} ${medicine.intakeTime} แล้ว อย่าลืมทานยาตามกำหนดเวลานะคะ',
          'notificationTime': notificationTime.toIso8601String(),
          'isRead': false,
        };
        
        // ส่งคำขอไปยัง API
        final url = Uri.parse('$baseUrl/notifications');
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(notificationData),
        );
        
        print('ผลการสร้างการแจ้งเตือน: ${response.statusCode}, ${response.body}');
      }
      
      print('สร้างการแจ้งเตือนสำเร็จ');
    } catch (e) {
      print('เกิดข้อผิดพลาดในการสร้างการแจ้งเตือน: $e');
    }
  }
}