import 'package:firebase_auth/firebase_auth.dart';

class ValidationHelper {
  static String? validateField(String value, String fieldName) {
    if (value.isEmpty) {
      return '$fieldName tidak boleh kosong.';
    }
    return null;
  }

  static String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email tidak boleh kosong';
    }

    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (password.length < 6) {
      return 'Password harus terdiri dari minimal 6 karakter';
    }
    return null;
  }

  static String? validateConfirmPassword(
      String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    if (password != confirmPassword) {
      return 'Password dan konfirmasi tidak cocok';
    }
    return null;
  }

  static String handleAuthException(dynamic exception) {
    if (exception is FirebaseAuthException) {
      switch (exception.code) {
        case 'user-not-found':
          return 'Email belum terdaftar. Silakan registrasi.';
        case 'wrong-password':
          return 'Password salah. Silakan coba lagi.';
        case 'email-already-in-use':
          return 'Email sudah digunakan. Silakan gunakan email lain.';
        case 'user-disabled':
          return 'Akun Anda telah dinonaktifkan. Hubungi dukungan.';
        case 'invalid-email':
          return 'Email tidak valid. Silakan periksa dan coba lagi.';
        default:
          return 'Terjadi kesalahan. Silakan coba lagi.';
      }
    }
    return 'Terjadi kesalahan. Silakan coba lagi.';
  }
}
