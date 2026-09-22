import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uicons/uicons.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/models/wealth_summary_model.dart';
import '../../domain/models/wealth_item.dart';
import '../../domain/models/investment_summary.dart';
import '../../domain/models/saving_goal_model.dart';
import 'package:flutter/material.dart';

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

final investmentPeriodProvider = StateProvider<String>((ref) => '1Y');

final investmentSummaryProvider = Provider<InvestmentSummary>((ref) {
  final period = ref.watch(investmentPeriodProvider);
  
  // Mock different data based on period
  List<FlSpot> spots;
  double returnPct;
  double pnl;
  
  switch (period) {
    case '1W':
      spots = const [FlSpot(0, 1.40), FlSpot(1, 1.45), FlSpot(2, 1.42), FlSpot(3, 1.50)];
      returnPct = 1.2;
      pnl = 15000000.0;
      break;
    case '1M':
      spots = const [FlSpot(0, 1.35), FlSpot(1, 1.38), FlSpot(2, 1.45), FlSpot(3, 1.42), FlSpot(4, 1.50)];
      returnPct = 2.5;
      pnl = 32000000.0;
      break;
    case '3M':
      spots = const [FlSpot(0, 1.25), FlSpot(1, 1.30), FlSpot(2, 1.45), FlSpot(3, 1.50)];
      returnPct = 3.8;
      pnl = 48000000.0;
      break;
    case '6M':
      spots = const [FlSpot(0, 1.20), FlSpot(1, 1.25), FlSpot(2, 1.35), FlSpot(3, 1.50)];
      returnPct = 4.2;
      pnl = 54000000.0;
      break;
    case 'ALL':
      spots = const [FlSpot(0, 0.8), FlSpot(1, 1.0), FlSpot(2, 1.2), FlSpot(3, 1.50)];
      returnPct = 12.5;
      pnl = 180000000.0;
      break;
    case '1Y':
    default:
      spots = const [
        FlSpot(0, 1.3), FlSpot(1, 1.32), FlSpot(2, 1.35), FlSpot(3, 1.42),
        FlSpot(4, 1.45), FlSpot(5, 1.40), FlSpot(6, 1.48), FlSpot(7, 1.50),
      ];
      returnPct = 4.8;
      pnl = 65200000.0;
      break;
  }

  return InvestmentSummary(
    totalValue: 1420000000.0,
    returnPercentage: returnPct,
    unrealizedPnL: pnl,
    performanceHistory: spots,
    allocations: [
      WealthAllocation(label: 'Stocks', percentage: 48),
      WealthAllocation(label: 'Crypto', percentage: 35),
      WealthAllocation(label: 'Bonds', percentage: 12),
      WealthAllocation(label: 'Other', percentage: 5),
    ],
  );
});

final wealthItemsProvider = Provider.family<List<WealthItem>, String>((ref, domainId) {
  final allItems = [
    // Investments
    WealthItem(
      id: 'i1',
      domainId: 'investments',
      category: 'Crypto',
      name: 'Bitcoin',
      institution: 'BTC',
      value: 65000.0,
      percentageChange: 2.45,
      iconData: UIcons.brands.bitcoin,
      currency: '\$',
    ),
    WealthItem(
      id: 'i2',
      domainId: 'investments',
      category: 'Crypto',
      name: 'Ethereum',
      institution: 'ETH',
      value: 3200.0,
      percentageChange: -1.2,
      iconData: UIcons.solidRounded.chart_pie_alt,
      currency: '\$',
    ),
    WealthItem(
      id: 'i3',
      domainId: 'investments',
      category: 'Stocks',
      name: 'NVIDIA',
      institution: 'NVDA',
      value: 222.51,
      percentageChange: 1.49,
      iconData: UIcons.solidRounded.chart_histogram,
      currency: '\$',
    ),
    WealthItem(
      id: 'i4',
      domainId: 'investments',
      category: 'Stocks',
      name: 'SpaceX',
      institution: 'SPCX',
      value: 152.64,
      percentageChange: -1.62,
      iconData: UIcons.solidRounded.rocket,
      currency: '\$',
    ),

    // Accounts
    WealthItem(
      id: 'a1',
      domainId: 'accounts',
      category: 'BANK',
      name: 'Tabungan Utama',
      institution: 'Bank BCA',
      identifier: '123456781241',
      value: 250000000.0,
      iconData: UIcons.solidRounded.bank,
      currency: 'Rp',
    ),
    WealthItem(
      id: 'a2',
      domainId: 'accounts',
      category: 'BANK',
      name: 'Dana Darurat',
      institution: 'Bank Mandiri',
      identifier: '9876543322',
      value: 150000000.0,
      iconData: UIcons.solidRounded.bank,
      currency: 'Rp',
    ),
    WealthItem(
      id: 'a3',
      domainId: 'accounts',
      category: 'E-WALLET',
      name: 'GoPay',
      institution: 'Gojek',
      identifier: '081234565678',
      value: 75000000.0,
      iconData: UIcons.solidRounded.wallet,
      currency: 'Rp',
    ),
    WealthItem(
      id: 'a4',
      domainId: 'accounts',
      category: 'CASH',
      name: 'Cash',
      institution: 'Physical Cash',
      value: 15000000.0,
      iconData: UIcons.solidRounded.coins,
      currency: 'Rp',
    ),
    WealthItem(
      id: 'a5',
      domainId: 'accounts',
      category: 'BANK',
      name: 'Simpedes',
      institution: 'Bank BRI',
      identifier: '332211447781',
      value: 0.0,
      iconData: UIcons.solidRounded.bank,
      currency: 'Rp',
      status: WealthItemStatus.archived,
    ),
    WealthItem(
      id: 'a6',
      domainId: 'accounts',
      category: 'BANK',
      name: 'M-Card',
      institution: 'Jenius',
      identifier: '900011114421',
      value: 0.0,
      iconData: UIcons.solidRounded.bank,
      currency: 'Rp',
      status: WealthItemStatus.archived,
    ),

    // Physical Assets
    WealthItem(
      id: 'p1',
      domainId: 'physical_assets',
      category: 'Real Estate',
      name: 'Rumah Tinggal',
      institution: 'Jakarta Selatan',
      value: 500000000.0,
      iconData: UIcons.solidRounded.home,
      currency: 'Rp',
    ),
    WealthItem(
      id: 'p2',
      domainId: 'physical_assets',
      category: 'Vehicles',
      name: 'Honda HR-V',
      institution: 'Kendaraan',
      value: 280000000.0,
      iconData: UIcons.solidRounded.car,
      currency: 'Rp',
    ),
    WealthItem(
      id: 'p3',
      domainId: 'physical_assets',
      category: 'Electronics',
      name: 'MacBook Pro',
      institution: 'Apple',
      value: 40000000.0,
      iconData: UIcons.solidRounded.computer,
      currency: 'Rp',
    ),

    // Liabilities
    WealthItem(
      id: 'l1',
      domainId: 'liabilities',
      category: 'Mortgage',
      name: 'KPR Rumah',
      institution: 'Bank BTN',
      value: -250000000.0,
      iconData: UIcons.solidRounded.home,
      currency: 'Rp',
    ),
    WealthItem(
      id: 'l2',
      domainId: 'liabilities',
      category: 'Credit Cards',
      name: 'Kartu Kredit',
      institution: 'Bank Mandiri',
      value: -30000000.0,
      iconData: UIcons.solidRounded.credit_card,
      currency: 'Rp',
    ),
  ];

  return allItems.where((item) => item.domainId == domainId).toList();
});

final savingGoalsProvider = Provider<List<SavingGoal>>((ref) {
  return [
    SavingGoal(
      id: 'g1',
      name: 'Dana Darurat (6 Bulan)',
      category: 'EMERGENCY',
      targetAmount: 100000000.0,
      currentAmount: 75000000.0,
      targetDate: DateTime(2026, 12, 31),
      iconData: UIcons.solidRounded.shield_check,
      color: const Color(0xFF00E5FF),
      accountName: 'Bank BCA - Dana Darurat',
    ),
    SavingGoal(
      id: 'g2',
      name: 'DP Rumah Pertama',
      category: 'HOUSING',
      targetAmount: 150000000.0,
      currentAmount: 60000000.0,
      targetDate: DateTime(2027, 8, 30),
      iconData: UIcons.solidRounded.home,
      color: const Color(0xFF10B981),
      accountName: 'Bank Mandiri - Deposito',
    ),
    SavingGoal(
      id: 'g3',
      name: 'Liburan ke Jepang',
      category: 'TRAVEL',
      targetAmount: 35000000.0,
      currentAmount: 10000000.0,
      targetDate: DateTime(2027, 3, 15),
      iconData: UIcons.solidRounded.plane_alt,
      color: const Color(0xFFF59E0B),
      accountName: 'Jenius - Save It',
    ),
    SavingGoal(
      id: 'g4',
      name: 'Upgrade Laptop M3 Max',
      category: 'GADGET',
      targetAmount: 40000000.0,
      currentAmount: 40000000.0,
      targetDate: DateTime(2026, 6, 30),
      iconData: UIcons.solidRounded.computer,
      color: const Color(0xFF8B5CF6),
      accountName: 'GoPay',
      status: SavingGoalStatus.completed,
    ),
  ];
});

