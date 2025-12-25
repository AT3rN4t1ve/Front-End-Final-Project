class MedicineMatcher {
  // รายชื่อยาเบาหวานที่รู้จัก
  static const List<String> diabetesMedicineList = [
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
    
    // ยากลุ่ม SGLT2 inhibitors
    'เอมพากลิโฟลซิน', 'empagliflozin', 'jardiance',
    'ดาพากลิโฟลซิน', 'dapagliflozin', 'forxiga',
    'คานากลิโฟลซิน', 'canagliflozin', 'invokana',
    
    // ยากลุ่ม GLP-1 agonists
    'ลิรากลูไทด์', 'liraglutide', 'victoza',
    'เอ็กซีนาไทด์', 'exenatide', 'byetta', 'bydureon',
    'ดูลากลูไทด์', 'dulaglutide', 'trulicity',
    'เซมากลูไทด์', 'semaglutide', 'ozempic'
  ];

  // คำที่เกี่ยวข้องกับเบาหวาน
  static const List<String> diabetesKeywords = [
    'เบาหวาน', 'น้ำตาลในเลือด', 'น้ำตาลสูง', 'ระดับน้ำตาล', 
    'diabetes', 'blood sugar', 'glucose', 'hyperglycemia',
    'insulin', 'อินซูลิน', 'glycemic', 'a1c', 'type 1', 'type 2'
  ];

  // ตรวจสอบว่าชื่อยานี้เป็นยาเบาหวานหรือไม่
  static Map<String, dynamic> checkDiabetesMedicine(String medicineName, {double threshold = 0.6}) {
    if (medicineName.isEmpty) {
      return {
        'name': medicineName,
        'similarity': 0.0,
        'isDiabetesMedicine': false,
      };
    }

    final lowercaseName = medicineName.toLowerCase().trim();
    
    // ตรวจสอบ exact match ก่อน
    for (String medicine in diabetesMedicineList) {
      if (medicine.toLowerCase() == lowercaseName) {
        return {
          'name': medicine,
          'similarity': 1.0,
          'isDiabetesMedicine': true,
        };
      }
    }
    
    // หาการจับคู่ที่ดีที่สุดโดยใช้ Levenshtein distance
    double bestMatch = 0;
    String bestMatchName = medicineName;
    
    for (String medicine in diabetesMedicineList) {
      final double similarity = _calculateSimilarity(
        lowercaseName, 
        medicine.toLowerCase()
      );
      
      if (similarity > bestMatch) {
        bestMatch = similarity;
        bestMatchName = medicine;
      }
    }
    
    if (bestMatch >= threshold) {
      return {
        'name': bestMatchName,
        'similarity': bestMatch,
        'isDiabetesMedicine': true,
      };
    }
    
    // ตรวจสอบด้วย regex pattern อย่างง่าย
    if (_matchesDiabetesMedicinePattern(medicineName)) {
      return {
        'name': medicineName,
        'similarity': 0.7,
        'isDiabetesMedicine': true,
      };
    }
    
    return {
      'name': medicineName,
      'similarity': bestMatch,
      'isDiabetesMedicine': false,
    };
  }
  
  // คำนวณความคล้ายคลึงของสตริง
  static double _calculateSimilarity(String s1, String s2) {
    // คำนวณระยะห่าง Levenshtein
    final distance = _levenshteinDistance(s1, s2);
    final maxLength = s1.length > s2.length ? s1.length : s2.length;
    return 1.0 - (distance / maxLength);
  }

  // คำนวณระยะห่าง Levenshtein
  static int _levenshteinDistance(String s1, String s2) {
    final m = s1.length;
    final n = s2.length;
    final dp = List.generate(
      m + 1, 
      (_) => List.filled(n + 1, 0)
    );

    for (int i = 0; i <= m; i++) {
      dp[i][0] = i;
    }

    for (int j = 0; j <= n; j++) {
      dp[0][j] = j;
    }

    for (int i = 1; i <= m; i++) {
      for (int j = 1; j <= n; j++) {
        final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
        dp[i][j] = [
          dp[i - 1][j] + 1,
          dp[i][j - 1] + 1,
          dp[i - 1][j - 1] + cost
        ].reduce((a, b) => a < b ? a : b);
      }
    }

    return dp[m][n];
  }
  
  // ตรวจสอบด้วย regex pattern อย่างง่าย
  static bool _matchesDiabetesMedicinePattern(String text) {
    if (text.isEmpty) return false;
    
    final lowercaseText = text.toLowerCase();
    
    // รูปแบบการตรวจสอบชื่อยาเบาหวาน
    final patterns = [
      RegExp(r'เมท[ฟทต]อร์(มิน|มีน|มีด)', caseSensitive: false),
      RegExp(r'[gk]l[uiy][ck][oa][szc][ei][dt][ea]', caseSensitive: false),
      RegExp(r'[gk]li[bp][ei][nz][ck]lam[ia]d[ea]', caseSensitive: false),
      RegExp(r'[gk]lim[ea]p[iy]ri[dt][ea]', caseSensitive: false),
      RegExp(r'pi[ou][gk]li[td]a[zs][ou]n[ea]', caseSensitive: false),
      RegExp(r's[iy]ta[gk]li[pb]t[iy]n', caseSensitive: false),
      RegExp(r'[ea]mpa[gk]li[ft]lo[sz][iy]n', caseSensitive: false),
      RegExp(r'a[ck]arb[ou][sz][ea]', caseSensitive: false),
    ];
    
    for (final pattern in patterns) {
      if (pattern.hasMatch(lowercaseText)) {
        return true;
      }
    }
    
    return false;
  }
  
  // ตรวจสอบคำที่เกี่ยวข้องกับเบาหวาน
  static bool hasDiabetesKeywords(String text) {
    if (text.isEmpty) return false;
    
    final lowercaseText = text.toLowerCase();
    return diabetesKeywords.any(
      (keyword) => lowercaseText.contains(keyword.toLowerCase())
    );
  }
}