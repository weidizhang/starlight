class StringUtil {
  static bool isEmpty(String s) {
    return s.isEmpty || s.trim().isEmpty;
  }

  static bool isAnyEmpty(List<String> stringList) {
    return stringList.any((s) => isEmpty(s));
  }

  static String formatCentsToDollars(int cents) {
    double inDollars = cents / 100.0;
    return '\$${inDollars.toStringAsFixed(2)}';
  }
}
