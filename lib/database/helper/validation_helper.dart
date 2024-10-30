class ValidationHelper {
  static String? validateEmail(String email) {
    if (email.isEmpty) {
      return "Email tidak boleh kosong.";
    } else if (!RegExp(r"^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      return "Format email tidak valid.";
    }
    return null; // Valid
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return "Password tidak boleh kosong.";
    }
    return null; // Valid
  }

  static String? validateField(String field, String fieldName) {
    if (field.isEmpty) {
      return "$fieldName tidak boleh kosong.";
    }
    return null; // Valid
  }
}
