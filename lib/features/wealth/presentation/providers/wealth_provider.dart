import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/wealth_summary_model.dart';

final wealthSummaryProvider = Provider<WealthSummary>((ref) {
  // Use realistic Indonesian mock values that reconcile
  // Total Assets: Rp 2.730.000.000
  // Total Liabilities: Rp 280.000.000
  // Net Worth: Rp 2.450.000.000

  return const WealthSummary(
    netWorth: 2450000000.0,
    netWorthChangePercentage: 2.4,
    totalAssets: 2730000000.0,
    totalLiabilities: 280000000.0,
    allocations: [
      WealthAllocation(label: 'Investments', percentage: 52),
      WealthAllocation(label: 'Physical Assets', percentage: 25),
      WealthAllocation(label: 'Cash', percentage: 18),
      WealthAllocation(label: 'Other', percentage: 5),
    ],
    domains: [
      WealthDomain(
        id: 'investments',
        title: 'Investments',
        value: 1420000000.0,
        subtitle: '45 holdings',
      ),
      WealthDomain(
        id: 'accounts',
        title: 'Accounts',
        value: 490000000.0,
        subtitle: '4 active accounts',
      ),
      WealthDomain(
        id: 'physical_assets',
        title: 'Physical Assets',
        value: 820000000.0,
        subtitle: '3 assets',
      ),
      WealthDomain(
        id: 'liabilities',
        title: 'Liabilities',
        value: 280000000.0,
        subtitle: '2 active liabilities',
      ),
      WealthDomain(
        id: 'goals',
        title: 'Goals',
        value: 0, // Goals don't have a total value in this context, just count
        subtitle: '3 active goals',
      ),
    ],
  );
});
