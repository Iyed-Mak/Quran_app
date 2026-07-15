import 'package:flutter/material.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen>
    with SingleTickerProviderStateMixin {
  String selectedGroup = 'فوج 1';

  final List<String> groups = ['فوج 1', 'فوج 2'];

  final Map<String, Map<String, bool>> groupStudents = {
    'فوج 1': {
      'عافري أحمد': false,
      'عياد محمد': true,
      'ليلى': false,
      'فاطمة': true,
      'يوسف': false,
      'سارة': true,
      'أحمد': false,
      'محمد': true,
      'سيف': false,
      'جميل': true,
      'قود': false,
      'ايمن': true,
    },
    'فوج 2': {
      'خالد': false,
      'نور': true,
      'ريم': false,
      'عمر': true,
      'هند': false,
      'بلال': true,
    },
  };

  Map<String, bool> get students => groupStudents[selectedGroup]!;

  @override
  Widget build(BuildContext context) {
    int presentCount = students.values.where((v) => v).length;
    int absentCount = students.length - presentCount;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[700],
          title: const Text(
            'قائمة الطلبة',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Column(
          children: [
            // Gradient Header with Summary
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green[600]!, Colors.green[400]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'تسجيل الحضور',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCounter('حاضر', presentCount, Colors.green[900]!),
                      const SizedBox(width: 24),
                      _buildCounter('غائب', absentCount, Colors.red[700]!),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Group Selector ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.shade50,
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
                      color: Colors.green[700],
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
                                color: Colors.green[800],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.group,
                              color: Colors.green[700],
                              size: 20,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGroup = value!;
                      });
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: students.isEmpty
                  ? Center(
                      child: Text(
                        'لا يوجد طلاب بعد',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        String name = students.keys.elementAt(index);
                        bool isPresent = students[name]!;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: isPresent
                                ? Colors.green[50]
                                : Colors.red[50],
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isPresent
                                  ? Colors.green[400]
                                  : Colors.red[400],
                              child: Text(
                                name[0],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              name,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.green[900],
                              ),
                            ),
                            trailing: Switch(
                              value: isPresent,
                              activeThumbColor: Colors.green[700],
                              onChanged: (val) {
                                setState(() {
                                  groupStudents[selectedGroup]![name] = val;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor: Colors.green[700],
                elevation: 6,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم حفظ الحضور بنجاح - $selectedGroup'),
                  ),
                );
              },
              child: const Text(
                'حفظ الحضور',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCounter(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 16, color: color)),
      ],
    );
  }
}
