import 'package:flutter_riverpod/flutter_riverpod.dart';

final videoToSendProgressProvider = StateProvider<double>((ref) {
  return 0.0;
});
