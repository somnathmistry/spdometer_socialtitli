import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/app_content/app_content.dart';
import 'distance_view.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = pedStatus, _steps = stepsCount;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  Future<bool> _checkActivityRecognitionPermission() async {
    bool granted = await Permission.activityRecognition.isGranted;

    if (!granted) {
      granted = await Permission.activityRecognition.request() ==
          PermissionStatus.granted;
    }

    return granted;
  }

  Future<void> initPlatformState() async {
    bool granted = await _checkActivityRecognitionPermission();
    if (!granted) {
      // tell user, the app will not work
    }

    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    (await _pedestrianStatusStream.listen(onPedestrianStatusChanged))
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title:  Text(appBarTitle),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                stepsTitle,
                style: TextStyle(fontSize: 30),
              ),
              Text(
                _steps,
                style: TextStyle(fontSize: 60),
              ),
              Divider(
                height: 100,
                thickness: 0,
                color: Colors.white,
              ),
              Text(
                pedTitle,
                style: TextStyle(fontSize: 30),
              ),
              Icon(
                _status == 'walking'
                    ? Icons.directions_walk
                    : _status == 'stopped'
                    ? Icons.accessibility_new
                    : Icons.error,
                size: 100,
              ),
              Center(
                child: Text(
                  _status,
                  style: _status == 'walking' || _status == 'stopped'
                      ? TextStyle(fontSize: 30)
                      : TextStyle(fontSize: 20, color: Colors.red),
                ),
              ),

             ElevatedButton(onPressed: (){
               _navigateToNextScreen(context);
             }, child: Text('See Distance'))  ],
          ),
        ),
      ),
    );
  }
  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => DistanceCalculatorScreen()));
  }
}