import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/photo.dart';

class PhotoService {
  static const String _baseUrl = 'https://picsum.photos/v2/list';
  
  // Fetch photos from Picsum API
  // I chose this API because it's free and has good image quality
  Future<List<Photo>> fetchPhotos({int limit = 10}) async {
    try {
      final uri = Uri.parse('$_baseUrl?limit=$limit');
      
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Photo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch photos: HTTP ${response.statusCode}');
      }
    } catch (e) {
      // Handle different types of errors
      if (e.toString().contains('SocketException')) {
        throw Exception('No internet connection available');
      } else if (e.toString().contains('TimeoutException')) {
        throw Exception('Request timed out. Please try again');
      } else {
        throw Exception('Something went wrong: ${e.toString()}');
      }
    }
  }
}

// Simple auth service for demo purposes
// In a real app, this would connect to a backend
class AuthService {
  Future<bool> login(String email, String password) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Basic validation - just check if fields are not empty
    // This is obviously not secure, but it's just for the demo
    return email.isNotEmpty && password.isNotEmpty;
  }
}
