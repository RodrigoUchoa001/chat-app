import 'dart:io';

import 'package:chatapp/core/services/cloudinary_service.dart';
import 'package:chatapp/features/media/domain/repositories/media_repository_interface.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mediaRepositoryProvider = Provider<MediaRepositoryInterface>((ref) {
  final cloudinaryService = ref.watch(cloudinaryProvider);

  return MediaRepository(cloudinaryService);
});

class MediaRepository implements MediaRepositoryInterface {
  final CloudinaryService _cloudinaryService;

  MediaRepository(this._cloudinaryService);

  @override
  Future<String?> uploadMedia(File mediaFile, {required bool isVideo}) {
    return _cloudinaryService.uploadMedia(mediaFile, isVideo: isVideo);
  }
}
