import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontmain/models/medicine_record.dart'; 
import 'package:frontmain/utils/medicine_matcher.dart';

class MedicineService {
  final Dio _dio;
  static const String baseUrl = 'http://192.168.1.7:5000/api';

  MedicineService() : _dio = Dio() {
    _dio.options.baseUrl = baseUrl;
    _initializeToken();
  }

  Future<void> _initializeToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token != null) {
      setToken(token);
    }
  }

  void setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // เพิ่มเมธอด OCR สำหรับสแกนซองยา
  Future<Map<String, dynamic>> scanMedicine(File image) async {
    try {
      // ตรวจสอบว่ามี token หรือไม่
      if (_dio.options.headers['Authorization'] == null) {
        await _initializeToken();
      }

      // สร้าง FormData เพื่ออัปโหลดรูปภาพ
      String fileName = image.path.split('/').last;
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          image.path,
          filename: fileName,
          contentType: MediaType('image', 'jpeg'),
        ),
      });

      // ส่งคำขอไปยัง OCR endpoint
      final response = await _dio.post('/scan', data: formData);

      if (response.statusCode == 200) {
        final data = response.data['data'];
        
        // ตรวจสอบชื่อยาด้วย fuzzy matching
        final medicineName = data['name'] ?? '';
        final medicineMatch = MedicineMatcher.checkDiabetesMedicine(medicineName);
        
        // อัพเดตข้อมูลด้วยผลลัพธ์จาก fuzzy matching
        if (medicineMatch['similarity'] >= 0.6) {
          data['name'] = medicineMatch['name'];
          data['isDiabetesMedicine'] = true;
          
          // ถ้าไม่มีข้อมูลสรรพคุณแต่เป็นยาเบาหวาน
          if ((data['purpose'] == null || data['purpose'].isEmpty) && medicineMatch['isDiabetesMedicine']) {
            data['purpose'] = 'ควบคุมระดับน้ำตาลในเลือด';
          }
        }
        
        return data;
      }

      throw Exception('Failed to process image');
    } catch (e) {
      print('Scan error: $e');
      rethrow;
    }
  }

  // บันทึกข้อมูลยา
  Future<MedicineRecord?> saveMedicineRecord(MedicineRecord record) async {
    try {
      // ตรวจสอบว่ามี token หรือไม่
      if (_dio.options.headers['Authorization'] == null) {
        await _initializeToken();
      }
      
      // สร้างข้อมูลที่จะส่งไปยัง API
      final data = record.toJson();

      // ส่งข้อมูลไปยัง API
      final response = await _dio.post('/medicines', data: data);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("บันทึกข้อมูลสำเร็จ: ${response.data}");
        return MedicineRecord.fromJson(response.data['data']);
      } else {
        print("บันทึกข้อมูลไม่สำเร็จ: ${response.statusCode} - ${response.data}");
        return null;
      }
    } catch (e) {
      print("เกิดข้อผิดพลาดในการบันทึกข้อมูล: $e");
      return null;
    }
  }

  // ดึงข้อมูลยาเบาหวาน
  Future<List<MedicineRecord>> getDiabetesMedicines() async {
    try {
      final response = await _dio.get('/diabetes-medicines');

      if (response.statusCode == 200) {
        List<dynamic> records = response.data['data'];
        return records
            .map((record) => MedicineRecord.fromJson(record))
            .toList();
      }

      return [];
    } catch (e) {
      print('Error fetching diabetes medicines: $e');
      return [];
    }
  }

  // เพิ่มเมธอดค้นหายาเบาหวาน
  Future<List<MedicineRecord>> searchDiabetesMedicines(String query) async {
    try {
      // ดึงข้อมูลยาเบาหวานทั้งหมด
      final allMedicines = await getDiabetesMedicines();
      
      if (query.isEmpty) {
        return allMedicines;
      }
      
      // กรองยาโดยใช้การค้นหาแบบไม่คำนึงถึงตัวอักษรใหญ่-เล็ก
      return allMedicines.where((medicine) {
        return medicine.name.toLowerCase().contains(query.toLowerCase()) || 
               medicine.drugUses.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } catch (e) {
      print('Error searching diabetes medicines: $e');
      return [];
    }
  }
}