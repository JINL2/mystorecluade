import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/atoms/display/cached_product_image.dart';

final cachedProductImageComponent = WidgetbookComponent(
  name: 'CachedProductImage',
  useCases: [
    WidgetbookUseCase(
      name: 'Default (No Image)',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: CachedProductImage(
          imageUrl: null,
          size: context.knobs.double.slider(
            label: 'Size',
            initialValue: 56,
            min: 24,
            max: 120,
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With URL',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: CachedProductImage(
          imageUrl: context.knobs.string(
            label: 'Image URL',
            initialValue: 'https://example.com/image.jpg',
          ),
          size: context.knobs.double.slider(
            label: 'Size',
            initialValue: 56,
            min: 24,
            max: 120,
          ),
        ),
      ),
    ),
  ],
);
