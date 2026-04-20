class CurrencyHelper {
  CurrencyHelper._();

  static double parseToDouble(String value) {
    final cleaned = value.replaceAll('.', '').replaceAll(',', '').trim();
    if (cleaned.isEmpty) return 0;
    return double.parse(cleaned);
  }

  static int parseToInt(String value) {
    final cleaned = value.replaceAll('.', '').replaceAll(',', '').trim();
    if (cleaned.isEmpty) return 0;
    return int.parse(cleaned);
  }
}