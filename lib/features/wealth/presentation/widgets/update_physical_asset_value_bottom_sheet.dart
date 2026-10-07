import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uicons/uicons.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/success_alert_dialog.dart';
import '../../domain/models/physical_asset_model.dart';
import '../providers/physical_assets_provider.dart';

class UpdatePhysicalAssetValueBottomSheet extends ConsumerStatefulWidget {
  final PhysicalAssetModel asset;

  const UpdatePhysicalAssetValueBottomSheet({
    super.key,
    required this.asset,
  });

  @override
  ConsumerState<UpdatePhysicalAssetValueBottomSheet> createState() => _UpdatePhysicalAssetValueBottomSheetState();
}

class _UpdatePhysicalAssetValueBottomSheetState extends ConsumerState<UpdatePhysicalAssetValueBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _valueController;

  final _currencyFormatter = CurrencyTextInputFormatter.currency(
    locale: 'id_ID',
    symbol: '',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    _valueController = TextEditingController(text: _currencyFormatter.formatDouble(widget.asset.currentEstimatedValue));
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final valueText = _valueController.text;
      final parsedValue = double.tryParse(valueText.replaceAll('.', ''));

      if (parsedValue == null) {
        return;
      }

      final updatedAsset = widget.asset.copyWith(
        currentEstimatedValue: parsedValue,
        lastValuedDate: DateTime.now(),
      );

      ref.read(physicalAssetsProvider.notifier).updateAsset(updatedAsset);

      Navigator.pop(context);
      SuccessAlertDialog.show(
        context,
        title: 'Value Updated',
        message: 'Current estimated value for "${updatedAsset.name}" has been successfully updated.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Update Value',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(UIcons.regularRounded.cross, color: AppColors.textSecondary, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Current Estimated Value Field
              FormField<String>(
                initialValue: _valueController.text,
                validator: (value) {
                  if (value == null || value.trim().isEmpty || double.tryParse(value.replaceAll('.', '')) == 0) {
                    return 'Value cannot be empty or zero';
                  }
                  return null;
                },
                builder: (FormFieldState<String> field) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current Estimated Value',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: field.hasError ? Border.all(color: AppColors.negative, width: 1) : null,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              decoration: const BoxDecoration(
                                border: Border(right: BorderSide(color: AppColors.border, width: 1)),
                              ),
                              child: const Text(
                                'IDR',
                                style: TextStyle(color: AppColors.primaryAccent, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _valueController,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [_currencyFormatter],
                                style: const TextStyle(color: AppColors.textPrimary),
                                onChanged: (val) => field.didChange(val),
                                decoration: const InputDecoration(
                                  hintText: '0',
                                  hintStyle: TextStyle(color: AppColors.textSecondary),
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (field.hasError) ...[
                        const SizedBox(height: 8),
                        Text(
                          field.errorText!,
                          style: const TextStyle(color: AppColors.negative, fontSize: 12),
                        ),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 32),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryAccent,
                  foregroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  elevation: 0,
                ),
                child: const Text(
                  'Update Value',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
