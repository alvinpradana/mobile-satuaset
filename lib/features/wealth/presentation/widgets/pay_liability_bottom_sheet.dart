import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/success_alert_dialog.dart';
import '../../domain/models/wealth_item.dart';
import '../providers/wealth_provider.dart';

class PayLiabilityBottomSheet extends ConsumerStatefulWidget {
  final WealthItem liability;

  const PayLiabilityBottomSheet({
    super.key,
    required this.liability,
  });

  @override
  ConsumerState<PayLiabilityBottomSheet> createState() => _PayLiabilityBottomSheetState();
}

class _PayLiabilityBottomSheetState extends ConsumerState<PayLiabilityBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  
  String? _selectedAccountId;
  
  final _currencyFormatter = CurrencyTextInputFormatter.currency(
    locale: 'id_ID',
    symbol: '',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    // Default to the mock monthly payment
    final double defaultMonthlyPayment = widget.liability.value.abs() * 0.05;
    _amountController.text = _currencyFormatter.format(defaultMonthlyPayment.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if ((_formKey.currentState?.validate() ?? false) && _selectedAccountId != null) {
      Navigator.pop(context); // Close bottom sheet
      SuccessAlertDialog.show(
        context,
        title: 'Payment Recorded',
        message: 'Your payment has been recorded successfully.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Add padding to account for keyboard
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    
    final accounts = ref.watch(wealthItemsProvider('accounts')).where((a) => a.status == WealthItemStatus.active).toList();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomInset),
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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

                const Text(
                  'Record Payment',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Source Account Selector
                const Text(
                  'Source Account',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedAccountId,
                  dropdownColor: AppColors.surface,
                  icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Select account',
                    hintStyle: const TextStyle(color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  items: accounts.map((account) {
                    return DropdownMenuItem<String>(
                      value: account.id,
                      child: Text('${account.name} - ${_currencyFormatter.format(account.value.toStringAsFixed(0))}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedAccountId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a source account';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Amount Field
                const Text(
                  'Amount',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [_currencyFormatter],
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
                  decoration: InputDecoration(
                    prefixText: 'Rp ',
                    prefixStyle: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    final numValue = double.tryParse(value.replaceAll('.', '')) ?? 0;
                    if (numValue <= 0) return 'Must be greater than 0';
                    
                    if (_selectedAccountId != null) {
                      final selectedAcc = accounts.firstWhere((a) => a.id == _selectedAccountId);
                      if (numValue > selectedAcc.value) {
                        return 'Insufficient balance';
                      }
                    }
                    
                    return null;
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Confirm Payment',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
