import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uicons/uicons.dart';
import 'package:intl/intl.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/success_alert_dialog.dart';
import '../../domain/models/physical_asset_model.dart';
import '../providers/physical_assets_provider.dart';

class AddPhysicalAssetBottomSheet extends ConsumerStatefulWidget {
  final PhysicalAssetModel? assetToEdit;

  const AddPhysicalAssetBottomSheet({
    super.key,
    this.assetToEdit,
  });

  @override
  ConsumerState<AddPhysicalAssetBottomSheet> createState() => _AddPhysicalAssetBottomSheetState();
}

class _AddPhysicalAssetBottomSheetState extends ConsumerState<AddPhysicalAssetBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  
  final _categories = ['Property', 'Vehicle', 'Gold', 'Electronics', 'Collectibles', 'Other'];
  String _selectedCategory = 'Property';
  
  final _nameController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _estimatedValueController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  
  DateTime _purchaseDate = DateTime.now();
  bool _showOptionalDetails = false;

  final _currencyFormatter = CurrencyTextInputFormatter.currency(
    locale: 'id_ID',
    symbol: '',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    if (widget.assetToEdit != null) {
      _selectedCategory = widget.assetToEdit!.category;
      _nameController.text = widget.assetToEdit!.name;
      _purchasePriceController.text = _currencyFormatter.formatDouble(widget.assetToEdit!.purchasePrice);
      if (widget.assetToEdit!.currentEstimatedValue != widget.assetToEdit!.purchasePrice) {
        _estimatedValueController.text = _currencyFormatter.formatDouble(widget.assetToEdit!.currentEstimatedValue);
      }
      _purchaseDate = widget.assetToEdit!.purchaseDate;
      if (widget.assetToEdit!.location != null || widget.assetToEdit!.notes != null) {
        _showOptionalDetails = true;
        _locationController.text = widget.assetToEdit!.location ?? '';
        _notesController.text = widget.assetToEdit!.notes ?? '';
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _purchasePriceController.dispose();
    _estimatedValueController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _purchaseDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryAccent,
              onPrimary: Colors.black,
              surface: AppColors.surfaceHover,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _purchaseDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final purchasePrice = double.tryParse(_purchasePriceController.text.replaceAll('.', '')) ?? 0;
      final estimatedValText = _estimatedValueController.text.trim();
      final estimatedValue = estimatedValText.isEmpty 
          ? purchasePrice 
          : (double.tryParse(estimatedValText.replaceAll('.', '')) ?? purchasePrice);

      final newAsset = PhysicalAssetModel(
        id: widget.assetToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        category: _selectedCategory,
        name: _nameController.text.trim(),
        purchasePrice: purchasePrice,
        currentEstimatedValue: estimatedValue,
        purchaseDate: _purchaseDate,
        lastValuedDate: widget.assetToEdit?.lastValuedDate ?? DateTime.now(),
        location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      if (widget.assetToEdit != null) {
        // Edit mode (not actually implemented in the provider right now, might need to call updateAsset if it exists)
        // If there's an edit function, call it, else simulate.
        ref.read(physicalAssetsProvider.notifier).updateAsset(newAsset);
      } else {
        ref.read(physicalAssetsProvider.notifier).addAsset(newAsset);
      }

      Navigator.pop(context);
      SuccessAlertDialog.show(
        context,
        title: widget.assetToEdit != null ? 'Asset Updated' : 'Asset Added',
        message: widget.assetToEdit != null 
          ? '"${newAsset.name}" has been successfully updated.'
          : '"${newAsset.name}" has been successfully added to your physical assets.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

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
                    widget.assetToEdit != null ? 'Edit Physical Asset' : 'Add Physical Asset',
                    style: const TextStyle(
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

              // Category Selector
              const Text(
                'Category',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: (widget.assetToEdit != null ? [_selectedCategory] : _categories).map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: InkWell(
                        onTap: widget.assetToEdit != null 
                            ? null 
                            : () {
                                setState(() {
                                  _selectedCategory = cat;
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
              ),
              const SizedBox(height: 24),

              // Asset Name Input
              _buildTextField(
                controller: _nameController,
                label: 'Asset Name',
                hint: 'e.g. House Bintaro',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Asset name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Purchase Date
              const Text(
                'Purchase Date',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(UIcons.regularRounded.calendar, color: AppColors.textSecondary, size: 18),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          DateFormat('dd MMM yyyy').format(_purchaseDate),
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
                        ),
                      ),
                      Icon(UIcons.regularRounded.angle_small_down, color: AppColors.textSecondary, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Purchase Price
              _buildAmountField(
                controller: _purchasePriceController,
                label: 'Purchase Price',
                hint: '0',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Purchase price is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Current Estimated Value
              _buildAmountField(
                controller: _estimatedValueController,
                label: 'Current Estimated Value (Optional)',
                hint: 'Leave blank to use purchase price',
              ),
              const SizedBox(height: 24),

              // Optional Details Expandable
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showOptionalDetails = !_showOptionalDetails;
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Add More Details (Optional)',
                      style: TextStyle(
                        color: AppColors.primaryAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      _showOptionalDetails ? UIcons.regularRounded.angle_small_up : UIcons.regularRounded.angle_small_down,
                      color: AppColors.primaryAccent,
                      size: 16,
                    ),
                  ],
                ),
              ),
              if (_showOptionalDetails) ...[
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _locationController,
                  label: 'Location',
                  hint: 'e.g. Jakarta Selatan',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _notesController,
                  label: 'Notes',
                  hint: 'Additional information...',
                  maxLines: 3,
                ),
              ],
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
                child: Text(
                  widget.assetToEdit != null ? 'Save Changes' : 'Save Asset',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
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
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return FormField<String>(
      initialValue: controller.text,
      validator: validator,
      builder: (FormFieldState<String> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: field.hasError ? Border.all(color: AppColors.negative, width: 1) : null,
              ),
              child: TextField(
                controller: controller,
                keyboardType: keyboardType,
                maxLines: maxLines,
                style: const TextStyle(color: AppColors.textPrimary),
                onChanged: (val) => field.didChange(val),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: const TextStyle(color: AppColors.textSecondary),
                  filled: true,
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
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
    );
  }

  Widget _buildAmountField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
  }) {
    return FormField<String>(
      initialValue: controller.text,
      validator: validator,
      builder: (FormFieldState<String> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w500),
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
                      controller: controller,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        _currencyFormatter,
                      ],
                      style: const TextStyle(color: AppColors.textPrimary),
                      onChanged: (val) => field.didChange(val),
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: const TextStyle(color: AppColors.textSecondary),
                        filled: true,
                        fillColor: Colors.transparent,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
    );
  }
}
