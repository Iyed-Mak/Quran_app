import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentDataScreen extends StatefulWidget {
  const StudentDataScreen({super.key});

  @override
  State<StudentDataScreen> createState() => _StudentDataScreenState();
}

class _StudentDataScreenState extends State<StudentDataScreen> {
  String selectedGroup = 'فوج 1';
  final List<String> groups = ['فوج 1', 'فوج 2'];

  final TextEditingController searchController = TextEditingController();

  final Map<String, List<Map<String, String>>> groupStudents = {
    'فوج 1': [
      {"name": "أحمد", "age": "12", "level": "50", "phone": "0551234567"},
      {"name": "محمد", "age": "13", "level": "29", "phone": "0559876543"},
      {"name": "ليلى", "age": "10", "level": "60", "phone": "0554567890"},
      {"name": "فاطمة", "age": "11", "level": "27", "phone": "0554567891"},
      {"name": "أيمن", "age": "14", "level": "26", "phone": "0554567892"},
      {"name": "جمال", "age": "15", "level": "25", "phone": "0554567893"},
    ],
    'فوج 2': [
      {"name": "خالد", "age": "12", "level": "15", "phone": "0551111111"},
      {"name": "نور", "age": "11", "level": "12", "phone": "0552222222"},
      {"name": "ريم", "age": "13", "level": "10", "phone": "0553333333"},
      {"name": "عمر", "age": "10", "level": "8", "phone": "0554444444"},
      {"name": "هند", "age": "14", "level": "6", "phone": "0555555555"},
      {"name": "بلال", "age": "12", "level": "4", "phone": "0556666666"},
    ],
  };

  List<Map<String, String>> get allStudents => groupStudents[selectedGroup]!;

  List<Map<String, String>> filteredStudents = [];
  String _lastGroup = '';

  @override
  void initState() {
    super.initState();
    filteredStudents = groupStudents[selectedGroup]!;
    _lastGroup = selectedGroup;
  }

  void _onGroupChanged(String group) {
    setState(() {
      selectedGroup = group;
      searchController.clear();
      filteredStudents = groupStudents[group]!;
      _lastGroup = group;
    });
  }

  void searchStudent(String query) {
    final source = groupStudents[selectedGroup]!;
    setState(() {
      filteredStudents = query.isEmpty
          ? source
          : source
                .where(
                  (student) => student["name"]!.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
                )
                .toList();
    });
  }

  Future<void> callParent(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("تعذر فتح تطبيق الاتصال")));
    }
  }

  Widget buildStudentCard(Map<String, String> student) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.teal.shade100,
            child: Text(
              student["name"]![0],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade700,
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  student["name"]!,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildInfoChip("العمر ${student["age"]}"),
                    const SizedBox(width: 8),
                    _buildInfoChip("الحزب ${student["level"]}"),
                  ],
                ),
                const SizedBox(height: 10),

                // Call Button
                Align(
                  alignment: Alignment.centerRight,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ElevatedButton.icon(
                      onPressed: () => callParent(student["phone"]!),
                      icon: const Icon(Icons.phone, size: 18),
                      label: Text(
                        "ولي الأمر: ${student["phone"]!}",
                        style: const TextStyle(fontSize: 14),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Edit Button
          Column(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                color: Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.teal.shade700,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Keep filtered list in sync when group changed externally
    if (_lastGroup != selectedGroup) {
      filteredStudents = groupStudents[selectedGroup]!;
      _lastGroup = selectedGroup;
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xffF5F7F6),
        appBar: AppBar(
          title: const Text("بيانات الطلاب"),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              // ── Group Selector ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.teal.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.shade50,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedGroup,
                    isExpanded: true,
                    icon: Icon(
                      Icons.arrow_drop_down_circle,
                      color: Colors.teal.shade700,
                    ),
                    items: groups.map((group) {
                      return DropdownMenuItem(
                        value: group,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              group,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.teal.shade800,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.group,
                              color: Colors.teal.shade700,
                              size: 20,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) => _onGroupChanged(value!),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Top Summary Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff009688), Color(0xff4DB6AC)],
                  ),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "إجمالي الطلاب",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${filteredStudents.length}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Search Field
              TextField(
                controller: searchController,
                onChanged: searchStudent,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: "... البحث عن طالب",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 15,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // List of Students
              Expanded(
                child: ListView.builder(
                  itemCount: filteredStudents.length,
                  itemBuilder: (context, index) {
                    return buildStudentCard(filteredStudents[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
