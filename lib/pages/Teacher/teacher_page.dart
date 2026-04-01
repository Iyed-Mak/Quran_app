import 'package:flutter/material.dart';
import 'screens/student_list_screen.dart';
import 'screens/Daily_Evaluation_Screen.dart';
import 'screens/monthly_summary_screen.dart';
import 'screens/teacher_attendance_screen.dart';
import 'screens/student_data_screen.dart';

class TeacherDashboard extends StatelessWidget {
  final String teacherName;

  const TeacherDashboard({super.key, required this.teacherName});

  Widget _buildCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color startColor,
    required Color endColor,
    required Widget page,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Material(
        borderRadius: BorderRadius.circular(24),
        elevation: 8,
        shadowColor: endColor.withOpacity(0.6),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [startColor, endColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            splashColor: Colors.white24,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 50, color: Colors.white),
                SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Custom AppBar
      body: Column(
        children: [
          Stack(
            children: [
              // Curved gradient background
              Container(
                height: 180,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blueAccent, Colors.lightBlueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),
              // Teacher name and dashboard title
              Positioned(
                left: 20,
                bottom: 20,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        color: Colors.blueAccent,
                        size: 36,
                      ),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          teacherName, // Teacher name dynamically displayed
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'لوحة التحكم', // Updated Arabic title, keeps same sense
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Dashboard Grid
          Expanded(
            child: GridView.count(
              padding: EdgeInsets.all(16),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildCard(
                  context: context,
                  title: 'التقييم اليومي',
                  icon: Icons.check_circle_rounded,
                  startColor: Colors.blue,
                  endColor: Colors.lightBlueAccent,
                  page: DailyEvaluationScreen(),
                ),
                _buildCard(
                  context: context,
                  title: 'حضور وانصراف  الطلبة',
                  icon: Icons.group_rounded,
                  startColor: Colors.green,
                  endColor: Colors.lightGreenAccent,
                  page: StudentListScreen(),
                ),
                _buildCard(
                  context: context,
                  title: 'التقييم الشهري',
                  icon: Icons.calendar_month_rounded,
                  startColor: Colors.orange,
                  endColor: Colors.deepOrangeAccent,
                  page: MonthlySummaryScreen(),
                ),
                _buildCard(
                  context: context,
                  title: 'حضور وانصراف المدرس',
                  icon: Icons.person_rounded,
                  startColor: Colors.purple,
                  endColor: Colors.purpleAccent,
                  page: TeacherAttendanceScreen(),
                ),
                _buildCard(
                  context: context,
                  title: 'بيانات الطلاب',
                  icon: Icons.info_rounded,
                  startColor: Colors.teal,
                  endColor: Colors.cyan,
                  page: StudentDataScreen(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
