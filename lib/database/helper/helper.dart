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

  static String formatTimestamp(String timestamp) {
    DateTime messageTime = DateTime.parse(timestamp);
    Duration difference = DateTime.now().difference(messageTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} detik yang lalu';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} minggu yang lalu';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} bulan yang lalu';
    } else {
      return '${(difference.inDays / 365).floor()} tahun yang lalu';
    }
  }

  static String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    final DateFormat formatter =
        DateFormat('dd MMMM yyyy'); // Format sesuai keinginan Anda
    return formatter.format(parsedDate);
  }
}
