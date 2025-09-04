import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import 'enhanced_quantity_selector.dart';
import 'toss_white_card.dart';

/// Demo widget to test the EnhancedQuantitySelector functionality
/// This helps validate the implementation before full integration
class QuantitySelectorDemo extends StatefulWidget {
  const QuantitySelectorDemo({super.key});

  @override
  State<QuantitySelectorDemo> createState() => _QuantitySelectorDemoState();
}

class _QuantitySelectorDemoState extends State<QuantitySelectorDemo> {
  int _fullModeQuantity = 0;
  int _compactModeQuantity = 2;
  int _addToCartQuantity = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quantity Selector Demo'),
        backgroundColor: TossColors.gray100,
      ),
      backgroundColor: TossColors.gray100,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full Mode Demo
            TossWhiteCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Full Mode (56px touch targets)',
                    style: TossTextStyles.h4.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space3),
                  Text(
                    'Features: Large touch targets, haptic feedback, long-press support, animations',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Quantity: $_fullModeQuantity',
                        style: TossTextStyles.bodyLarge,
                      ),
                      EnhancedQuantitySelector(
                        quantity: _fullModeQuantity,
                        maxQuantity: 10,
                        onQuantityChanged: (newQuantity) {
                          setState(() {
                            _fullModeQuantity = newQuantity;
                          });
                        },
                        semanticLabel: 'Full mode quantity selector',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: TossSpacing.space4),
            
            // Compact Mode Demo
            TossWhiteCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Compact Mode',
                    style: TossTextStyles.h4.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space3),
                  Text(
                    'Features: Space-efficient design for lists and cards',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Quantity: $_compactModeQuantity',
                        style: TossTextStyles.bodyLarge,
                      ),
                      EnhancedQuantitySelector(
                        quantity: _compactModeQuantity,
                        maxQuantity: 99,
                        compactMode: true,
                        onQuantityChanged: (newQuantity) {
                          setState(() {
                            _compactModeQuantity = newQuantity;
                          });
                        },
                        semanticLabel: 'Compact mode quantity selector',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: TossSpacing.space4),
            
            // Add to Cart State Demo
            TossWhiteCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add to Cart State',
                    style: TossTextStyles.h4.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space3),
                  Text(
                    'Features: Shows "Add to cart" button when quantity is 0',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Quantity: $_addToCartQuantity',
                        style: TossTextStyles.bodyLarge,
                      ),
                      EnhancedQuantitySelector(
                        quantity: _addToCartQuantity,
                        maxQuantity: 5,
                        showAddToCartState: true,
                        addToCartText: 'Add to cart',
                        onQuantityChanged: (newQuantity) {
                          setState(() {
                            _addToCartQuantity = newQuantity;
                          });
                        },
                        semanticLabel: 'Add to cart quantity selector',
                      ),
                    ],
                  ),
                  SizedBox(height: TossSpacing.space2),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _addToCartQuantity = 0;
                      });
                    },
                    child: const Text('Reset to Add to Cart State'),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: TossSpacing.space4),
            
            // Instructions
            TossWhiteCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Testing Instructions',
                    style: TossTextStyles.h4.copyWith(
                      fontWeight: FontWeight.bold,
                      color: TossColors.primary,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space3),
                  _buildTestInstruction('✅ Tap buttons to feel haptic feedback'),
                  _buildTestInstruction('✅ Long-press +/- for rapid changes'),
                  _buildTestInstruction('✅ Notice smooth animations'),
                  _buildTestInstruction('✅ Test accessibility with screen reader'),
                  _buildTestInstruction('✅ Verify 56px touch targets (vs 16px old)'),
                  _buildTestInstruction('✅ Check max quantity warnings'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTestInstruction(String instruction) {
    return Padding(
      padding: EdgeInsets.only(bottom: TossSpacing.space2),
      child: Text(
        instruction,
        style: TossTextStyles.body.copyWith(
          color: TossColors.gray700,
        ),
      ),
    );
  }
}