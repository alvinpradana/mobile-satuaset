enum Currency {
  idr,
  usd,
  eur,
  jpy,
  gbp,
  sgd,
  aud,
  myr,
}

extension CurrencyExt on Currency {
  String get symbol {
    switch (this) {
      case Currency.idr:
        return 'Rp';
      case Currency.usd:
        return '\$';
      case Currency.eur:
        return '€';
      case Currency.jpy:
        return '¥';
      case Currency.gbp:
        return '£';
      case Currency.sgd:
        return 'S\$';
      case Currency.aud:
        return 'A\$';
      case Currency.myr:
        return 'RM';
    }
  }

  String get displayName {
    switch (this) {
      case Currency.idr:
        return 'Indonesian Rupiah';
      case Currency.usd:
        return 'US Dollar';
      case Currency.eur:
        return 'Euro';
      case Currency.jpy:
        return 'Japanese Yen';
      case Currency.gbp:
        return 'British Pound';
      case Currency.sgd:
        return 'Singapore Dollar';
      case Currency.aud:
        return 'Australian Dollar';
      case Currency.myr:
        return 'Malaysian Ringgit';
    }
  }
}
