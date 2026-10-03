import 'package:flutter/material.dart';
import 'package:uicons/uicons.dart';
import '../../core/theme/app_colors.dart';
import '../models/currency_model.dart';

class CurrencyPickerSheet extends StatelessWidget {
  final Currency selectedCurrency;
  final ValueChanged<Currency> onCurrencySelected;

  const CurrencyPickerSheet({
    super.key,
    required this.selectedCurrency,
    required this.onCurrencySelected,
  });

  static void show(BuildContext context, {
    required Currency selectedCurrency,
    required ValueChanged<Currency> onCurrencySelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => CurrencyPickerSheet(
        selectedCurrency: selectedCurrency,
        onCurrencySelected: onCurrencySelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select Currency',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: Currency.values.length,
              itemBuilder: (context, index) {
                final currency = Currency.values[index];
                final isSelected = selectedCurrency == currency;
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surfaceHover,
                    ),
                    child: Center(
                      child: Text(
                        currency.symbol,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    currency.name.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    currency.displayName,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(UIcons.regularRounded.check, color: AppColors.primaryAccent)
                      : null,
                  onTap: () {
                    onCurrencySelected(currency);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
