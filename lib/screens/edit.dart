import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:frontmain/screens/main2.dart';
import 'package:frontmain/screens/user.dart';
import 'package:frontmain/screens/drugDetails.dart';
import 'package:frontmain/models/medicine_record.dart';
import 'package:frontmain/utils/medicine_matcher.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:frontmain/services/medicine_service.dart';

class Editpage extends StatefulWidget {
  const Editpage({super.key});

  @override
  State<Editpage> createState() => _EditpageState();
}

class _EditpageState extends State<Editpage> {
  TextEditingController medicineNameController = TextEditingController();
  TextEditingController pillCountController = TextEditingController();
  TextEditingController drugUsesController = TextEditingController();
  TextEditingController intakeTimeController = TextEditingController();
  
  final ImagePicker _picker = ImagePicker();
  File? _image;
  
  // เพิ่มตัวแปรสำหรับแสดงคำแนะนำชื่อยาที่ถูกต้อง
  String? suggestedName;
  bool showSuggestion = false;
  bool isDiabetesMedicine = false;
  
  // เพิ่มตัวแปรสำหรับจัดการกับ loading state
  bool _isLoading = false;
  
  // สร้าง instance ของ MedicineService
  final MedicineService _medicineService = MedicineService();

  @override
  void initState() {
    super.initState();
    // เพิ่มการเริ่มต้น locale สำหรับวันที่ภาษาไทย
    initializeDateFormatting('th_TH', null).then((_) {
      // โค้ดเพิ่มเติมหลังจากเริ่มต้น locale เสร็จแล้ว (ถ้ามี)
    });
    
    // เพิ่ม listener เพื่อตรวจสอบชื่อยาแบบ real-time
    medicineNameController.addListener(_checkMedicineName);
  }

  @override
  void dispose() {
    medicineNameController.removeListener(_checkMedicineName);
    medicineNameController.dispose();
    pillCountController.dispose();
    drugUsesController.dispose();
    intakeTimeController.dispose();
    super.dispose();
  }

  // ตรวจสอบชื่อยาด้วย fuzzy matching
  void _checkMedicineName() {
    if (medicineNameController.text.isNotEmpty) {
      final result = MedicineMatcher.checkDiabetesMedicine(medicineNameController.text);
      
      // ถ้าความคล้ายคลึงมากกว่า 0.6 แต่ไม่ใช่ 1.0 (ไม่ใช่ชื่อเดียวกัน) ให้แสดงคำแนะนำ
      if (result['similarity'] >= 0.6 && result['similarity'] < 1.0) {
        setState(() {
          suggestedName = result['name'];
          showSuggestion = true;
          isDiabetesMedicine = result['isDiabetesMedicine'];
        });
        
        // ถ้าเป็นยาเบาหวานและไม่มีข้อมูลสรรพคุณ ให้เติมอัตโนมัติ
        if (isDiabetesMedicine && drugUsesController.text.isEmpty) {
          drugUsesController.text = 'ควบคุมระดับน้ำตาลในเลือด';
        }
      } else if (result['similarity'] == 1.0) {
        // กรณีชื่อตรงกันเลย
        setState(() {
          showSuggestion = false;
          isDiabetesMedicine = result['isDiabetesMedicine'];
        });
        
        // ถ้าเป็นยาเบาหวานและไม่มีข้อมูลสรรพคุณ ให้เติมอัตโนมัติ
        if (isDiabetesMedicine && drugUsesController.text.isEmpty) {
          drugUsesController.text = 'ควบคุมระดับน้ำตาลในเลือด';
        }
      } else {
        setState(() {
          showSuggestion = false;
          isDiabetesMedicine = false;
        });
      }
    } else {
      setState(() {
        showSuggestion = false;
        isDiabetesMedicine = false;
      });
    }
  }

  // ยอมรับคำแนะนำชื่อยา
  void _acceptSuggestion() {
    if (suggestedName != null) {
      medicineNameController.text = suggestedName!;
      setState(() {
        showSuggestion = false;
      });
    }
  }
  
  // เลือกรูปภาพจากแกลเลอรี่
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ไม่สามารถเลือกรูปภาพได้: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ถ่ายรูปด้วยกล้อง
  Future<void> _takePicture() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ไม่สามารถถ่ายรูปได้: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  // บันทึกข้อมูลยาและนำทางไปหน้าถัดไป
  Future<void> _saveMedicineData() async {
    // ตรวจสอบว่ามีการป้อนชื่อยาหรือไม่
    if (medicineNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณาระบุชื่อยา'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    // แสดง loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("กำลังบันทึกข้อมูล...")
            ],
          ),
        );
      },
    );
    
    try {
      // สร้าง MedicineRecord
      final medicineData = MedicineRecord(
        name: medicineNameController.text,
        dosage: pillCountController.text,
        intakeTime: intakeTimeController.text,
        drugUses: drugUsesController.text,
        imageUrl: _image?.path,
        isDiabetesMedicine: isDiabetesMedicine,
      );
      
      // เรียกใช้ MedicineService เพื่อบันทึกข้อมูล
      final savedRecord = await _medicineService.saveMedicineRecord(medicineData);
      
      // ปิด dialog
      Navigator.pop(context);
      
      setState(() {
        _isLoading = false;
      });
      
      if (savedRecord != null) {
        // บันทึกสำเร็จ
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('บันทึกข้อมูลยาสำเร็จ'),
            backgroundColor: Colors.green,
          ),
        );
        
        // ไปหน้ารายละเอียดยา
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DrugDetailspage(
              medicineData: savedRecord,
            ),
          ),
        );
      } else {
        // เกิดข้อผิดพลาดในการบันทึกข้อมูล
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ไม่สามารถบันทึกข้อมูลได้ กรุณาลองใหม่อีกครั้ง'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // ปิด dialog
      Navigator.pop(context);
      
      setState(() {
        _isLoading = false;
      });
      
      // แสดงข้อความผิดพลาด
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาด: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5F2),
      appBar: AppBar(
        title: const Text(
          'สแกนซองยา',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFFFF9800),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ส่วนแสดงรูปภาพและปุ่มเลือกรูป
            Container(
              color: Color(0xFFF2F2F2),
              width: double.infinity,
              height: 200,
              child: _image != null
                  ? Image.file(
                      _image!,
                      fit: BoxFit.cover,
                    )
                  : Center(
                      child: Icon(
                        Icons.image,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                    ),
            ),
            
            // ปุ่มเลือกรูปภาพ
            Container(
              color: Color(0xFFE8F5E9),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _takePicture,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('ถ่ายภาพ'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _pickImageFromGallery,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('เลือกจากแกลเลอรี่'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // หัวข้อข้อมูลยา
            Container(
              color: Color(0xFFF8EFF7),
              padding: EdgeInsets.all(16),
              width: double.infinity,
              child: Text(
                'ข้อมูลยา',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            // ช่องกรอกข้อมูลยา
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // ชื่อยา
                  TextField(
                    controller: medicineNameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.medication, color: Colors.orange),
                      hintText: 'ชื่อยา',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  
                  // แสดงข้อความแนะนำชื่อยา (ถ้ามี)
                  if (showSuggestion && suggestedName != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                      child: InkWell(
                        onTap: _acceptSuggestion,
                        child: Row(
                          children: [
                            Icon(Icons.lightbulb_outline, 
                                size: 16, color: Colors.amber),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'คุณหมายถึง "$suggestedName" หรือไม่? (แตะเพื่อใช้)',
                                style: TextStyle(
                                  color: Colors.blue[700],
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  
                  SizedBox(height: 12),
                  
                  // จำนวนเม็ด/มิลลิกรัม
                  TextField(
                    controller: pillCountController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.straighten, color: Colors.orange),
                      hintText: 'จำนวนเม็ด/มิลลิกรัม',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  
                  // สรรพคุณของยา
                  TextField(
                    controller: drugUsesController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.healing, color: Colors.orange),
                      hintText: 'สรรพคุณของยา',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  
                  // เวลาในการทาน
                  TextField(
                    controller: intakeTimeController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.access_time, color: Colors.orange),
                      hintText: 'เวลาในการทาน',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // ปุ่มบันทึกข้อมูลยา
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveMedicineData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9800),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    disabledBackgroundColor: Colors.grey,
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'บันทึกข้อมูลยา',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ),
          ],
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