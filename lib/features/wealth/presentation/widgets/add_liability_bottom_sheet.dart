import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/success_alert_dialog.dart';

class AddLiabilityBottomSheet extends StatefulWidget {
  const AddLiabilityBottomSheet({super.key});

  @override
  State<AddLiabilityBottomSheet> createState() => _AddLiabilityBottomSheetState();
}

class _AddLiabilityBottomSheetState extends State<AddLiabilityBottomSheet> {
  String _selectedCategory = 'MORTGAGE';
  final _categories = ['MORTGAGE', 'CREDIT CARD', 'PERSONAL LOAN', 'VEHICLE LOAN'];

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _providerController = TextEditingController();
  final _balanceController = TextEditingController();
  final _monthlyPaymentController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _providerController.dispose();
    _balanceController.dispose();
    _monthlyPaymentController.dispose();
    super.dispose();
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
                'Add New Liability',
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: InkWell(
                        onTap: () => setState(() => _selectedCategory = cat),
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
              ),
              const SizedBox(height: 24),

              // Liability Name Input
              _buildTextField(
                controller: _nameController,
                label: 'Liability Name',
                hint: 'e.g. KPR Rumah BTN, Kartu Kredit Mandiri',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Liability name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Bank / Provider Name Input
              _buildTextField(
                controller: _providerController,
                label: 'Bank / Lender Name',
                hint: 'e.g. Bank BTN, Bank Mandiri',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Bank / Lender name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Outstanding Balance Input
              _buildTextField(
                controller: _balanceController,
                label: 'Total Outstanding Balance (Rp)',
                hint: '0',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Outstanding balance is required';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Must be a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Monthly Payment Input
              _buildTextField(
                controller: _monthlyPaymentController,
                label: 'Monthly Installment / Payment (Rp) (Optional)',
                hint: '0',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    if (double.tryParse(value) == null) {
                      return 'Must be a valid number';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context); // Close bottom sheet
                    SuccessAlertDialog.show(
                      context,
                      title: 'Liability Added',
                      message: 'Liability "${_nameController.text}" has been successfully added to your liabilities.',
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
                  'Save Liability',
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
