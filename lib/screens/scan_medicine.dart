// ปรับปรุง scan_medicine.dart
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:frontmain/screens/main2.dart';
import 'package:frontmain/screens/user.dart';
import 'package:frontmain/services/medicine_service.dart';
import 'package:frontmain/models/medicine_record.dart';

class ScanMedicinePage extends StatefulWidget {
  const ScanMedicinePage({super.key});

  @override
  State<ScanMedicinePage> createState() => _ScanMedicinePageState();
}

class _ScanMedicinePageState extends State<ScanMedicinePage> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  bool _isLoading = false;
  bool _scanCompleted = false;
  String _scanStatus = '';
  MedicineRecord? _scanResult;
  final MedicineService _medicineService = MedicineService();
  bool _isMockData = false; // เพิ่มตัวแปรเพื่อตรวจสอบว่าเป็นข้อมูลจำลองหรือไม่

  // TextEditingController สำหรับแก้ไขข้อมูลหลังสแกน
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pillCountController = TextEditingController();
  final TextEditingController _intakeTimeController = TextEditingController();
  final TextEditingController _drugUsesController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _pillCountController.dispose();
    _intakeTimeController.dispose();
    _drugUsesController.dispose();
    super.dispose();
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
          _scanCompleted = false;
          _scanStatus = '';
          _scanResult = null;
          _isMockData = false;
        });
      }
    } catch (e) {
      _showErrorDialog('ไม่สามารถเลือกรูปภาพได้: ${e.toString()}');
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
          _scanCompleted = false;
          _scanStatus = '';
          _scanResult = null;
          _isMockData = false;
        });
      }
    } catch (e) {
      _showErrorDialog('ไม่สามารถถ่ายรูปได้: ${e.toString()}');
    }
  }

  // วิเคราะห์รูปภาพด้วย OCR
  Future<void> _scanMedicineImage() async {
  if (_image == null) {
    _showErrorDialog('กรุณาเลือกรูปภาพก่อน');
    return;
  }

  setState(() {
    _isLoading = true;
    _scanStatus = 'กำลังวิเคราะห์ซองยา...';
  });

  try {
    // เรียกใช้บริการสแกนยา
    final result = await _medicineService.scanMedicine(_image!);

    // ตรวจสอบผลลัพธ์
    setState(() {
      _isLoading = false;
      _scanCompleted = true;
      
      // ตรวจสอบว่าเป็นข้อมูลจำลองหรือไม่
      _isMockData = result['isMockData'] ?? false;
      
      _scanStatus = _isMockData 
          ? 'ไม่สามารถอ่านข้อความจากรูปภาพ แสดงตัวอย่างข้อมูลแทน'
          : 'สแกนเสร็จสิ้น';
      
      // แปลงข้อมูลเป็น MedicineRecord
      _scanResult = MedicineRecord.fromJson(result);
      
      // เติมข้อมูลใน TextField
      _nameController.text = _scanResult!.name;
      _pillCountController.text = _scanResult!.dosage;
      _intakeTimeController.text = _scanResult!.intakeTime;
      _drugUsesController.text = _scanResult!.drugUses;
    });

    // แสดงคำเตือนถ้าเป็นข้อมูลจำลอง
    if (_isMockData) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ไม่สามารถอ่านข้อความจากรูปภาพได้ กรุณาตรวจสอบรูปภาพหรือป้อนข้อมูลด้วยตนเอง'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 5),
        ),
      );
    }
  } catch (e) {
    setState(() {
      _isLoading = false;
      _scanStatus = 'เกิดข้อผิดพลาดในการสแกน';
    });
    _showErrorDialog('ไม่สามารถวิเคราะห์รูปภาพได้: ${e.toString()}');
  }
}

  // บันทึกข้อมูลยาลงฐานข้อมูล
  Future<void> _saveMedicineData() async {
    // ... โค้ดเดิม ...
  }

  // แสดงกล่องข้อความแจ้งเตือนข้อผิดพลาด
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('แจ้งเตือน'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ตกลง'),
          ),
        ],
      ),
    );
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // คำแนะนำการใช้งาน
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: const Text(
                    'คำแนะนำ: ถ่ายรูปซองยาให้เห็นชื่อยา วิธีใช้ และข้อมูลสำคัญอย่างชัดเจน เพื่อการวิเคราะห์ที่แม่นยำ',
                    style: TextStyle(color: Colors.blue, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 20),
                
                // แสดงรูปภาพที่เลือก
                _image != null
                    ? Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _image!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image, size: 50, color: Colors.grey),
                            SizedBox(height: 10),
                            Text(
                              'ยังไม่มีรูปซองยา',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                const SizedBox(height: 20),
                
                // ปุ่มเลือกรูปภาพและถ่ายรูป
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickImageFromGallery,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('แกลเลอรี่'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _takePicture,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('ถ่ายรูป'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // ปุ่มสแกน
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _image == null || _isLoading ? null : _scanMedicineImage,
                    icon: const Icon(Icons.document_scanner),
                    label: const Text('สแกนซองยา'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: const Color(0xFFFF9800),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                
                // แสดงสถานะการสแกน
                if (_scanStatus.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _isMockData 
                          ? Colors.orange.shade50
                          : (_scanCompleted ? Colors.green.shade50 : Colors.blue.shade50),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _isMockData 
                              ? Icons.warning
                              : (_scanCompleted ? Icons.check_circle : Icons.info),
                          color: _isMockData 
                              ? Colors.orange
                              : (_scanCompleted ? Colors.green : Colors.blue),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _scanStatus,
                            style: TextStyle(
                              color: _isMockData 
                                  ? Colors.orange
                                  : (_scanCompleted ? Colors.green : Colors.blue),
                            ),
                          ),
                        ),
                        if (_isLoading)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
                
                // แสดงผลลัพธ์และให้แก้ไขได้
                if (_scanCompleted && _scanResult != null)
                  Container(
                    padding: const EdgeInsets.all(15),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'ผลการสแกน (สามารถแก้ไขได้)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            if (_isMockData)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'ตัวอย่าง',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        _buildTextField(
                          controller: _nameController,
                          label: 'ชื่อยา',
                          icon: Icons.medication,
                        ),
                        const SizedBox(height: 10),
                        _buildTextField(
                          controller: _pillCountController,
                          label: 'จำนวนเม็ด',
                          icon: Icons.numbers,
                        ),
                        const SizedBox(height: 10),
                        _buildTextField(
                          controller: _intakeTimeController,
                          label: 'วิธีการทาน',
                          icon: Icons.access_time,
                        ),
                        const SizedBox(height: 10),
                        _buildTextField(
                          controller: _drugUsesController,
                          label: 'สรรพคุณของยา',
                          icon: Icons.healing,
                        ), 
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _saveMedicineData,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              backgroundColor: Colors.green,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'บันทึกข้อมูลยา',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                      ],
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

  // สร้าง TextField
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(icon, color: const Color(0xFFFF9800)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        isDense: true,
      ),
    );
  }

  // สร้าง Bottom Navigation Bar
  Widget _buildBottomNavigationBar() {
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