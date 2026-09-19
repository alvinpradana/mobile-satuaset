class WealthSummary {
  final double netWorth;
  final double netWorthChangePercentage;
  final double totalAssets;
  final double totalLiabilities;
  final List<WealthAllocation> allocations;
  final List<WealthDomain> domains;

  const WealthSummary({
    required this.netWorth,
    required this.netWorthChangePercentage,
    required this.totalAssets,
    required this.totalLiabilities,
    required this.allocations,
    required this.domains,
  });
}

class WealthAllocation {
  final String label;
  final double percentage;

  const WealthAllocation({
    required this.label,
    required this.percentage,
  });
}

class WealthDomain {
  final String id;
  final String title;
  final double value;
  final String subtitle;

  const WealthDomain({
    required this.id,
    required this.title,
    required this.value,
    required this.subtitle,
  });
}
