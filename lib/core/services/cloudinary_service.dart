import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CloudinaryService {
  final Dio _dio = Dio();

  final String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME']!;
  final String apiKey = dotenv.env['CLOUDINARY_API_KEY']!;
  final String apiSecret = dotenv.env['CLOUDINARY_API_SECRET']!;

  Future<String> uploadImage(String filePath) async {
    try {
      final url = 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';
      FormData formData = FormData.fromMap({
        'file': MultipartFile.fromFileSync(filePath),
        'upload_preset': 'unsigned_preset',
        'api_key': apiKey,
        'timestamp': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      });

      final response = await _dio.post(url, data: formData);

      if (response.statusCode == 200) {
        final imageUrl = response.data['secure_url'];
        return imageUrl;
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}
