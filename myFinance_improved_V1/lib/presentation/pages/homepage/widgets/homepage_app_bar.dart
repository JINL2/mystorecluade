import 'package:flutter/material.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_shadows.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomepageAppBar extends StatelessWidget {
  const HomepageAppBar({
    super.key,
    required this.userName,
    required this.companyName,
    this.storeName,
    required this.profileImageUrl,
    required this.onMenuTap,
    required this.onProfileTap,
    required this.onLogoutTap,
    required this.onSyncTap,
    this.isSyncing = false,
  });

  final String userName;
  final String companyName;
  final String? storeName;
  final String profileImageUrl;
  final VoidCallback onMenuTap;
  final VoidCallback onProfileTap;
  final VoidCallback onLogoutTap;
  final VoidCallback onSyncTap;
  final bool isSyncing;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.background,
        boxShadow: TossShadows.shadow1,
      ),
      child: Column(
        children: [
          // Top Row - Menu, Greeting, Profile
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Menu Icon
                IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: TossColors.gray900,
                  ),
                  onPressed: onMenuTap,
                  splashRadius: 24,
                ),
                
                // Greeting
                Expanded(
                  child: GestureDetector(
                    onTap: onProfileTap,
                    child: Text(
                      'Hello! $userName',
                      style: TossTextStyles.h3.copyWith(
                        color: TossColors.gray900,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                
                // Profile Image
                GestureDetector(
                  onTap: onProfileTap,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: profileImageUrl,
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: TossColors.gray100,
                        child: const Icon(
                          Icons.person,
                          size: 20,
                          color: TossColors.gray400,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: TossColors.gray100,
                        child: const Icon(
                          Icons.person,
                          size: 20,
                          color: TossColors.gray400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Company & Store Info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              children: [
                // Company Row
                Row(
                  children: [
                    Text(
                      'Your Company: ',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        companyName,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                
                // Store Row (if store selected)
                if (storeName != null && storeName!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Your Store: ',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          storeName!,
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray900,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          
          // Bottom Actions Row
          Container(
            padding: const EdgeInsets.only(right: 16, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Logout Text Button
                GestureDetector(
                  onTap: onLogoutTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Text(
                      'LogOut',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // Sync Icon Button
                GestureDetector(
                  onTap: isSyncing ? null : onSyncTap,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    child: AnimatedRotation(
                      duration: const Duration(milliseconds: 1000),
                      turns: isSyncing ? 1 : 0,
                      child: Icon(
                        Icons.sync,
                        size: 20,
                        color: isSyncing ? TossColors.primary : TossColors.gray600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}