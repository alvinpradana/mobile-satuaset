import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uicons/uicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/success_alert_dialog.dart';

// --- DUMMY DATA MODELS ---
class CryptoAsset {
  final String id;
  final String symbol;
  final String name;

  const CryptoAsset(this.id, this.symbol, this.name);
}

const List<CryptoAsset> dummyCryptoAssets = [
  CryptoAsset('bitcoin', 'BTC', 'Bitcoin'),
  CryptoAsset('ethereum', 'ETH', 'Ethereum'),
  CryptoAsset('tether', 'USDT', 'Tether'),
  CryptoAsset('solana', 'SOL', 'Solana'),
  CryptoAsset('binancecoin', 'BNB', 'BNB'),
  CryptoAsset('ripple', 'XRP', 'XRP'),
  CryptoAsset('cardano', 'ADA', 'Cardano'),
  CryptoAsset('dogecoin', 'DOGE', 'Dogecoin'),
];

const List<String> dummyCryptoPlatforms = [
  'Binance',
  'Indodax',
  'Tokocrypto',
  'Pintu',
  'Bybit',
  'Trust Wallet',
  'Metamask',
  'Other'
];

enum Currency { idr, usd }

class AddInvestmentBottomSheet extends StatefulWidget {
  final String? initialCategory;
  final bool isCategoryLocked;
  final CryptoAsset? initialCryptoAsset;
  final bool isAssetLocked;

  const AddInvestmentBottomSheet({
    super.key, 
    this.initialCategory, 
    this.isCategoryLocked = false,
    this.initialCryptoAsset,
    this.isAssetLocked = false,
  });

  @override
  State<AddInvestmentBottomSheet> createState() => _AddInvestmentBottomSheetState();
}

class _AddInvestmentBottomSheetState extends State<AddInvestmentBottomSheet> {
  late String _selectedCategory;
  
  // Form State
  CryptoAsset? _selectedCrypto;
  String? _selectedPlatform;
  final TextEditingController _unitsController = TextEditingController();
  final TextEditingController _avgPriceController = TextEditingController();
  Currency _selectedCurrency = Currency.usd;

  final List<String> _categories = ['Crypto', 'Stocks', 'Bonds', 'Mutual Funds', 'Other'];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? _categories.first;
    if (!_categories.contains(_selectedCategory)) {
      _categories.add(_selectedCategory);
    }
    
    _selectedCrypto = widget.initialCryptoAsset;
    
    // Listeners for validation updates
    _unitsController.addListener(() => setState(() {}));
    _avgPriceController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _unitsController.dispose();
    _avgPriceController.dispose();
    super.dispose();
  }

  bool _isFormValid() {
    if (_selectedCategory == 'Crypto') {
      if (_selectedCrypto == null) return false;
      if (_selectedPlatform == null) return false;
      
      final units = double.tryParse(_unitsController.text.replaceAll(',', '.'));
      if (units == null || units <= 0) return false;
      
      final price = double.tryParse(_avgPriceController.text.replaceAll(',', '.'));
      if (price == null || price <= 0) return false;
      
      return true;
    }
    // Fallback for other categories (for now)
    return false;
  }

  void _submitForm() {
    if (!_isFormValid()) return;
    
    final payload = {
      "investment_category": _selectedCategory.toUpperCase(),
      "asset_id": _selectedCrypto?.id,
      "ticker": _selectedCrypto?.symbol,
      "name": _selectedCrypto?.name,
      "platform": _selectedPlatform?.toUpperCase(),
      "units": double.parse(_unitsController.text.replaceAll(',', '.')),
      "average_price": double.parse(_avgPriceController.text.replaceAll(',', '.')),
      "currency": _selectedCurrency.name.toUpperCase(),
    };
    
    debugPrint("=== SIMULATED SUBMIT PAYLOAD ===");
    debugPrint(const JsonEncoder.withIndent('  ').convert(payload));
    
    Navigator.pop(context);
    SuccessAlertDialog.show(
      context,
      title: 'Investment Added',
      message: 'Investment "${_selectedCrypto?.symbol}" has been successfully added to your portfolio.',
    );
  }

  // --- SELECTORS ---
  Future<void> _openAssetSelector() async {
    final result = await showModalBottomSheet<CryptoAsset>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => const _AssetSelectorSheet(assets: dummyCryptoAssets),
    );

    if (result != null) {
      setState(() {
        _selectedCrypto = result;
      });
    }
  }

  Future<void> _openPlatformSelector() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => const _PlatformSelectorSheet(platforms: dummyCryptoPlatforms),
    );

    if (result != null) {
      setState(() {
        _selectedPlatform = result;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    // Only support Crypto for now as requested
    final isCrypto = _selectedCategory == 'Crypto';

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
              'Add Investment',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
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
                            // reset fields when category changes
                            _selectedCrypto = null;
                            _selectedPlatform = null;
                            _unitsController.clear();
                            _avgPriceController.clear();
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
            
            if (isCrypto) ...[
              // Asset Selector
              _buildSelectorField(
                label: 'Asset Name / Ticker',
                value: _selectedCrypto != null ? '${_selectedCrypto!.symbol} - ${_selectedCrypto!.name}' : null,
                hint: 'Select Crypto Asset',
                icon: UIcons.regularRounded.search_alt,
                onTap: widget.isAssetLocked ? () {} : _openAssetSelector,
                isLocked: widget.isAssetLocked,
              ),
              const SizedBox(height: 16),
              
              // Platform Selector
              _buildSelectorField(
                label: 'Broker / Platform',
                value: _selectedPlatform,
                hint: 'Select Platform',
                icon: UIcons.regularRounded.building,
                onTap: _openPlatformSelector,
              ),
              const SizedBox(height: 16),
              
              // Units and Avg Price
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _unitsController,
                      label: 'Units / Shares',
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
            ] else ...[
              // Placeholder for non-crypto categories
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12)
                ),
                child: const Text('Only Crypto is available for testing right now.', style: TextStyle(color: AppColors.textSecondary)),
              ),
            ],
            
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
}

class _AssetSelectorSheet extends StatefulWidget {
  final List<CryptoAsset> assets;
  const _AssetSelectorSheet({required this.assets});

  @override
  State<_AssetSelectorSheet> createState() => _AssetSelectorSheetState();
}

class _AssetSelectorSheetState extends State<_AssetSelectorSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<CryptoAsset> _filteredAssets = [];

  @override
  void initState() {
    super.initState();
    _filteredAssets = widget.assets;
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
        _filteredAssets = widget.assets;
      } else {
        _filteredAssets = widget.assets.where((asset) {
          return asset.name.toLowerCase().contains(query) || asset.symbol.toLowerCase().contains(query);
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
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Text('Select Asset', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search ticker or name...',
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
                child: _filteredAssets.isEmpty 
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(UIcons.regularRounded.search, size: 48, color: AppColors.textSecondary.withOpacity(0.3)),
                          const SizedBox(height: 16),
                          Text(
                            'No assets found for "${_searchController.text}"', 
                            style: const TextStyle(color: AppColors.textSecondary),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: _filteredAssets.length,
                      itemBuilder: (context, index) {
                        final asset = _filteredAssets[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                          leading: CircleAvatar(
                            backgroundColor: AppColors.surfaceHover,
                            child: Text(asset.symbol[0], style: const TextStyle(color: AppColors.textPrimary)),
                          ),
                          title: Text(asset.symbol, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                          subtitle: Text(asset.name, style: const TextStyle(color: AppColors.textSecondary)),
                          onTap: () => Navigator.pop(context, asset),
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
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
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

