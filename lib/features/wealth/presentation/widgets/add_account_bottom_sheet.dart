import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/success_alert_dialog.dart';
import 'package:uicons/uicons.dart';
import '../../../../shared/models/currency_model.dart';
import '../../../../shared/widgets/currency_picker_sheet.dart';

const List<String> dummyBankProviders = ['Bank BCA', 'Bank Mandiri', 'Bank BNI', 'Bank BRI', 'Bank Syariah Indonesia (BSI)', 'CIMB Niaga', 'Permata Bank', 'Bank Jago', 'SeaBank', 'Jenius'];
const List<String> dummyEwalletProviders = ['GoPay', 'OVO', 'DANA', 'ShopeePay', 'LinkAja'];
const List<String> dummyCryptoProviders = ['Indodax', 'Tokocrypto', 'Pintu', 'Pluang', 'Binance', 'Metamask', 'Trust Wallet'];

class AddAccountBottomSheet extends StatefulWidget {
  const AddAccountBottomSheet({super.key});

  @override
  State<AddAccountBottomSheet> createState() => _AddAccountBottomSheetState();
}

class _AddAccountBottomSheetState extends State<AddAccountBottomSheet> {
  String _selectedCategory = 'BANK';
  final _categories = ['BANK', 'E-WALLET', 'CASH', 'CRYPTO'];
  Currency _selectedCurrency = Currency.idr;
  String? _selectedProvider;

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
                        _selectedProvider = null;
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

            // Provider Selector
            if (_selectedCategory != 'CASH') ...[
              _buildSelectorField(
                label: 'Provider / Platform',
                value: _selectedProvider,
                hint: 'Select Provider',
                icon: UIcons.regularRounded.building,
                onTap: _openProviderSelector,
              ),
              const SizedBox(height: 16),
            ],

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
            FormField<String>(
              initialValue: _balanceController.text,
              validator: (value) {
                final text = _balanceController.text;
                if (text.trim().isEmpty) {
                  return 'Initial balance is required';
                }
                if (double.tryParse(text) == null) {
                  return 'Must be a valid number';
                }
                return null;
              },
              builder: (FormFieldState<String> field) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: field.hasError
                            ? Border.all(color: AppColors.negative, width: 1)
                            : null,
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
                            child: TextField(
                              controller: _balanceController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: AppColors.textPrimary),
                              onChanged: (val) => field.didChange(val),
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
                        style: const TextStyle(
                          color: AppColors.negative,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
            const SizedBox(height: 32),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (_selectedCategory != 'CASH' && _selectedProvider == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select a provider'),
                        backgroundColor: AppColors.negative,
                      ),
                    );
                    return;
                  }

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

  Future<void> _openProviderSelector() async {
    List<String> providers;
    if (_selectedCategory == 'BANK') {
      providers = dummyBankProviders;
    } else if (_selectedCategory == 'E-WALLET') {
      providers = dummyEwalletProviders;
    } else if (_selectedCategory == 'CRYPTO') {
      providers = dummyCryptoProviders;
    } else {
      return;
    }

    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ProviderSelectorSheet(providers: providers),
    );

    if (result != null) {
      setState(() {
        _selectedProvider = result;
      });
    }
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
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
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: const TextStyle(color: AppColors.textPrimary),
              onChanged: (val) => field.didChange(val),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: field.hasError ? const BorderSide(color: AppColors.negative, width: 1) : BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: field.hasError ? const BorderSide(color: AppColors.negative, width: 1) : BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: field.hasError ? const BorderSide(color: AppColors.negative, width: 1) : const BorderSide(color: AppColors.primaryAccent, width: 1),
                ),
              ),
            ),
            if (field.hasError) ...[
              const SizedBox(height: 8),
              Text(
                field.errorText!,
                style: const TextStyle(
                  color: AppColors.negative,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _ProviderSelectorSheet extends StatefulWidget {
  final List<String> providers;
  const _ProviderSelectorSheet({required this.providers});

  @override
  State<_ProviderSelectorSheet> createState() => _ProviderSelectorSheetState();
}

class _ProviderSelectorSheetState extends State<_ProviderSelectorSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredProviders = [];

  @override
  void initState() {
    super.initState();
    _filteredProviders = widget.providers;
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
        _filteredProviders = widget.providers;
      } else {
        _filteredProviders = widget.providers.where((provider) {
          return provider.toLowerCase().contains(query);
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
                child: Text('Select Provider', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search provider...',
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
                child: _filteredProviders.isEmpty 
                  ? Center(
                      child: Text(
                        'No providers found for "${_searchController.text}"', 
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: _filteredProviders.length,
                      itemBuilder: (context, index) {
                        final provider = _filteredProviders[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                          title: Text(provider, style: const TextStyle(color: AppColors.textPrimary)),
                          onTap: () => Navigator.pop(context, provider),
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
