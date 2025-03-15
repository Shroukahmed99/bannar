// ad_manager.dart
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  // معرفات الإعلانات الحقيقية
  static const String _realBannerAdUnitId = 'ca-app-pub-7376650992574816/4176453695';
  static const String _realInterstitialAdUnitId = 'ca-app-pub-7376650992574816/9536886738';
  
  // معرفات الإعلانات التجريبية (للاختبار)
  static const String _testBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testInterstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
  
  // استخدام معرفات الاختبار في بيئة التطوير
  static bool _isTestMode = true;
  
  // الحصول على معرفات الإعلانات المناسبة
  static String get bannerAdUnitId => _isTestMode ? _testBannerAdUnitId : _realBannerAdUnitId;
  static String get interstitialAdUnitId => _isTestMode ? _testInterstitialAdUnitId : _realInterstitialAdUnitId;
  
  // الإعلانات
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  bool _isBannerAdLoaded = false;
  bool _isInterstitialAdReady = false;
  
  // متغير للتحكم في عرض الإعلانات البينية
  DateTime? _lastInterstitialShownTime;
  
  // الحصول على حالة تحميل إعلان البانر
  bool get isBannerAdLoaded => _isBannerAdLoaded;
  
  // الحصول على إعلان البانر
  BannerAd? get bannerAd => _bannerAd;
  
  // تهيئة الإعلانات
  void initialize() {
    print("🚀 تهيئة مدير الإعلانات... وضع الاختبار: $_isTestMode");
    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        testDeviceIds: ["7C38AD7B7B7B7B7B7B7B7B7B7B7B7B7B"], // استبدل بمعرف جهازك الحقيقي
      ),
    );
    
    loadBannerAd();
    loadInterstitialAd();
  }
  
  // تحميل إعلان البانر مع آلية إعادة المحاولة
  void loadBannerAd() {
    // تحقق من وجود إعلان سابق وإزالته
    if (_bannerAd != null) {
      _bannerAd!.dispose();
      _bannerAd = null;
    }
    
    print("📢 جاري تحميل إعلان البانر... معرف الإعلان: ${bannerAdUnitId}");
    
    _bannerAd = BannerAd(
      adUnitId: bannerAdUnitId, // استخدام المعرف الصحيح
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          print("✅ إعلان البانر تم تحميله بنجاح!");
          _isBannerAdLoaded = true; // تحديث حالة التحميل
        },
        onAdFailedToLoad: (ad, error) {
          print("❌ فشل تحميل إعلان البانر: ${error.message}");
          _isBannerAdLoaded = false;
          ad.dispose();
          
          // إعادة المحاولة بعد فترة
          print("⏱️ إعادة محاولة تحميل إعلان البانر بعد 30 ثانية...");
          Future.delayed(Duration(seconds: 30), loadBannerAd);
        },
      ),
    );

    _bannerAd!.load();
  }
  
  // تحميل الإعلان البيني مع آلية إعادة المحاولة
  void loadInterstitialAd() {
    print("📢 جاري تحميل الإعلان البيني... معرف الإعلان: ${interstitialAdUnitId}");
    
    if (_interstitialAd != null) {
      _interstitialAd!.dispose();
      _interstitialAd = null;
    }
    
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print("✅ الإعلان البيني تم تحميله بنجاح!");
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
          
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              print("🔄 تم إغلاق الإعلان البيني، جاري إعادة التحميل...");
              _isInterstitialAdReady = false;
              ad.dispose();
              _interstitialAd = null;
              _lastInterstitialShownTime = DateTime.now();
              loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
              print("❌ فشل عرض الإعلان البيني: $error");
              _isInterstitialAdReady = false;
              ad.dispose();
              _interstitialAd = null;
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          print("❌ فشل تحميل الإعلان البيني: $error");
          _interstitialAd = null;
          _isInterstitialAdReady = false;
          
          // إعادة المحاولة بعد فترة
          if (error.code == 3) { // رمز الخطأ "No fill"
            print("⏱️ إعادة المحاولة بعد 30 ثانية...");
            Future.delayed(Duration(seconds: 30), loadInterstitialAd);
          } else {
            print("⏱️ إعادة المحاولة بعد 60 ثانية...");
            Future.delayed(Duration(minutes: 1), loadInterstitialAd);
          }
        },
      ),
    );
  }
  
  // عرض الإعلان البيني مع منع التكرار السريع
  Future<bool> showInterstitialAd() async {
    // التحقق من جاهزية الإعلان البيني
    if (_interstitialAd == null || !_isInterstitialAdReady) {
      print("⚠️ الإعلان البيني غير جاهز بعد.");
      // إعادة تحميل الإعلان إذا كان غير متوفر
      loadInterstitialAd();
      return false;
    }

    // التحقق من الفاصل الزمني منذ آخر عرض
    if (_lastInterstitialShownTime != null) {
      final difference = DateTime.now().difference(_lastInterstitialShownTime!);
      if (difference.inSeconds < 60) { // منع العرض أكثر من مرة في الدقيقة الواحدة
        print("⏱️ لم يمر وقت كافٍ منذ آخر عرض للإعلان البيني (${difference.inSeconds} ثانية).");
        return false;
      }
    }

    try {
      await Future.delayed(Duration(seconds: 1)); // تأخير صغير قبل العرض
      print("🎯 جاري عرض الإعلان البيني...");
      
      // الاحتفاظ بنسخة مؤقتة من الإعلان
      final InterstitialAd adToShow = _interstitialAd!;
      
      // إعادة تعيين المتغيرات
      _interstitialAd = null;
      _isInterstitialAdReady = false;
      
      // عرض الإعلان
      adToShow.show();
      
      // تحديث وقت آخر عرض
      _lastInterstitialShownTime = DateTime.now();
      
      // تحميل إعلان جديد
      loadInterstitialAd();
      
      return true;
    } catch (e) {
      print("❌ خطأ أثناء عرض الإعلان البيني: $e");
      _isInterstitialAdReady = false;
      loadInterstitialAd();
      return false;
    }
  }
  
  // توقيف عرض الإعلانات
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _bannerAd = null;
    _interstitialAd = null;
  }
  
  // ضبط وضع الاختبار
  static void setTestMode(bool isTestMode) {
    _isTestMode = isTestMode;
    print("🔧 تم ضبط وضع الاختبار: $_isTestMode");
  }
}