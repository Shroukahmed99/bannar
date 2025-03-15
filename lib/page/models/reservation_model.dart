// lib/models/reservation_model.dart
import 'package:flutter/material.dart';

class ReservationModel {
  final String id;
  final String arabicTitle;
  final String englishTitle;
  final String iconName;
  final String url;
  final Color primaryColor;
  final Color secondaryColor;

  ReservationModel({
    required this.id,
    required this.arabicTitle,
    required this.englishTitle,
    required this.iconName,
    required this.url,
    required this.primaryColor,
    required this.secondaryColor,
  });
}