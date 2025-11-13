import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/entities/user_profile.dart';

class ProfileAvatarSection extends StatelessWidget {
  final UserProfile profile;
  final String? temporaryImageUrl;
  final VoidCallback onAvatarTap;

  const ProfileAvatarSection({
    super.key,
    required this.profile,
    this.temporaryImageUrl,
    required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onAvatarTap,
      child: Stack(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: TossColors.gray100,
                width: 3,
              ),
            ),
            child: _buildAvatar(),
          ),
          // Edit indicator
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: TossColors.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: TossColors.surface,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: TossColors.gray900.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.camera_alt,
                size: 14,
                color: TossColors.surface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    if (temporaryImageUrl != null) {
      return CircleAvatar(
        radius: 42,
        backgroundImage: temporaryImageUrl!.startsWith('http')
            ? NetworkImage(temporaryImageUrl!) as ImageProvider
            : FileImage(File(temporaryImageUrl!)),
      );
    }

    if (profile.hasProfileImage) {
      return CircleAvatar(
        radius: 42,
        backgroundImage: NetworkImage(profile.profileImage!),
      );
    }

    return CircleAvatar(
      radius: 42,
      backgroundColor: TossColors.primary.withValues(alpha: 0.1),
      child: Text(
        profile.initials,
        style: TossTextStyles.h3.copyWith(
          color: TossColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class AvatarOptionsBottomSheet extends StatelessWidget {
  final bool hasProfileImage;
  final Future<void> Function(ImageSource) onPickImage;
  final VoidCallback onRemoveImage;

  const AvatarOptionsBottomSheet({
    super.key,
    required this.hasProfileImage,
    required this.onPickImage,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: Column(
                children: [
                  Text(
                    'Change Profile Picture',
                    style: TossTextStyles.h3.copyWith(
                      fontWeight: FontWeight.w700,
                      color: TossColors.gray900,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space6),
                  _AvatarOption(
                    icon: Icons.camera_alt_outlined,
                    title: 'Take Photo',
                    onTap: () async {
                      Navigator.pop(context);
                      final status = await Permission.camera.status;
                      if (!status.isGranted) {
                        final result = await Permission.camera.request();
                        if (result.isGranted) {
                          await onPickImage(ImageSource.camera);
                        } else {
                          if (context.mounted) {
                            _showPermissionDeniedDialog(context);
                          }
                        }
                      } else {
                        await onPickImage(ImageSource.camera);
                      }
                    },
                  ),
                  const SizedBox(height: TossSpacing.space3),
                  _AvatarOption(
                    icon: Icons.photo_library_outlined,
                    title: 'Choose from Gallery',
                    onTap: () async {
                      Navigator.pop(context);
                      final status = await Permission.photos.status;
                      if (!status.isGranted) {
                        final result = await Permission.photos.request();
                        if (result.isGranted) {
                          await onPickImage(ImageSource.gallery);
                        } else {
                          if (context.mounted) {
                            _showPermissionDeniedDialog(context);
                          }
                        }
                      } else {
                        await onPickImage(ImageSource.gallery);
                      }
                    },
                  ),
                  if (hasProfileImage) ...[
                    const SizedBox(height: TossSpacing.space3),
                    _AvatarOption(
                      icon: Icons.delete_outline,
                      title: 'Remove Photo',
                      onTap: () {
                        Navigator.pop(context);
                        onRemoveImage();
                      },
                      isDestructive: true,
                    ),
                  ],
                  const SizedBox(height: TossSpacing.space3),
                  _AvatarOption(
                    icon: Icons.close,
                    title: 'Cancel',
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
            'This app needs access to your photos to change your profile picture. Please enable photo access in Settings.',),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}

class _AvatarOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _AvatarOption({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space4,
        ),
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: isDestructive ? TossColors.error : TossColors.gray700,
            ),
            const SizedBox(width: TossSpacing.space4),
            Expanded(
              child: Text(
                title,
                style: TossTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDestructive ? TossColors.error : TossColors.gray900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
