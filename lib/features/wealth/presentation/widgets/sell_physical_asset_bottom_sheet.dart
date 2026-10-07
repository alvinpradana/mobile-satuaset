import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uicons/uicons.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/success_alert_dialog.dart';
import '../../domain/models/physical_asset_model.dart';
import '../../domain/models/wealth_item.dart';
import '../providers/physical_assets_provider.dart';
import '../providers/wealth_provider.dart';

class SellPhysicalAssetBottomSheet extends ConsumerStatefulWidget {
  final PhysicalAssetModel asset;

  const SellPhysicalAssetBottomSheet({
    super.key,
    required this.asset,
  });

  @override
  ConsumerState<SellPhysicalAssetBottomSheet> createState() => _SellPhysicalAssetBottomSheetState();
}

class _SellPhysicalAssetBottomSheetState extends ConsumerState<SellPhysicalAssetBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _priceController;
  DateTime _saleDate = DateTime.now();
  WealthItem? _selectedAccount;

  final _currencyFormatter = CurrencyTextInputFormatter.currency(
    locale: 'id_ID',
    symbol: '',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(text: _currencyFormatter.formatDouble(widget.asset.currentEstimatedValue));
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedAccount != null) {
      final priceText = _priceController.text;
      final parsedPrice = double.tryParse(priceText.replaceAll('.', ''));

      if (parsedPrice == null) return;

      final updatedAsset = widget.asset.copyWith(
        salePrice: parsedPrice,
        saleDate: _saleDate,
        status: PhysicalAssetStatus.sold,
      );

      ref.read(physicalAssetsProvider.notifier).updateAsset(updatedAsset);
      
      // Normally we would also update the selected account balance here using an accounts provider method.
      // e.g. ref.read(accountsProvider.notifier).addBalance(_selectedAccount!.id, parsedPrice);

      Navigator.pop(context);
      SuccessAlertDialog.show(
        context,
        title: 'Asset Sold',
        message: 'Successfully sold "${widget.asset.name}" and routed the funds to ${_selectedAccount!.name}.',
      );
    }
  }

  void _openAccountSelector() {
    final accounts = ref.read(wealthItemsProvider('accounts')).where((a) => a.status == WealthItemStatus.active).toList();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AccountSelectorSheet(
        accounts: accounts,
        onSelected: (account) {
          setState(() {
            _selectedAccount = account;
          });
        },
      ),
    );
  }
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _saleDate,
      firstDate: widget.asset.purchaseDate, // Can't sell before buying
      lastDate: DateTime.now(), // Can't sell in the future
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryAccent,
              onPrimary: Colors.black,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _saleDate) {
      setState(() {
        _saleDate = picked;
      });
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
                    'Sell Asset',
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
              
              // Asset Field (Locked)
              _buildSelectorField(
                label: 'Asset Name',
                value: widget.asset.name,
                hint: '',
                icon: UIcons.regularRounded.home,
                onTap: () {},
                isLocked: true,
              ),
              const SizedBox(height: 16),
              
              // Destination Account Selector
              _buildSelectorField(
                label: 'Destination Account',
                value: _selectedAccount?.name,
                hint: 'Select Destination Account',
                icon: UIcons.regularRounded.bank,
                onTap: _openAccountSelector,
              ),
              if (_selectedAccount == null && _formKey.currentState?.validate() == false)
                const Padding(
                  padding: EdgeInsets.only(top: 8.0, left: 4.0),
                  child: Text(
                    'Please select a destination account',
                    style: TextStyle(color: AppColors.negative, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 16),
              
              // Sale Date
              _buildSelectorField(
                label: 'Sale Date',
                value: DateFormat('dd MMM yyyy').format(_saleDate),
                hint: 'Select Date',
                icon: UIcons.regularRounded.calendar,
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 16),

              // Sale Price Field
              FormField<String>(
                initialValue: _priceController.text,
                validator: (value) {
                  if (value == null || value.trim().isEmpty || double.tryParse(value.replaceAll('.', '')) == 0) {
                    return 'Sale price cannot be empty or zero';
                  }
                  return null;
                },
                builder: (FormFieldState<String> field) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sale Price',
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
                                controller: _priceController,
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
                onPressed: (_formKey.currentState?.validate() ?? false) && _selectedAccount != null ? _submitForm : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryAccent,
                  disabledBackgroundColor: AppColors.surface,
                  foregroundColor: Colors.black,
                  disabledForegroundColor: AppColors.textSecondary,
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  elevation: 0,
                ),
                child: const Text(
                  'Confirm Sale',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
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

class _AccountSelectorSheet extends StatelessWidget {
  final List<WealthItem> accounts;
  final Function(WealthItem) onSelected;

  const _AccountSelectorSheet({
    required this.accounts,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Select Destination Account',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          ...accounts.map((account) {
            final currencyFormatter = NumberFormat.currency(
              locale: 'id_ID',
              symbol: account.currency,
              decimalDigits: 0,
            );
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(account.iconData, color: AppColors.primaryAccent),
              ),
              title: Text(account.name, style: const TextStyle(color: AppColors.textPrimary)),
              subtitle: Text(account.institution ?? '', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              trailing: Text(
                currencyFormatter.format(account.value),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                onSelected(account);
                Navigator.pop(context);
              },
            );
          }),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
