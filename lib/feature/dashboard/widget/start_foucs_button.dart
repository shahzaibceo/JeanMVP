import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
import 'package:flutter/material.dart';
import '../../../common/common_widget/custom_button.dart';
import '../../../common/utils/responsive_helper/responsive_helper.dart';
import '../../../feature/habit_creation/page/habit_creation_screen.dart';
import '../../../theme/app_colors.dart';

class StartFocusButton extends StatelessWidget {
  final ResponsiveHelper resp;

  const StartFocusButton({super.key, required this.resp});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomButton(
        text: "start_focus".tr(),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => HabitCreationView()),
          );
        },
        width: resp.wp(300),
        height: resp.hp(56),
        borderRadius: resp.radius(16),
        suffixIcon: const Icon(Icons.arrow_forward_rounded,
            color: AppColors.white, size: 20),
      ),
    );
  }
}