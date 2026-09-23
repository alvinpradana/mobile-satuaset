import 'package:flutter/material.dart';
import 'package:uicons/uicons.dart';
import '../../../../core/theme/app_colors.dart';

class AddInvestmentBottomSheet extends StatefulWidget {
  final String? initialCategory;
  final bool isCategoryLocked;

  const AddInvestmentBottomSheet({super.key, this.initialCategory, this.isCategoryLocked = false});

  @override
  State<AddInvestmentBottomSheet> createState() => _AddInvestmentBottomSheetState();
}

class _AddInvestmentBottomSheetState extends State<AddInvestmentBottomSheet> {
  late String _selectedCategory;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brokerController = TextEditingController();
  final TextEditingController _unitsController = TextEditingController();
  final TextEditingController _avgPriceController = TextEditingController();

  final List<String> _categories = ['Crypto', 'Stocks', 'Bonds', 'Mutual Funds', 'Other'];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? _categories.first;
    if (!_categories.contains(_selectedCategory)) {
      _categories.add(_selectedCategory);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brokerController.dispose();
    _unitsController.dispose();
    _avgPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String assetHint = 'e.g. Name or Ticker';
    String brokerHint = 'e.g. Platform Name';

    if (_selectedCategory == 'Crypto') {
      assetHint = 'e.g. BTC, ETH, USDT';
      brokerHint = 'e.g. Binance, Indodax, Tokocrypto';
    } else if (_selectedCategory == 'Stocks') {
      assetHint = 'e.g. BBCA, AAPL, GOTO';
      brokerHint = 'e.g. Ajaib, IPOT, Stockbit';
    } else if (_selectedCategory == 'Bonds') {
      assetHint = 'e.g. SBR012, ORI023';
      brokerHint = 'e.g. Bareksa, Bibit';
    } else if (_selectedCategory == 'Mutual Funds') {
      assetHint = 'e.g. Sucorinvest Money Market';
      brokerHint = 'e.g. Bibit, Bareksa';
    }

    return Container(
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
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add Investment',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            if (!widget.isCategoryLocked) ...[
              const Text(
                'Asset Category',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories.map((category) {
                    final isSelected = _selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primaryAccent : AppColors.surfaceHover,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? Colors.black : AppColors.textPrimary,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
            ],
            
            _buildTextField(
              controller: _nameController,
              label: 'Asset Name / Ticker',
              hintText: assetHint,
              prefixIcon: UIcons.regularRounded.search_alt,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _brokerController,
              label: 'Broker / Platform',
              hintText: brokerHint,
              prefixIcon: UIcons.regularRounded.building,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _unitsController,
                    label: 'Units / Shares',
                    hintText: '0.00',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _avgPriceController,
                    label: 'Average Price',
                    hintText: '0',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement save logic via Riverpod
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Investment saved successfully')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryAccent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Save Investment',
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    IconData? prefixIcon,
    TextInputType keyboardType = TextInputType.text,
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
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.surface,
            prefixIcon: prefixIcon != null 
                ? Icon(prefixIcon, color: AppColors.textSecondary, size: 18) 
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryAccent, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
