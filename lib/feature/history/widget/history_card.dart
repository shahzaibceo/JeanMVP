import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../common/common_widget/custom_conrtainer.dart';
import '../../../common/common_widget/custom_text.dart';
import '../../../common/extensions/sized_box.dart';
import '../../../common/utils/responsive_helper/responsive_helper.dart';
import '../../../theme/cubit/theme_cubit.dart';

// Note: This model is here for UI demonstration. 
// You can move it or replace it with your own logic.
class HistoryItem {
  final String habitName;
  final String status; // "Ends" or "In Process"
  final String streakInfo; // "Streak End" or "X Days Streak"
  final DateTime date;

  HistoryItem({
    required this.habitName,
    required this.status,
    required this.streakInfo,
    required this.date,
  });
}

class HistoryCard extends StatelessWidget {
  final HistoryItem item;
  final ResponsiveHelper resp;
  final ThemeCubit themeCubit;

  const HistoryCard({
    super.key,
    required this.item,
    required this.resp,
    required this.themeCubit,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnded = item.status == "Ends";
    final Color statusColor = isEnded ? Colors.redAccent : const Color(0xFF00FFA3);
    final String dateStr = DateFormat('dd-MMM-yyyy').format(item.date);

    return CustomContainer(
      margin: EdgeInsets.only(bottom: resp.hp(12)),
      padding: EdgeInsets.symmetric(horizontal: resp.wp(20), vertical: resp.hp(16)),
      borderRadius: resp.radius(24),
      color: themeCubit.containerColor,
      border: Border.all(color: themeCubit.greyColor.withOpacity(0.1), width: 1),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: item.habitName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: themeCubit.textColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              CustomText(
                text: item.status,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          8.sbh(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.whatshot,
                    color: statusColor,
                    size: resp.wp(18),
                  ),
                  4.sbw(context),
                  CustomText(
                    text: item.streakInfo,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              CustomText(
                text: dateStr,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: themeCubit.unselectedColor.withOpacity(0.6),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
