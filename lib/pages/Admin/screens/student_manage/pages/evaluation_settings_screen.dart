import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════════
// نموذج إعدادات التقييم — مشترك بين صفحتَي النتائج والإعدادات
// ═══════════════════════════════════════════════════════════════════

class EvalSettings {
  final double examWeight; // نسبة الامتحان (0.10 – 0.90)
  final int examsPerPeriod; // عدد الاختبارات لكل فترة (1-5)
  final bool summerEnabled; // تفعيل الدورة الصيفية في المعدل السنوي

  const EvalSettings({
    this.examWeight = 0.60,
    this.examsPerPeriod = 3,
    this.summerEnabled = true,
  });

  double get contWeight => 1.0 - examWeight;
  int get examPct => (examWeight * 100).round();
  int get contPct => 100 - examPct;
  int get activePeriodCount => summerEnabled ? 4 : 3;

  EvalSettings copyWith({
    double? examWeight,
    int? examsPerPeriod,
    bool? summerEnabled,
  }) => EvalSettings(
    examWeight: examWeight ?? this.examWeight,
    examsPerPeriod: examsPerPeriod ?? this.examsPerPeriod,
    summerEnabled: summerEnabled ?? this.summerEnabled,
  );
}

// ═══════════════════════════════════════════════════════════════════
// شاشة إعدادات التقييم
// ═══════════════════════════════════════════════════════════════════

class EvaluationSettingsScreen extends StatefulWidget {
  const EvaluationSettingsScreen({super.key, required this.settings});
  final EvalSettings settings;

  @override
  State<EvaluationSettingsScreen> createState() =>
      _EvaluationSettingsScreenState();
}

class _EvaluationSettingsScreenState extends State<EvaluationSettingsScreen> {
  static const Color _gs = Color(0xff1565C0);
  static const Color _ge = Color(0xff42A5F5);
  static const LinearGradient _grad = LinearGradient(
    colors: [_gs, _ge],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  late double _examWeight;
  late int _examsPerPeriod;
  late bool _summerEnabled;

  @override
  void initState() {
    super.initState();
    _examWeight = widget.settings.examWeight;
    _examsPerPeriod = widget.settings.examsPerPeriod;
    _summerEnabled = widget.settings.summerEnabled;
  }

  int get _examPct => (_examWeight * 100).round();
  int get _contPct => 100 - _examPct;
  EvalSettings get _current => EvalSettings(
    examWeight: _examWeight,
    examsPerPeriod: _examsPerPeriod,
    summerEnabled: _summerEnabled,
  );

  void _save() => Navigator.pop(context, _current);

  @override
  Widget build(BuildContext context) {
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
            decoration: const BoxDecoration(gradient: _grad),
          ),
          title: const Text(
            'إعدادات التقييم',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          actions: [
            TextButton(
              onPressed: _save,
              child: const Text(
                'حفظ',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFormulaCard(),
                const SizedBox(height: 14),
                _buildWeightCard(),
                const SizedBox(height: 14),
                _buildExamsCountCard(),
                const SizedBox(height: 14),
                _buildSummerCard(),
                const SizedBox(height: 14),
                _buildAnnualFormulaCard(),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _save,
                    style: FilledButton.styleFrom(
                      backgroundColor: _gs,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.save_outlined),
                    label: const Text(
                      'حفظ الإعدادات',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── معاينة صيغة الحساب ──────────────────────────────────────────
  Widget _buildFormulaCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: _grad,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: _gs.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.functions_outlined,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'معاينة صيغة الحساب',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'معدل الفترة =',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13.5,
                      height: 1.6,
                    ),
                    children: [
                      const TextSpan(text: '( '),
                      const TextSpan(
                        text: 'متوسط الامتحانات',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(
                        text: '  ×  $_examPct%',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: ' )'),
                      const TextSpan(text: '  +  '),
                      const TextSpan(text: '( '),
                      const TextSpan(
                        text: 'التقييم المستمر',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(
                        text: '  ×  $_contPct%',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: ' )'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── ضبط النسب ───────────────────────────────────────────────────
  Widget _buildWeightCard() {
    return _settingsCard(
      title: 'نسبة الامتحان والتقييم المستمر',
      icon: Icons.pie_chart_outline,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'نسبة الامتحان',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _gs.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$_examPct%',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _gs,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: _gs,
                        thumbColor: _gs,
                        inactiveTrackColor: Colors.grey.shade200,
                        overlayColor: _gs.withValues(alpha: 0.1),
                      ),
                      child: Slider(
                        value: _examWeight,
                        min: 0.10,
                        max: 0.90,
                        divisions: 16,
                        onChanged: (v) => setState(() => _examWeight = v),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.lock_outline, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 6),
                  Text(
                    'نسبة التقييم المستمر',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Text(
                  '$_contPct%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade700,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'تُحسب تلقائياً: 100% − نسبة الامتحان = $_contPct%',
            style: TextStyle(fontSize: 11, color: Colors.grey[500]),
          ),
          const SizedBox(height: 8),
          // Visual weight bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: [
                Expanded(
                  flex: _examPct,
                  child: Container(
                    height: 20,
                    color: _gs,
                    child: Center(
                      child: Text(
                        'الامتحان $_examPct%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: _contPct,
                  child: Container(
                    height: 20,
                    color: Colors.orange.shade400,
                    child: Center(
                      child: Text(
                        'مستمر $_contPct%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── عدد الاختبارات ──────────────────────────────────────────────
  Widget _buildExamsCountCard() {
    return _settingsCard(
      title: 'عدد الاختبارات لكل فترة',
      icon: Icons.quiz_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'اختر عدد الاختبارات التي تُجرى في كل فترة دراسية:',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final n = i + 1;
              final sel = _examsPerPeriod == n;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: GestureDetector(
                  onTap: () => setState(() => _examsPerPeriod = n),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: sel ? _gs : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: sel ? _gs : Colors.grey.shade300,
                        width: sel ? 2 : 1,
                      ),
                      boxShadow: sel
                          ? [
                              BoxShadow(
                                color: _gs.withValues(alpha: 0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        '$n',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: sel ? Colors.white : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              'الإعداد الحالي: $_examsPerPeriod اختبار${_examsPerPeriod > 2 ? "ات" : (_examsPerPeriod == 1 ? "" : "ان")} لكل فترة',
              style: TextStyle(
                fontSize: 12,
                color: _gs,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── الدورة الصيفية ───────────────────────────────────────────────
  Widget _buildSummerCard() {
    return _settingsCard(
      title: 'الدورة الصيفية',
      icon: Icons.wb_sunny_outlined,
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        value: _summerEnabled,
        onChanged: (v) => setState(() => _summerEnabled = v),
        activeThumbColor: _gs,
        title: const Text(
          'تفعيل الدورة الصيفية في المعدل السنوي',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        subtitle: Text(
          _summerEnabled
              ? 'المعدل السنوي = (ف1 + ف2 + ف3 + صيفي) ÷ 4'
              : 'المعدل السنوي = (ف1 + ف2 + ف3) ÷ 3',
          style: TextStyle(fontSize: 11.5, color: Colors.grey[600]),
        ),
      ),
    );
  }

  // ── معاينة المعدل السنوي ─────────────────────────────────────────
  Widget _buildAnnualFormulaCard() {
    final parts = ['ف. الأول', 'ف. الثاني', 'ف. الثالث'];
    if (_summerEnabled) parts.add('الدورة الصيفية');
    return _settingsCard(
      title: 'صيغة المعدل السنوي',
      icon: Icons.calendar_today_outlined,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'المعدل السنوي العام =',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 6),
            Text(
              '( ${parts.join(' + ')} )  ÷  ${parts.length}',
              style: TextStyle(
                fontSize: 13,
                color: Colors.blue.shade800,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _gs, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.blue.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
