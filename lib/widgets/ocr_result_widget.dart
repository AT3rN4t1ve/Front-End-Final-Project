import 'package:flutter/material.dart';
import 'package:frontmain/models/medicine_record.dart';
import 'package:frontmain/utils/medicine_matcher.dart';

class OcrResultWidget extends StatefulWidget {
  final MedicineRecord initialData;
  final Function(MedicineRecord) onSave;
  final Function() onCancel;

  const OcrResultWidget({
    Key? key,
    required this.initialData,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<OcrResultWidget> createState() => _OcrResultWidgetState();
}

class _OcrResultWidgetState extends State<OcrResultWidget> {
  late MedicineRecord _medicineData;
  late TextEditingController _nameController;
  late TextEditingController _dosageController;
  late TextEditingController _intakeTimeController;
  late TextEditingController _drugUsesController;
  
  bool _isValidating = false;
  Map<String, String?> _suggestions = {};

  @override
  void initState() {
    super.initState();
    _medicineData = widget.initialData;
    _nameController = TextEditingController(text: _medicineData.name);
    _dosageController = TextEditingController(text: _medicineData.dosage);
    _intakeTimeController = TextEditingController(text: _medicineData.intakeTime);
    _drugUsesController = TextEditingController(text: _medicineData.drugUses);
    
    // ตรวจสอบและปรับปรุงข้อมูลด้วย fuzzy matching
    _validateData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _intakeTimeController.dispose();
    _drugUsesController.dispose();
    super.dispose();
  }
  
  void _validateData() {
    setState(() {
      _isValidating = true;
    });
    
    try {
      // ตรวจสอบชื่อยา
      final medicineResult = MedicineMatcher.checkDiabetesMedicine(_nameController.text);
      
      setState(() {
        _suggestions = {};
        
        // ถ้ามีชื่อยาที่ใกล้เคียงมากกว่า แต่ไม่ใช่ชื่อเดียวกัน
        if (medicineResult['similarity'] >= 0.6 && medicineResult['similarity'] < 1.0) {
          _suggestions['name'] = medicineResult['name'];
        }
        
        _isValidating = false;
      });
    } catch (e) {
      setState(() {
        _isValidating = false;
      });
      print('Validation error: $e');
    }
  }
  
  void _applyNameSuggestion() {
    if (_suggestions['name'] != null) {
      setState(() {
        _nameController.text = _suggestions['name']!;
        _suggestions.remove('name');
        
        // ถ้าเป็นยาเบาหวานและไม่มีข้อมูลสรรพคุณ
        final medicineResult = MedicineMatcher.checkDiabetesMedicine(_nameController.text);
        if (medicineResult['isDiabetesMedicine'] && _drugUsesController.text.isEmpty) {
          _drugUsesController.text = 'ควบคุมระดับน้ำตาลในเลือด';
        }
      });
    }
  }
  
  void _updateRecord() {
    setState(() {
      _medicineData = MedicineRecord(
        id: _medicineData.id,
        name: _nameController.text,
        dosage: _dosageController.text,
        intakeTime: _intakeTimeController.text,
        drugUses: _drugUsesController.text,
        imageUrl: _medicineData.imageUrl,
        createdAt: _medicineData.createdAt,
        isDiabetesMedicine: MedicineMatcher.checkDiabetesMedicine(_nameController.text)['isDiabetesMedicine'],
      );
    });
    
    widget.onSave(_medicineData);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'ข้อมูลที่สแกนได้',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // ชื่อยา
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'ชื่อยา',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              
              // แสดงคำแนะนำถ้ามี
              if (_suggestions['name'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                  child: InkWell(
                    onTap: _applyNameSuggestion,
                    child: Row(
                      children: [
                        const Icon(Icons.lightbulb_outline, size: 16, color: Colors.amber),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'คุณหมายถึง "${_suggestions['name']}" หรือไม่? (แตะเพื่อใช้)',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          
          // ขนาดยา
          TextField(
            controller: _dosageController,
            decoration: InputDecoration(
              labelText: 'วิธีการรับประทาน',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 12),
          
          // เวลาทานยา
          TextField(
            controller: _intakeTimeController,
            decoration: InputDecoration(
              labelText: 'เวลาในการทาน',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 12),
          
          // สรรพคุณ
          TextField(
            controller: _drugUsesController,
            decoration: InputDecoration(
              labelText: 'สรรพคุณของยา',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 24),
          
          // ปุ่มบันทึก/ยกเลิก
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: widget.onCancel,
                child: const Text('ยกเลิก'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _isValidating ? null : _updateRecord,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9800),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                ),
                child: _isValidating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('บันทึก'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}