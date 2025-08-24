import 'package:flutter/material.dart';
import '../toss/toss_bottom_sheet.dart';
import 'toss_bottom_drawer.dart';
import 'company_store_bottom_drawer.dart';

/// Example usage of theme-aware bottom drawers
class DrawerExamples {
  
  /// Show company & store selector from bottom
  static void showCompanyStoreSelector(BuildContext context) {
    CompanyStoreBottomDrawer.show(
      context: context,
      onSelectionChanged: () {
        // Handle selection change
      },
    );
  }
  
  /// Show the new theme-aware bottom drawer
  static void showBottomDrawer(BuildContext context) {
    TossBottomDrawer.show(
      context: context,
      title: 'Store Selection',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
            leading: Icon(Icons.store),
            title: Text('test1'),
            subtitle: Text('5 stores • Employee'),
          ),
          const ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Gangnam Branch'),
          ),
          const ListTile(
            leading: Icon(Icons.store_outlined),
            title: Text('test2'),
          ),
        ],
      ),
      actions: [
        TossDrawerAction(
          title: 'Add new store',
          icon: Icons.add,
          onTap: () {},  // TODO: Implement add store
        ),
        TossDrawerAction(
          title: 'View codes',
          icon: Icons.qr_code,
          onTap: () {},  // TODO: Implement view codes
        ),
      ],
    );
  }
  
  /// Show the original bottom sheet (now theme-aware)
  static void showBottomSheet(BuildContext context) {
    TossBottomSheet.show(
      context: context,
      title: 'Options',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Select an option from below:'),
          const SizedBox(height: 16),
          // Your content here
        ],
      ),
      actions: [
        TossActionItem(
          title: 'Edit',
          icon: Icons.edit,
          onTap: () {},  // TODO: Implement edit
        ),
        TossActionItem(
          title: 'Delete',
          icon: Icons.delete,
          isDestructive: true,
          onTap: () {},  // TODO: Implement delete
        ),
      ],
    );
  }
}

/// Quick demo widget to test both drawers
class DrawerTestWidget extends StatelessWidget {
  const DrawerTestWidget({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Drawer Test')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => DrawerExamples.showCompanyStoreSelector(context),
              child: const Text('Show Company/Store Selector'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => DrawerExamples.showBottomDrawer(context),
              child: const Text('Show New Bottom Drawer'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => DrawerExamples.showBottomSheet(context),
              child: const Text('Show Fixed Bottom Sheet'),
            ),
            const SizedBox(height: 32),
            Text(
              'Theme: ${Theme.of(context).brightness.name}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}