// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:omra/page/home_page.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized(); // تهيئة الواجهات قبل تشغيل التطبيق
//   MobileAds.instance.initialize(); // تهيئة AdMob
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Pilgrimage Reservations',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: HomeScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
// main.dart
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:omra/page/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // تهيئة إعلانات Google Mobile Ads
  await MobileAds.instance.initialize();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيق العمرة',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Cairo', // تأكد من إضافة الخط في ملف pubspec.yaml
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}