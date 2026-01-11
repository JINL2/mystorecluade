/// Design System Showcase Page
///
/// Displays all shared widgets organized by folder structure,
/// similar to widgetbook but embedded in the app.
library;

import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import 'folders/atoms_showcase.dart';
import 'folders/molecules_showcase.dart';
import 'folders/organisms_showcase.dart';
import 'folders/themes_showcase.dart';

class DesignShowcasePage extends StatelessWidget {
  const DesignShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final folders = [
      _FolderItem(
        name: 'Themes',
        description: 'Colors, Spacing, Typography, Shadows',
        icon: Icons.palette_outlined,
        page: const ThemesShowcase(),
      ),
      _FolderItem(
        name: 'Atoms',
        description: 'Buttons, Badges, Chips, Inputs, Layouts',
        icon: Icons.circle_outlined,
        page: const AtomsShowcase(),
      ),
      _FolderItem(
        name: 'Molecules',
        description: 'Cards, FAB, Dropdown, Navigation',
        icon: Icons.hexagon_outlined,
        page: const MoleculesShowcase(),
      ),
      _FolderItem(
        name: 'Organisms',
        description: 'Calendars, Dialogs, Pickers, Sheets',
        icon: Icons.widgets_outlined,
        page: const OrganismsShowcase(),
      ),
    ];

    return Container(
      color: TossColors.gray50,
      child: ListView.separated(
        padding: const EdgeInsets.all(TossSpacing.space4),
        itemCount: folders.length,
        separatorBuilder: (_, __) => const SizedBox(height: TossSpacing.space3),
        itemBuilder: (context, index) {
          final folder = folders[index];
          return _FolderCard(
            folder: folder,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => _FolderDetailPage(folder: folder),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _FolderCard extends StatelessWidget {
  final _FolderItem folder;
  final VoidCallback onTap;

  const _FolderCard({
    required this.folder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: TossColors.white,
      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        child: Container(
          padding: const EdgeInsets.all(TossSpacing.space4),
          decoration: BoxDecoration(
            border: Border.all(color: TossColors.gray200),
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: TossColors.primarySurface,
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Icon(
                  folder.icon,
                  color: TossColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      folder.name,
                      style: TossTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space1),
                    Text(
                      folder.description,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: TossColors.gray400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FolderDetailPage extends StatelessWidget {
  final _FolderItem folder;

  const _FolderDetailPage({required this.folder});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.gray50,
      appBar: AppBar(
        title: Text(folder.name),
        backgroundColor: TossColors.white,
        foregroundColor: TossColors.gray900,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: folder.page,
    );
  }
}

class _FolderItem {
  final String name;
  final String description;
  final IconData icon;
  final Widget page;

  _FolderItem({
    required this.name,
    required this.description,
    required this.icon,
    required this.page,
  });
}
