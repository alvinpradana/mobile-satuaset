import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uicons/uicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/success_alert_dialog.dart';
import '../../domain/models/wealth_item.dart';
import 'add_investment_bottom_sheet.dart' show CryptoAsset;
import '../../../../shared/models/currency_model.dart';
import '../../../../shared/widgets/currency_picker_sheet.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class SellInvestmentBottomSheet extends StatefulWidget {
  final CryptoAsset asset;
  final List<AssetExchangeAllocation> allocations;

  const SellInvestmentBottomSheet({
    super.key, 
    required this.asset,
    required this.allocations,
  });

  @override
  State<SellInvestmentBottomSheet> createState() => _SellInvestmentBottomSheetState();
}

class _SellInvestmentBottomSheetState extends State<SellInvestmentBottomSheet> {
  AssetExchangeAllocation? _selectedPlatform;
  final TextEditingController _unitsController = TextEditingController();
  final TextEditingController _avgPriceController = TextEditingController();
  Currency _selectedCurrency = Currency.usd;

  @override
  void initState() {
    super.initState();
    
    // Listeners for validation updates
    _unitsController.addListener(() => setState(() {}));
    _avgPriceController.addListener(() => setState(() {}));
    
    // Auto-select if only 1 platform exists
    if (widget.allocations.length == 1) {
      _selectedPlatform = widget.allocations.first;
    }
  }

  @override
  void dispose() {
    _unitsController.dispose();
    _avgPriceController.dispose();
    super.dispose();
  }

  double _parseFormattedPrice(String value) {
    if (value.isEmpty) return 0;
    if (_selectedCurrency == Currency.usd) {
      return double.tryParse(value.replaceAll(',', '')) ?? 0;
    } else {
      return double.tryParse(value.replaceAll('.', '')) ?? 0;
    }
  }

  CurrencyTextInputFormatter get _currencyFormatter {
    if (_selectedCurrency == Currency.usd) {
      return CurrencyTextInputFormatter.currency(
        locale: 'en_US',
        symbol: '',
        decimalDigits: 2,
      );
    } else {
      return CurrencyTextInputFormatter.currency(
        locale: 'id_ID',
        symbol: '',
        decimalDigits: 0,
      );
    }
  }

  bool _isFormValid() {
    if (_selectedPlatform == null) return false;
    
    final units = double.tryParse(_unitsController.text.replaceAll(',', '.'));
    if (units == null || units <= 0 || units > _selectedPlatform!.units) return false;
    
    final price = _parseFormattedPrice(_avgPriceController.text);
    if (price <= 0) return false;
    
    return true;
  }

  void _submitForm() {
    if (!_isFormValid()) return;
    
    final payload = {
      "action": "SELL",
      "asset_id": widget.asset.id,
      "ticker": widget.asset.symbol,
      "name": widget.asset.name,
      "platform": _selectedPlatform?.exchangeName,
      "units_sold": double.tryParse(_unitsController.text.replaceAll(',', '.')) ?? 0,
      "sell_price": _parseFormattedPrice(_avgPriceController.text),
      "currency": _selectedCurrency.name.toUpperCase(),
    };
    
    debugPrint("=== SIMULATED SELL PAYLOAD ===");
    debugPrint(const JsonEncoder.withIndent('  ').convert(payload));
    
    Navigator.pop(context);
    SuccessAlertDialog.show(
      context,
      title: 'Investment Sold',
      message: 'Successfully sold ${payload["units_sold"]} units of ${widget.asset.symbol} from ${_selectedPlatform?.exchangeName}.',
    );
  }

  // --- SELECTORS ---

  void _openPlatformSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _PlatformSelectorSheet(
        allocations: widget.allocations,
        onSelected: (allocation) {
          setState(() {
            _selectedPlatform = allocation;
            // Clear units if they exceed new platform's max
            final currentUnits = double.tryParse(_unitsController.text.replaceAll(',', '.'));
            if (currentUnits != null && currentUnits > allocation.units) {
              _unitsController.clear();
            }
          });
        },
      ),
    );
  }

  // --- UI BUILDING ---

  @override
  Widget build(BuildContext context) {
    String? unitsErrorText;
    if (_selectedPlatform != null && _unitsController.text.isNotEmpty) {
      final units = double.tryParse(_unitsController.text.replaceAll(',', '.'));
      if (units != null && units > _selectedPlatform!.units) {
        unitsErrorText = 'Exceeds balance';
      }
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 24,
        right: 24,
        top: 8,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Text(
              'Sell Investment',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            
            // Asset Field (Locked)
                    _buildSelectorField(
                      label: 'Asset Name / Ticker',
                      value: '${widget.asset.symbol} - ${widget.asset.name}',
                      hint: '',
                      icon: UIcons.regularRounded.coins,
                      onTap: () {},
                      isLocked: true,
                    ),
                    const SizedBox(height: 16),
                    
                    // Platform Selector
                    _buildSelectorField(
                      label: 'Broker / Platform',
                      value: _selectedPlatform?.exchangeName,
                      hint: 'Select Source Platform',
                      icon: UIcons.regularRounded.building,
                      onTap: _openPlatformSelector,
                    ),
                    
                    // Show available units if platform selected
                    if (_selectedPlatform != null) ...[
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          'Available: ${_selectedPlatform!.units} ${widget.asset.symbol}',
                          style: const TextStyle(
                            color: AppColors.primaryAccent,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    
                    // Units and Sell Price
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _unitsController,
                            label: 'Units to Sell',
                            hintText: '0.00',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            textInputAction: TextInputAction.next,
                            errorText: unitsErrorText,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d*[\.,]?\d*')),
                              TextInputFormatter.withFunction((oldValue, newValue) {
                                return newValue.copyWith(text: newValue.text.replaceAll(',', '.'));
                              }),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildPriceField(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isFormValid() ? _submitForm : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryAccent,
                          disabledBackgroundColor: AppColors.surface,
                          foregroundColor: Colors.black,
                          disabledForegroundColor: AppColors.textSecondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Sell Investment',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction? textInputAction,
    List<TextInputFormatter>? inputFormatters,
    String? errorText,
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
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            error: errorText != null ? Transform.translate(
              offset: const Offset(-16, 0),
              child: Text(errorText, style: const TextStyle(color: AppColors.negative, fontSize: 12)),
            ) : null,
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
  
  Widget _buildPriceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selling Price',
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
                  controller: _avgPriceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.done,
                  inputFormatters: [
                    _currencyFormatter,
                  ],
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    hintText: '0.00',
                    hintStyle: TextStyle(color: AppColors.textSecondary),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// --- SELECTOR SHEETS ---

class _PlatformSelectorSheet extends StatelessWidget {
  final List<AssetExchangeAllocation> allocations;
  final Function(AssetExchangeAllocation) onSelected;

  const _PlatformSelectorSheet({
    required this.allocations,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Source Platform',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(UIcons.regularRounded.cross, color: AppColors.textSecondary, size: 16),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: allocations.length,
              itemBuilder: (context, index) {
                final alloc = allocations[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  leading: CircleAvatar(
                    backgroundColor: AppColors.surfaceHover,
                    child: Icon(UIcons.regularRounded.building, color: AppColors.textPrimary, size: 18),
                  ),
                  title: Text(alloc.exchangeName, style: const TextStyle(color: AppColors.textPrimary)),
                  subtitle: Text('${alloc.units} units available', style: const TextStyle(color: AppColors.textSecondary)),
                  onTap: () {
                    onSelected(alloc);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
