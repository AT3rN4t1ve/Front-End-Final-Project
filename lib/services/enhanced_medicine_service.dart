// lib/services/enhanced_medicine_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontmain/models/medicine_record.dart';
import 'package:frontmain/utils/fuzzy_matching.dart';

class EnhancedMedicineService {
  static const String baseUrl = 'http://192.168.1.7:5000/api';
  String? _token;
  
  // Singleton pattern
  static final EnhancedMedicineService _instance = EnhancedMedicineService._internal();
  factory EnhancedMedicineService() => _instance;
  EnhancedMedicineService._internal();
  
  // ข้อมูลยาสำหรับเปรียบเทียบ
  final List<String> medicineDatabase = FuzzyMatching.commonMedicineNames;
  
  // ฟังก์ชันตั้งค่า token
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('jwt_token');
  }
  
  // ตรวจสอบว่ามี token หรือไม่
  bool get isAuthenticated => _token != null;
  
  // กำหนด token
  void setToken(String token) {
    _token = token;
  }
  
  // ฟังก์ชันแนบ token ไปกับ headers
  Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }

  // ตรวจสอบและปรับปรุงข้อมูลโดยใช้ fuzzy matching
  MedicineRecord improveMedicineData(MedicineRecord record) {
    // ตรวจสอบและปรับปรุงชื่อยา
    if (record.name.isNotEmpty && record.name != 'ไม่ระบุ') {
      final bestMatch = FuzzyMatching.findBestMatch(
        record.name, 
        medicineDatabase, 
        threshold: 0.7
      );
      
      if (bestMatch != null && bestMatch != record.name) {
        record = MedicineRecord(
          id: record.id,
          name: bestMatch,
          dosage: record.dosage,
          intakeTime: record.intakeTime,
          drugUses: record.drugUses,
          imageUrl: record.imageUrl,
          createdAt: record.createdAt,
        );
      }
    }
    
    return record;
  }
  
  // แยกข้อมูลจากข้อความ OCR ด้วย RegExp และ fuzzy matching
  MedicineRecord extractMedicineDataFromText(String text) {
    // ค้นหาชื่อยาจากข้อความ
    final medicineNames = FuzzyMatching.extractMedicineNames(text);
    final String name = medicineNames.isNotEmpty ? medicineNames.first : 'ไม่ระบุ';
    
    // ค้นหาวิธีการรับประทานยา
    final dosageInstructions = FuzzyMatching.extractDosageInstructions(text) ?? 'ไม่ระบุ';
    
    // ค้นหาเวลาทานยา
    final intakeTime = FuzzyMatching.extractIntakeTime(text) ?? 'ไม่ระบุ';
    
    // ค้นหาสรรพคุณยา
    final purpose = FuzzyMatching.extractMedicinePurpose(text) ?? 'ไม่ระบุ';
    
    return MedicineRecord(
      name: name,
      dosage: dosageInstructions,
      intakeTime: intakeTime,
      drugUses: purpose,
    );
  }
  
  // สแกนยาด้วย OCR
  Future<MedicineRecord?> scanMedicine(File image) async {
    if (_token == null) {
      await initialize();
    }
    
    try {
      // สร้าง multipart request
      var uri = Uri.parse('$baseUrl/scan');
      var request = http.MultipartRequest('POST', uri);
      
      // เพิ่ม headers
      request.headers.addAll({
        if (_token != null) 'Authorization': 'Bearer $_token',
      });
      
      // เพิ่มไฟล์
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
      
      // ส่งคำขอ
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];
        var record = MedicineRecord.fromJson(data);
        
        // ปรับปรุงข้อมูลด้วย fuzzy matching
        return improveMedicineData(record);
      } else {
        // ถ้าเซิร์ฟเวอร์มีปัญหา ให้พยายามวิเคราะห์ด้วย OCR บนอุปกรณ์
        // (ต้องมีการเพิ่ม package OCR สำหรับ Flutter เช่น google_mlkit_text_recognition)
        
        // เพื่อให้ตัวอย่างนี้ทำงานได้ เราจะสร้างข้อมูลตัวอย่างง่ายๆ
        return MedicineRecord(
          name: 'ไม่สามารถระบุชื่อยาได้',
          dosage: 'ไม่ระบุ',
          intakeTime: 'ไม่ระบุ',
          drugUses: 'ไม่ระบุ',
        );
      }
    } catch (e) {
      print('Scan error: $e');
      return null;
    }
  }
  
  // ดึงข้อมูลยาทั้งหมด
  Future<List<MedicineRecord>> getMedicineRecords() async {
    if (_token == null) {
      await initialize();
    }
    
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/medicines'),
        headers: _headers,
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        return data.map((json) => MedicineRecord.fromJson(json)).toList();
      }
      
      return [];
    } catch (e) {
      print('Error fetching records: $e');
      return [];
    }
  }
  
  // บันทึกข้อมูลยาใหม่
  Future<MedicineRecord?> saveMedicineRecord(MedicineRecord record) async {
    if (_token == null) {
      await initialize();
    }
    
    try {
      // ปรับปรุงข้อมูลด้วย fuzzy matching ก่อนบันทึก
      final improvedRecord = improveMedicineData(record);
      
      final response = await http.post(
        Uri.parse('$baseUrl/medicines'),
        headers: _headers,
        body: jsonEncode(improvedRecord.toJson()),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body)['data'];
        return MedicineRecord.fromJson(data);
      }
      
      return null;
    } catch (e) {
      print('Error saving record: $e');
      return null;
    }
  }
  
  // ตรวจสอบความถูกต้องของข้อมูลยาก่อนบันทึก
  Future<Map<String, dynamic>> validateMedicineData(MedicineRecord record) async {
    if (_token == null) {
      await initialize();
    }
    
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/validate-medicine'),
        headers: _headers,
        body: jsonEncode(record.toJson()),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      
      // ถ้า API ไม่ตอบสนอง ให้ตรวจสอบด้วย fuzzy matching บนอุปกรณ์
      final improvedRecord = improveMedicineData(record);
      
      return {
        'original': record.toJson(),
        'suggestions': {
          'name': improvedRecord.name != record.name ? improvedRecord.name : null
        },
        'isValid': true
      };
      
    } catch (e) {
      print('Validation error: $e');
      
      // ตรวจสอบด้วย fuzzy matching บนอุปกรณ์
      final improvedRecord = improveMedicineData(record);
      
      return {
        'original': record.toJson(),
        'suggestions': {
          'name': improvedRecord.name != record.name ? improvedRecord.name : null
        },
        'isValid': true
      };
    }
  }
}