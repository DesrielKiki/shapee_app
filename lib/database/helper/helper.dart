class Helper {
  static String formatSold(String sold) {
    // Mengkonversi string ke integer
    final soldInt = int.tryParse(sold) ?? 0;

    if (soldInt >= 1000000000) {
      // Miliar
      return '${(soldInt / 1000000000).floor()}.${((soldInt % 1000000000) / 100000000).floor()}jt'; // Misal 1,0jt
    } else if (soldInt >= 1000000) {
      // Juta
      return '${(soldInt / 1000000).floor()}.${((soldInt % 1000000) / 100000).floor()}jt'; // Misal 1,8jt
    } else if (soldInt >= 1000) {
      // Ribu
      return '${(soldInt / 1000).floor()}rb'; // Ribu
    } else {
      return sold; // Tampilkan angka asli
    }
  }
}
