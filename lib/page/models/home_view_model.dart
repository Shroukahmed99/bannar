// lib/viewmodels/home_view_model.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import '../models/reservation_model.dart';
import 'ad_view_model.dart';

class HomeViewModel {
  final AdViewModel adViewModel = AdViewModel();
  
  List<ReservationModel> getReservationOptions() {
    return [
      ReservationModel(
        id: 'rawda',
        arabicTitle: 'حجز الروضة',
        englishTitle: 'Rawda Reservation',
        iconName: 'mosque',
        url: 'http://www.almaehadalealibialjamiea.com/2021/04/blog-post_81.html',
        primaryColor: Color(0xFF1E8449),
        secondaryColor: Color(0xFF27AE60),
      ),
      ReservationModel(
        id: 'umrah',
        arabicTitle: 'حجز العمرة',
        englishTitle: 'Umrah Reservation',
        iconName: 'account_balance',
        url: 'http://www.almaehadalealibialjamiea.com/2021/01/blog-post_75.html',
        primaryColor: Color(0xFFD35400),
        secondaryColor: Color(0xFFE67E22),
      ),
      ReservationModel(
        id: 'hajj',
        arabicTitle: 'حجز الحج',
        englishTitle: 'Hajj Reservation',
        iconName: 'holiday_village',
        url: 'http://www.almaehadalealibialjamiea.com/2022/01/2022-30.html',
        primaryColor: Color(0xFF0E6655),
        secondaryColor: Color(0xFF16A085),
      ),
      ReservationModel(
        id: 'howto',
        arabicTitle: 'كيفية الحجز',
        englishTitle: 'How to Book',
        iconName: 'help_outline',
        url: 'http://www.almaehadalealibialjamiea.com/2022/01/2022-30.html',
        primaryColor: Color(0xFF4A235A),
        secondaryColor: Color(0xFF7D3C98),
      ),
    ];
  }
  
  Future<void> launchUrl(String url, BuildContext context) async {
    final Uri uri = Uri.parse(url);
    if (!await url_launcher.launchUrl(uri, mode: url_launcher.LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('لا يمكن فتح الرابط: $url')),
      );
    }
  }
  
  void initialize() {
    AdViewModel.setTestMode(true);
    adViewModel.initialize();
  }
  
  void dispose() {
    adViewModel.dispose();
  }
}