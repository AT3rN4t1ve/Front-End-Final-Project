import 'package:flutter/material.dart';
import 'package:frontmain/models/medicine_record.dart';
import 'package:frontmain/screens/drugDetails.dart';
import 'package:frontmain/screens/main2.dart';
import 'package:frontmain/screens/user.dart';
import 'package:frontmain/services/medicine_service.dart';

class DiabetesMedicinesPage extends StatefulWidget {
  const DiabetesMedicinesPage({super.key});

  @override
  State<DiabetesMedicinesPage> createState() => _DiabetesMedicinesPageState();
}

class _DiabetesMedicinesPageState extends State<DiabetesMedicinesPage> {
  final MedicineService _medicineService = MedicineService();
  List<MedicineRecord> _medicines = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMedicines();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
    _searchMedicines();
  }

  Future<void> _loadMedicines() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final medicines = await _medicineService.getDiabetesMedicines();
      setState(() {
        _medicines = medicines;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('ไม่สามารถโหลดข้อมูลยาได้: ${e.toString()}');
    }
  }

  Future<void> _searchMedicines() async {
    if (_searchQuery.isEmpty) {
      _loadMedicines();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final medicines = await _medicineService.searchDiabetesMedicines(_searchQuery);
      setState(() {
        _medicines = medicines;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('ไม่สามารถค้นหายาได้: ${e.toString()}');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'รายการยาเบาหวาน',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFFFF9800),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ค้นหาชื่อยาเบาหวาน...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _medicines.isEmpty
                    ? const Center(
                        child: Text(
                          'ไม่พบข้อมูลยาเบาหวาน',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _medicines.length,
                        itemBuilder: (context, index) {
                          final medicine = _medicines[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            child: ListTile(
                              title: Text(
                                medicine.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (medicine.drugUses.isNotEmpty)
                                    Text('สรรพคุณ: ${medicine.drugUses}'),
                                  if (medicine.intakeTime.isNotEmpty)
                                    Text('เวลาทาน: ${medicine.intakeTime}'),
                                ],
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              contentPadding: const EdgeInsets.all(16),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DrugDetailspage(
                                      medicineData: medicine,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

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
                MaterialPageRoute(
                  builder: (context) => const Main2(),
                ),
              );
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const User(),
                ),
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