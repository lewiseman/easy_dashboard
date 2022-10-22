import 'package:easy_dashboard/src/models/body_model.dart';
import 'package:flutter/material.dart';

/// A controller to help with the [EasyDashboard] elements .
/// Give more control to the user
class EasyController extends ChangeNotifier {
  final EasyBody? intialBody;
  EasyController({
    this.intialBody,
  }) {
    init();
  }
  late EasyBody body;
  bool _moving = true;

  void init() {
    switchBody(intialBody ??
        EasyBody(child: const SizedBox(), title: const SizedBox()));
  }

  EasyBody get page => body;
  bool get moving => _moving;

  void switchBody(EasyBody body) {
    this.body = body;
    notifyListeners();
  }

  void movingToTrue() {
    _moving = true;
    notifyListeners();
  }

  void movingToFalse() {
    _moving = false;
    notifyListeners();
  }
}
