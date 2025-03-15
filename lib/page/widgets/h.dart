

// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:omra/page/widgets/drawer_item.dart';
// import 'package:omra/page/widgets/reservation_button.dart';
// import 'package:url_launcher/url_launcher.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   late AnimationController _animationController;

//   // إعلان بانر
//   BannerAd? _bannerAd;
//   bool _isBannerAdLoaded = false;

//   // إعلان بيني
//   InterstitialAd? _interstitialAd;
  
//   // إعلان مستطيل كبير
//   NativeAd? _nativeAd;
//   bool _isNativeAdLoaded = false;

//   @override
//   void initState() {
//     super.initState();
//     print("🎬 HomeScreen Initialized!");

//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 1),
//     )..forward();

//     // تحميل الإعلانات
//     _loadBannerAd();
//     _loadInterstitialAd();
//     _loadNativeAd();
    
//     // عرض الإعلان البيني تلقائيًا بعد فترة زمنية
//     Future.delayed(Duration(seconds: 5), () {
//       _showInterstitialAd();
//     });
//   }

//   @override
//   void dispose() {
//     print("🛑 HomeScreen Disposed!");
//     _animationController.dispose();
//     _bannerAd?.dispose();
//     _interstitialAd?.dispose();
//     _nativeAd?.dispose();
//     super.dispose();
//   }

//   // تحميل إعلان البانر
//   void _loadBannerAd() {
//     print("📢 جاري تحميل إعلان البانر...");
//     _bannerAd = BannerAd(
//       adUnitId: 'ca-app-pub-7376650992574816/4176453695',
//       size: AdSize.largeBanner,  // استخدام حجم أكبر للبانر
//       request: AdRequest(),
//       listener: BannerAdListener(
//         onAdLoaded: (Ad ad) {
//           print("✅ إعلان البانر تم تحميله بنجاح!");
//           setState(() {
//             _isBannerAdLoaded = true;
//           });
//         },
//         onAdFailedToLoad: (Ad ad, LoadAdError error) {
//           print("❌ فشل تحميل إعلان البانر: $error");
//           ad.dispose();
//           // إعادة المحاولة بعد فترة
//           Future.delayed(Duration(minutes: 1), _loadBannerAd);
//         },
//       ),
//     );
//     _bannerAd?.load();
//   }

//   // تحميل إعلان بيني
//   void _loadInterstitialAd() {
//     print("📢 جاري تحميل الإعلان البيني...");
//     InterstitialAd.load(
//       adUnitId: 'ca-app-pub-7376650992574816/9536886738',
//       request: AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (InterstitialAd ad) {
//           print("✅ الإعلان البيني تم تحميله بنجاح!");
//           _interstitialAd = ad;

//           _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
//             onAdDismissedFullScreenContent: (InterstitialAd ad) {
//               print("🔄 تم إغلاق الإعلان، جاري إعادة التحميل...");
//               ad.dispose();
//               _loadInterstitialAd();
//             },
//             onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
//               print("❌ فشل عرض الإعلان البيني: $error");
//               ad.dispose();
//               _loadInterstitialAd();
//             },
//           );
//         },
//         onAdFailedToLoad: (LoadAdError error) {
//           print("❌ فشل تحميل الإعلان البيني: $error");
//           _interstitialAd = null;
//           // إعادة المحاولة بعد فترة
//           Future.delayed(Duration(minutes: 1), _loadInterstitialAd);
//         },
//       ),
//     );
//   }

//   // تحميل إعلان مستطيل كبير
//   void _loadNativeAd() {
//     _nativeAd = NativeAd(
//       adUnitId: 'ca-app-pub-7376650992574816/4176453695', // استخدم معرف الإعلان الخاص بك للإعلانات المستطيلة
//       request: AdRequest(),
//       factoryId: 'listTile',
//       listener: NativeAdListener(
//         onAdLoaded: (Ad ad) {
//           print('✅ تم تحميل الإعلان المستطيل بنجاح!');
//           setState(() {
//             _isNativeAdLoaded = true;
//           });
//         },
//         onAdFailedToLoad: (Ad ad, LoadAdError error) {
//           print('❌ فشل تحميل الإعلان المستطيل: $error');
//           ad.dispose();
//           // إعادة المحاولة بعد فترة
//           Future.delayed(Duration(minutes: 1), _loadNativeAd);
//         },
//       ),
//     );
//     _nativeAd?.load();
//   }

//   // عرض الإعلان البيني
//   void _showInterstitialAd() {
//     if (_interstitialAd != null) {
//       print("🚀 عرض الإعلان البيني...");
//       _interstitialAd!.show();
//     } else {
//       print("⚠️ الإعلان البيني غير جاهز حالياً!");
//       _loadInterstitialAd();
//     }
//   }

//   // فتح رابط خارجي
//   Future<void> _launchURL(String url) async {
//     final Uri uri = Uri.parse(url);
//     if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('لا يمكن فتح الرابط: $url')),
//       );
//     }
//   }

//   void _openDrawer() {
//     _scaffoldKey.currentState?.openDrawer();
//   }

//   // ========== App UI Building ==========
//   @override
//   Widget build(BuildContext context) {
//     print("🔄 Rebuilding UI...");
//     return Scaffold(
//       key: _scaffoldKey,
//       extendBodyBehindAppBar: true,
//       appBar: _buildAppBar(),
//       drawer: _buildDrawer(),
//       body: _buildBody(),
//     );
//   }

//   // ========== UI Components ==========
//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       leading: IconButton(
//         icon: Icon(Icons.menu, color: Colors.indigo),
//         onPressed: _openDrawer,
//       ),
//       title: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Hero(
//             tag: 'logo',
//             child: Image.asset('assets/images/omra.png', width: 60, height: 60),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBody() {
//     return Container(
//       child: SafeArea(
//         child: Column(
//           children: [
//             // Native ad at the top
//             _buildNativeAdContainer(),
            
//             // Main content
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: _buildMainContent(),
//                 ),
//               ),
//             ),
            
//             // Banner ad at the bottom
//             _buildBannerAdContainer(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNativeAdContainer() {
//     if (_isNativeAdLoaded && _nativeAd != null) {
//       return Container(
//         height: 80,
//         margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: Colors.grey.shade300),
//         ),
//         padding: EdgeInsets.symmetric(horizontal: 8),
//         child: AdWidget(ad: _nativeAd!),
//       );
//     } else {
//       return SizedBox(height: 8);
//     }
//   }

//   Widget _buildBannerAdContainer() {
//     if (_isBannerAdLoaded && _bannerAd != null) {
//       return Container(
//         alignment: Alignment.center,
//         width: _bannerAd!.size.width.toDouble(),
//         height: _bannerAd!.size.height.toDouble(),
//         margin: EdgeInsets.only(bottom: 8),
//         child: AdWidget(ad: _bannerAd!),
//       );
//     } else {
//       return SizedBox(height: 8);
//     }
//   }

//   Widget _buildMainContent() {
//     return Column(
//       children: [
//         SizedBox(height: 20),
//         _buildReservationButton(
//           'حجز الروضة', 
//           'Rawda Reservation',
//           Color(0xFF1E8449), 
//           Color(0xFF27AE60), 
//           Icons.mosque,
//           'http://www.almaehadalealibialjamiea.com/2021/04/blog-post_81.html'
//         ),
//         SizedBox(height: 20),
//         _buildReservationButton(
//           'حجز العمرة', 
//           'Umrah Reservation',
//           Color(0xFFD35400), 
//           Color(0xFFE67E22), 
//           Icons.account_balance, 
//           'http://www.almaehadalealibialjamiea.com/2021/01/blog-post_75.html'
//         ),
//         SizedBox(height: 20),
//         _buildReservationButton(
//           'حجز الحج', 
//           'Hajj Reservation',
//           Color(0xFF0E6655), 
//           Color(0xFF16A085), 
//           Icons.holiday_village, 
//           'http://www.almaehadalealibialjamiea.com/2022/01/2022-30.html'
//         ),
//         SizedBox(height: 20),
//         _buildReservationButton(
//           'كيفية الحجز', 
//           'How to Book',
//           Color(0xFF4A235A), 
//           Color(0xFF7D3C98), 
//           Icons.help_outline, 
//           'http://www.almaehadalealibialjamiea.com/2022/01/2022-30.html'
//         ),
//         SizedBox(height: 20),
//       ],
//     );
//   }

//   Widget _buildDrawer() {
//     return Drawer(
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Colors.indigo.shade900, Colors.indigo.shade700],
//           ),
//         ),
//         child: Column(
//           children: <Widget>[
//             _buildDrawerHeader(),
//             _buildDrawerItems(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDrawerHeader() {
//     return Container(
//       height: 180,
//       width: double.infinity,
//       alignment: Alignment.center,
//       decoration: BoxDecoration(color: Colors.indigo.shade800),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SizedBox(height: 30),
//           Container(
//             padding: EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               shape: BoxShape.circle,
//             ),
//             child: Image.asset('assets/images/omra.png',
//                 width: 70, height: 70),
//           ),
//           SizedBox(height: 15),
//           Text(
//             "تطبيق العمرة",
//             style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDrawerItems() {
//     return Expanded(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: <Widget>[
//           DrawerItem(
//             text: 'حجز الروضة',
//             icon: Icons.mosque,
//             url:
//                 'http://www.almaehadalealibialjamiea.com/2021/04/blog-post_81.html',
//           ),
//           DrawerItem(
//             text: 'حجز العمرة',
//             icon: Icons.account_balance,
//             url:
//                 'http://www.almaehadalealibialjamiea.com/2021/01/blog-post_75.html',
//           ),
//           DrawerItem(
//             text: ' حجز الحج',
//             icon: Icons.holiday_village,
//             url:
//                 'http://www.almaehadalealibialjamiea.com/2022/01/2022-30.html',
//           ),
//           DrawerItem(
//             text: ' كيفية الحجز',
//             icon: Icons.book,
//             url:
//                 'http://www.almaehadalealibialjamiea.com/2022/01/2022-30.html',
//           ),
//         ],
//       ),
//     );
//   }

//    Widget _buildReservationButton(String arabicText, String englishText, Color color, Color secondaryColor, IconData icon, String url) {
//     return SlideTransition(
//       position: Tween<Offset>(begin: Offset(-1, 0), end: Offset.zero).animate(
//         CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
//       ),
//       child: ReservationButton(
//         arabicText: arabicText,
//         englishText: englishText,
//         color: color,
//         secondaryColor: secondaryColor,
//         logoIconData: icon,
//         onPressed: () {
//           // عرض الإعلان البيني عند الضغط على أي زر ثم الانتقال للرابط
//           _showInterstitialAd();
//           _launchURL(url);
//         },
//       ),
//     );
//   }
// }