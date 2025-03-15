import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:omra/page/widgets/ad_manager.dart';
import 'package:omra/page/widgets/drawer_item.dart';
import 'package:omra/page/widgets/reservation_button.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;

  // مدير الإعلانات
  final AdManager _adManager = AdManager();

  // في ملف home_screen.dart
  @override
  void initState() {
    super.initState();
    print("🎬 HomeScreen Initialized!");

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..forward();

    // تعيين وضع الاختبار
    AdManager.setTestMode(true); // تعيين true للاختبار و false للإنتاج

    // تهيئة الإعلانات
    _adManager.initialize();

    // إعادة محاولة تحميل الإعلانات
    Future.delayed(Duration(seconds: 3), () {
      if (!_adManager.isBannerAdLoaded) {
        _adManager.loadBannerAd();
      }
    });

    // إعادة بناء الواجهة لتحديث عرض الإعلانات
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) setState(() {});
    });

    // عرض الإعلان البيني بعد فترة من بدء التطبيق
    Future.delayed(Duration(seconds: 5), () {
      _adManager.showInterstitialAd();
    });
  }

  @override
  void dispose() {
    print("🛑 HomeScreen Disposed!");
    _animationController.dispose();
    _adManager.dispose();
    super.dispose();
  }

  // فتح رابط خارجي
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('لا يمكن فتح الرابط: $url')),
      );
    }
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  // ========== App UI Building ==========
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: _buildBody(),
    );
  }

  // ========== UI Components ==========
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.menu, color: Colors.indigo),
        onPressed: _openDrawer,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Hero(
            tag: 'logo',
            child: Image.asset('assets/images/omra.png', width: 60, height: 60),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      child: SafeArea(
        child: Column(
          children: [
            // Main content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildMainContent(),
                ),
              ),
            ),

            // Banner ad at the bottom
            _buildBannerAdContainer(),
          ],
        ),
      ),
    );
  }

  // في ملف home_screen.dart

  Widget _buildBannerAdContainer() {
    return StatefulBuilder(
      builder: (context, setState) {
        // تحديث الحالة دورياً
        Future.delayed(Duration(seconds: 2), () {
          if (mounted) {
            setState(() {});
          }
        });

        if (_adManager.isBannerAdLoaded && _adManager.bannerAd != null) {
          // عرض الإعلان الذي تم تحميله بنجاح
          return Container(
            alignment: Alignment.center,
            width: _adManager.bannerAd!.size.width.toDouble(),
            height: _adManager.bannerAd!.size.height.toDouble(),
            margin: EdgeInsets.symmetric(vertical: 10),
            child: AdWidget(ad: _adManager.bannerAd!),
          );
        } else {
          // إذا فشل تحميل الإعلان
          if (!_adManager.isBannerAdLoaded) {
            // إعادة محاولة التحميل
            Future.delayed(Duration(seconds: 5), () {
              _adManager.loadBannerAd();
              if (mounted) setState(() {});
            });
          }

          // عرض مساحة احتياطية بدلاً من الإعلان
          return Container(
            height: 50,
            child: Center(
              child: Text(
                "جاري تحميل الإعلان...",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        SizedBox(height: 20),
        _buildReservationButton(
            'حجز الروضة',
            'Rawda Reservation',
            Color(0xFF1E8449),
            Color(0xFF27AE60),
            Icons.mosque,
            'http://www.almaehadalealibialjamiea.com/2021/04/blog-post_81.html'),
        SizedBox(height: 20),
        _buildReservationButton(
            'حجز العمرة',
            'Umrah Reservation',
            Color(0xFFD35400),
            Color(0xFFE67E22),
            Icons.account_balance,
            'http://www.almaehadalealibialjamiea.com/2021/01/blog-post_75.html'),
        SizedBox(height: 20),
        _buildReservationButton(
            'حجز الحج',
            'Hajj Reservation',
            Color(0xFF0E6655),
            Color(0xFF16A085),
            Icons.holiday_village,
            'http://www.almaehadalealibialjamiea.com/2022/01/2022-30.html'),
        SizedBox(height: 20),
        _buildReservationButton(
            'كيفية الحجز',
            'How to Book',
            Color(0xFF4A235A),
            Color(0xFF7D3C98),
            Icons.help_outline,
            'http://www.almaehadalealibialjamiea.com/2022/01/2022-30.html'),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo.shade900, Colors.indigo.shade700],
          ),
        ),
        child: Column(
          children: <Widget>[
            _buildDrawerHeader(),
            _buildDrawerItems(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      height: 180,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Colors.indigo.shade800),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Image.asset('assets/images/omra.png', width: 70, height: 70),
          ),
          SizedBox(height: 15),
          Text(
            "تطبيق العمرة",
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItems() {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerItem(
            text: 'حجز الروضة',
            icon: Icons.mosque,
            url:
                'http://www.almaehadalealibialjamiea.com/2021/04/blog-post_81.html',
            onTap: () {
              // عرض الإعلان قبل فتح الرابط
              _adManager.showInterstitialAd().then((shown) {
                _launchURL(
                    'http://www.almaehadalealibialjamiea.com/2021/04/blog-post_81.html');
              });
            },
          ),
          DrawerItem(
            text: 'حجز العمرة',
            icon: Icons.account_balance,
            url:
                'http://www.almaehadalealibialjamiea.com/2021/01/blog-post_75.html',
            // تكملة كود home_screen.dart
            onTap: () {
              _adManager.showInterstitialAd().then((shown) {
                _launchURL(
                    'http://www.almaehadalealibialjamiea.com/2021/01/blog-post_75.html');
              });
            },
          ),
          DrawerItem(
            text: ' حجز الحج',
            icon: Icons.holiday_village,
            url: 'http://www.almaehadalealibialjamiea.com/2022/01/2022-30.html',
            onTap: () {
              _adManager.showInterstitialAd().then((shown) {
                _launchURL(
                    'http://www.almaehadalealibialjamiea.com/2022/01/2022-30.html');
              });
            },
          ),
          DrawerItem(
            text: ' كيفية الحجز',
            icon: Icons.book,
            url: 'http://www.almaehadalealibialjamiea.com/2022/01/2022-30.html',
            onTap: () {
              _adManager.showInterstitialAd().then((shown) {
                _launchURL(
                    'http://www.almaehadalealibialjamiea.com/2022/01/2022-30.html');
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReservationButton(String arabicText, String englishText,
      Color color, Color secondaryColor, IconData icon, String url) {
    return SlideTransition(
      position: Tween<Offset>(begin: Offset(-1, 0), end: Offset.zero).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      ),
      child: ReservationButton(
          arabicText: arabicText,
          englishText: englishText,
          color: color,
          secondaryColor: secondaryColor,
          logoIconData: icon,
          onPressed: () async {
            // استخدام وضع القوة (force=true) لعرض الإعلان البيني فورًا
            bool shown = await _adManager.showInterstitialAd(force: true);

            // الانتقال للرابط في كل الأحوال
            _launchURL(url);
          }),
    );
  }
}
