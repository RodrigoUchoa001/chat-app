import 'package:chatapp/features/chat/data/repositories/chat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final markMessageAsSeenProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return (chatId, messageId) {
    return chatRepository.markMessageAsSeen(chatId, messageId);
  };
});
