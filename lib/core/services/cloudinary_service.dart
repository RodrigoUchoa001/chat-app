import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cloudinaryProvider = Provider<CloudinaryService>((ref) {
  return CloudinaryService();
});

class CloudinaryService {
  final Dio _dio = Dio();

  final String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME']!;
  final String apiKey = dotenv.env['CLOUDINARY_API_KEY']!;
  final String apiSecret = dotenv.env['CLOUDINARY_API_SECRET']!;

  Future<String?> uploadMedia(File mediaFile, {required bool isVideo}) async {
    try {
      final url = 'https://api.cloudinary.com/v1_1/$cloudName/upload/';

      FormData formData = FormData.fromMap({
        // dont forget to put await
        'file': await MultipartFile.fromFile(mediaFile.path),
        'upload_preset': 'testeteste',
        'api_key': apiKey,
        'timestamp': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      });

      final response = await _dio.post(url, data: formData);

      if (response.statusCode == 200) {
        return response.data["secure_url"];
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erro ao enviar mídia para Cloudinary: $e");
      }
      return null;
    }
  }
}
