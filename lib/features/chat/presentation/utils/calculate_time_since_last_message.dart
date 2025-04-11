import 'package:chatapp/core/localization/app_localization.dart';
import 'package:chatapp/core/localization/locale_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

String calculateTimeSinceLastMessage(dynamic timestamp, WidgetRef ref) {
  final locale = ref.watch(localeProvider);
  final localization = ref.watch(localizationProvider(locale)).value;

  if (timestamp is Timestamp) {
    timestamp = timestamp.toDate();
  } else if (timestamp is String) {
    timestamp = DateTime.parse(timestamp.toString());
  } else if (timestamp is! DateTime) {
    return localization?.translate("invalid-date") ?? "";
  }

  final now = DateTime.now();
  final difference = now.difference(timestamp);

  if (difference.inHours < 24) {
    if (difference.inMinutes < 1) {
      return localization?.translate("just-now") ?? "";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} min ${localization?.translate("ago") ?? ""}";
    } else {
      return "${difference.inHours}h ${localization?.translate("ago") ?? ""}";
    }
  } else {
    if (locale.languageCode == "pt") {
      return DateFormat("dd/MM/yyyy").format(timestamp);
    } else {
      return DateFormat("MMM d, yyyy").format(timestamp);
    }
  }
}
