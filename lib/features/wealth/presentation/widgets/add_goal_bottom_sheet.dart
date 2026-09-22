import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/success_alert_dialog.dart';

class AddGoalBottomSheet extends StatefulWidget {
  const AddGoalBottomSheet({super.key});

  @override
  State<AddGoalBottomSheet> createState() => _AddGoalBottomSheetState();
}

class _AddGoalBottomSheetState extends State<AddGoalBottomSheet> {
  String _selectedCategory = 'EMERGENCY';
  final _categories = ['EMERGENCY', 'HOUSING', 'TRAVEL', 'VEHICLE', 'GADGET', 'OTHER'];

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _currentAmountController = TextEditingController();
  final _targetMonthsController = TextEditingController();
  final _accountController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _targetAmountController.dispose();
    _currentAmountController.dispose();
    _targetMonthsController.dispose();
    _accountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                'Create New Saving Goal',
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

              // Goal Name Input
              _buildTextField(
                controller: _nameController,
                label: 'Goal Name',
                hint: 'e.g. Dana Darurat, DP Rumah, Liburan',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Goal name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Target Amount Input
              _buildTextField(
                controller: _targetAmountController,
                label: 'Target Amount (Rp)',
                hint: '0',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Target amount is required';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Must be a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Current Saved Amount Input
              _buildTextField(
                controller: _currentAmountController,
                label: 'Initial Saved Amount (Rp)',
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
              const SizedBox(height: 16),

              // Target Months Input
              _buildTextField(
                controller: _targetMonthsController,
                label: 'Target Timeline (Months)',
                hint: 'e.g. 12',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Target months is required';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Must be a valid integer';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Source Account (Optional)
              _buildTextField(
                controller: _accountController,
                label: 'Connected Account (Optional)',
                hint: 'e.g. Bank BCA - Tabungan',
              ),
              const SizedBox(height: 32),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context); // Close bottom sheet
                    SuccessAlertDialog.show(
                      context,
                      title: 'Goal Created',
                      message: 'Goal "${_nameController.text}" has been successfully created!',
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
                  'Save Goal',
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
