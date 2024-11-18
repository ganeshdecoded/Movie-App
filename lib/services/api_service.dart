import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/show.dart';

class ApiService {
  static const String baseUrl = 'https://api.tvmaze.com';

  Future<List<Show>> getShows(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search/shows?q=$query'));
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Show.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load shows');
    }
  }
} 