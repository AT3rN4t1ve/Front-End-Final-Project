class MedicineRecord {
  final int? id;
  final String name;
  final String dosage;
  final String intakeTime;
  final String drugUses;
  final String? imageUrl;
  final DateTime? createdAt;
  final bool isDiabetesMedicine;

  MedicineRecord({
    this.id,
    required this.name,
    required this.dosage,
    required this.intakeTime,
    required this.drugUses,
    this.imageUrl,
    this.createdAt,
    this.isDiabetesMedicine = false,
  });

  factory MedicineRecord.fromJson(Map<String, dynamic> json) {
    return MedicineRecord(
      id: json['id'],
      name: json['name'] ?? json['title'] ?? '',
      dosage: json['dosage'] ?? json['pillCount'] ?? json['strength'] ?? '',
      intakeTime: json['intakeTime'] ?? json['timing'] ?? json['frequency'] ?? '',
      drugUses: json['drugUses'] ?? json['purpose'] ?? '',
      imageUrl: json['imageUrl'] ?? json['image'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      isDiabetesMedicine: json['isDiabetesMedicine'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dosage': dosage,
      'intakeTime': intakeTime,
      'drugUses': drugUses,
      'imageUrl': imageUrl,
      'isDiabetesMedicine': isDiabetesMedicine,
    };
  }
}