import 'package:flutter/material.dart';
import '../services/distance_services.dart'; // Import the service file

class DistanceCalculatorScreen extends StatefulWidget {
  @override
  _DistanceCalculatorScreenState createState() => _DistanceCalculatorScreenState();
}

class _DistanceCalculatorScreenState extends State<DistanceCalculatorScreen> {
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();
  final _apiKey = 'YOUR_GOOGLE_API_KEY'; // Replace with your API key
  final _distanceService = DistanceService('YOUR_GOOGLE_API_KEY');
  String _result = '';

  void _calculateDistance() async {
    try {
      final distance = await _distanceService.getWalkingDistance(
        _originController.text,
        _destinationController.text,
      );
      setState(() {
        _result = 'Distance: ${distance.toStringAsFixed(2)} km';
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Walking Distance Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _originController,
              decoration: InputDecoration(labelText: 'Start Address'),
            ),
            TextField(
              controller: _destinationController,
              decoration: InputDecoration(labelText: 'End Address'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateDistance,
              child: Text('Calculate Distance'),
            ),
            SizedBox(height: 20),
            Text(_result, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
