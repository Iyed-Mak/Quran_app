import 'package:flutter/material.dart';
import 'screens/student_list_screen.dart';
import 'screens/Daily_Evaluation_Screen.dart';
// import '../reports/monthly_summary_screen.dart';
// import '../students/student_profile_screen.dart';
// import 'teacher_attendance_screen.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('لوحة المعلم')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ElevatedButton(
            child: Text('اثبات حضور و انصراف الطلبة'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => StudentListScreen()),
              );
            },
          ),

          ElevatedButton(
            child: Text('التقييم اليومي'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DailyEvaluationScreen()),
              );
            },
          ),
          // ElevatedButton(
          //   child: Text('ملخص التقييم الشهري للحلقة'),
          //   onPressed: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (_) => MonthlySummaryScreen()));
          //   },
          // ),
          // ElevatedButton(
          //   child: Text('بيانات الطلاب'),
          //   onPressed: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (_) => StudentProfileScreen()));
          //   },
          // ),
          // ElevatedButton(
          //   child: Text('تسجيل حضور وانصراف المدرس'),
          //   onPressed: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (_) => TeacherAttendanceScreen()));
          //   },
          // ),
        ],
      ),
    );
  }
}
