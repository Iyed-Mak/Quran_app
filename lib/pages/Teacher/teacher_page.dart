import 'package:flutter/material.dart';
import 'screens/student_list_screen.dart';
import 'screens/daily_evaluation_screen.dart';
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
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Material(
        borderRadius: BorderRadius.circular(24),
        elevation: 12,
        shadowColor: endColor.withValues(alpha: 0.4),
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
            splashColor: Colors.white30,
            highlightColor: Colors.white10,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => page));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 40, color: Colors.white),
                ),
                SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 2,
                        offset: Offset(0.5, 0.5),
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
              // Enhanced curved gradient background with pattern
              Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blueAccent.shade700,
                      Colors.lightBlueAccent.shade200,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
              ),
              // Decorative elements
              Positioned(
                top: 20,
                right: 20,
                child: Icon(
                  Icons.school,
                  color: Colors.white.withValues(alpha: 0.3),
                  size: 60,
                ),
              ),
              Positioned(
                top: 80,
                left: 20,
                child: Icon(
                  Icons.book,
                  color: Colors.white.withValues(alpha: 0.2),
                  size: 40,
                ),
              ),
              // Teacher info section
              Positioned(
                left: 20,
                bottom: 30,
                right: 20,
                child: Row(
                  children: [
                    Hero(
                      tag: 'teacher_avatar',
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          color: Colors.blueAccent,
                          size: 40,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'مرحباً، $teacherName',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
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
                          SizedBox(height: 4),
                          Text(
                            'لوحة التحكم الخاصة بك',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Dashboard Grid with improved layout
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.1,
                children: [
                  _buildCard(
                    context: context,
                    title: 'التقييم اليومي',
                    icon: Icons.check_circle_rounded,
                    startColor: Colors.blue.shade600,
                    endColor: Colors.lightBlueAccent.shade200,
                    page: DailyEvaluationScreen(),
                  ),
                  _buildCard(
                    context: context,
                    title: 'حضور وانصراف الطلبة',
                    icon: Icons.group_rounded,
                    startColor: Colors.green.shade600,
                    endColor: Colors.lightGreenAccent.shade200,
                    page: StudentListScreen(),
                  ),
                  _buildCard(
                    context: context,
                    title: 'التقييم الشهري',
                    icon: Icons.calendar_month_rounded,
                    startColor: Colors.orange.shade600,
                    endColor: Colors.deepOrangeAccent.shade200,
                    page: MonthlySummaryScreen(),
                  ),
                  _buildCard(
                    context: context,
                    title: 'حضور وانصراف المدرس',
                    icon: Icons.person_rounded,
                    startColor: Colors.purple.shade600,
                    endColor: Colors.purpleAccent.shade200,
                    page: TeacherAttendanceScreen(),
                  ),
                  _buildCard(
                    context: context,
                    title: 'بيانات الطلاب',
                    icon: Icons.info_rounded,
                    startColor: Colors.teal.shade600,
                    endColor: Colors.cyan.shade200,
                    page: StudentDataScreen(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
