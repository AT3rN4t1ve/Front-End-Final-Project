class NotificationMedicine {
  final int id;
  final String title;
  final String message;
  final String? medicineId;
  final DateTime notificationTime;
  final bool isRead;
  final DateTime createdAt;

  NotificationMedicine({
    required this.id,
    required this.title,
    required this.message,
    this.medicineId,
    required this.notificationTime,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationMedicine.fromJson(Map<String, dynamic> json) {
    return NotificationMedicine(
      id: json['id'],
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      medicineId: json['medicineId']?.toString(),
      notificationTime: json['notificationTime'] != null
          ? DateTime.parse(json['notificationTime'])
          : DateTime.now(),
      isRead: json['isRead'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'medicineId': medicineId,
      'notificationTime': notificationTime.toIso8601String(),
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}