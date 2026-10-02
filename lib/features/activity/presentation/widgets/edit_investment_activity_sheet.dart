import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uicons/uicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/success_alert_dialog.dart';
import '../../domain/models/activity_item.dart';
import 'package:intl/intl.dart';

enum Currency { idr, usd }

class EditInvestmentActivitySheet extends ConsumerStatefulWidget {
  final ActivityItem activity;

  const EditInvestmentActivitySheet({
    super.key,
    required this.activity,
  });

  @override
  ConsumerState<EditInvestmentActivitySheet> createState() => _EditInvestmentActivitySheetState();
}

class _EditInvestmentActivitySheetState extends ConsumerState<EditInvestmentActivitySheet> {
  String? _selectedPlatform;
  final TextEditingController _unitsController = TextEditingController();
  final TextEditingController _avgPriceController = TextEditingController();
  Currency _selectedCurrency = Currency.usd; // Defaulting to USD, but ideally mapped

  @override
  void initState() {
    super.initState();
    
    _selectedPlatform = widget.activity.account;
    
    if (widget.activity.quantity != null) {
      _unitsController.text = widget.activity.quantity.toString();
      if (widget.activity.quantity! > 0) {
        final avgPrice = widget.activity.amount / widget.activity.quantity!;
        _avgPriceController.text = avgPrice.toStringAsFixed(2).replaceAll('.00', '');
      }
    }
    
    if (widget.activity.currency.toUpperCase() == 'IDR' || widget.activity.currency.toUpperCase() == 'RP') {
      _selectedCurrency = Currency.idr;
    }

    _unitsController.addListener(() => setState(() {}));
    _avgPriceController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _unitsController.dispose();
    _avgPriceController.dispose();
    super.dispose();
  }

  void _openPlatformSelector() {
    final List<String> mockPlatforms = ['Indodax', 'Binance', 'Tokocrypto', 'Pluang', 'Gotrade', 'Ajaib', 'Pintu'];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _PlatformSelectorSheet(
        platforms: mockPlatforms,
      ),
    ).then((selected) {
      if (selected != null) {
        setState(() {
          _selectedPlatform = selected as String;
        });
      }
    });
  }

  bool _isFormValid() {
    if (_selectedPlatform == null || _selectedPlatform!.isEmpty) return false;
    
    final units = double.tryParse(_unitsController.text.replaceAll(',', '.'));
    if (units == null || units <= 0) return false;
    
    final price = double.tryParse(_avgPriceController.text.replaceAll(',', '.'));
    if (price == null || price <= 0) return false;
    
    return true;
  }

  void _submitForm() {
    if (!_isFormValid()) return;
    
    final units = double.parse(_unitsController.text.replaceAll(',', '.'));
    final price = double.parse(_avgPriceController.text.replaceAll(',', '.'));
    final totalValue = units * price;
    
    final payload = {
      "action": "EDIT_ACTIVITY",
      "activity_id": widget.activity.id,
      "platform": _selectedPlatform,
      "units": units,
      "price": price,
      "total_amount": totalValue,
      "currency": _selectedCurrency.name.toUpperCase(),
    };
    
    debugPrint("=== SIMULATED EDIT PAYLOAD ===");
    debugPrint(const JsonEncoder.withIndent('  ').convert(payload));
    
    Navigator.pop(context); // close edit form
    Navigator.pop(context); // close detail sheet
    
    SuccessAlertDialog.show(
      context,
      title: 'Transaction Updated',
      message: 'The transaction has been successfully updated.',
    );
  }

  @override
  Widget build(BuildContext context) {
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
              'Edit Transaction',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
              
            _buildSelectorField(
                      label: 'Broker / Platform',
                      value: _selectedPlatform,
                      hint: 'Select Source Platform',
                      icon: UIcons.regularRounded.building,
                      onTap: _openPlatformSelector,
                    ),
                    const SizedBox(height: 16),
                      
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _unitsController,
                            label: 'Units',
                            hintText: '0.00',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            textInputAction: TextInputAction.next,
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
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    TextInputType? keyboardType,
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
          'Average Price',
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
                  setState(() {
                    _selectedCurrency = _selectedCurrency == Currency.usd ? Currency.idr : Currency.usd;
                  });
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
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*[\.,]?\d*')),
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      return newValue.copyWith(text: newValue.text.replaceAll(',', '.'));
                    }),
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

  Widget _buildSelectorField({
    required String label,
    required String? value,
    required String hint,
    required IconData icon,
    required VoidCallback onTap,
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
                      color: value != null ? AppColors.textPrimary : AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ),
                Icon(UIcons.regularRounded.angle_small_down, color: AppColors.textSecondary, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PlatformSelectorSheet extends StatefulWidget {
  final List<String> platforms;
  const _PlatformSelectorSheet({required this.platforms});

  @override
  State<_PlatformSelectorSheet> createState() => _PlatformSelectorSheetState();
}

class _PlatformSelectorSheetState extends State<_PlatformSelectorSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredPlatforms = [];

  @override
  void initState() {
    super.initState();
    _filteredPlatforms = widget.platforms;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredPlatforms = widget.platforms;
      } else {
        _filteredPlatforms = widget.platforms.where((platform) {
          return platform.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (_, scrollController) {
        return Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2))),
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Text('Select Platform', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search platform...',
                    hintStyle: const TextStyle(color: AppColors.textSecondary),
                    prefixIcon: Icon(UIcons.regularRounded.search, color: AppColors.textSecondary, size: 20),
                    suffixIcon: _searchController.text.isNotEmpty ? IconButton(
                      icon: Icon(UIcons.regularRounded.cross_circle, color: AppColors.textSecondary, size: 18),
                      onPressed: () {
                        _searchController.clear();
                      },
                    ) : null,
                    filled: true,
                    fillColor: AppColors.surfaceHover,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.primaryAccent, width: 1),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _filteredPlatforms.isEmpty 
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(UIcons.regularRounded.search, size: 48, color: AppColors.textSecondary.withOpacity(0.3)),
                          const SizedBox(height: 16),
                          Text(
                            'No platforms found for "${_searchController.text}"', 
                            style: const TextStyle(color: AppColors.textSecondary),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: _filteredPlatforms.length,
                      itemBuilder: (context, index) {
                        final platform = _filteredPlatforms[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                          title: Text(platform, style: const TextStyle(color: AppColors.textPrimary)),
                          onTap: () => Navigator.pop(context, platform),
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
}
