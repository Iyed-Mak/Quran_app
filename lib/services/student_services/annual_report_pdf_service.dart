import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:quran_app/services/student_services/student_info.dart';
import 'package:quran_app/utils/date_formatter.dart';

/// خدمة مسؤولة فقط عن توليد كشف النقاط السنوي بصيغة PDF وحفظه على
/// جهاز المستخدم.
///
/// تم فصل هذا المنطق بالكامل عن الواجهة (UI) حتى تبقى
/// `assessment_results_screen.dart` خالية من أي تفاصيل متعلقة بإنشاء
/// أو حفظ الملفات (Clean Architecture / Separation of Concerns).
///
/// ملاحظة حول الحفظ: يتم حفظ الملف داخل مجلد التطبيق الخاص
/// (Application Documents Directory) عبر حزمة path_provider، وهو مسار
/// يعمل على أندرويد و iOS بدون الحاجة لطلب أي صلاحيات تخزين إضافية.
/// إذا احتجت لاحقًا لحفظه في مجلد "التنزيلات" العام، فذلك يتطلب صلاحيات
/// تخزين إضافية وخارج نطاق هذا التحديث (لا يوجد مشاركة أو معاينة هنا).
class AnnualReportPdfService {
  AnnualReportPdfService._(); // فئة Static فقط - لا حاجة لإنشاء كائن منها.

  static pw.Font? _regularFont;
  static pw.Font? _boldFont;

  /// يحمّل خط Cairo العربي من الأصول (assets) مرة واحدة فقط، ثم يعيد
  /// استخدام النسخة المحمّلة في كل توليد لاحق لتحسين الأداء.
  ///
  /// ملاحظة تشخيصية: إذا ظهرت رسائل مثل "Helvetica-Bold has no Unicode
  /// support" في الـ console فهذا يعني أن الخط المخصّص لم يُحمَّل
  /// إطلاقًا (وليس أنه نُقص بعض الحروف). أكثر سببين شائعين لذلك:
  /// 1) تعديل pubspec.yaml ثم تنفيذ Hot Reload فقط بدل Hot Restart/
  ///    flutter run من جديد (تغييرات pubspec.yaml لا تُطبَّق بالـ Hot
  ///    Reload أبدًا، فقط بإعادة تشغيل كاملة).
  /// 2) ملفات الخط غير موجودة فعليًا في assets/fonts/ بنفس الاسم
  ///    المستخدم هنا تمامًا.
  static Future<void> _loadFonts() async {
    if (_regularFont != null && _boldFont != null) return; // محمّل مسبقًا
    try {
      final regularData = await rootBundle.load(
        'assets/fonts/Cairo-Regular.ttf',
      );
      final boldData = await rootBundle.load('assets/fonts/Cairo-Bold.ttf');
      _regularFont = pw.Font.ttf(regularData);
      _boldFont = pw.Font.ttf(boldData);
      // ignore: avoid_print
      print('✅ AnnualReportPdfService: تم تحميل خط Cairo العربي بنجاح.');
    } catch (e) {
      // نرمي خطأً واضحًا بدل ترك الكود يستمر بصمت ويستخدم خط Helvetica
      // الافتراضي (الذي لا يدعم العربية إطلاقًا).
      // ignore: avoid_print
      print(
        '❌ AnnualReportPdfService: فشل تحميل خط Cairo. تأكد من: '
        '1) وجود الملفات في assets/fonts/Cairo-Regular.ttf و Cairo-Bold.ttf، '
        '2) أنك نفّذت flutter pub get ثم Hot Restart كامل (لا يكفي Hot Reload). '
        'الخطأ الأصلي: $e',
      );
      rethrow;
    }
  }

  /// يولّد كشف النقاط السنوي الكامل بصيغة PDF (تنسيق A4) ويحفظه على
  /// الجهاز. يُعيد [File] الناتج عند النجاح، أو يرمي استثناءً عند الفشل
  /// (يُترك التعامل مع الاستثناء للواجهة لعرض رسالة مناسبة للمستخدم).
  static Future<File> generateAndSaveAnnualReport({
    required StudentInfo studentInfo,
    required List<String> tabLabels,
    required List<String> subjects,
    required List<List<List<double?>>> semesterGrades,
    required double? Function(int semesterIndex) semesterAverageFn,
    required double? Function() annualAverageFn,
    required double? Function(double? exam, double? continuous) finalFn,
    required String Function(double?) fmtFn,
    required String Function(double?) appreciationFn,
  }) async {
    await _loadFonts();

    final pw.Font regular = _regularFont!;
    final pw.Font bold = _boldFont!;

    final double? annualAvg = annualAverageFn();
    final String issueDate = _formatDate(DateTime.now());

    final pw.Document doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        theme: pw.ThemeData.withFont(base: regular, bold: bold),
        textDirection: pw.TextDirection.rtl,
        header: (context) {
          // الترويسة تظهر فقط في أول صفحة لتجنّب تكرارها إن امتدّ
          // التقرير لأكثر من صفحة واحدة.
          if (context.pageNumber != 1) return pw.SizedBox();
          return _buildHeader(bold: bold, regular: regular);
        },
        footer: (context) => _buildFooter(
          regular: regular,
          issueDate: issueDate,
          pageNumber: context.pageNumber,
          pagesCount: context.pagesCount,
        ),
        build: (context) => [
          pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildStudentInfoBlock(
                  studentInfo,
                  bold: bold,
                  regular: regular,
                ),
                pw.SizedBox(height: 16),

                // قسم لكل فصل دراسي (الفصل الأول/الثاني/الثالث/الدورة الصيفية)
                ...List.generate(tabLabels.length, (i) {
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildSemesterSection(
                        title: tabLabels[i],
                        subjects: subjects,
                        grades: semesterGrades[i],
                        semesterAverage: semesterAverageFn(i),
                        finalFn: finalFn,
                        fmtFn: fmtFn,
                        appreciationFn: appreciationFn,
                        bold: bold,
                        regular: regular,
                      ),
                      pw.SizedBox(height: 14),
                    ],
                  );
                }),

                pw.SizedBox(height: 6),
                _buildAnnualAverageBlock(
                  annualAvg: annualAvg,
                  fmtFn: fmtFn,
                  appreciationFn: appreciationFn,
                  bold: bold,
                  regular: regular,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final List<int> bytes = await doc.save();
    return _saveToDevice(bytes);
  }

  // -----------------------------------------------------------------
  // بناء أجزاء التقرير
  // -----------------------------------------------------------------

  static pw.Widget _buildHeader({
    required pw.Font bold,
    required pw.Font regular,
  }) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      margin: const pw.EdgeInsets.only(bottom: 14),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromInt(
          0xFF2E7D32,
        ), // نفس درجة الأخضر المستخدمة في التطبيق
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            'كشف النقاط الرسمي',
            style: pw.TextStyle(
              font: bold,
              fontSize: 20,
              color: PdfColors.white,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'مركز تعليم القرآن الكريم — التقرير السنوي',
            style: pw.TextStyle(
              font: regular,
              fontSize: 12,
              color: PdfColors.white,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter({
    required pw.Font regular,
    required String issueDate,
    required int pageNumber,
    required int pagesCount,
  }) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 10),
      child: pw.Column(
        children: [
          pw.Divider(color: PdfColors.grey300),
          pw.SizedBox(height: 4),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'تاريخ إصدار كشف النقاط: $issueDate',
                style: pw.TextStyle(
                  font: regular,
                  fontSize: 9,
                  color: PdfColors.grey600,
                ),
              ),
              pw.Text(
                'صفحة $pageNumber من $pagesCount',
                style: pw.TextStyle(
                  font: regular,
                  fontSize: 9,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildStudentInfoBlock(
    StudentInfo info, {
    required pw.Font bold,
    required pw.Font regular,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromInt(0xFFE8F5E9),
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: PdfColor.fromInt(0xFFA5D6A7)),
      ),
      child: pw.Row(
        children: [
          _infoCell('اسم الطالب', info.name, bold: bold, regular: regular),
          _infoCell(
            'رقم التسجيل',
            info.registrationNumber,
            bold: bold,
            regular: regular,
          ),
          _infoCell('الفوج', info.group, bold: bold, regular: regular),
          _infoCell(
            'السنة الدراسية',
            info.academicYear,
            bold: bold,
            regular: regular,
            isLast: true,
          ),
        ],
      ),
    );
  }

  static pw.Widget _infoCell(
    String label,
    String value, {
    required pw.Font bold,
    required pw.Font regular,
    bool isLast = false,
  }) {
    return pw.Expanded(
      child: pw.Container(
        margin: isLast ? pw.EdgeInsets.zero : const pw.EdgeInsets.only(left: 6),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              label,
              style: pw.TextStyle(
                font: regular,
                fontSize: 9,
                color: PdfColors.grey700,
              ),
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              value,
              style: pw.TextStyle(
                font: bold,
                fontSize: 11.5,
                color: PdfColor.fromInt(0xFF1B5E20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// يبني جدول مادة واحدة لكل فصل دراسي: المادة / الامتحان / التقييم
  /// المستمر / المعدل النهائي، إضافةً إلى معدل الفصل في الأسفل.
  ///
  /// ملاحظة: نعتمد طول قائمة subjects (وليس طول grades) عند البناء،
  /// تمامًا كما تفعل شاشة النتائج الأصلية (_buildResultsTable) - حتى
  /// يبقى محتوى PDF مطابقًا تمامًا لما يراه الطالب في الشاشة.
  static pw.Widget _buildSemesterSection({
    required String title,
    required List<String> subjects,
    required List<List<double?>> grades,
    required double? semesterAverage,
    required double? Function(double?, double?) finalFn,
    required String Function(double?) fmtFn,
    required String Function(double?) appreciationFn,
    required pw.Font bold,
    required pw.Font regular,
  }) {
    final List<String> headers = [
      'المادة',
      'الامتحان (/20)',
      'التقييم المستمر (/20)',
      'المعدل النهائي',
    ];

    final List<List<String>> data = List.generate(subjects.length, (i) {
      final double? exam = grades[i][0];
      final double? cont = grades[i][1];
      final double? fin = finalFn(exam, cont);
      return [subjects[i], fmtFn(exam), fmtFn(cont), fmtFn(fin)];
    });

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: pw.BoxDecoration(
            color: PdfColor.fromInt(0xFF388E3C),
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Text(
            title,
            style: pw.TextStyle(
              font: bold,
              fontSize: 13,
              color: PdfColors.white,
            ),
          ),
        ),
        pw.SizedBox(height: 6),
        pw.TableHelper.fromTextArray(
          headers: headers,
          data: data,
          headerStyle: pw.TextStyle(
            font: bold,
            fontSize: 10,
            color: PdfColors.white,
          ),
          headerDecoration: pw.BoxDecoration(
            color: PdfColor.fromInt(0xFF66BB6A),
          ),
          cellStyle: pw.TextStyle(font: regular, fontSize: 10),
          cellAlignment: pw.Alignment.center,
          cellAlignments: {0: pw.Alignment.centerRight},
          oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
          border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.6),
          cellPadding: const pw.EdgeInsets.symmetric(
            vertical: 6,
            horizontal: 6,
          ),
        ),
        pw.SizedBox(height: 6),
        pw.Align(
          alignment: pw.Alignment.centerLeft,
          child: pw.Text(
            semesterAverage != null
                ? 'معدل الفصل: ${fmtFn(semesterAverage)} / 20   —   ${appreciationFn(semesterAverage)}'
                : 'معدل الفصل: بيانات غير مكتملة',
            style: pw.TextStyle(
              font: bold,
              fontSize: 11,
              color: PdfColor.fromInt(0xFF2E7D32),
            ),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildAnnualAverageBlock({
    required double? annualAvg,
    required String Function(double?) fmtFn,
    required String Function(double?) appreciationFn,
    required pw.Font bold,
    required pw.Font regular,
  }) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromInt(0xFF2E7D32),
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'المعدل السنوي العام',
                style: pw.TextStyle(
                  font: regular,
                  fontSize: 11,
                  color: PdfColors.white,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                annualAvg != null ? '${fmtFn(annualAvg)} / 20' : 'غير مكتمل',
                style: pw.TextStyle(
                  font: bold,
                  fontSize: 20,
                  color: PdfColors.white,
                ),
              ),
            ],
          ),
          if (annualAvg != null)
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: pw.BoxDecoration(
                color: PdfColors.white,
                borderRadius: pw.BorderRadius.circular(16),
              ),
              child: pw.Text(
                appreciationFn(annualAvg),
                style: pw.TextStyle(
                  font: bold,
                  fontSize: 12,
                  color: PdfColor.fromInt(0xFF2E7D32),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // -----------------------------------------------------------------
  // أدوات مساعدة (تنسيق التاريخ / الحفظ على الجهاز)
  // -----------------------------------------------------------------

  static String _formatDate(DateTime? d) => formatDzDate(d);

  /// يحفظ بايتات الـ PDF داخل مجلد التطبيق على الجهاز ويُعيد ملف [File].
  /// تم اختيار اسم ملف بحروف لاتينية فقط لتجنّب أي مشاكل محتملة مع
  /// أنظمة ملفات أو إصدارات أندرويد قديمة لا تتعامل بشكل جيد مع أسماء
  /// ملفات بحروف عربية.
  static Future<File> _saveToDevice(List<int> bytes) async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final String fileName =
        'annual_report_card_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final File file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}
