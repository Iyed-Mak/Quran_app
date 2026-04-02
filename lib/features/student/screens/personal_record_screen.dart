import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/student_mock_data.dart';

/// وحدة السجل الشخصي — عرض البيانات الشخصية وتحديث المعلومات.
class PersonalRecordScreen extends StatefulWidget {
  const PersonalRecordScreen({super.key});

  @override
  State<PersonalRecordScreen> createState() => _PersonalRecordScreenState();
}

class _PersonalRecordScreenState extends State<PersonalRecordScreen> {
  late StudentProfile _profile;
  bool _editing = false;

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _guardianCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _profile = StudentProfile(
      fullName: mockStudentProfile.fullName,
      studentId: mockStudentProfile.studentId,
      gradeLevel: mockStudentProfile.gradeLevel,
      section: mockStudentProfile.section,
      phone: mockStudentProfile.phone,
      email: mockStudentProfile.email,
      guardianName: mockStudentProfile.guardianName,
    );
    _syncControllers();
  }

  void _syncControllers() {
    _nameCtrl.text = _profile.fullName;
    _phoneCtrl.text = _profile.phone;
    _emailCtrl.text = _profile.email;
    _guardianCtrl.text = _profile.guardianName;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _guardianCtrl.dispose();
    super.dispose();
  }

  void _save() {
    setState(() {
      _profile.fullName = _nameCtrl.text.trim();
      _profile.phone = _phoneCtrl.text.trim();
      _profile.email = _emailCtrl.text.trim();
      _profile.guardianName = _guardianCtrl.text.trim();
      _editing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ التعديلات (محليًا للعرض التجريبي).')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('السجل الشخصي', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'عرض بياناتك وتحديث معلومات الاتصال وولي الأمر.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ReadOnlyRow(label: 'رقم الطالب', value: _profile.studentId),
                  const Divider(height: 24),
                  _ReadOnlyRow(label: 'الصف', value: _profile.gradeLevel),
                  _ReadOnlyRow(label: 'الشعبة', value: _profile.section),
                  const Divider(height: 24),
                  if (_editing) ...[
                    TextField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(labelText: 'الاسم الكامل'),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _phoneCtrl,
                      decoration: const InputDecoration(labelText: 'الجوال'),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[\d+]')),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _emailCtrl,
                      decoration: const InputDecoration(labelText: 'البريد الإلكتروني'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _guardianCtrl,
                      decoration: const InputDecoration(
                        labelText: 'اسم ولي الأمر',
                      ),
                    ),
                  ] else ...[
                    _ReadOnlyRow(label: 'الاسم', value: _profile.fullName),
                    _ReadOnlyRow(label: 'الجوال', value: _profile.phone),
                    _ReadOnlyRow(label: 'البريد', value: _profile.email),
                    _ReadOnlyRow(label: 'ولي الأمر', value: _profile.guardianName),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _editing
          ? FloatingActionButton.extended(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('حفظ'),
            )
          : FloatingActionButton.extended(
              onPressed: () => setState(() => _editing = true),
              icon: const Icon(Icons.edit),
              label: const Text('تعديل'),
            ),
    );
  }
}

class _ReadOnlyRow extends StatelessWidget {
  const _ReadOnlyRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyLarge)),
        ],
      ),
    );
  }
}
