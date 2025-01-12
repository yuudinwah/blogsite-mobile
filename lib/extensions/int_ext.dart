import 'package:intl/intl.dart';

extension IntegerExt on int {
  String format({
    String? locale,
    String? name,
  }) {
    return NumberFormat.currency(
      locale: locale,
      decimalDigits: 0,
      name: name ?? "",
    ).format(this);
  }
}