import 'package:flutter/material.dart';
import 'package:gym_tracker/app.dart';

// Adicione esta linha global
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const GymTrackerApp());
}
