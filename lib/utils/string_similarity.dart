// lib/utils/string_similarity.dart
class StringSimilarity {
  /// คำนวณค่าความเหมือนระหว่างสองข้อความ
  /// ค่าที่ได้จะอยู่ระหว่าง 0.0 (ไม่เหมือนเลย) ถึง 1.0 (เหมือนกันทุกประการ)
  static double compareTwoStrings(String str1, String str2) {
    if (str1 == str2) return 1.0;
    if (str1.isEmpty || str2.isEmpty) return 0.0;
    
    // ใช้อัลกอริทึม Levenshtein distance
    str1 = str1.toLowerCase();
    str2 = str2.toLowerCase();
    
    final len1 = str1.length;
    final len2 = str2.length;
    
    // เมตริกซ์สำหรับคำนวณระยะห่าง
    List<List<int>> dist = List.generate(
      len1 + 1, 
      (i) => List.generate(len2 + 1, (j) => j == 0 ? i : (i == 0 ? j : 0))
    );
    
    for (int i = 1; i <= len1; i++) {
      for (int j = 1; j <= len2; j++) {
        if (str1[i - 1] == str2[j - 1]) {
          dist[i][j] = dist[i - 1][j - 1];
        } else {
          dist[i][j] = 1 + [
            dist[i - 1][j],     // ลบ
            dist[i][j - 1],     // เพิ่ม
            dist[i - 1][j - 1]  // แทนที่
          ].reduce((a, b) => a < b ? a : b);
        }
      }
    }
    
    // คำนวณค่าความเหมือนจากระยะทาง Levenshtein
    final maxLen = len1 > len2 ? len1 : len2;
    return maxLen > 0 ? 1 - dist[len1][len2] / maxLen : 1.0;
  }
}