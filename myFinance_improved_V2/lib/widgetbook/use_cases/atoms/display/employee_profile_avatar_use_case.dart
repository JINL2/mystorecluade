import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/atoms/display/employee_profile_avatar.dart';

final employeeProfileAvatarComponent = WidgetbookComponent(
  name: 'EmployeeProfileAvatar',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: EmployeeProfileAvatar(
          name: context.knobs.string(
            label: 'Name',
            initialValue: 'John Doe',
          ),
          size: context.knobs.double.slider(
            label: 'Size',
            initialValue: 48,
            min: 24,
            max: 96,
          ),
          showBorder: context.knobs.boolean(
            label: 'Show Border',
            initialValue: true,
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Multiple Avatars',
      builder: (context) => const Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            EmployeeProfileAvatar(name: 'John', size: 48),
            EmployeeProfileAvatar(name: 'Jane', size: 48),
            EmployeeProfileAvatar(name: 'Bob', size: 48),
          ],
        ),
      ),
    ),
  ],
);
