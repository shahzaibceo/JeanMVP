import 'package:attention_anchor/common/common_widget/custom_conrtainer.dart';
import 'package:attention_anchor/common/common_widget/custom_text.dart';
import 'package:attention_anchor/common/constants/image_strings/app_icons.dart';
import 'package:attention_anchor/common/extensions/gesture_detector.dart';
import 'package:attention_anchor/common/extensions/sized_box.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/feature/bottom_nav/cubit/bottom_cubit.dart';
import 'package:attention_anchor/feature/habit_creation/page/habit_creation_screen.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
import 'package:attention_anchor/feature/settings/pages/setting_page.dart';
import 'package:attention_anchor/theme/app_colors.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';


class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  State<BottomNavigationBarScreen> createState() => _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> with WidgetsBindingObserver {

  List<Widget> _buildScreens() {
    return [
      const HabitCreationView(),
      const SettingsScreen(),
      const SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>(); 
    final resp = ResponsiveHelper(context);

    final List<Map<String, dynamic>> _navItems = [
      {'icon': AppIcons.home, 'label': "Home".tr()},
      {'icon': AppIcons.streak, 'label': "Streak".tr()},
      {'icon': AppIcons.setting, 'label': "Settings".tr()},
    ];

    double barWidth = MediaQuery.of(context).size.width - 40;
    double itemWidth = barWidth / _navItems.length;

    return BlocProvider(
      create: (_) => BottomBarCubit(),
      child: BlocBuilder<BottomBarCubit, int>(
        builder: (context, selectedIndex) {
          return Scaffold(
            backgroundColor: themeCubit.backgroundColor,
            body: IndexedStack(
              index: selectedIndex,
              children: _buildScreens(),
            ),
            bottomNavigationBar: SafeArea(
              bottom: true,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomContainer(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                    height: resp.wp(75), 
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CustomPaint(
                          size: Size(barWidth, 75),
                          painter: BottomBarPainter(
                            xOffset: (itemWidth * selectedIndex) + (itemWidth / 2),
                            backgroundColor: themeCubit.containerColor,
                            borderColor:  themeCubit.isDark ? AppColors.primary.withValues(alpha: 0.3) : AppColors.white,
                            textDirection: Directionality.of(context),
                          ),
                        ),

                        Builder(builder: (_) {
                          double xOffset = (itemWidth * selectedIndex) + (itemWidth / 2);
                          if (Directionality.of(context) == TextDirection.rtl) {
                            xOffset = barWidth - xOffset;
                          }
                          return AnimatedPositioned(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeInOut,
                            left: xOffset - 35, 
                            top: -25,
                            child: Column(
                              children: [
                                CustomContainer(
                                  width: resp.wp(65),
                                  height: resp.hp(65),
                                  shape: BoxShape.circle,
                                  color: AppColors.primary,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(alpha: 0.3),
                                      blurRadius: resp.radius(10),
                                      offset: const Offset(0, 5),
                                    )
                                  ],
                                  child: Center(
                                    child: SvgPicture.asset(
                                      _navItems[selectedIndex]['icon'],
                                      colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                                      width: resp.wp(28),
                                    ),
                                  ),
                                ),
                                15.sbh(context), 
                                CustomText(
                                  text: _navItems[selectedIndex]['label'],
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: themeCubit.textColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ],
                            ),
                          );
                        }),

                        Positioned.fill(
                          right: resp.wp(20),
                          left: resp.wp(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(_navItems.length, (index) {
                              if (index == selectedIndex) return SizedBox(width: itemWidth);
                              
                              return 
                                CustomContainer(
                                  width: resp.wp(58),
                                  height: resp.hp(58),
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                  child: Center(
                                    child: SvgPicture.asset(
                                      _navItems[index]['icon'],
                                      width: resp.wp(24),
                                      colorFilter: ColorFilter.mode(
                                        AppColors.primary, 
                                        BlendMode.srcIn
                                      ),
                                    ),
                                  ),
                                
                              ).onTap((){
                                 context.read<BottomBarCubit>().changeTab(index);
                              });
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class BottomBarPainter extends CustomPainter {
  final double xOffset;
  final Color backgroundColor;
  final Color borderColor;
  final TextDirection textDirection;

  BottomBarPainter({
    required this.xOffset,
    required this.backgroundColor,
    required this.borderColor,
    required this.textDirection,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double adjustedXOffset = xOffset;

    // Mirror for RTL
    if (textDirection == TextDirection.rtl) {
      adjustedXOffset = size.width - xOffset;
    }

    Paint paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    double radius = 25;
    double holeWidth = 95;
    double holeHeight = 42;

    Path path = Path();
    path.moveTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    path.lineTo(adjustedXOffset - (holeWidth * 0.6), 0);

    path.cubicTo(
      adjustedXOffset - (holeWidth * 0.4), 0,
      adjustedXOffset - (holeWidth * 0.35), holeHeight,
      adjustedXOffset, holeHeight,
    );
    path.cubicTo(
      adjustedXOffset + (holeWidth * 0.35), holeHeight,
      adjustedXOffset + (holeWidth * 0.4), 0,
      adjustedXOffset + (holeWidth * 0.6), 0,
    );

    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);
    path.lineTo(size.width, size.height - radius);
    path.quadraticBezierTo(size.width, size.height, size.width - radius, size.height);
    path.lineTo(radius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);
    path.close();

    canvas.drawShadow(path, Colors.black.withOpacity(0.05), 5, true);
    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}