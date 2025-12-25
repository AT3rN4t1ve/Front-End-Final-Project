import 'package:flutter/material.dart';
import 'package:frontmain/screens/main2.dart';
import 'package:frontmain/screens/user.dart';
import 'package:frontmain/screens/drugDetails.dart';
import 'package:frontmain/models/medicine_record.dart';

class MedicineSchedulePage extends StatefulWidget {
  final MedicineRecord medicineData;

  const MedicineSchedulePage({
    Key? key, 
    required this.medicineData,
  }) : super(key: key);

  @override
  State<MedicineSchedulePage> createState() => _MedicineSchedulePageState();
}

class _MedicineSchedulePageState extends State<MedicineSchedulePage> {
  // ข้อมูลเวลาทานยา
  final List<bool> _daysOfWeek = List.filled(7, true); // จันทร์-อาทิตย์
  TimeOfDay _morningTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _noonTime = const TimeOfDay(hour: 12, minute: 0);
  TimeOfDay _eveningTime = const TimeOfDay(hour: 18, minute: 0);
  TimeOfDay _bedtimeTime = const TimeOfDay(hour: 21, minute: 0);
  
  // สถานะการเลือกช่วงเวลา
  bool _takeMorning = true;
  bool _takeNoon = false;
  bool _takeEvening = true;
  bool _takeBedtime = false;
  
  // เพิ่มฟังก์ชันสำหรับจัดการเวลาทานยาแบบยืดหยุ่น
  final List<String> _customTimes = ['19:00']; // เริ่มต้นด้วยเวลา 19:00 น.
  
  // ฟังก์ชันเพิ่มเวลาทานยาที่กำหนดเอง
  void _addCustomTime() {
    setState(() {
      _customTimes.add('19:00'); // เพิ่มเวลาเริ่มต้น
    });
  }
  
  // ฟังก์ชันลบเวลาทานยาที่กำหนดเอง
  void _removeCustomTime(int index) {
    setState(() {
      _customTimes.removeAt(index);
    });
  }
  
  // ฟังก์ชันแสดง TimePicker และอัปเดตเวลาที่กำหนดเอง
  Future<void> _selectCustomTime(int index) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 19, minute: 0), // เวลาเริ่มต้น
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFF9800),
            ),
            buttonTheme: const ButtonThemeData(
              colorScheme: ColorScheme.light(
                primary: Color(0xFFFF9800),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (selectedTime != null) {
      setState(() {
        _customTimes[index] = selectedTime.format(context); // อัปเดตเวลาในรายการ
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5F2),
      appBar: AppBar(
        title: const Text(
          'ตั้งเวลาทานยา',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFFFF9800),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ข้อมูลยา
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ชื่อยา: ${widget.medicineData.name}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "ขนาดยา: ${widget.medicineData.dosage}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "สรรพคุณ: ${widget.medicineData.drugUses}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            
            // วันที่ต้องทานยา
            _buildSectionTitle("วันที่ต้องทานยา"),
            const SizedBox(height: 8),
            _buildDaysOfWeek(),
            
            const SizedBox(height: 24),

            // ช่วงเวลาที่ต้องทาน (แบบปกติ)
            _buildSectionTitle("ช่วงเวลาที่ต้องทานยา"),
            const SizedBox(height: 8),
            _buildTimeSelection(),
            
            const SizedBox(height: 24),
            
            // เวลาทานยาที่กำหนดเอง (เพิ่มเติม)
            _buildSectionTitle("เวลาทานยาเพิ่มเติม"),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // แสดงรายการเวลาที่กำหนดเอง
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _customTimes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _selectCustomTime(index),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF9800),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    _customTimes[index],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                              onPressed: () => _removeCustomTime(index),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  
                  // ปุ่มเพิ่มเวลา
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _addCustomTime,
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        'เพิ่มเวลา',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF9800),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // ปุ่มบันทึก
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveSchedule,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9800),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "บันทึกเวลาทานยา",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // สร้างหัวข้อส่วน
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  // สร้างส่วนเลือกวันในสัปดาห์
  Widget _buildDaysOfWeek() {
    final days = ["จ.", "อ.", "พ.", "พฤ.", "ศ.", "ส.", "อา."];
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          7,
          (index) => GestureDetector(
            onTap: () {
              setState(() {
                _daysOfWeek[index] = !_daysOfWeek[index];
              });
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _daysOfWeek[index]
                    ? const Color(0xFFFF9800)
                    : Colors.grey.shade200,
              ),
              child: Center(
                child: Text(
                  days[index],
                  style: TextStyle(
                    color: _daysOfWeek[index] ? Colors.white : Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // สร้างส่วนเลือกเวลาทานยา
  Widget _buildTimeSelection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTimeOption(
            "เช้า",
            _takeMorning,
            _morningTime,
            (value) => setState(() => _takeMorning = value),
            (time) => setState(() => _morningTime = time),
          ),
          const Divider(),
          _buildTimeOption(
            "กลางวัน",
            _takeNoon,
            _noonTime,
            (value) => setState(() => _takeNoon = value),
            (time) => setState(() => _noonTime = time),
          ),
          const Divider(),
          _buildTimeOption(
            "เย็น",
            _takeEvening,
            _eveningTime,
            (value) => setState(() => _takeEvening = value),
            (time) => setState(() => _eveningTime = time),
          ),
          const Divider(),
          _buildTimeOption(
            "ก่อนนอน",
            _takeBedtime,
            _bedtimeTime,
            (value) => setState(() => _takeBedtime = value),
            (time) => setState(() => _bedtimeTime = time),
          ),
        ],
      ),
    );
  }

  // สร้างตัวเลือกเวลา
  Widget _buildTimeOption(
    String title,
    bool isSelected,
    TimeOfDay time,
    Function(bool) onCheckChanged,
    Function(TimeOfDay) onTimeChanged,
  ) {
    return Row(
      children: [
        Checkbox(
          value: isSelected,
          onChanged: (value) => onCheckChanged(value ?? false),
          activeColor: const Color(0xFFFF9800),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        isSelected
            ? TextButton(
                onPressed: () async {
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: time,
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Color(0xFFFF9800),
                          ),
                          buttonTheme: const ButtonThemeData(
                            colorScheme: ColorScheme.light(
                              primary: Color(0xFFFF9800),
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (selectedTime != null) {
                    onTimeChanged(selectedTime);
                  }
                },
                child: Text(
                  "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFFFF9800),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : const SizedBox(width: 80),
      ],
    );
  }

  // บันทึกเวลาทานยา
  void _saveSchedule() {
    // รวบรวมข้อมูลเวลาทานยา
    List<String> scheduleTimes = [];
    
    // เพิ่มเวลาจากตัวเลือกทั่วไป
    if (_takeMorning) {
      scheduleTimes.add("เช้า ${_morningTime.hour}:${_morningTime.minute.toString().padLeft(2, '0')}");
    }
    
    if (_takeNoon) {
      scheduleTimes.add("กลางวัน ${_noonTime.hour}:${_noonTime.minute.toString().padLeft(2, '0')}");
    }
    
    if (_takeEvening) {
      scheduleTimes.add("เย็น ${_eveningTime.hour}:${_eveningTime.minute.toString().padLeft(2, '0')}");
    }
    
    if (_takeBedtime) {
      scheduleTimes.add("ก่อนนอน ${_bedtimeTime.hour}:${_bedtimeTime.minute.toString().padLeft(2, '0')}");
    }
    
    // เพิ่มเวลาที่กำหนดเอง
    for (final customTime in _customTimes) {
      scheduleTimes.add("เวลา $customTime");
    }
    
    // สร้างข้อมูลที่ปรับปรุงและส่งไปยังหน้ารายละเอียดยา
    final updatedMedicine = MedicineRecord(
      id: widget.medicineData.id,
      name: widget.medicineData.name,
      dosage: widget.medicineData.dosage,
      intakeTime: scheduleTimes.join(", "),
      drugUses: widget.medicineData.drugUses,
      imageUrl: widget.medicineData.imageUrl,
      isDiabetesMedicine: widget.medicineData.isDiabetesMedicine,
    );
    
    // แสดงข้อความสำเร็จ
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('บันทึกเวลาทานยาสำเร็จ'),
        backgroundColor: Colors.green,
      ),
    );
    
    // นำทางไปหน้ารายละเอียดยา
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DrugDetailspage(
          medicineData: updatedMedicine,
        ),
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
