import 'package:flutter/material.dart';

/// Quick-stat card — fully responsive via LayoutBuilder.
/// Scales icon size, font sizes, padding, and spacing
/// based on the actual pixel space the grid cell provides.
class StatisticsCard extends StatelessWidget {
  const StatisticsCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.trend,
    this.trendUp,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final String? trend;
  final bool? trendUp;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double w = constraints.maxWidth;
        final double h = constraints.maxHeight;

        // ── Scale everything off the smaller dimension ──
        final double ref = h.isFinite ? h.clamp(60.0, 160.0) : 120.0;
        final double iconSize = (ref * 0.22).clamp(14.0, 26.0);
        final double iconPad = (ref * 0.06).clamp(4.0, 10.0);
        final double valueSize = (ref * 0.22).clamp(14.0, 26.0);
        final double labelSize = (ref * 0.12).clamp(9.0, 14.0);
        final double trendSize = (ref * 0.10).clamp(8.0, 12.0);
        final double vPad = (ref * 0.09).clamp(6.0, 14.0);
        final double hPad = (w * 0.08).clamp(8.0, 16.0);
        final double gap = (ref * 0.06).clamp(3.0, 8.0);

        // Only show trend row when there's enough vertical room
        final bool showTrend = trend != null && h > 100;

        return Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.13),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              // ── Icon row ──
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(iconPad),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: iconSize),
                  ),
                  const Spacer(),
                  if (trendUp != null)
                    Icon(
                      trendUp! ? Icons.trending_up : Icons.trending_down,
                      color: trendUp! ? Colors.green.shade600 : Colors.red,
                      size: iconSize * 0.85,
                    ),
                ],
              ),

              SizedBox(height: gap),

              // ── Value ──
              Text(
                value,
                style: TextStyle(
                  fontSize: valueSize,
                  fontWeight: FontWeight.bold,
                  color: color,
                  height: 1.1,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),

              // ── Label ──
              Text(
                label,
                style: TextStyle(
                  fontSize: labelSize,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),

              // ── Trend (conditional on height) ──
              if (showTrend) ...[
                SizedBox(height: gap * 0.5),
                Text(
                  trend!,
                  style: TextStyle(
                    fontSize: trendSize,
                    color: trendUp == true
                        ? Colors.green.shade600
                        : Colors.grey.shade500,
                    height: 1.1,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
