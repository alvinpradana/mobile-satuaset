import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/success_alert_dialog.dart';
import 'package:uicons/uicons.dart';
import '../../../../shared/models/currency_model.dart';
import '../../../../shared/widgets/currency_picker_sheet.dart';

class AddAccountBottomSheet extends StatefulWidget {
  const AddAccountBottomSheet({super.key});

  @override
  State<AddAccountBottomSheet> createState() => _AddAccountBottomSheetState();
}

class _AddAccountBottomSheetState extends State<AddAccountBottomSheet> {
  String _selectedCategory = 'BANK';
  final _categories = ['BANK', 'E-WALLET', 'CASH', 'CRYPTO'];
  Currency _selectedCurrency = Currency.idr;

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _identifierController = TextEditingController();
  final _balanceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _identifierController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  String get _accountNameHint {
    switch (_selectedCategory) {
      case 'BANK':
        return 'e.g. BCA Utama';
      case 'E-WALLET':
        return 'e.g. Gopay';
      case 'CASH':
        return 'e.g. Dompet Pribadi';
      case 'CRYPTO':
        return 'e.g. Metamask';
      default:
        return 'e.g. Tabungan Liburan';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Add padding to account for keyboard
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
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
              'Add New Account',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Category Selector
            const Text(
              'Category',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedCategory = cat;
                        if (cat == 'CRYPTO') {
                          _selectedCurrency = Currency.usd;
                        } else {
                          _selectedCurrency = Currency.idr;
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryAccent : AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppColors.primaryAccent : AppColors.border,
                        ),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: isSelected ? Colors.black : AppColors.textPrimary,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Name Input
            _buildTextField(
              controller: _nameController,
              label: 'Account Name',
              hint: _accountNameHint,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Account name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Identifier Input
            if (_selectedCategory != 'CASH') ...[
              _buildTextField(
                controller: _identifierController,
                label: _selectedCategory == 'CRYPTO' ? 'Wallet Address (Optional)' : 'Account Number / ID (Optional)',
                hint: _selectedCategory == 'CRYPTO' ? 'e.g. 0x...abc' : 'e.g. 1234567890',
                keyboardType: _selectedCategory == 'CRYPTO' ? TextInputType.text : TextInputType.number,
                validator: (value) {
                  if (_selectedCategory != 'CRYPTO' && value != null && value.trim().isNotEmpty) {
                    if (int.tryParse(value) == null) {
                      return 'Must be numeric';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
            ],

            // Initial Balance Input
            const Text(
              'Initial Balance',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Currency Toggle
                  GestureDetector(
                    onTap: () {
                      CurrencyPickerSheet.show(
                        context,
                        selectedCurrency: _selectedCurrency,
                        onCurrencySelected: (currency) {
                          setState(() {
                            _selectedCurrency = currency;
                          });
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      decoration: const BoxDecoration(
                        border: Border(right: BorderSide(color: AppColors.border, width: 1)),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _selectedCurrency.name.toUpperCase(),
                            style: const TextStyle(color: AppColors.primaryAccent, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 4),
                          Icon(UIcons.regularRounded.angle_small_down, color: AppColors.primaryAccent, size: 12),
                        ],
                      ),
                    ),
                  ),
                  
                  // Input Field
                  Expanded(
                    child: TextFormField(
                      controller: _balanceController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: AppColors.textPrimary),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Initial balance is required';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Must be a valid number';
                        }
                        return null;
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
            const SizedBox(height: 32),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Mock submission
                  Navigator.pop(context); // Close bottom sheet
                  SuccessAlertDialog.show(
                    context,
                    title: 'Account Added',
                    message: 'Account "${_nameController.text}" has been successfully added to your portfolio.',
                  );
                }
              },
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
                'Save Account',
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
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
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: AppColors.textPrimary),
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryAccent, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.negative, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.negative, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
