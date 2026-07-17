import 'package:flutter/material.dart';
import 'package:quran_app/pages/Student/screens/home_work_screen.dart';
import 'package:quran_app/pages/Student/screens/student_profile_screen.dart';
import 'package:quran_app/pages/Student/screens/assessment_results_screen.dart';
import 'package:quran_app/pages/Student/screens/study_schedule_screen.dart';
import 'package:quran_app/pages/Student/screens/exam_schedule_screen.dart';
import 'package:quran_app/pages/Student/screens/announcements_screen.dart';
import 'package:quran_app/pages/Student/screens/required_files_screen.dart';

import 'package:quran_app/pages/login_page.dart';

class StudentPage extends StatelessWidget {
  final String studentName;

  const StudentPage({super.key, required this.studentName});

  void _logout(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
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
                  top: 30,
                  right: 20,
                  child: Icon(
                    Icons.school,
                    color: Colors.white.withValues(alpha: 0.3),
                    size: 60,
                  ),
                ),
                Positioned(
                  top: 100,
                  left: 20,
                  child: Icon(
                    Icons.book,
                    color: Colors.white.withValues(alpha: 0.2),
                    size: 40,
                  ),
                ),
                // Logout button
                Positioned(
                  top: 40,
                  left: 20,
                  child: Material(
                    color: Colors.white24,
                    shape: const CircleBorder(),
                    child: IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      tooltip: 'تسجيل الخروج',
                      onPressed: () => _logout(context),
                    ),
                  ),
                ),
                // Student info section
                Positioned(
                  left: 20,
                  bottom: 30,
                  right: 20,
                  child: Row(
                    children: [
                      Hero(
                        tag: 'student_avatar',
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
                              'مرحباً، $studentName',
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
            // Dashboard Grid with improved layout — fully responsive
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double width = constraints.maxWidth;

                  // Responsive breakpoints: mobile / tablet / desktop
                  final int crossAxisCount = width >= 1000
                      ? 4
                      : width >= 600
                      ? 3
                      : 2;

                  final double childAspectRatio = width >= 1000
                      ? 1.15
                      : width >= 600
                      ? 1.1
                      : 1.05;

                  final double horizontalPadding = width >= 1000
                      ? 32
                      : width >= 600
                      ? 24
                      : 16;

                  final double maxContentWidth = width >= 1000 ? 1100 : width;

                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxContentWidth),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: 5,
                        ),
                        child: GridView.count(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: childAspectRatio,
                          children: [
                            _buildCard(
                              context: context,
                              title: 'الملف الشخصي للطالب',
                              icon: Icons.person_outline,
                              startColor: Colors.blue.shade600,
                              endColor: Colors.lightBlueAccent.shade200,
                              page: const StudentProfileScreen(),
                            ),
                            _buildCard(
                              context: context,
                              title: 'نتائج الاختبارات',
                              icon: Icons.bar_chart_outlined,
                              startColor: Colors.green.shade600,
                              endColor: Colors.lightGreenAccent.shade200,
                              page: const AssessmentResultsScreen(),
                            ),
                            _buildCard(
                              context: context,
                              title: 'البرنامج الدراسي',
                              icon: Icons.menu_book_outlined,
                              startColor: Colors.orange.shade600,
                              endColor: Colors.deepOrangeAccent.shade200,
                              page: const StudyScheduleScreen(),
                            ),
                            _buildCard(
                              context: context,
                              title: 'جدول الاختبارات',
                              icon: Icons.event_note_outlined,
                              startColor: Colors.purple.shade600,
                              endColor: Colors.purpleAccent.shade200,
                              page: const ExamScheduleScreen(),
                            ),
                            _buildCard(
                              context: context,
                              title: 'الإعلانات والتنبيهات',
                              icon: Icons.notifications_outlined,
                              startColor: Colors.teal.shade600,
                              endColor: Colors.cyan.shade200,
                              page: const AnnouncementsScreen(),
                            ),
                            _buildCard(
                              context: context,
                              title: 'الواجبات والمهام',
                              icon: Icons.assignment_outlined,
                              endColor: Colors.pinkAccent.shade200,
                              startColor: Colors.pink.shade600,
                              page: const HomeworkScreen(),
                            ),
                            _buildCard(
                              context: context,
                              title: 'الملفات المطلوبة',
                              icon: Icons.folder_open_outlined,
                              startColor: Colors.blue.shade700,
                              endColor: Colors.lightBlueAccent.shade200,
                              page: StudentRequiredFilesScreen(studentName: studentName),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
