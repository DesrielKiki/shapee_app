import 'package:intl/intl.dart';

class Helper {
  static String formatSold(String sold) {
    final soldInt = int.tryParse(sold) ?? 0;

    if (soldInt >= 1000000000) {
      return '${(soldInt / 1000000000).floor()}.${((soldInt % 1000000000) / 100000000).floor()}jt';
    } else if (soldInt >= 1000000) {
      return '${(soldInt / 1000000).floor()}.${((soldInt % 1000000) / 100000).floor()}jt';
    } else if (soldInt >= 1000) {
      return '${(soldInt / 1000).floor()}rb';
    } else {
      return sold;
    }
  }

  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 2,
    );

    return formatter.format(amount);
  }

  static String formatSoldFormatted(String sold) {
    return formatCurrency(double.tryParse(sold) ?? 0);
  }
}
