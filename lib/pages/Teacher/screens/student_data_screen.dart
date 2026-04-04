import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentDataScreen extends StatefulWidget {
  const StudentDataScreen({super.key});

  @override
  State<StudentDataScreen> createState() => _StudentDataScreenState();
}

class _StudentDataScreenState extends State<StudentDataScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, String>> students = [
    {"name": "أحمد", "age": "12", "level": "50", "phone": "0551234567"},
    {"name": "محمد", "age": "13", "level": "29", "phone": "0559876543"},
    {"name": "ليلى", "age": "10", "level": "60", "phone": "0554567890"},
    {"name": "فاطمة", "age": "11", "level": "27", "phone": "0554567891"},
    {"name": "أيمن", "age": "14", "level": "26", "phone": "0554567892"},
    {"name": "جمال", "age": "15", "level": "25", "phone": "0554567893"},
  ];

  List<Map<String, String>> filteredStudents = [];

  @override
  void initState() {
    super.initState();
    filteredStudents = students;
  }

  void searchStudent(String query) {
    setState(() {
      filteredStudents = students
          .where(
            (student) =>
                student["name"]!.toLowerCase().contains(query.toLowerCase()),
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
                // Call Button
                Align(
                  alignment: Alignment.centerRight,
                  child: Directionality(
                    textDirection:
                        TextDirection.rtl, // Force RTL inside the button
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
    return Scaffold(
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
    );
  }
}
