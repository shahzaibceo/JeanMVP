import 'dart:math' as math;

import 'package:attention_anchor/common/common_widget/custom_text.dart';
import 'package:attention_anchor/common/extensions/sized_box.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
import 'package:attention_anchor/theme/app_colors.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';

/// A half-circle urge-intensity gauge used on step 1.
///
/// Visuals: an upper-half arc with 10 evenly spaced numeric ticks and a
/// draggable knob. The arc fills from the start point up to the knob's
/// angle in the brand purple; the remainder is rendered in a muted tone.
/// The centre shows the current numeric value and a one-word
/// severity label (Mild / Moderate / High / Very High).
///
/// Interaction: tap or pan on the arc — the closest 1..10 tick to the
/// gesture angle is reported via [onChanged]. The widget itself is
/// stateless; state lives in the surrounding cubit.
class UrgeGaugeWidget extends StatelessWidget {
  final int value; // 1..10
  final ValueChanged<int> onChanged;
  final ThemeCubit themeCubit;

  const UrgeGaugeWidget({
    super.key,
    required this.value,
    required this.onChanged,
    required this.themeCubit,
  });

  /// Maps a 1..10 reading to a short translated severity label key.
  static String _severityKey(int v) {
    if (v <= 3) return 'severity_mild';
    if (v <= 5) return 'severity_moderate';
    if (v <= 7) return 'severity_high';
    return 'severity_very_high';
  }

  @override
  Widget build(BuildContext context) {
    final resp = ResponsiveHelper(context);
    final size = resp.wp(260);

    return SizedBox(
      width: size,
      height: size * 0.72,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;
          // The arc sits inside a square whose width equals the widget
          // width; the visible half-circle therefore has half its
          // height visible.
          final radius = w / 2 - resp.wp(20);
          final center = Offset(w / 2, h - resp.wp(8));

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanUpdate: (d) => _emitFromGesture(d.localPosition, center, radius),
            onTapDown: (d) => _emitFromGesture(d.localPosition, center, radius),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CustomPaint(
                  size: Size(w, h),
                  painter: _GaugePainter(
                    value: value,
                    radius: radius,
                    center: center,
                    trackColor:
                        themeCubit.unselectedColor.withValues(alpha: 0.15),
                    fillColor: AppColors.primary,
                    knobColor: AppColors.primary,
                    textColor: themeCubit.textColor,
                    mutedColor: themeCubit.unselectedColor,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: resp.hp(8)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        text: '$value',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: themeCubit.textColor,
                              fontWeight: FontWeight.w800,
                              fontSize: resp.fontSize(48),
                            ),
                      ),
                      2.sbh(context),
                      CustomText(
                        text: _severityKey(value).tr(),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: themeCubit.unselectedColor,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Converts a local-coordinate gesture point to an angle on the arc
  /// and snaps it to the nearest 1..10 tick.
  ///
  /// The arc spans angle π (left, "1") through 2π (right, "10") going
  /// clockwise across the top. Points below the arc baseline are
  /// clamped to the nearest endpoint so a stray swipe never crashes
  /// the selection.
  void _emitFromGesture(Offset local, Offset center, double radius) {
    final dx = local.dx - center.dx;
    final dy = local.dy - center.dy;
    // Ignore points below the diameter (lower half) — keep the previous value.
    if (dy > 0) return;
    final angle = math.atan2(dy, dx); // -π..π
    // Map to π..2π: for upper half angle is in (-π, 0); we want it in (π, 2π).
    final mapped = angle + 2 * math.pi;
    // 1 is at π, 10 is at 2π. Fraction along arc:
    final fraction = ((mapped - math.pi) / math.pi).clamp(0.0, 1.0);
    final snapped = (fraction * 9).round() + 1; // 1..10
    if (snapped != value) onChanged(snapped);
  }
}

class _GaugePainter extends CustomPainter {
  final int value;
  final double radius;
  final Offset center;
  final Color trackColor;
  final Color fillColor;
  final Color knobColor;
  final Color textColor;
  final Color mutedColor;

  _GaugePainter({
    required this.value,
    required this.radius,
    required this.center,
    required this.trackColor,
    required this.fillColor,
    required this.knobColor,
    required this.textColor,
    required this.mutedColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(center: center, radius: radius);
    const startAngle = math.pi; // left (9 o'clock)
    const sweep = math.pi; // upper half, clockwise across the top

    // Track (full upper-half).
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 14;
    canvas.drawArc(rect, startAngle, sweep, false, trackPaint);

    // Fill from start to the current value's angle.
    final fraction = ((value - 1) / 9).clamp(0.0, 1.0);
    final fillSweep = sweep * fraction;
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 14;
    if (fillSweep > 0) {
      canvas.drawArc(rect, startAngle, fillSweep, false, fillPaint);
    }

    // Tick numbers (1..10) just outside the track.
    for (var i = 1; i <= 10; i++) {
      final t = (i - 1) / 9;
      final ang = startAngle + sweep * t;
      // Place number slightly outside the arc; nudge corner-most numbers
      // (1 and 10) closer to the centre vertically to avoid clipping.
      final outerR = radius + 22;
      final p = Offset(
        center.dx + math.cos(ang) * outerR,
        center.dy + math.sin(ang) * outerR,
      );
      final isHighlighted = i == value;
      final tp = TextPainter(
        text: TextSpan(
          text: '$i',
          style: TextStyle(
            color: isHighlighted ? fillColor : mutedColor,
            fontSize: isHighlighted ? 14 : 12,
            fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w500,
            fontFamily: 'Sora',
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, p - Offset(tp.width / 2, tp.height / 2));
    }

    // Knob at the current value's angle.
    final knobAngle = startAngle + sweep * fraction;
    final knobPos = Offset(
      center.dx + math.cos(knobAngle) * radius,
      center.dy + math.sin(knobAngle) * radius,
    );
    // Outer ring (white halo) so the knob reads against any background.
    canvas.drawCircle(
      knobPos,
      11,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      knobPos,
      9,
      Paint()..color = knobColor,
    );
    // Inner dot with the number for readability at small sizes.
    final knobLabel = TextPainter(
      text: TextSpan(
        text: '$value',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          fontFamily: 'Sora',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    knobLabel.paint(
      canvas,
      knobPos - Offset(knobLabel.width / 2, knobLabel.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter old) =>
      old.value != value ||
      old.radius != radius ||
      old.center != center ||
      old.fillColor != fillColor ||
      old.trackColor != trackColor;
}
