import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../models/supply_chain_models.dart';
import '../providers/persona_provider.dart';
import 'package:myfinance_improved/core/themes/index.dart';

class PersonaSelectorWidget extends ConsumerWidget {
  final bool isCompact;

  const PersonaSelectorWidget({
    super.key,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPersona = ref.watch(currentPersonaProvider);
    final availablePersonas = ref.watch(availablePersonasProvider);
    
    if (isCompact) {
      return _buildCompactSelector(context, ref, currentPersona, availablePersonas);
    }
    
    return _buildFullSelector(context, ref, currentPersona, availablePersonas);
  }

  Widget _buildCompactSelector(
    BuildContext context,
    WidgetRef ref,
    UserPersona currentPersona,
    List<UserPersona> availablePersonas,
  ) {
    return PopupMenuButton<UserPersona>(
      initialValue: currentPersona,
      onSelected: (persona) {
        ref.read(currentPersonaProvider.notifier).state = persona;
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: currentPersona.themeColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(
            color: currentPersona.themeColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getPersonaIcon(currentPersona.role),
              color: currentPersona.themeColor,
              size: 16,
            ),
            SizedBox(width: TossSpacing.space2),
            Text(
              _getPersonaEnglishLabel(currentPersona.role),
              style: TossTextStyles.caption.copyWith(
                color: currentPersona.themeColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: TossSpacing.space1),
            Icon(
              Icons.keyboard_arrow_down,
              color: currentPersona.themeColor,
              size: 16,
            ),
          ],
        ),
      ),
      itemBuilder: (context) {
        return availablePersonas.map((persona) {
          return PopupMenuItem<UserPersona>(
            value: persona,
            child: Row(
              children: [
                Icon(
                  _getPersonaIcon(persona.role),
                  color: persona.themeColor,
                  size: 20,
                ),
                SizedBox(width: TossSpacing.space2),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getPersonaEnglishLabel(persona.role),
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _getPersonaDescription(persona.role),
                      style: TossTextStyles.small.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }

  Widget _buildFullSelector(
    BuildContext context,
    WidgetRef ref,
    UserPersona currentPersona,
    List<UserPersona> availablePersonas,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: TossColors.gray100,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.person_outline,
                  color: TossColors.primary,
                  size: 24,
                ),
                SizedBox(width: TossSpacing.space2),
                Text(
                  'Role Perspective',
                  style: TossTextStyles.h4.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Persona grid
          Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: TossSpacing.space3,
                mainAxisSpacing: TossSpacing.space3,
                childAspectRatio: 1.8,
              ),
              itemCount: availablePersonas.length,
              itemBuilder: (context, index) {
                final persona = availablePersonas[index];
                final isSelected = persona.role == currentPersona.role;
                
                return _buildPersonaCard(
                  context,
                  ref,
                  persona,
                  isSelected,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonaCard(
    BuildContext context,
    WidgetRef ref,
    UserPersona persona,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () {
        ref.read(currentPersonaProvider.notifier).state = persona;
      },
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
      child: Container(
        padding: EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          color: isSelected 
              ? persona.themeColor.withValues(alpha: 0.1)
              : TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(
            color: isSelected 
                ? persona.themeColor
                : TossColors.gray200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: persona.themeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Icon(
                    _getPersonaIcon(persona.role),
                    color: persona.themeColor,
                    size: 20,
                  ),
                ),
                Spacer(),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: persona.themeColor,
                    size: 20,
                  ),
              ],
            ),
            
            SizedBox(height: TossSpacing.space2),
            
            // Title
            Text(
              _getPersonaEnglishLabel(persona.role),
              style: TossTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? persona.themeColor : TossColors.gray900,
              ),
            ),
            
            SizedBox(height: TossSpacing.space1),
            
            // Description
            Text(
              _getPersonaDescription(persona.role),
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPersonaIcon(UserRole role) {
    switch (role) {
      case UserRole.ceo:
        return Icons.business_center;
      case UserRole.purchasingManager:
        return Icons.shopping_cart;
      case UserRole.storeManager:
        return Icons.store;
      case UserRole.analyst:
        return Icons.analytics;
    }
  }

  String _getPersonaEnglishLabel(UserRole role) {
    switch (role) {
      case UserRole.ceo:
        return 'CEO';
      case UserRole.purchasingManager:
        return 'Purchasing Manager';
      case UserRole.storeManager:
        return 'Store Manager';
      case UserRole.analyst:
        return 'Analyst';
    }
  }

  String _getPersonaDescription(UserRole role) {
    switch (role) {
      case UserRole.ceo:
        return 'Strategic overview and exception management';
      case UserRole.purchasingManager:
        return 'Supplier performance and procurement';
      case UserRole.storeManager:
        return 'Inventory optimization and sales';
      case UserRole.analyst:
        return 'Comprehensive analysis and insights';
    }
  }
}