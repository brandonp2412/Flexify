import 'package:flutter/material.dart';

class ExerciseState extends ChangeNotifier {
  String? selected;

  void selectExercise(String exercise) {
    selected = exercise;
    notifyListeners();
  }
}
