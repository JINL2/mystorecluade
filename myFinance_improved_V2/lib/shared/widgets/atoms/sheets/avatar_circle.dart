import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Circular avatar with loading and error states
class AvatarCircle extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final bool isSelected;
  final IconData fallbackIcon;

  const AvatarCircle({
    super.key,
    this.imageUrl,
    this.size = 40,
    this.isSelected = false,
    this.fallbackIcon = Icons.person,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? TossColors.primary : TossColors.gray200,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ClipOval(
        child: imageUrl != null ? _buildNetworkImage() : _buildFallback(),
      ),
    );
  }

  Widget _buildNetworkImage() {
    return Image.network(
      imageUrl!,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _buildFallback(),
      loadingBuilder: (_, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildLoading();
      },
    );
  }

  Widget _buildFallback() {
    return Container(
      color: TossColors.gray200,
      child: Icon(
        fallbackIcon,
        size: size * 0.5,
        color: TossColors.gray500,
      ),
    );
  }

  Widget _buildLoading() {
    return Container(
      color: TossColors.gray200,
      child: Center(
        child: SizedBox(
          width: size * 0.4,
          height: size * 0.4,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(TossColors.gray400),
          ),
        ),
      ),
    );
  }
}
