extension StringExtension on String {
  String ucfirst() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String stripLeft(String pattern) {
    int i = 0;
    while (startsWith(pattern, i)) {
      i += pattern.length;
    }
    return substring(i);
  }

  String concat(String str) {
    return this + str;
  }

  String get initials {
    if (this == " ") return "";
    String initials = trim()
        .replaceAll(RegExp(r"\s\s+"), " ")
        .split(" ")
        .map((s) => s.substring(0, 1).toUpperCase())
        .join("");
    if (initials.length > 2) return initials = initials.substring(0, 2);
    return initials;
  }

  String truncate(int length) {
    if (this.length > length) {
      return substring(0, length);
    }
    return this;
  }
}
