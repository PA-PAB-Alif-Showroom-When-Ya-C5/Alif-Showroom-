class TextNormalizer {
  TextNormalizer._();

  static String toTitleCase(String input) {
    final cleaned = input.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (cleaned.isEmpty) return cleaned;

    return cleaned
        .toLowerCase()
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }
}