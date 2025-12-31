import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/update_cart_quantity_usecase.dart';

/// Add to cart use case provider
final addToCartUseCaseProvider = Provider<AddToCartUseCase>((ref) {
  return const AddToCartUseCase();
});

/// Update cart quantity use case provider
final updateCartQuantityUseCaseProvider = Provider<UpdateCartQuantityUseCase>((ref) {
  return const UpdateCartQuantityUseCase();
});
