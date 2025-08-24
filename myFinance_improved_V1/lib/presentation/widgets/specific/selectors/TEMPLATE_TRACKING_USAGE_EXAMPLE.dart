// =====================================================
// TEMPLATE USAGE TRACKING - IMPLEMENTATION EXAMPLES
// =====================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/quick_access_provider.dart';
import 'smart_template_selector.dart';

// Example 1: Using SmartTemplateSelector in a page
class ExampleTemplateUsagePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Template Quick Access Example')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Show smart template selector with quick access
            SmartTemplateSelector(
              title: 'Quick Templates',
              maxQuickItems: 6,
              onTemplateSelected: (template) {
                // Custom handling when template is selected
                print('Selected template: ${template['template_name']}');
                // Template usage will be automatically tracked
              },
            ),
            
            SizedBox(height: 20),
            
            // Example of manually fetching quick access templates
            Text('Manual Quick Access Templates:'),
            Consumer(
              builder: (context, ref, child) {
                final quickTemplatesAsync = ref.watch(
                  quickAccessTemplatesProvider(
                    contextType: 'transaction',
                    limit: 5,
                  )
                );
                
                return quickTemplatesAsync.when(
                  data: (templates) => ListView.builder(
                    shrinkWrap: true,
                    itemCount: templates.length,
                    itemBuilder: (context, index) {
                      final template = templates[index];
                      return ListTile(
                        title: Text(template['template_name'] ?? 'Unknown'),
                        subtitle: Text('Used ${template['usage_count']} times'),
                        onTap: () {
                          // Manual template selection - you would need to manually track this
                          print('Manually selected: ${template['template_name']}');
                        },
                      );
                    },
                  ),
                  loading: () => CircularProgressIndicator(),
                  error: (error, stack) => Text('Error: $error'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Example 2: Using in existing pages where templates are already used
/*

### INTEGRATION EXAMPLE:

In any page where you want to show quick access templates, simply add:

```dart
import 'package:myfinance_improved/presentation/widgets/specific/selectors/smart_template_selector.dart';

// In your build method:
SmartTemplateSelector(
  title: 'Frequently Used Templates',
  showQuickAccess: true,
  maxQuickItems: 6,
  onTemplateSelected: (template) {
    // Handle template selection
    // The SmartTemplateSelector automatically tracks usage
    TemplateUsageBottomSheet.show(context, template);
  },
),
```

### AUTOMATIC TRACKING:

Template usage is now automatically tracked in these scenarios:

1. **Template Selection from List** - When user taps template in template list
   - Tracked in: `transaction_template_page.dart`
   - Usage Type: 'selected'
   - Context: 'template_selection'

2. **Template Transaction Creation** - When user creates transaction from template
   - Tracked in: `template_usage_bottom_sheet.dart` 
   - Usage Type: 'used'
   - Context: 'transaction_creation'

3. **Quick Access Selection** - When user selects from quick access grid
   - Tracked in: `smart_template_selector.dart`
   - Usage Type: 'selected'
   - Context: 'quick_access_selection'

### DATABASE STRUCTURE:

All tracking data is stored in `transaction_templates_preferences` table:
- template_id: UUID of the template
- template_name: Name of the template
- template_type: Type of template (transaction, income, expense, etc.)
- usage_type: How template was used (selected, used, created, etc.)
- used_at: Timestamp
- metadata: Additional context data

### QUICK ACCESS RETRIEVAL:

The system provides quick access to frequently used templates via:
- RPC Function: `get_user_quick_access_templates`
- Provider: `QuickAccessTemplates`
- Widget: `SmartTemplateSelector`

Templates are ranked by usage frequency with recency bonuses.

*/