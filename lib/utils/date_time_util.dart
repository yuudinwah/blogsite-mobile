import 'package:intl/intl.dart';

class DateTimeUtil {
  format(dynamic date, {String? format, String locale = 'id'}) {
    return DateFormat(format, locale).format(date).toString();
  }
}
