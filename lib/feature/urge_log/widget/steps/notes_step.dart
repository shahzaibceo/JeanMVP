import 'package:attention_anchor/common/common_widget/custom_text.dart';
import 'package:attention_anchor/common/common_widget/custom_text_field.dart';
import 'package:attention_anchor/common/extensions/sized_box.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
import 'package:attention_anchor/feature/urge_log/cubit/urge_flow_cubit.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Step 4 — "Additional Notes". A multiline text area capped at 300
/// characters with a live counter underneath. The notes field is
/// optional; the user can always press Next.
class NotesStep extends StatefulWidget {
  final ThemeCubit themeCubit;
  const NotesStep({super.key, required this.themeCubit});

  @override
  State<NotesStep> createState() => _NotesStepState();
}

class _NotesStepState extends State<NotesStep> {
  static const int _maxChars = 300;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        TextEditingController(text: context.read<UrgeFlowCubit>().state.notes);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resp = ResponsiveHelper(context);
    final theme = widget.themeCubit;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        16.sbh(context),
        CustomText(
          text: 'notes_question'.tr(),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: theme.textColor,
                fontWeight: FontWeight.w600,
              ),
        ),
        12.sbh(context),
        CustomTextFormField(
          controller: _controller,
          readOnly: false,
          enableSuggestions: true,
          autocorrect: true,
          showBorder: true,
          maxLines: 8,
          minLines: 6,
          maxLength: _maxChars,
          hintText: 'notes_hint'.tr(),
          borderRadiusValue: 14,
          fillColor: theme.containerColor,
          onChanged: context.read<UrgeFlowCubit>().setNotes,
          contentPadding: EdgeInsets.symmetric(
            horizontal: resp.wp(14),
            vertical: resp.hp(12),
          ),
        ),
        // BlocBuilder<UrgeFlowCubit, UrgeFlowState>(
        //   buildWhen: (a, b) => a.notes.length != b.notes.length,
        //   builder: (context, state) {
        //     return Align(
        //       alignment: AlignmentDirectional.centerEnd,
        //       // child: CustomText(
        //       //   text: '${state.notes.length}/$_maxChars',
        //       //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        //       //         color: theme.unselectedColor,
        //       //       ),
        //       // ),
        //     );
        //   },
        // ),
      ],
    );
  }
}
