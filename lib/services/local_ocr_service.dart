import 'dart:io';
import 'package:frontmain/models/medicine_record.dart';
import 'package:frontmain/utils/fuzzy_matching.dart';
import 'package:frontmain/utils/medicine_matcher.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class LocalOcrService {
  final TextRecognizer _textRecognizer = TextRecognizer();
  
  // Singleton pattern แก้ไขรูปแบบประโยค
  static final LocalOcrService _instance = LocalOcrService._internal();
  factory LocalOcrService() => _instance;
  LocalOcrService._internal();
  
  Future<void> dispose() async {
    await _textRecognizer.close();
  }
  
  Future<MedicineRecord> processImage(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      
      //แปลงข้อความที่ได้จาก OCR เป็น string
      final String text = recognizedText.text;
      
      //ใช้ fuzzy matching เพื่อแยกข้อมูลจากข้อความ
      return _extractMedicineData(text);
    } catch (e) {
      print('Local OCR Error: $e');
      
      // ในกรณีที่เกิดข้อผิดพลาด ส่งคืนข้อมูลว่างเปล่า
      return MedicineRecord(
        name: 'ไม่สามารถระบุชื่อยาได้',
        dosage: 'ไม่ระบุ',
        intakeTime: 'ไม่ระบุ',
        drugUses: 'ไม่ระบุ',
      );
    }
  }
  
  MedicineRecord _extractMedicineData(String text) {
    //ใช้ fuzzy matching เพื่อแยกข้อมูลจากข้อความ
    
    // ค้นหาชื่อยาจากข้อความ
    final medicineNames = FuzzyMatching.extractMedicineNames(text);
    final String name = medicineNames.isNotEmpty ? medicineNames.first : 'ไม่ระบุ';
    
    // ค้นหาวิธีการรับประทานยา
    final dosageInstructions = FuzzyMatching.extractDosageInstructions(text) ?? 'ไม่ระบุ';
    
    // ค้นหาเวลาทานยา
    final intakeTime = FuzzyMatching.extractIntakeTime(text) ?? 'ไม่ระบุ';
    
    //ค้นหาสรรพคุณยา
    final purpose = FuzzyMatching.extractMedicinePurpose(text) ?? 'ไม่ระบุ';
    
    //ตรวจสอบว่าเป็นยาเบาหวานหรือไม่
    final diabetesCheck = MedicineMatcher.checkDiabetesMedicine(name);
    final isDiabetes = diabetesCheck['isDiabetesMedicine'] as bool;
    
    return MedicineRecord(
      name: name,
      dosage: dosageInstructions,
      intakeTime: intakeTime,
      drugUses: purpose,
      isDiabetesMedicine: isDiabetes,
    );
  }
  
  //ปรับปรุงผลลัพธ์ด้วย fuzzy matching
  MedicineRecord improveMedicineData(MedicineRecord record) {
    //ตรวจสอบและปรับปรุงชื่อยา
    if (record.name.isNotEmpty && record.name != 'ไม่ระบุ') {
      final medicineResult = MedicineMatcher.checkDiabetesMedicine(record.name);
      
      if (medicineResult['similarity'] >= 0.7) {
        return MedicineRecord(
          id: record.id,
          name: medicineResult['name'] as String,
          dosage: record.dosage,
          intakeTime: record.intakeTime,
          drugUses: record.drugUses,
          imageUrl: record.imageUrl,
          createdAt: record.createdAt,
          isDiabetesMedicine: medicineResult['isDiabetesMedicine'] as bool,
        );
      }
    }
    
    return record;
  }
}