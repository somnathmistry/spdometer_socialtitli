import 'dart:convert';
import 'package:http/http.dart' as http;

class DistanceService {
  final String apiKey;

  DistanceService(this.apiKey);

  Future<double> getWalkingDistance(String origin, String destination) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/distancematrix/json'
          '?units=metric'
          '&origins=$origin'
          '&destinations=$destination'
          '&mode=walking'
          '&key=$apiKey',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final distanceText = data['rows'][0]['elements'][0]['distance']['text'];
      final distanceValue = data['rows'][0]['elements'][0]['distance']['value'];
      return distanceValue / 1000;  // Distance in kilometers
    } else {
      throw Exception('Failed to load distance');
    }
  }
}
