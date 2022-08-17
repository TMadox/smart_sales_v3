class ValuesManager {
  static String checkString(String? input) => input ?? ' ';
  static String doubleToString(dynamic input) {
    if (input is double) {
      return input.toStringAsFixed(3);
    } else {
      return (input ?? "").toString();
    }
  }

  static num checkNum(num input) {
    if (input.isNaN || input.isInfinite) {
      return 0.0;
    } else {
      return input;
    }
  }

  static num numberValidator(String value) {
    if (value == "") {
      return 0.0;
    }
    final number = num.tryParse(value);
    if (number == null) {
      return 0.0;
    } else {
      return number;
    }
  }
}
