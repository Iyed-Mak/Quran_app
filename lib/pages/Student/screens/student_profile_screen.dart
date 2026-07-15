import 'package:flutter/material.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  // ── Mock student data ──
  final Map<String, String> studentInfo = {
    'الاسم الكامل': ' عافري أحمد',
    'العمر': '13 سنة',
    'الفوج': 'فوج 1',
    'الحزب الحالي': 'الحزب 40',
    'تاريخ الالتحاق': '2023-09-01',
    'رقم ولي الأمر': '0551234567',
  };

  // ── Mock administrative documents ──
  // true = received (مكتملة), false = pending (غير مستلمة)
  final List<Map<String, dynamic>> documents = [
    {'name': 'شهادة الميلاد', 'received': true},
    {'name': 'صورتان شمسيتان', 'received': true},
    {'name': 'شهادة مدرسية', 'received': false},
    {'name': 'نسخة من بطاقة ولي الأمر', 'received': true},
    {'name': 'استمارة التسجيل', 'received': false},
  ];

  int get totalDocs => documents.length;
  int get receivedDocs => documents.where((d) => d['received'] == true).length;
  double get completionRate => totalDocs == 0 ? 0 : receivedDocs / totalDocs;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xffF4FBF6),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: AppBar(
              backgroundColor: Colors.blue[700],
              iconTheme: const IconThemeData(color: Colors.white),
              title: const Text(
                'الملف الشخصي',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              elevation: 0,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Hero profile card ──
              _buildProfileHeroCard(),

              const SizedBox(height: 20),

              // ── Student info section ──
              _sectionTitle(Icons.info_outline, 'المعلومات الشخصية'),
              const SizedBox(height: 10),
              _buildInfoGrid(),

              const SizedBox(height: 24),

              // ── Administrative documents section ──
              _sectionTitle(Icons.folder_copy_outlined, 'الوثائق الإدارية'),
              const SizedBox(height: 10),
              _buildDocumentsSummaryCard(),
              const SizedBox(height: 14),
              _buildDocumentsList(),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────
  // Profile hero card
  // ────────────────────────────────────────────────
  Widget _buildProfileHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade400],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200,
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 38,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 36,
              color: Colors.blue.shade700,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  studentInfo['الاسم الكامل']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _heroBadge(Icons.group, studentInfo['الفوج']!),
                    const SizedBox(width: 8),
                    _heroBadge(Icons.menu_book, studentInfo['الحزب الحالي']!),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────
  // Section title
  // ────────────────────────────────────────────────
  Widget _sectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.blue.shade700, size: 20),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade900,
          ),
        ),
      ],
    );
  }

  // ────────────────────────────────────────────────
  // Info grid
  // ────────────────────────────────────────────────
  Widget _buildInfoGrid() {
    final entries = studentInfo.entries.toList();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entries.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.4,
      ),
      itemBuilder: (context, index) {
        final entry = entries[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade50,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                entry.key,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Text(
                entry.value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  // ────────────────────────────────────────────────
  // Documents summary card
  // ────────────────────────────────────────────────
  Widget _buildDocumentsSummaryCard() {
    final pct = (completionRate * 100).toInt();
    final Color progressColor = completionRate == 1.0
        ? Colors.blue.shade600
        : completionRate >= 0.5
        ? Colors.orange.shade600
        : Colors.red.shade400;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Three stat chips
          Row(
            children: [
              _statChip(
                label: 'الوثائق المطلوبة',
                value: '$totalDocs',
                icon: Icons.folder_outlined,
                color: Colors.blue.shade600,
              ),
              const SizedBox(width: 10),
              _statChip(
                label: 'الوثائق المستلمة',
                value: '$receivedDocs',
                icon: Icons.check_circle_outline,
                color: Colors.blue.shade600,
              ),
              const SizedBox(width: 10),
              _statChip(
                label: 'نسبة الاكتمال',
                value: '$pct%',
                icon: Icons.pie_chart_outline,
                color: progressColor,
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Progress bar
          Row(
            children: [
              Text(
                'اكتمال الملف',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              const Spacer(),
              Text(
                '$pct%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: progressColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: completionRate,
              minHeight: 10,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(progressColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statChip({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────
  // Documents list
  // ────────────────────────────────────────────────
  Widget _buildDocumentsList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'اسم الوثيقة',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  'الحالة',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Document rows
          ...documents.asMap().entries.map((entry) {
            final index = entry.key;
            final doc = entry.value;
            final bool received = doc['received'] as bool;
            final bool isLast = index == documents.length - 1;

            return Container(
              decoration: BoxDecoration(
                border: isLast
                    ? null
                    : Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade100,
                          width: 1,
                        ),
                      ),
                borderRadius: isLast
                    ? const BorderRadius.vertical(bottom: Radius.circular(20))
                    : null,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  // Doc icon
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: received
                          ? Colors.blue.shade50
                          : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      received
                          ? Icons.description_outlined
                          : Icons.hourglass_empty_rounded,
                      color: received
                          ? Colors.blue.shade600
                          : Colors.orange.shade600,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Doc name
                  Expanded(
                    child: Text(
                      doc['name'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // Status badge
                  _statusBadge(received),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _statusBadge(bool received) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: received ? Colors.blue.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: received ? Colors.blue.shade300 : Colors.orange.shade300,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            received ? 'مكتملة' : 'غير مستلمة',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: received ? Colors.blue.shade700 : Colors.orange.shade700,
            ),
          ),
          const SizedBox(width: 4),
          Text(received ? '✓' : '⏳', style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
