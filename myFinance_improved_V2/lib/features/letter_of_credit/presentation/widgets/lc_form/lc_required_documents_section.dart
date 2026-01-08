import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/repositories/lc_repository.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Required Documents section for LC form
class LCRequiredDocumentsSection extends StatelessWidget {
  final List<LCRequiredDocumentParams> requiredDocuments;
  final ValueChanged<List<LCRequiredDocumentParams>> onDocumentsChanged;

  const LCRequiredDocumentsSection({
    super.key,
    required this.requiredDocuments,
    required this.onDocumentsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...requiredDocuments.asMap().entries.map((entry) {
          return _buildDocumentItem(context, entry.key, entry.value);
        }),
        const SizedBox(height: TossSpacing.space2),
        TossButton.textButton(
          text: 'Add Document',
          leadingIcon: Icon(Icons.add, size: TossSpacing.iconSM),
          onPressed: () => _addDocument(context),
        ),
      ],
    );
  }

  Widget _buildDocumentItem(BuildContext context, int index, LCRequiredDocumentParams doc) {
    return TossWhiteCard(
      margin: const EdgeInsets.only(bottom: TossSpacing.space2),
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc.name ?? doc.code,
                  style: TossTextStyles.bodyMedium,
                ),
                const SizedBox(height: TossSpacing.space1),
                Text(
                  'Original: ${doc.copiesOriginal}, Copy: ${doc.copiesCopy}',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              final newList = List<LCRequiredDocumentParams>.from(requiredDocuments);
              newList.removeAt(index);
              onDocumentsChanged(newList);
            },
          ),
        ],
      ),
    );
  }

  void _addDocument(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => LCAddDocumentDialog(
        onAdd: (doc) {
          final newList = List<LCRequiredDocumentParams>.from(requiredDocuments);
          newList.add(doc);
          onDocumentsChanged(newList);
        },
      ),
    );
  }
}

/// Dialog for adding a required document
class LCAddDocumentDialog extends StatefulWidget {
  final ValueChanged<LCRequiredDocumentParams> onAdd;

  const LCAddDocumentDialog({super.key, required this.onAdd});

  @override
  State<LCAddDocumentDialog> createState() => _LCAddDocumentDialogState();
}

class _LCAddDocumentDialogState extends State<LCAddDocumentDialog> {
  String _code = '';
  String _name = '';
  int _original = 3;
  int _copy = 3;

  final _commonDocs = [
    {'code': 'BL', 'name': 'Bill of Lading'},
    {'code': 'AWB', 'name': 'Air Waybill'},
    {'code': 'CI', 'name': 'Commercial Invoice'},
    {'code': 'PL', 'name': 'Packing List'},
    {'code': 'CO', 'name': 'Certificate of Origin'},
    {'code': 'INS', 'name': 'Insurance Certificate'},
    {'code': 'CERT', 'name': 'Inspection Certificate'},
    {'code': 'PHY', 'name': 'Phytosanitary Certificate'},
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Required Document'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Common documents dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Document Type'),
              items: [
                const DropdownMenuItem(value: '', child: Text('Custom...')),
                ..._commonDocs.map((d) => DropdownMenuItem(
                      value: d['code'],
                      child: Text('${d['code']} - ${d['name']}'),
                    )),
              ],
              onChanged: (v) {
                if (v != null && v.isNotEmpty) {
                  final doc = _commonDocs.firstWhere((d) => d['code'] == v);
                  setState(() {
                    _code = doc['code']!;
                    _name = doc['name']!;
                  });
                }
              },
            ),
            const SizedBox(height: TossSpacing.space4),
            TossTextField(
              inlineLabel: 'Code',
              controller: TextEditingController(text: _code),
              hintText: '',
              onChanged: (v) => _code = v,
            ),
            const SizedBox(height: TossSpacing.space4),
            TossTextField(
              inlineLabel: 'Name',
              controller: TextEditingController(text: _name),
              hintText: '',
              onChanged: (v) => _name = v,
            ),
            const SizedBox(height: TossSpacing.space4),
            Row(
              children: [
                Expanded(
                  child: TossTextField(
                    inlineLabel: 'Original Copies',
                    keyboardType: TextInputType.number,
                    controller: TextEditingController(text: '$_original'),
                    hintText: '',
                    onChanged: (v) => _original = int.tryParse(v) ?? 3,
                  ),
                ),
                const SizedBox(width: TossSpacing.space4),
                Expanded(
                  child: TossTextField(
                    inlineLabel: 'Copy Copies',
                    keyboardType: TextInputType.number,
                    controller: TextEditingController(text: '$_copy'),
                    hintText: '',
                    onChanged: (v) => _copy = int.tryParse(v) ?? 3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TossButton.textButton(
          text: 'Cancel',
          onPressed: () => Navigator.pop(context),
        ),
        TossButton.primary(
          text: 'Add',
          onPressed: () {
            if (_code.isNotEmpty) {
              widget.onAdd(LCRequiredDocumentParams(
                code: _code,
                name: _name.isNotEmpty ? _name : null,
                copiesOriginal: _original,
                copiesCopy: _copy,
              ));
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
