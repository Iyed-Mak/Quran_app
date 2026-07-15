import 'package:flutter/material.dart';

/// بطاقة قابلة لإعادة الاستخدام في جميع أقسام لوحة التحكم.
///
/// سبب مشكلة "Bottom overflowed by XX pixels" السابقة:
/// كان Spacer() بين صف الأيقونة والعنوان يحاول امتلاك كل المساحة
/// الرأسية المتبقية، لكن GridView يمنحه مساحة محدودة (أو صفرية أحيانًا)
/// فيتسبب في overflow صامت أو ظاهر. الحل: إزالة Spacer() كليًا واستبداله
/// بـ SizedBox ثابت صغير، وجعل mainAxisSize = MainAxisSize.min حتى تأخذ
/// البطاقة فقط الحجم الذي يحتاجه محتواها بالضبط.
class DashboardCard extends StatefulWidget {
  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.gradientStart,
    required this.gradientEnd,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color gradientStart;
  final Color gradientEnd;
  final VoidCallback onTap;
  final String? badge;

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.035 : 1.0,
        duration: const Duration(milliseconds: 160),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          elevation: _hovered ? 10 : 4,
          shadowColor: widget.gradientEnd.withValues(alpha: 0.4),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: widget.onTap,
            splashColor: Colors.white24,
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [widget.gradientStart, widget.gradientEnd],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              // لا نقيّد الارتفاع هنا — GridView هو من يتحكم بالارتفاع
              // عبر childAspectRatio المحسوب في DashboardScreen.
              // padding ثابت ومعقول يضمن أن المحتوى لن يضغط على الحواف.
              padding: const EdgeInsets.all(16),
              child: Column(
                // min: تأخذ الـ Column أقل ارتفاع ممكن بحسب محتواها.
                // هذا يمنع Spacer() من إنشاء طلب ارتفاع غير منتهٍ داخل
                // قيد محدود من GridView.
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── الصف العلوي: أيقونة + شارة اختيارية ──
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.22),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Icon(
                          widget.icon,
                          color: Colors.white,
                          // حجم ثابت صغير يحافظ على تناسق البطاقات عبر
                          // الشاشات المختلفة.
                          size: 24,
                        ),
                      ),
                      const Spacer(),
                      if (widget.badge != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.28),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            widget.badge!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),

                  // مسافة ثابتة بدل Spacer() — هذا هو جوهر الإصلاح.
                  const SizedBox(height: 10),

                  // ── العنوان ──
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),

                  const SizedBox(height: 4),

                  // ── الوصف ──
                  Text(
                    widget.description,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.82),
                      fontSize: 11.5,
                      height: 1.35,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
