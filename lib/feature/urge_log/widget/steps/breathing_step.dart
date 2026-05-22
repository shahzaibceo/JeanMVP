import 'dart:math' as math;

import 'package:attention_anchor/common/common_widget/custom_button.dart';
import 'package:attention_anchor/common/common_widget/custom_conrtainer.dart';
import 'package:attention_anchor/common/common_widget/custom_text.dart';
import 'package:attention_anchor/common/extensions/gesture_detector.dart';
import 'package:attention_anchor/common/extensions/sized_box.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/feature/bottom_nav/cubit/bottom_cubit.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
import 'package:attention_anchor/feature/urge_log/cubit/urge_flow_cubit.dart';
import 'package:attention_anchor/feature/urge_log/cubit/urge_flow_state.dart';
import 'package:attention_anchor/feature/urge_log/cubit/urge_log_cubit.dart';
import 'package:attention_anchor/theme/app_colors.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Step 8 — "Breathing Exercise". Renders the circular phase timer at
/// the centre of the screen with a play/pause toggle below it. Auto-
/// starts the timer when the user reaches the step.
class BreathingStep extends StatefulWidget {
  final ThemeCubit themeCubit;
  const BreathingStep({super.key, required this.themeCubit});

  @override
  State<BreathingStep> createState() => _BreathingStepState();
}

class _BreathingStepState extends State<BreathingStep> {
  @override
  void initState() {
    super.initState();
    // Auto-start as soon as the step is mounted. addPostFrameCallback
    // ensures the cubit emit happens after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<UrgeFlowCubit>().startBreathing();
    });
  }

  /// Maps a [BreathingPhase] to its translation key.
  String _phaseKey(BreathingPhase p) {
    switch (p) {
      case BreathingPhase.inhale:
        return 'breathe_in';
      case BreathingPhase.hold:
        return 'breathe_hold';
      case BreathingPhase.exhale:
        return 'breathe_out';
    }
  }

  @override
  Widget build(BuildContext context) {
    final resp = ResponsiveHelper(context);
    final theme = widget.themeCubit;
    final ringSize = resp.wp(220);

    return BlocBuilder<UrgeFlowCubit, UrgeFlowState>(
      builder: (context, state) {
        final progress = state.breathingElapsedSeconds /
            UrgeFlowCubit.breathingTotalSeconds;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            18.sbh(context),
            CustomText(
              textAlign: TextAlign.center,
              text: _phaseKey(state.breathingPhase).tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: theme.textColor,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            28.sbh(context),
            Center(
              child: SizedBox(
                width: ringSize,
                height: ringSize,
                child: CustomPaint(
                  painter: _BreathingRingPainter(
                    progress: progress.clamp(0.0, 1.0).toDouble(),
                    trackColor:
                        theme.unselectedColor.withValues(alpha: 0.15),
                    progressColor: AppColors.primary,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          text: '${state.breathingPhaseRemaining}',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                color: theme.textColor,
                                fontWeight: FontWeight.w700,
                                fontSize: resp.fontSize(54),
                              ),
                        ),
                        CustomText(
                          text: 'seconds'.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color: theme.unselectedColor,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            22.sbh(context),
            CustomText(
              textAlign: TextAlign.center,
              text: 'follow_circle'.tr(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: theme.unselectedColor,
                  ),
            ),
            18.sbh(context),
            Center(
              child: CustomContainer(
                width: resp.wp(56),
                height: resp.wp(56),
                shape: BoxShape.circle,
                color: theme.containerColor,
                border: Border.all(
                  color: theme.greyColor.withValues(alpha: 0.5),
                  width: 1,
                ),
                alignment: Alignment.center,
                child: Icon(
                  state.breathingIsRunning
                      ? Icons.pause
                      : Icons.play_arrow_rounded,
                  color: AppColors.primary,
                  size: resp.fontSize(26),
                ),
              ).onTap(() {
                final cubit = context.read<UrgeFlowCubit>();
                state.breathingIsRunning
                    ? cubit.pauseBreathing()
                    : cubit.startBreathing();
              }),
            ),
            22.sbh(context),
            // "Complete Log" appears when the session reaches the end.
            if (state.breathingElapsedSeconds >=
                UrgeFlowCubit.breathingTotalSeconds)
              CustomButton(
                text: 'complete_log'.tr(),
                onTap: () {
                  final flow = context.read<UrgeFlowCubit>();
                  context
                      .read<UrgeLogCubit>()
                      .addEntry(flow.buildLogEntry());
                  flow.stopBreathingIfNeeded();
                  flow.reset();
                  context.read<BottomBarCubit>().changeTab(0);
                },
                borderRadius: resp.radius(14),
                height: resp.hp(52),
                textSize: resp.fontSize(16),
              ),
          ],
        );
      },
    );
  }
}

/// Paints the outer breathing ring: a faint full-circle track with an
/// arc overlay representing total-session progress, rotated so 0% sits
/// at 12 o'clock.
class _BreathingRingPainter extends CustomPainter {
  final double progress; // 0..1
  final Color trackColor;
  final Color progressColor;

  _BreathingRingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = 14.0;
    final r = size.shortestSide / 2 - stroke / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: r);

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 0, 2 * math.pi, false, trackPaint);

    if (progress > 0) {
      final progressPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round;
      // Start at the top (−π/2) and sweep clockwise.
      canvas.drawArc(
        rect,
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BreathingRingPainter old) =>
      old.progress != progress ||
      old.trackColor != trackColor ||
      old.progressColor != progressColor;
}
