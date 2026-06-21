import 'package:intl/intl.dart';

String formatDateByDMMMYYYY(DateTime date) {
  return DateFormat('d MMM, yyyy').format(date.toLocal());
}

String formatDateByHm(DateTime date) {
  return DateFormat('HH:mm').format(date.toLocal());
}

String formatDateByEEEEddMMMM(DateTime date) {
  return DateFormat('EEEE, dd MMMM', 'id_ID').format(date.toLocal());
}

String formatDateByddMMMMyyyy(DateTime date) {
  return DateFormat('dd MMMM yyyy').format(date.toLocal());
}
