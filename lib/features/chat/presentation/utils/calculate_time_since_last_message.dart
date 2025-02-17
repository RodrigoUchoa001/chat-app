import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String calculateTimeSinceLastMessage(dynamic timestamp) {
  if (timestamp is Timestamp) {
    timestamp = timestamp.toDate();
  } else if (timestamp is String) {
    timestamp = DateTime.parse(timestamp.toString());
  } else if (timestamp is! DateTime) {
    return "Invalid date";
  }

  final now = DateTime.now();
  final difference = now.difference(timestamp);

  if (difference.inHours < 24) {
    if (difference.inMinutes < 1) {
      return "Just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} min ago";
    } else {
      return "${difference.inHours}h ago";
    }
  } else {
    return DateFormat("MMM d, yyyy").format(timestamp);
  }
}
