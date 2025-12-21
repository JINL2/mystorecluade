import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../counter_party/models/counter_party_models.dart';
import '../../counter_party/widgets/counter_party_form.dart';
import 'package:myfinance_improved/core/themes/index.dart';

/// Wrapper widget for editing counterparty from debt control context
/// This widget fetches the counterparty data and shows the CounterPartyForm
class EditCounterpartySheet {
  static Future<bool?> show(
    BuildContext context, {
    required String counterpartyId,
    required String counterpartyName,
    VoidCallback? onUpdate,
  }) async {
    // First fetch the counterparty data
    CounterParty? counterParty;
    
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('counterparties')
          .select()
          .eq('counterparty_id', counterpartyId)
          .eq('is_deleted', false)
          .maybeSingle();
          
      if (response != null) {
        counterParty = CounterParty.fromJson(response);
      }
    } catch (e) {
      // Error fetching counterparty
    }
    
    if (counterParty == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load counterparty details'),
          backgroundColor: TossColors.error,
        ),
      );
      return null;
    }
    
    // Show the form with fetched data using the existing CounterPartyForm
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      enableDrag: true,
      isDismissible: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: CounterPartyForm(
          counterParty: counterParty,
        ),
      ),
    ).then((result) {
      // If the form was saved successfully, call the onUpdate callback
      if (result == true && onUpdate != null) {
        onUpdate();
      }
      return result;
    });
  }
}