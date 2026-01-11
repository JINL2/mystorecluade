import 'package:widgetbook/widgetbook.dart';

import 'chat_bubble_use_case.dart';
import 'chat_input_field_use_case.dart';
import 'result_data_card_use_case.dart';
import 'typing_indicator_use_case.dart';

final aiChatDirectory = WidgetbookCategory(
  name: 'AI Chat (4)',
  children: [
    WidgetbookFolder(
      name: 'Messages (2)',
      children: [
        chatBubbleComponent,
        typingIndicatorComponent,
      ],
    ),
    WidgetbookFolder(
      name: 'Input (1)',
      children: [
        chatInputFieldComponent,
      ],
    ),
    WidgetbookFolder(
      name: 'Display (1)',
      children: [
        resultDataCardComponent,
      ],
    ),
  ],
);
