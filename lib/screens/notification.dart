import 'package:flutter/material.dart';
import 'package:frontmain/screens/main2.dart';
import 'package:frontmain/screens/user.dart';
import 'package:frontmain/models/notification_medicine.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // ข้อมูลตัวอย่างสำหรับการแสดงผล
  List<NotificationMedicine> notifications = [
    NotificationMedicine(
      id: 1,
      title: "Metformin",
      message: "ถึงเวลาทานยาเบาหวาน",
      notificationTime: DateTime.now(),
      isRead: false,
      createdAt: DateTime.now(),
    ),
    NotificationMedicine(
      id: 2,
      title: "Aspirin",
      message: "ถึงเวลาทานยาบำรุงหัวใจ",
      notificationTime: DateTime.now().subtract(Duration(hours: 4)),
      isRead: true,
      createdAt: DateTime.now().subtract(Duration(hours: 4)),
    ),
  ];

  // รายการยาที่ทานแล้ว
  List<NotificationMedicine> takenMedicines = [];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE, d MMMM yyyy', 'th');
    final formattedDate = formatter.format(now);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF5F2),
      appBar: AppBar(
        title: const Text(
          'รายการแจ้งเตือนทานยา',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Color(0xFFFF9800),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          _buildHeaderSection(formattedDate),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: TabBar(
                      tabs: [
                        Tab(text: "รายการแจ้งเตือน"),
                        Tab(text: "ยาที่ทานแล้ว"),
                      ],
                      labelColor: const Color(0xFFFF9800),
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: const Color(0xFFFF9800),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // แท็บที่ 1: รายการแจ้งเตือน
                        _buildNotificationList(),
                        
                        // แท็บที่ 2: ยาที่ทานแล้ว
                        _buildTakenMedicineList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeaderSection(String formattedDate) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xFFFF9800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'วันนี้',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            formattedDate,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList() {
    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              "ไม่มีการแจ้งเตือน",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        final timeFormat = DateFormat('HH:mm');
        
        return Card(
          margin: EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            title: Text(
              notification.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text(notification.message),
                SizedBox(height: 4),
                Text(
                  "เวลา: ${timeFormat.format(notification.notificationTime)}",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () => _markAsTaken(notification),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text("ทานแล้ว"),
            ),
            leading: Container(
              width: 10,
              decoration: BoxDecoration(
                color: notification.isRead ? Colors.transparent : Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTakenMedicineList() {
    if (takenMedicines.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.healing_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              "ยังไม่มีประวัติการทานยา",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: takenMedicines.length,
      itemBuilder: (context, index) {
        final medicine = takenMedicines[index];
        final timeFormat = DateFormat('dd/MM/yyyy HH:mm');
        
        return Card(
          margin: EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            title: Row(
              children: [
                Text(
                  medicine.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 18,
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text(medicine.message),
                SizedBox(height: 4),
                Text(
                  "ทานเมื่อ: ${timeFormat.format(DateTime.now())}",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _removeFromTakenList(index),
            ),
          ),
        );
      },
    );
  }

  void _markAsTaken(NotificationMedicine notification) {
    setState(() {
      // เพิ่มในรายการยาที่ทานแล้ว
      takenMedicines.add(notification);
      
      // ลบออกจากรายการแจ้งเตือน
      notifications.removeWhere((item) => item.id == notification.id);
    });
    
    // แสดงข้อความแจ้งเตือน
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('บันทึกการทานยา ${notification.title} สำเร็จ'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _removeFromTakenList(int index) {
    setState(() {
      takenMedicines.removeAt(index);
    });
  }

  Widget _buildBottomNavigationBar() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Container(
        height: 60,
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.arrow_back), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: ''),
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
          unselectedLabelStyle: TextStyle(fontSize: 0),
          selectedLabelStyle: TextStyle(fontSize: 0),
          iconSize: 35,
          backgroundColor: Color(0xFFFF9800),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.6),
          type: BottomNavigationBarType.fixed,
          elevation: 10,
        ),
      ),
    );
  }
}