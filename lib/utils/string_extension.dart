import 'package:intl/intl.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String timestamp() {
    final now = DateFormat('yyyy-MM-dd_HH-mm').format(DateTime.now());
    return "${this}_$now";
  }

  String normalize() {
    return "$this.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ')";
  }
}
