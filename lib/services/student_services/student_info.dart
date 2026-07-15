/// نموذج بيانات الطالب المستخدمة في كشف النقاط السنوي.
///
/// بيانات تجريبية (Mock) فقط - لا يوجد أي اتصال بقاعدة بيانات أو
/// واجهة خلفية (API). هذا النموذج موجود فقط لتجميع الحقول المطلوبة
/// في الـ PDF بشكل منظّم بدل تمرير عدة معاملات نصية منفصلة.
class StudentInfo {
  final String name;
  final String registrationNumber;
  final String group;
  final String academicYear;

  const StudentInfo({
    required this.name,
    required this.registrationNumber,
    required this.group,
    required this.academicYear,
  });
}
