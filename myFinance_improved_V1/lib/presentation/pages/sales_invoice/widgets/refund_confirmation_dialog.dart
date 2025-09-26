import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/app_state_provider.dart';
import '../models/invoice_models.dart';
import '../models/cash_location_models.dart' as cash_models;

class RefundConfirmationDialog extends ConsumerStatefulWidget {
  final Invoice invoice;
  final Currency? currency;
  final Function(Map<String, dynamic>)? onSuccess;
  final VoidCallback? onCancel;

  const RefundConfirmationDialog({
    Key? key,
    required this.invoice,
    this.currency,
    this.onSuccess,
    this.onCancel,
  }) : super(key: key);

  static void show(
    BuildContext context,
    Invoice invoice,
    Currency? currency, {
    Function(Map<String, dynamic>)? onSuccess,
  }) {
    HapticFeedback.lightImpact();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return RefundConfirmationDialog(
          invoice: invoice,
          currency: currency,
          onSuccess: (result) {
            Navigator.pop(dialogContext);
            onSuccess?.call(result);
          },
          onCancel: () {
            Navigator.pop(dialogContext);
          },
        );
      },
    );
  }

  @override
  ConsumerState<RefundConfirmationDialog> createState() => _RefundConfirmationDialogState();
}

class _RefundConfirmationDialogState extends ConsumerState<RefundConfirmationDialog> {
  final _reasonController = TextEditingController();
  final _supabase = Supabase.instance.client;
  bool _isProcessing = false;
  String? _errorMessage;
  
  // Cash location related state
  List<cash_models.CashLocation> _cashLocations = [];
  cash_models.CashLocation? _selectedCashLocation;
  bool _isLoadingLocations = false;

  @override
  void initState() {
    super.initState();
    _loadCashLocations();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _loadCashLocations() async {
    setState(() {
      _isLoadingLocations = true;
      _errorMessage = null;
    });

    try {
      // Get company and store IDs from app state
      final appState = ref.read(appStateProvider);
      if (appState.companyChoosen.isEmpty) {
        throw Exception('Company not selected');
      }

      print('🔍 [CASH_LOCATIONS] Loading cash locations...');
      print('📊 [CASH_LOCATIONS] Company ID: ${appState.companyChoosen}');
      print('🏪 [CASH_LOCATIONS] Store ID: ${appState.storeChoosen}');

      final response = await _supabase.rpc(
        'get_cash_locations',
        params: {
          'p_company_id': appState.companyChoosen,
          'p_store_id': appState.storeChoosen.isNotEmpty ? appState.storeChoosen : null,
        },
      );

      print('📥 [CASH_LOCATIONS] Raw response: $response');
      print('📋 [CASH_LOCATIONS] Response type: ${response.runtimeType}');

      if (response != null) {
        List<cash_models.CashLocation> locations = [];
        
        if (response is List) {
          // Direct array response
          print('📝 [CASH_LOCATIONS] Processing direct array response with ${response.length} items');
          for (int i = 0; i < response.length; i++) {
            try {
              final item = response[i] as Map<String, dynamic>;
              print('🔍 [CASH_LOCATIONS] Item $i: $item');
              final location = cash_models.CashLocation.fromJson(item);
              locations.add(location);
              print('✅ [CASH_LOCATIONS] Successfully parsed location: ${location.id} - ${location.name}');
            } catch (e, stackTrace) {
              print('❌ [CASH_LOCATIONS] Error parsing item $i: $e');
              print('📚 [CASH_LOCATIONS] Stack trace: $stackTrace');
              print('📄 [CASH_LOCATIONS] Failed item data: ${response[i]}');
            }
          }
        } else if (response is Map && response['success'] == true) {
          // Wrapped response
          print('📝 [CASH_LOCATIONS] Processing wrapped response');
          final data = response['data'] as List<dynamic>;
          print('📊 [CASH_LOCATIONS] Data array has ${data.length} items');
          
          for (int i = 0; i < data.length; i++) {
            try {
              final item = data[i] as Map<String, dynamic>;
              print('🔍 [CASH_LOCATIONS] Item $i: $item');
              final location = cash_models.CashLocation.fromJson(item);
              locations.add(location);
              print('✅ [CASH_LOCATIONS] Successfully parsed location: ${location.id} - ${location.name}');
            } catch (e, stackTrace) {
              print('❌ [CASH_LOCATIONS] Error parsing item $i: $e');
              print('📚 [CASH_LOCATIONS] Stack trace: $stackTrace');
              print('📄 [CASH_LOCATIONS] Failed item data: ${data[i]}');
            }
          }
        } else if (response is Map && response['success'] == false) {
          throw Exception(response['message'] ?? 'Failed to load cash locations');
        } else {
          print('⚠️ [CASH_LOCATIONS] Unexpected response format');
          throw Exception('Unexpected response format');
        }

        print('🎯 [CASH_LOCATIONS] Successfully loaded ${locations.length} locations');
        
        setState(() {
          _cashLocations = locations;
          // Auto-select first location if available
          if (locations.isNotEmpty) {
            _selectedCashLocation = locations.first;
            print('🎯 [CASH_LOCATIONS] Auto-selected location: ${locations.first.id} - ${locations.first.name}');
          }
          _isLoadingLocations = false;
        });
      } else {
        throw Exception('No response received');
      }
    } catch (e, stackTrace) {
      print('❌ [CASH_LOCATIONS] Error loading cash locations: $e');
      print('📚 [CASH_LOCATIONS] Stack trace: $stackTrace');
      setState(() {
        _errorMessage = 'Failed to load payment locations: ${e.toString().replaceAll('Exception: ', '')}';
        _isLoadingLocations = false;
      });
    }
  }

  Future<void> _processRefund() async {
    // Validate cash location selection
    if (_selectedCashLocation == null) {
      setState(() {
        _errorMessage = 'Please select a payment location for the refund';
      });
      return;
    }

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      // Get current user ID
      final userId = ref.read(authStateProvider)?.id;
      
      if (userId == null) {
        throw Exception('User not authenticated');
      }
      
      // Prepare parameters following the correct RPC signature
      // inventory_refund_invoice(p_created_by, p_invoice_id, p_refund_date, p_refund_reason)
      final params = {
        'p_created_by': userId,  // Required
        'p_invoice_id': widget.invoice.invoiceId,  // Required
        'p_refund_date': DateTime.now().toIso8601String(),  // Required
        'p_refund_reason': _reasonController.text.isNotEmpty ? _reasonController.text.trim() : null,  // Optional
      };
      
      // Call RPC function
      final response = await _supabase.rpc(
        'inventory_refund_invoice',
        params: params,
      );
      
      if (response != null && response is Map && response['success'] == true) {
        print('✅ [REFUND] Inventory refund successful, creating journal entry...');
        
        // Create refund journal entry following the guide
        final journalSuccess = await _createRefundJournalEntry(
          refundAmount: response['refund_amount']?.toDouble() ?? widget.invoice.amounts.totalAmount,
          invoiceNumber: response['invoice_number'] ?? widget.invoice.invoiceNumber,
        );
        
        // Success - prepare enhanced result data
        final resultData = {
          'success': true,
          'message': response['message'] ?? 'Refund processed successfully',
          'invoice_number': response['invoice_number'] ?? widget.invoice.invoiceNumber,
          'refund_amount': response['refund_amount'] ?? widget.invoice.amounts.totalAmount,
          'warnings': response['warnings'] ?? [],
          'refund_reason': _reasonController.text.isNotEmpty ? _reasonController.text.trim() : null,
          'journal_created': journalSuccess,
        };
        
        if (journalSuccess) {
          print('✅ [REFUND] Journal entry created successfully');
        } else {
          print('⚠️ [REFUND] Journal entry failed, but inventory refund succeeded');
        }
        
        // Call success callback with enhanced data
        widget.onSuccess?.call(resultData);
      } else {
        // Error from RPC - handle various error response formats
        String errorMessage;
        if (response != null && response is Map && response.containsKey('error')) {
          // Supabase error format
          final errorObj = response['error'];
          if (errorObj is Map && errorObj.containsKey('message')) {
            errorMessage = errorObj['message']?.toString() ?? 'Failed to process refund';
          } else {
            errorMessage = errorObj?.toString() ?? 'Failed to process refund';
          }
        } else if (response != null && response is Map && response.containsKey('message')) {
          // Custom error format
          errorMessage = response['message']?.toString() ?? 'Failed to process refund';
        } else if (response != null && response is Map && response['success'] == false) {
          // Explicit failure format
          errorMessage = response['message']?.toString() ?? 'Refund request was rejected';
        } else {
          // Fallback error message
          errorMessage = 'Failed to process refund. Please try again.';
        }
        
        setState(() {
          _errorMessage = errorMessage;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  // Create refund journal entry following the guide
  Future<bool> _createRefundJournalEntry({
    required double refundAmount,
    required String invoiceNumber,
  }) async {
    try {
      final appState = ref.read(appStateProvider);
      final userId = ref.read(authStateProvider)?.id;
      
      if (userId == null || _selectedCashLocation == null) {
        print('❌ [JOURNAL] Missing required data: userId or cashLocation');
        return false;
      }

      print('🔍 [JOURNAL] Creating refund journal entry');
      print('💰 [JOURNAL] Refund amount: $refundAmount');
      print('📍 [JOURNAL] Cash location: ${_selectedCashLocation!.id}');

      // Build journal lines following the guide exactly
      final List<Map<String, dynamic>> journalLines = [];
      final totalAmount = widget.invoice.amounts.totalAmount;
      
      // Line 1: DEBIT Sales Revenue (reverse the sale)
      journalLines.add({
        'account_id': 'e45e7d41-7fda-43a1-ac55-9779f3e59697', // Sales revenue account
        'debit': totalAmount,
        'credit': 0,
        'description': 'Sales refund',
        // NO cash object here - this is revenue account
      });
      
      // Line 2: CREDIT Cash/Bank (payment going out)
      journalLines.add({
        'account_id': 'd4a7a16e-45a1-47fe-992b-ff807c8673f0', // Cash account
        'debit': 0,
        'credit': totalAmount,
        'description': 'Cash refund to customer',
        // IMPORTANT: cash object ONLY for cash/bank accounts
        'cash': {
          'cash_location_id': _selectedCashLocation!.id,
        },
      });

      // Prepare RPC parameters following the guide exactly
      final params = {
        'p_base_amount': widget.invoice.amounts.totalAmount,  // Use invoice's total amount
        'p_company_id': appState.companyChoosen,
        'p_created_by': userId,
        'p_description': invoiceNumber,  // Just the invoice number
        'p_entry_date': DateTime.now().toIso8601String(),
        'p_lines': journalLines,
        'p_store_id': appState.storeChoosen,
        
        // CRITICAL: These MUST be null or empty for refunds
        'p_counterparty_id': null,      // NEVER use for refunds
        'p_if_cash_location_id': null,  // NEVER use - put in p_lines instead
      };

      print('📤 [JOURNAL] RPC Parameters: $params');

      // Call RPC function
      final response = await _supabase.rpc(
        'insert_journal_with_everything',
        params: params,
      );

      print('📥 [JOURNAL] RPC Response: $response');

      if (response != null) {
        print('✅ [JOURNAL] Journal entry created: $response');
        return true;
      } else {
        print('❌ [JOURNAL] No response from journal RPC');
        return false;
      }
      
    } catch (e, stackTrace) {
      print('❌ [JOURNAL] Error creating refund journal: $e');
      print('📚 [JOURNAL] Stack trace: $stackTrace');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '', decimalDigits: 0);
    final symbol = widget.currency?.symbol ?? '';
    
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.all(TossSpacing.space5),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          boxShadow: [
            BoxShadow(
              color: TossColors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Warning Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: TossColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_rounded,
                  color: TossColors.error,
                  size: 32,
                ),
              ),
              
              SizedBox(height: TossSpacing.space4),
              
              // Title
              Text(
                'Refund Invoice',
                style: TossTextStyles.h2.copyWith(
                  fontWeight: FontWeight.bold,
                  color: TossColors.gray900,
                ),
              ),
              
              SizedBox(height: TossSpacing.space3),
              
              // Invoice Details
              Container(
                padding: EdgeInsets.all(TossSpacing.space3),
                decoration: BoxDecoration(
                  color: TossColors.gray50,
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Column(
                  children: [
                    _buildDetailRow('Invoice:', widget.invoice.invoiceNumber, isInvoiceNumber: true),
                    SizedBox(height: TossSpacing.space2),
                    _buildDetailRow('Amount:', '$symbol${currencyFormat.format(widget.invoice.amounts.totalAmount)}', isAmount: true),
                  ],
                ),
              ),
              
              SizedBox(height: TossSpacing.space4),
              
              // Cash Location Selection
              _buildCashLocationSection(),
              
              SizedBox(height: TossSpacing.space4),
              
              // Refund Reason Text Field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Refund Reason (Optional)',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space2),
                  TextField(
                    controller: _reasonController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Enter reason for refund...',
                      hintStyle: TossTextStyles.body.copyWith(
                        color: TossColors.gray500,
                      ),
                      filled: true,
                      fillColor: TossColors.gray50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        borderSide: BorderSide(color: TossColors.gray300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        borderSide: BorderSide(color: TossColors.gray300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        borderSide: BorderSide(color: TossColors.primary, width: 2),
                      ),
                      contentPadding: EdgeInsets.all(TossSpacing.space3),
                    ),
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                    ),
                    enabled: !_isProcessing,
                  ),
                ],
              ),
              
              // Error Message
              if (_errorMessage != null) ...[
                SizedBox(height: TossSpacing.space3),
                Container(
                  padding: EdgeInsets.all(TossSpacing.space3),
                  decoration: BoxDecoration(
                    color: TossColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: TossColors.error,
                        size: 20,
                      ),
                      SizedBox(width: TossSpacing.space2),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              SizedBox(height: TossSpacing.space3),
              
              // Warning Message
              Text(
                'Are you sure you want to refund this invoice?',
                textAlign: TextAlign.center,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray700,
                  height: 1.4,
                ),
              ),
              
              SizedBox(height: TossSpacing.space2),
              
              Text(
                'This action cannot be undone.',
                textAlign: TextAlign.center,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                ),
              ),
              
              SizedBox(height: TossSpacing.space5),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isProcessing ? null : widget.onCancel,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
                        side: const BorderSide(color: TossColors.gray300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.gray700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (_isProcessing || _selectedCashLocation == null) ? null : () {
                        HapticFeedback.mediumImpact();
                        _processRefund();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedCashLocation == null 
                          ? TossColors.gray300 
                          : TossColors.error,
                        foregroundColor: _selectedCashLocation == null 
                          ? TossColors.gray500 
                          : TossColors.white,
                        padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        ),
                      ),
                      child: _isProcessing 
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(TossColors.white),
                            ),
                          )
                        : Text(
                            'OK',
                            style: TossTextStyles.body.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isInvoiceNumber = false, bool isAmount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray600,
          ),
        ),
        Text(
          value,
          style: TossTextStyles.body.copyWith(
            fontWeight: isAmount ? FontWeight.bold : FontWeight.w600,
            color: isAmount ? TossColors.error : TossColors.gray900,
          ),
        ),
      ],
    );
  }

  Widget _buildCashLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Refund Payment Location',
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            color: TossColors.gray900,
          ),
        ),
        SizedBox(height: TossSpacing.space2),
        
        if (_isLoadingLocations) ...[
          Container(
            padding: EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(color: TossColors.gray300),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(TossColors.primary),
                  ),
                ),
                SizedBox(width: TossSpacing.space3),
                Text(
                  'Loading payment locations...',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
          ),
        ] else if (_cashLocations.isEmpty) ...[
          Container(
            padding: EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(color: TossColors.warning.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: TossColors.warning,
                  size: 20,
                ),
                SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    'No payment locations available. Please set up cash locations in your settings.',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.warning,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(color: TossColors.gray300),
            ),
            child: Column(
              children: _cashLocations.map((location) {
                final isSelected = _selectedCashLocation?.id == location.id;
                return InkWell(
                  onTap: _isProcessing ? null : () {
                    setState(() {
                      _selectedCashLocation = location;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(TossSpacing.space3),
                    decoration: BoxDecoration(
                      color: isSelected 
                        ? TossColors.primary.withValues(alpha: 0.1)
                        : TossColors.white,
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? TossColors.primary : TossColors.gray400,
                              width: 2,
                            ),
                            color: isSelected ? TossColors.primary : TossColors.white,
                          ),
                          child: isSelected ? Icon(
                            Icons.check,
                            size: 12,
                            color: TossColors.white,
                          ) : null,
                        ),
                        SizedBox(width: TossSpacing.space3),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Location name
                              Text(
                                location.name,
                                style: TossTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: TossColors.gray900,
                                ),
                              ),
                              SizedBox(height: TossSpacing.space1),
                              // Simple type display
                              Text(
                                location.type.toLowerCase(),
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Show type badge on the right
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: TossSpacing.space2,
                            vertical: TossSpacing.space1,
                          ),
                          decoration: BoxDecoration(
                            color: TossColors.gray100,
                            borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                          ),
                          child: Text(
                            location.type.toUpperCase(),
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }
}