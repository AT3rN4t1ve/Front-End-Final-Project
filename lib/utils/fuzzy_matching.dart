// lib/utils/fuzzy_matching.dart
import 'string_similarity.dart';

class FuzzyMatching {
  /// รายชื่อยาทั่วไปที่พบบ่อย
  static const List<String> commonMedicineNames = [
    // ยากลุ่ม Biguanides
    'เมทฟอร์มิน', 'metformin', 'glucophage',
    
    // ยากลุ่ม Sulfonylureas
    'กลิเบนคลาไมด์', 'glibenclamide', 'glyburide',
    'กลิไพไซด์', 'glipizide', 'glucotrol',
    'กลิคลาไซด์', 'gliclazide', 'diamicron',
    'ไกลเมพิไรด์', 'glimepiride', 'amaryl',
    
    // ยากลุ่ม Alpha-glucosidase inhibitors
    'อคาร์โบส', 'acarbose', 'glucobay',
    
    // ยากลุ่ม Thiazolidinediones
    'ไพโอกลิตาโซน', 'pioglitazone', 'actos',
    'โรซิกลิตาโซน', 'rosiglitazone', 'avandia',
    
    // ยากลุ่ม DPP-4 inhibitors
    'ซิตากลิปติน', 'sitagliptin', 'januvia',
    'วิลดากลิปติน', 'vildagliptin', 'galvus',
    'แซกซากลิปติน', 'saxagliptin', 'onglyza',
    'ลินากลิปติน', 'linagliptin', 'trajenta',
    
    // ยาทั่วไป
    'พาราเซตามอล', 'paracetamol', 'tylenol',
    'แอสไพริน', 'aspirin',
    'อะม็อกซีซิลลิน', 'amoxicillin',
  ];

  /// หาข้อความที่ใกล้เคียงที่สุดจากรายการ
  static String? findBestMatch(String input, List<String> dictionary, {double threshold = 0.7}) {
    if (input.isEmpty || dictionary.isEmpty) {
      return null;
    }
    
    double bestScore = 0.0;
    String? bestMatch;
    
    for (final word in dictionary) {
      final score = StringSimilarity.compareTwoStrings(input, word);
      if (score > bestScore) {
        bestScore = score;
        bestMatch = word;
      }
    }
    
    return bestScore >= threshold ? bestMatch : null;
  }
  
  /// แยกชื่อยาจากข้อความ
  static List<String> extractMedicineNames(String text) {
    if (text.isEmpty) return [];
    
    final foundMedicines = <String>[];
    final lowerText = text.toLowerCase();
    
    for (final name in commonMedicineNames) {
      if (lowerText.contains(name.toLowerCase())) {
        foundMedicines.add(name);
      }
    }
    
    // ค้นหาชื่อยาทั่วไปที่มีรูปแบบที่รู้จัก
    final medicinePatterns = [
      RegExp(r'\b(?:paracetamol|พาราเซตามอล)\b', caseSensitive: false),
      RegExp(r'\b(?:amoxicillin|อะม็อกซีซิลลิน)\b', caseSensitive: false),
      RegExp(r'\b(?:metformin|เมทฟอร์มิน)\b', caseSensitive: false),
    ];
    
    for (final pattern in medicinePatterns) {
      final match = pattern.firstMatch(text);
      if (match != null && !foundMedicines.contains(match.group(0))) {
        foundMedicines.add(match.group(0)!);
      }
    }
    
    return foundMedicines;
  }
  
  /// แยกวิธีการรับประทานยาจากข้อความ
  static String? extractDosageInstructions(String text) {
    if (text.isEmpty) return null;
    
    final patterns = [
      RegExp(r'รับประทานครั้งละ\s*(\d+)\s*เม็ด', caseSensitive: false),
      RegExp(r'ทานครั้งละ\s*(\d+)\s*เม็ด', caseSensitive: false),
      RegExp(r'วันละ\s*(\d+)\s*ครั้ง', caseSensitive: false),
      RegExp(r'รับประทาน\s*(\d+)\s*ครั้งต่อวัน', caseSensitive: false),
    ];
    
    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        return match.group(0);
      }
    }
    
    return null;
  }
  
  /// แยกเวลาที่ต้องรับประทานยาจากข้อความ
  static String? extractIntakeTime(String text) {
    if (text.isEmpty) return null;
    
    final patterns = [
      RegExp(r'(?:เช้า|กลางวัน|เย็น|ก่อนนอน)', caseSensitive: false),
      RegExp(r'(?:ก่อน|หลัง)อาหาร(?:เช้า|กลางวัน|เย็น)?', caseSensitive: false),
      RegExp(r'เวลา\s*(\d{1,2})[:.]*(\d{0,2})\s*น', caseSensitive: false),
    ];
    
    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        return match.group(0);
      }
    }
    
    return null;
  }
  
  /// แยกสรรพคุณของยาจากข้อความ
  static String? extractMedicinePurpose(String text) {
    if (text.isEmpty) return null;
    
    final patterns = [
      RegExp(r'รักษา(โรค)?([^\s.,]+)', caseSensitive: false),
      RegExp(r'บรรเทาอาการ([^\s.,]+)', caseSensitive: false),
      RegExp(r'ลดอาการ([^\s.,]+)', caseSensitive: false),
      RegExp(r'ป้องกัน(โรค)?([^\s.,]+)', caseSensitive: false),
      RegExp(r'ควบคุม(โรค)?([^\s.,]+)', caseSensitive: false),
    ];
    
    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        return match.group(0);
      }
    }
    
    return null;
  }
}