import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:uicons/uicons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/success_alert_dialog.dart';
import '../../domain/models/wealth_item.dart';
import '../providers/wealth_provider.dart';

class PayLiabilityBottomSheet extends ConsumerStatefulWidget {
  final WealthItem liability;
  final Map<String, dynamic>? paymentToEdit;

  const PayLiabilityBottomSheet({
    super.key,
    required this.liability,
    this.paymentToEdit,
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
    if (widget.paymentToEdit != null) {
      _amountController.text = _currencyFormatter.formatDouble(widget.paymentToEdit!['amount'] ?? 0.0);
      _selectedAccountId = widget.paymentToEdit!['accountId'];
    } else {
      // Default to the mock monthly payment
      final double defaultMonthlyPayment = widget.liability.value.abs() * 0.05;
      _amountController.text = _currencyFormatter.formatDouble(defaultMonthlyPayment);
    }
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
        title: widget.paymentToEdit != null ? 'Payment Updated' : 'Payment Recorded',
        message: widget.paymentToEdit != null 
            ? 'Your payment has been updated successfully.'
            : 'Your payment has been recorded successfully.',
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.paymentToEdit != null ? 'Edit Payment' : 'Record Payment',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(UIcons.regularRounded.cross_small, color: AppColors.textSecondary, size: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Source Account Selector
                _buildSelectorField(
                  label: 'Source Account',
                  value: _selectedAccountId != null
                      ? '${accounts.firstWhere((a) => a.id == _selectedAccountId).name} - Rp ${_currencyFormatter.formatDouble(accounts.firstWhere((a) => a.id == _selectedAccountId).value)}'
                      : null,
                  hint: 'Select account',
                  icon: UIcons.regularRounded.bank,
                  onTap: () => _showAccountPicker(accounts),
                ),
                if (_selectedAccountId == null && _formKey.currentState?.validate() == false)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0, left: 4.0),
                    child: Text(
                      'Please select a source account',
                      style: TextStyle(color: AppColors.negative, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 16),

                // Amount Field
                FormField<String>(
                  initialValue: _amountController.text,
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
                  builder: (FormFieldState<String> field) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Amount',
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
                                  controller: _amountController,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  inputFormatters: [_currencyFormatter],
                                  style: const TextStyle(color: AppColors.textPrimary),
                                  onChanged: (val) {
                                    field.didChange(val);
                                    setState(() {});
                                  },
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    widget.paymentToEdit != null ? 'Save Changes' : 'Confirm Payment',
                    style: const TextStyle(
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

  void _showAccountPicker(List<WealthItem> accounts) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Select Account',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (accounts.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'No active accounts available.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                )
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: accounts.length,
                    itemBuilder: (context, index) {
                      final account = accounts[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        title: Text(
                          account.name,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          'Rp ${_currencyFormatter.formatDouble(account.value)}',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _selectedAccountId = account.id;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSelectorField({
    required String label,
    required String? value,
    required String hint,
    required IconData icon,
    required VoidCallback onTap,
    bool isLocked = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(icon, color: AppColors.textSecondary, size: 18),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    value ?? hint,
                    style: TextStyle(
                      color: value != null ? (isLocked ? AppColors.textSecondary : AppColors.textPrimary) : AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (!isLocked)
                  Icon(UIcons.regularRounded.angle_small_down, color: AppColors.textSecondary, size: 16)
                else
                  Icon(UIcons.regularRounded.lock, color: AppColors.textSecondary, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
