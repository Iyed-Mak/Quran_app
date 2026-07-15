import 'package:flutter/material.dart';

/// ملخص التقييم الشهري الإداري — مع تبويب الجنس
class MonthlySummaryScreen extends StatefulWidget {
  const MonthlySummaryScreen({super.key});

  @override
  State<MonthlySummaryScreen> createState() => _MonthlySummaryScreenState();
}

class _MonthlySummaryScreenState extends State<MonthlySummaryScreen>
    with SingleTickerProviderStateMixin {
  // ── ألوان وحدة الإدارة ──────────────────────────────────────────
  static const Color _gradientStart = Color(0xff1565C0);
  static const Color _gradientEnd = Color(0xff42A5F5);
  static const LinearGradient _appGradient = LinearGradient(
    colors: [_gradientStart, _gradientEnd],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  // ── تبويب الجنس ─────────────────────────────────────────────────
  late final TabController _tabCtrl;
  bool get _isFemale => _tabCtrl.index == 1;

  // ── جدول الجنس: true = أنثى، false = ذكر ───────────────────────
  static const Map<String, bool> _genderMap = {
    'أحمد': false,
    'محمد': false,
    'يوسف': false,
    'خالد': false,
    'عمر': false,
    'بلال': false,
    'ليلى': true,
    'فاطمة': true,
    'سارة': true,
    'نور': true,
    'ريم': true,
    'هند': true,
  };

  // ── أسماء المعلمين (مفصولة حسب الجنس) ──────────────────────────
  static const Map<String, String> _maleTeachers = {
    'فوج 1': 'أحمد بن علي',
    'فوج 2': 'يوسف الإدريسي',
  };
  static const Map<String, String> _femaleTeachers = {
    'فوج 1': 'سارة محمد',
    'فوج 2': 'فاطمة الزهراء',
  };
  Map<String, String> get _currentTeachers =>
      _isFemale ? _femaleTeachers : _maleTeachers;

  // ── فلاتر ────────────────────────────────────────────────────────
  static const List<Map<String, dynamic>> _months = [
    {'label': 'كل الأشهر', 'value': null},
    {'label': 'سبتمبر', 'value': 9},
    {'label': 'أكتوبر', 'value': 10},
    {'label': 'نوفمبر', 'value': 11},
    {'label': 'ديسمبر', 'value': 12},
    {'label': 'جانفي', 'value': 1},
    {'label': 'فيفري', 'value': 2},
    {'label': 'مارس', 'value': 3},
    {'label': 'افريل', 'value': 4},
    {'label': 'ماي', 'value': 5},
    {'label': 'جوان', 'value': 6},
  ];
  static const List<String> _academicYears = ['2025 / 2026', '2024 / 2025'];
  int? _selectedMonth;
  String _selectedYear = '2025 / 2026';

  // ── الأفواج الموسّعة (منفصلة حسب الجنس) ────────────────────────
  final _maleExpanded = <String>{'فوج 1', 'فوج 2'};
  final _femaleExpanded = <String>{'فوج 1', 'فوج 2'};
  Set<String> get _expandedGroups =>
      _isFemale ? _femaleExpanded : _maleExpanded;

  // ══════════════════════════════════════════════════════════════════
  // بيانات تجريبية (مشتركة — الفلترة تتم بـ _genderMap)
  // ══════════════════════════════════════════════════════════════════
  final Map<String, List<Map<String, dynamic>>> groupStudents = {
    'فوج 1': [
      {"name": "أحمد", "score": 18},
      {"name": "محمد", "score": 88},
      {"name": "ليلى", "score": 56},
      {"name": "فاطمة", "score": 100},
      {"name": "يوسف", "score": 84},
      {"name": "سارة", "score": 72},
    ],
    'فوج 2': [
      {"name": "خالد", "score": 91},
      {"name": "نور", "score": 65},
      {"name": "ريم", "score": 78},
      {"name": "عمر", "score": 45},
      {"name": "هند", "score": 88},
      {"name": "بلال", "score": 55},
    ],
  };

  final Map<String, Map<String, List<Map<String, dynamic>>>>
  groupSessionRecords = {
    'فوج 1': {
      'أحمد': [
        {
          'date': '01/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ربع',
          'revision': 'حزب',
          'score': '18',
        },
        {
          'date': '05/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ثمن',
          'revision': 'نصف',
          'score': '15',
        },
        {
          'date': '10/06/2025',
          'attendance': 'غائب',
          'memorization': '—',
          'revision': '—',
          'score': '—',
        },
        {
          'date': '15/06/2025',
          'attendance': 'حاضر',
          'memorization': 'نصف',
          'revision': 'حزب',
          'score': '17',
        },
        {
          'date': '20/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ربع',
          'revision': 'حزبين',
          'score': '19',
        },
        {
          'date': '25/06/2025',
          'attendance': 'حاضر',
          'memorization': 'حزب',
          'revision': 'حزبين',
          'score': '20',
        },
      ],
      'محمد': [
        {
          'date': '01/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ثمن',
          'revision': 'ربع',
          'score': '14',
        },
        {
          'date': '05/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ربع',
          'revision': 'حزب',
          'score': '16',
        },
        {
          'date': '10/06/2025',
          'attendance': 'حاضر',
          'memorization': 'نصف',
          'revision': 'نصف',
          'score': '15',
        },
        {
          'date': '15/06/2025',
          'attendance': 'غائب',
          'memorization': '—',
          'revision': '—',
          'score': '—',
        },
        {
          'date': '20/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ربع',
          'revision': 'حزب',
          'score': '17',
        },
        {
          'date': '25/06/2025',
          'attendance': 'حاضر',
          'memorization': 'نصف',
          'revision': 'حزبين',
          'score': '18',
        },
      ],
      'ليلى': [
        {
          'date': '01/06/2025',
          'attendance': 'حاضر',
          'memorization': 'لاشي',
          'revision': 'حزب',
          'score': '10',
        },
        {
          'date': '05/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ثمن',
          'revision': 'نصف',
          'score': '12',
        },
        {
          'date': '10/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ربع',
          'revision': 'ربع',
          'score': '13',
        },
        {
          'date': '15/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ثمن',
          'revision': 'حزب',
          'score': '11',
        },
        {
          'date': '20/06/2025',
          'attendance': 'غائب',
          'memorization': '—',
          'revision': '—',
          'score': '—',
        },
        {
          'date': '25/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ربع',
          'revision': 'نصف',
          'score': '14',
        },
      ],
      'فاطمة': [
        {
          'date': '01/06/2025',
          'attendance': 'حاضر',
          'memorization': 'حزب',
          'revision': 'حزبين',
          'score': '20',
        },
        {
          'date': '05/06/2025',
          'attendance': 'حاضر',
          'memorization': 'حزب',
          'revision': 'حزبين',
          'score': '20',
        },
        {
          'date': '10/06/2025',
          'attendance': 'حاضر',
          'memorization': 'نصف',
          'revision': 'حزب',
          'score': '19',
        },
        {
          'date': '15/06/2025',
          'attendance': 'حاضر',
          'memorization': 'حزب',
          'revision': 'حزبين',
          'score': '20',
        },
        {
          'date': '20/06/2025',
          'attendance': 'حاضر',
          'memorization': 'نصف',
          'revision': 'حزب',
          'score': '19',
        },
        {
          'date': '25/06/2025',
          'attendance': 'حاضر',
          'memorization': 'حزب',
          'revision': 'حزبين',
          'score': '20',
        },
      ],
      'يوسف': [
        {
          'date': '01/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ربع',
          'revision': 'نصف',
          'score': '16',
        },
        {
          'date': '05/06/2025',
          'attendance': 'غائب',
          'memorization': '—',
          'revision': '—',
          'score': '—',
        },
        {
          'date': '10/06/2025',
          'attendance': 'حاضر',
          'memorization': 'نصف',
          'revision': 'حزب',
          'score': '17',
        },
        {
          'date': '15/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ربع',
          'revision': 'نصف',
          'score': '15',
        },
        {
          'date': '20/06/2025',
          'attendance': 'حاضر',
          'memorization': 'نصف',
          'revision': 'حزب',
          'score': '18',
        },
        {
          'date': '25/06/2025',
          'attendance': 'حاضر',
          'memorization': 'حزب',
          'revision': 'حزبين',
          'score': '19',
        },
      ],
      'سارة': [
        {
          'date': '01/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ثمن',
          'revision': 'ربع',
          'score': '13',
        },
        {
          'date': '05/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ربع',
          'revision': 'نصف',
          'score': '14',
        },
        {
          'date': '10/06/2025',
          'attendance': 'غائب',
          'memorization': '—',
          'revision': '—',
          'score': '—',
        },
        {
          'date': '15/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ثمن',
          'revision': 'ربع',
          'score': '12',
        },
        {
          'date': '20/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ربع',
          'revision': 'حزب',
          'score': '15',
        },
        {
          'date': '25/06/2025',
          'attendance': 'حاضر',
          'memorization': 'نصف',
          'revision': 'حزب',
          'score': '16',
        },
      ],
    },
    'فوج 2': {
      'خالد': [
        {
          'date': '01/06/2025',
          'attendance': 'حاضر',
          'memorization': 'حزب',
          'revision': 'حزبين',
          'score': '20',
        },
        {
          'date': '05/06/2025',
          'attendance': 'حاضر',
          'memorization': 'نصف',
          'revision': 'حزب',
          'score': '19',
        },
        {
          'date': '10/06/2025',
          'attendance': 'حاضر',
          'memorization': 'حزب',
          'revision': 'حزبين',
          'score': '20',
        },
        {
          'date': '15/06/2025',
          'attendance': 'حاضر',
          'memorization': 'نصف',
          'revision': 'حزب',
          'score': '18',
        },
        {
          'date': '20/06/2025',
          'attendance': 'حاضر',
          'memorization': 'حزب',
          'revision': 'حزبين',
          'score': '20',
        },
        {
          'date': '25/06/2025',
          'attendance': 'غائب',
          'memorization': '—',
          'revision': '—',
          'score': '—',
        },
      ],
      'نور': [
        {
          'date': '01/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ثمن',
          'revision': 'ربع',
          'score': '12',
        },
        {
          'date': '05/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ربع',
          'revision': 'نصف',
          'score': '13',
        },
        {
          'date': '10/06/2025',
          'attendance': 'غائب',
          'memorization': '—',
          'revision': '—',
          'score': '—',
        },
        {
          'date': '15/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ثمن',
          'revision': 'حزب',
          'score': '14',
        },
        {
          'date': '20/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ربع',
          'revision': 'نصف',
          'score': '13',
        },
        {
          'date': '25/06/2025',
          'attendance': 'حاضر',
          'memorization': 'نصف',
          'revision': 'حزب',
          'score': '15',
        },
      ],
      'ريم': [
        {
          'date': '01/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ربع',
          'revision': 'حزب',
          'score': '16',
        },
        {
          'date': '05/06/2025',
          'attendance': 'حاضر',
          'memorization': 'نصف',
          'revision': 'نصف',
          'score': '15',
        },
        {
          'date': '10/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ربع',
          'revision': 'حزب',
          'score': '16',
        },
        {
          'date': '15/06/2025',
          'attendance': 'غائب',
          'memorization': '—',
          'revision': '—',
          'score': '—',
        },
        {
          'date': '20/06/2025',
          'attendance': 'حاضر',
          'memorization': 'نصف',
          'revision': 'حزبين',
          'score': '17',
        },
        {
          'date': '25/06/2025',
          'attendance': 'حاضر',
          'memorization': 'حزب',
          'revision': 'حزبين',
          'score': '18',
        },
      ],
      'عمر': [
        {
          'date': '01/06/2025',
          'attendance': 'غائب',
          'memorization': '—',
          'revision': '—',
          'score': '—',
        },
        {
          'date': '05/06/2025',
          'attendance': 'حاضر',
          'memorization': 'لاشي',
          'revision': 'ثمن',
          'score': '8',
        },
        {
          'date': '10/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ثمن',
          'revision': 'ربع',
          'score': '10',
        },
        {
          'date': '15/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ربع',
          'revision': 'نصف',
          'score': '11',
        },
        {
          'date': '20/06/2025',
          'attendance': 'غائب',
          'memorization': '—',
          'revision': '—',
          'score': '—',
        },
        {
          'date': '25/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ثمن',
          'revision': 'ربع',
          'score': '9',
        },
      ],
      'هند': [
        {
          'date': '01/06/2025',
          'attendance': 'حاضر',
          'memorization': 'نصف',
          'revision': 'حزب',
          'score': '18',
        },
        {
          'date': '05/06/2025',
          'attendance': 'حاضر',
          'memorization': 'حزب',
          'revision': 'حزبين',
          'score': '19',
        },
        {
          'date': '10/06/2025',
          'attendance': 'حاضر',
          'memorization': 'نصف',
          'revision': 'حزب',
          'score': '17',
        },
        {
          'date': '15/06/2025',
          'attendance': 'حاضر',
          'memorization': 'حزب',
          'revision': 'حزبين',
          'score': '20',
        },
        {
          'date': '20/06/2025',
          'attendance': 'غائب',
          'memorization': '—',
          'revision': '—',
          'score': '—',
        },
        {
          'date': '25/06/2025',
          'attendance': 'حاضر',
          'memorization': 'نصف',
          'revision': 'حزب',
          'score': '18',
        },
      ],
      'بلال': [
        {
          'date': '01/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ثمن',
          'revision': 'ربع',
          'score': '11',
        },
        {
          'date': '05/06/2025',
          'attendance': 'غائب',
          'memorization': '—',
          'revision': '—',
          'score': '—',
        },
        {
          'date': '10/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ربع',
          'revision': 'نصف',
          'score': '12',
        },
        {
          'date': '15/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ثمن',
          'revision': 'ربع',
          'score': '10',
        },
        {
          'date': '20/06/2025',
          'attendance': 'حاضر',
          'memorization': 'ربع',
          'revision': 'حزب',
          'score': '13',
        },
        {
          'date': '25/06/2025',
          'attendance': 'حاضر',
          'memorization': 'نصف',
          'revision': 'حزب',
          'score': '12',
        },
      ],
    },
  };

  // ══════════════════════════════════════════════════════════════════
  // مساعدات الفلترة حسب الجنس
  // ══════════════════════════════════════════════════════════════════

  /// طلبة الفوج المفلترون حسب الجنس الحالي
  List<Map<String, dynamic>> _genderedStudents(String group) =>
      (groupStudents[group] ?? [])
          .where((s) => (_genderMap[s['name']] ?? false) == _isFemale)
          .toList();

  /// سجلات الحلقات المفلترة حسب الجنس الحالي
  Map<String, List<Map<String, dynamic>>> _genderedSessions(String group) {
    final all = groupSessionRecords[group] ?? {};
    return {
      for (final e in all.entries)
        if ((_genderMap[e.key] ?? false) == _isFemale) e.key: e.value,
    };
  }

  // ══════════════════════════════════════════════════════════════════
  // Lifecycle
  // ══════════════════════════════════════════════════════════════════
  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this)
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  // ══════════════════════════════════════════════════════════════════
  // منطق الحساب (محفوظ من النسخة الأصلية + فلترة الجنس)
  // ══════════════════════════════════════════════════════════════════
  double _labelToHizbValue(String label) {
    switch (label) {
      case 'لاشي':
        return 0;
      case 'ثمن':
        return 0.125;
      case 'ربع':
        return 0.25;
      case 'نصف':
        return 0.5;
      case 'حزب':
        return 1;
      case 'حزبين':
        return 2;
      default:
        return 0;
    }
  }

  String _formatHizbTotal(double total) {
    if (total <= 0) return 'لاشي';
    final int whole = total.floor();
    final double frac = total - whole;
    if (frac >= 0.875) return '${whole + 1} حزب';
    String fracLabel = '';
    if (frac >= 0.375)
      fracLabel = 'ونصف';
    else if (frac >= 0.1875)
      fracLabel = 'وربع';
    else if (frac >= 0.0625)
      fracLabel = 'وثمن';
    if (whole == 0) {
      if (frac >= 0.375) return 'نصف حزب';
      if (frac >= 0.1875) return 'ربع حزب';
      if (frac >= 0.0625) return 'ثمن حزب';
      return 'لاشي';
    }
    return fracLabel.isEmpty ? '$whole حزب' : '$whole حزب $fracLabel';
  }

  List<Map<String, dynamic>> _computeGroupTotals(String group) {
    final students = _genderedStudents(group);
    final sessions = _genderedSessions(group);
    final result = <Map<String, dynamic>>[];

    for (final student in students) {
      final name = student['name'] as String;
      final records = sessions[name] ?? [];
      int absences = 0;
      double memTotal = 0, revTotal = 0;
      int scoreSum = 0, scoredCount = 0;

      for (final r in records) {
        if (r['attendance'] == 'غائب') {
          absences++;
          continue;
        }
        memTotal += _labelToHizbValue(r['memorization'] as String);
        revTotal += _labelToHizbValue(r['revision'] as String);
        final v = int.tryParse(r['score'].toString());
        if (v != null) {
          scoreSum += v;
          scoredCount++;
        }
      }

      result.add({
        'name': name,
        'absences': absences,
        'totalSessions': records.length,
        'totalMemorization': _formatHizbTotal(memTotal),
        'totalRevision': _formatHizbTotal(revTotal),
        'average': scoredCount > 0
            ? (scoreSum / scoredCount).toStringAsFixed(1)
            : '—',
        'rawAverage': scoredCount > 0 ? scoreSum / scoredCount : 0.0,
      });
    }
    return result;
  }

  // ── إحصائيات الفوج (مفلترة حسب الجنس) ───────────────────────────
  double _groupAvgScore(String group) {
    final totals = _computeGroupTotals(group);
    final valid = totals
        .map((t) => t['rawAverage'] as double)
        .where((v) => v > 0)
        .toList();
    return valid.isEmpty ? 0 : valid.reduce((a, b) => a + b) / valid.length;
  }

  double _groupAttendanceRate(String group) {
    final sessions = _genderedSessions(group);
    int total = 0, absences = 0;
    sessions.forEach((_, records) {
      total += records.length;
      absences += records.where((r) => r['attendance'] == 'غائب').length;
    });
    return total == 0 ? 100 : ((total - absences) / total * 100);
  }

  int _groupTotalAbsences(String group) {
    final sessions = _genderedSessions(group);
    return sessions.values.fold(
      0,
      (sum, recs) => sum + recs.where((r) => r['attendance'] == 'غائب').length,
    );
  }

  // ── إحصائيات إجمالية (مفلترة حسب الجنس) ─────────────────────────
  int get _totalStudentsForGender {
    return groupStudents.values.fold(
      0,
      (sum, list) =>
          sum +
          list
              .where((s) => (_genderMap[s['name']] ?? false) == _isFemale)
              .length,
    );
  }

  int get _totalAbsencesForGender {
    int total = 0;
    for (final g in _currentTeachers.keys) {
      total += _groupTotalAbsences(g);
    }
    return total;
  }

  double get _overallAvgScore {
    double sum = 0;
    int count = 0;
    for (final g in _currentTeachers.keys) {
      final s = _groupAvgScore(g);
      if (s > 0) {
        sum += s;
        count++;
      }
    }
    return count == 0 ? 0 : sum / count;
  }

  double get _overallAttendanceRate {
    double sum = 0;
    for (final g in _currentTeachers.keys) {
      sum += _groupAttendanceRate(g);
    }
    return _currentTeachers.isEmpty ? 0 : sum / _currentTeachers.length;
  }

  // ── ألوان ────────────────────────────────────────────────────────
  Color _scoreColor(double v) {
    if (v >= 16) return Colors.green.shade600;
    if (v >= 10) return Colors.orange.shade700;
    return Colors.red.shade600;
  }

  String _appreciation(double v) {
    if (v >= 18) return 'ممتاز';
    if (v >= 16) return 'جيد جداً';
    if (v >= 14) return 'جيد';
    if (v >= 10) return 'مقبول';
    return 'ضعيف';
  }

  Color _rateColor(double r) {
    if (r >= 90) return Colors.green.shade600;
    if (r >= 75) return Colors.orange.shade700;
    return Colors.red.shade600;
  }

  // ══════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final int maleCount = groupStudents.values.fold(
      0,
      (s, l) =>
          s + l.where((e) => (_genderMap[e['name']] ?? false) == false).length,
    );
    final int femaleCount = groupStudents.values.fold(
      0,
      (s, l) =>
          s + l.where((e) => (_genderMap[e['name']] ?? false) == true).length,
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: _appGradient),
          ),
          title: const Text(
            'ملخص التقييم الشهري',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          // ── تبويب الجنس ──
          bottom: TabBar(
            controller: _tabCtrl,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            tabs: [
              Tab(child: _tabLabel('👦  الطلبة', maleCount)),
              Tab(child: _tabLabel('👧  الطالبات', femaleCount)),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            controller: _tabCtrl,
            children: [_buildContent(), _buildContent()],
          ),
        ),
      ),
    );
  }

  // ── ترقيم التبويب ─────────────────────────────────────────────
  Widget _tabLabel(String label, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // محتوى كل تبويب (يشترك في نفس الويدجت لأن _isFemale يتغير تلقائياً)
  // ══════════════════════════════════════════════════════════════════
  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilters(),
          const SizedBox(height: 16),
          _buildSummaryCards(),
          const SizedBox(height: 18),
          _buildSectionLabel('ملخص الأفواج', Icons.groups_outlined),
          const SizedBox(height: 10),
          ..._currentTeachers.keys.map(
            (g) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _buildGroupCard(g),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // شريط الفلاتر
  // ══════════════════════════════════════════════════════════════════
  Widget _buildFilters() {
    return LayoutBuilder(
      builder: (ctx, box) {
        final bool isWide = box.maxWidth >= 560;
        final month = _buildDropdown<int?>(
          label: 'الشهر',
          icon: Icons.calendar_month_outlined,
          value: _selectedMonth,
          items: _months
              .map(
                (m) => DropdownMenuItem<int?>(
                  value: m['value'] as int?,
                  child: Text(m['label'] as String),
                ),
              )
              .toList(),
          onChanged: (v) => setState(() => _selectedMonth = v),
        );
        final year = _buildDropdown<String>(
          label: 'السنة الدراسية',
          icon: Icons.school_outlined,
          value: _selectedYear,
          items: _academicYears
              .map((y) => DropdownMenuItem(value: y, child: Text(y)))
              .toList(),
          onChanged: (v) {
            if (v != null) setState(() => _selectedYear = v);
          },
        );
        if (isWide) {
          return Row(
            children: [
              Expanded(flex: 2, child: month),
              const SizedBox(width: 12),
              Expanded(flex: 3, child: year),
            ],
          );
        }
        return Column(children: [month, const SizedBox(height: 10), year]);
      },
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required IconData icon,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      decoration: InputDecoration(
        hintText: label,
        prefixIcon: Icon(icon, size: 18, color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _gradientStart, width: 1.5),
        ),
      ),
      items: items,
      onChanged: onChanged,
      isExpanded: true,
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // بطاقات الإجماليات (مفلترة حسب الجنس)
  // ══════════════════════════════════════════════════════════════════
  Widget _buildSummaryCards() {
    final genderLabel = _isFemale ? 'الطالبات' : 'الطلبة';
    final cards = [
      _CardData(
        icon: Icons.group_work_outlined,
        label: 'عدد الأفواج',
        value: '${_currentTeachers.length}',
        color: Colors.blue.shade700,
      ),
      _CardData(
        icon: Icons.people_alt_outlined,
        label: 'إجمالي $genderLabel',
        value: '$_totalStudentsForGender',
        color: Colors.teal.shade600,
      ),
      _CardData(
        icon: Icons.event_busy_outlined,
        label: 'إجمالي الغيابات',
        value: '$_totalAbsencesForGender',
        color: Colors.red.shade600,
      ),
      _CardData(
        icon: Icons.star_outline,
        label: 'المتوسط العام للتقييم',
        value: '${_overallAvgScore.toStringAsFixed(1)} / 20',
        color: _scoreColor(_overallAvgScore),
      ),
      _CardData(
        icon: Icons.verified_user_outlined,
        label: 'معدل الحضور العام',
        value: '${_overallAttendanceRate.toStringAsFixed(1)}%',
        color: _rateColor(_overallAttendanceRate),
      ),
    ];
    return LayoutBuilder(
      builder: (ctx, box) {
        final cols = box.maxWidth >= 800
            ? 5
            : box.maxWidth >= 560
            ? 3
            : 2;
        const gap = 12.0;
        final cardW = (box.maxWidth - gap * (cols - 1)) / cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: cards
              .map((d) => SizedBox(width: cardW, child: _summaryCard(d)))
              .toList(),
        );
      },
    );
  }

  Widget _summaryCard(_CardData d) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(right: BorderSide(color: d.color, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: d.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(d.icon, color: d.color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  d.label,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  d.value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: d.color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // بطاقة الفوج (قابلة للتوسيع — مفلترة حسب الجنس)
  // ══════════════════════════════════════════════════════════════════
  Widget _buildGroupCard(String group) {
    final bool expanded = _expandedGroups.contains(group);
    final String teacher = _currentTeachers[group] ?? '—';
    final List<Map> gStudents = _genderedStudents(group);
    final double avgScore = _groupAvgScore(group);
    final double attendance = _groupAttendanceRate(group);
    final int totalAbsences = _groupTotalAbsences(group);
    final String genderLabel = _isFemale ? 'طالبة' : 'طالب';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // ── رأس الفوج ──────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(gradient: _appGradient),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _isFemale ? Icons.girl : Icons.boy,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            group,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          Text(
                            'الأستاذ${_isFemale ? 'ة' : ''}: $teacher',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // عدد الطلبة
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${gStudents.length} $genderLabel',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ── إحصائيات الفوج ──
                if (gStudents.isNotEmpty) ...[
                  Row(
                    children: [
                      Expanded(
                        child: _groupStat(
                          label: 'المتوسط',
                          value: '${avgScore.toStringAsFixed(1)}/20',
                          icon: Icons.star_half,
                          color: Colors.white,
                        ),
                      ),
                      _vDivider(),
                      Expanded(
                        child: _groupStat(
                          label: 'الحضور',
                          value: '${attendance.toStringAsFixed(1)}%',
                          icon: Icons.check_circle_outline,
                          color: Colors.white,
                        ),
                      ),
                      _vDivider(),
                      Expanded(
                        child: _groupStat(
                          label: 'الغيابات',
                          value: '$totalAbsences',
                          icon: Icons.event_busy_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // شريط التقدم
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: avgScore / 20,
                            minHeight: 7,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.25,
                            ),
                            valueColor: const AlwaysStoppedAnimation(
                              Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _appreciation(avgScore),
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: _scoreColor(avgScore),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                ] else ...[
                  const SizedBox(height: 8),
                ],

                // ── زر التوسيع ──
                if (gStudents.isNotEmpty)
                  GestureDetector(
                    onTap: () => setState(() {
                      if (expanded)
                        _expandedGroups.remove(group);
                      else
                        _expandedGroups.add(group);
                    }),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            expanded ? 'إخفاء التفاصيل' : 'عرض تفاصيل الطلبة',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            expanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── محتوى الجسم: جدول أو حالة فارغة ──────────────────
          if (gStudents.isEmpty)
            _buildEmptyState()
          else
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 280),
              crossFadeState: expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.table_chart_outlined,
                          size: 16,
                          color: _gradientStart,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'الملخص الشهري لكل ${_isFemale ? 'طالبة' : 'طالب'}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildStudentSummaryTable(group),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── حالة فارغة ───────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('📋', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 10),
            Text(
              'لا توجد بيانات لهذا الفوج.',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _groupStat({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color.withValues(alpha: 0.85), size: 16),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: color.withValues(alpha: 0.8), fontSize: 10.5),
        ),
      ],
    );
  }

  Widget _vDivider() => Container(
    width: 1,
    height: 36,
    color: Colors.white.withValues(alpha: 0.3),
  );

  // ══════════════════════════════════════════════════════════════════
  // جدول ملخص الطلبة
  // ══════════════════════════════════════════════════════════════════
  Widget _buildStudentSummaryTable(String group) {
    final totals = _computeGroupTotals(group);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width - 64,
          ),
          child: Column(
            children: [
              // ── ترويسة ──
              Container(
                color: _gradientStart.withValues(alpha: 0.08),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                child: Row(
                  children: [
                    _th('الطالب${_isFemale ? 'ة' : ''}', w: 110),
                    _th('الغيابات', w: 80),
                    _th('الحفظ الإجمالي', w: 130),
                    _th('المراجعة الإجمالية', w: 140),
                    _th('متوسط التقييم', w: 115),
                    _th('التقدير', w: 90),
                  ],
                ),
              ),
              // ── صفوف ──
              ...totals.asMap().entries.map((e) {
                final i = e.key;
                final row = e.value;
                final raw = row['rawAverage'] as double;
                return Container(
                  color: i.isEven ? Colors.white : Colors.grey.shade50,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 10,
                  ),
                  child: Row(
                    children: [
                      // الاسم
                      SizedBox(
                        width: 110,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 13,
                              backgroundColor: _gradientStart.withValues(
                                alpha: 0.1,
                              ),
                              child: Text(
                                (row['name'] as String).isNotEmpty
                                    ? (row['name'] as String)[0]
                                    : '؟',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: _gradientStart,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                row['name'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.5,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // الغيابات
                      SizedBox(
                        width: 80,
                        child: Center(
                          child: _absenceBadge(
                            row['absences'] as int,
                            row['totalSessions'] as int,
                          ),
                        ),
                      ),
                      // الحفظ
                      SizedBox(
                        width: 130,
                        child: Center(
                          child: _progressChip(
                            '${row["totalMemorization"]}',
                            Colors.blue.shade700,
                            Colors.blue.shade50,
                            Colors.blue.shade200,
                          ),
                        ),
                      ),
                      // المراجعة
                      SizedBox(
                        width: 140,
                        child: Center(
                          child: _progressChip(
                            '${row["totalRevision"]}',
                            Colors.indigo.shade700,
                            Colors.indigo.shade50,
                            Colors.indigo.shade100,
                          ),
                        ),
                      ),
                      // المتوسط
                      SizedBox(
                        width: 115,
                        child: Center(
                          child: row['average'] == '—'
                              ? Text(
                                  '—',
                                  style: TextStyle(color: Colors.grey[400]),
                                )
                              : _scoreBadge('${row["average"]}/20', raw),
                        ),
                      ),
                      // التقدير
                      SizedBox(
                        width: 90,
                        child: Center(
                          child: row['average'] == '—'
                              ? Text(
                                  '—',
                                  style: TextStyle(color: Colors.grey[400]),
                                )
                              : _appreciationBadge(raw),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _th(String label, {required double w}) {
    return SizedBox(
      width: w,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: Colors.blue.shade900,
        ),
      ),
    );
  }

  Widget _absenceBadge(int absences, int total) {
    final Color c = absences == 0 ? Colors.green.shade600 : Colors.red.shade600;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: c.withValues(alpha: 0.3)),
      ),
      child: Text(
        '$absences / $total',
        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: c),
      ),
    );
  }

  Widget _progressChip(String label, Color text, Color bg, Color border) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: text,
        ),
      ),
    );
  }

  Widget _scoreBadge(String label, double raw) {
    final Color c = _scoreColor(raw);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: c.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: c),
      ),
    );
  }

  Widget _appreciationBadge(double raw) {
    final Color c = _scoreColor(raw);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.withValues(alpha: 0.35)),
      ),
      child: Text(
        _appreciation(raw),
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: c),
      ),
    );
  }

  Widget _buildSectionLabel(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: _gradientStart, size: 20),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade900,
          ),
        ),
      ],
    );
  }
}

// ── نموذج بطاقة الملخص ──
class _CardData {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _CardData({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}
