
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:attention_anchor/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class MainBackground extends StatelessWidget {
  final Widget child;
final PreferredSizeWidget? appBar;
  const MainBackground({super.key, required this.child, this.appBar});

  @override
  Widget build(BuildContext context) {
    final resp = ResponsiveHelper(context);
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final isDark = state.isDark;
        final Color baseColor = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
        
        final Color glowColor = AppColors.primary.withOpacity(isDark ? 0.10 : 0.1);

        return Scaffold(
          backgroundColor: baseColor,
          appBar: appBar,
          body: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 2, 
                height: 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: glowColor, 
                  boxShadow: [
                    BoxShadow(
                      color: glowColor,
                      blurRadius: resp.radius(180),  
                      spreadRadius: resp.wp(200), 
                    ),
                  ],
                ),
              ),
              
              child,
            ],
          ),
        );
      },
    );
  }
}