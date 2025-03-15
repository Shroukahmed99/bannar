// lib/viewmodels/ad_view_model.dart
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdViewModel {
  // Real ad IDs
  static const String _realBannerAdUnitId = 'ca-app-pub-7376650992574816/4176453695';
  static const String _realInterstitialAdUnitId = 'ca-app-pub-7376650992574816/9536886738';
  
  // Test ad IDs
  static const String _testBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testInterstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
  
  // Test mode flag
  static bool _isTestMode = true;
  
  // Getters for ad unit IDs
  static String get bannerAdUnitId => _isTestMode ? _testBannerAdUnitId : _realBannerAdUnitId;
  static String get interstitialAdUnitId => _isTestMode ? _testInterstitialAdUnitId : _realInterstitialAdUnitId;
  
  // Ad instances
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  bool _isBannerAdLoaded = false;
  bool _isInterstitialAdReady = false;
  
  // Interstitial ad control
  DateTime? _lastInterstitialShownTime;
  
  // Getters
  bool get isBannerAdLoaded => _isBannerAdLoaded;
  BannerAd? get bannerAd => _bannerAd;
  
  // Initialize ads
  void initialize() {
    print("🚀 Initializing AdViewModel... Test mode: $_isTestMode");
    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        testDeviceIds: ["7C38AD7B7B7B7B7B7B7B7B7B7B7B7B7B"],
      ),
    );
    
    loadBannerAd();
    loadInterstitialAd();
  }
  
  // Load banner ad with retry mechanism
  void loadBannerAd() {
    if (_bannerAd != null) {
      _bannerAd!.dispose();
      _bannerAd = null;
    }
    
    print("📢 Loading banner ad... ID: ${bannerAdUnitId}");
    
    _bannerAd = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          print("✅ Banner ad loaded successfully!");
          _isBannerAdLoaded = true;
        },
        onAdFailedToLoad: (ad, error) {
          print("❌ Failed to load banner ad: ${error.message}");
          _isBannerAdLoaded = false;
          ad.dispose();
          _bannerAd = null;
          
          // Retry after delay
          Future.delayed(Duration(seconds: 30), loadBannerAd);
        },
        onAdOpened: (ad) => print("💡 Banner ad opened"),
        onAdClosed: (ad) => print("🚪 Banner ad closed"),
        onAdImpression: (ad) => print("👁️ Banner ad impression"),
        onAdClicked: (ad) => print("🖱️ Banner ad clicked"),
      ),
    );

    try {
      _bannerAd!.load();
    } catch (e) {
      print("❌ Error loading banner ad: $e");
      _isBannerAdLoaded = false;
      _bannerAd = null;
      
      // Retry after delay
      Future.delayed(Duration(seconds: 60), loadBannerAd);
    }
  }
  
  // Load interstitial ad with retry mechanism
  void loadInterstitialAd() {
    print("📢 Loading interstitial ad... ID: ${interstitialAdUnitId}");
    
    if (_interstitialAd != null) {
      _interstitialAd!.dispose();
      _interstitialAd = null;
    }
    
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print("✅ Interstitial ad loaded successfully!");
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
          
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              print("🔄 Interstitial ad closed, reloading...");
              _isInterstitialAdReady = false;
              ad.dispose();
              _interstitialAd = null;
              _lastInterstitialShownTime = DateTime.now();
              loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
              print("❌ Failed to show interstitial ad: $error");
              _isInterstitialAdReady = false;
              ad.dispose();
              _interstitialAd = null;
              loadInterstitialAd();
            },
            onAdShowedFullScreenContent: (ad) => print("📺 Interstitial ad shown successfully!"),
            onAdClicked: (ad) => print("🖱️ Interstitial ad clicked"),
            onAdImpression: (ad) => print("👁️ Interstitial ad impression recorded"),
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          print("❌ Failed to load interstitial ad: $error");
          _interstitialAd = null;
          _isInterstitialAdReady = false;
          
          // Retry after delay
          if (error.code == 3) { // "No fill" error
            Future.delayed(Duration(seconds: 30), loadInterstitialAd);
          } else {
            Future.delayed(Duration(minutes: 1), loadInterstitialAd);
          }
        },
      ),
    );
  }
  
  // Show interstitial ad with optional force parameter
  Future<bool> showInterstitialAd({bool force = false}) async {
    if (_interstitialAd == null || !_isInterstitialAdReady) {
      print("⚠️ Interstitial ad not ready yet.");
      loadInterstitialAd();
      return false;
    }

    if (!force && _lastInterstitialShownTime != null) {
      final difference = DateTime.now().difference(_lastInterstitialShownTime!);
      if (difference.inSeconds < 60) {
        print("⏱️ Not enough time since last ad (${difference.inSeconds} seconds).");
        return false;
      }
    }

    try {
      await Future.delayed(Duration(milliseconds: 300));
      print("🎯 Showing interstitial ad...");
      
      final InterstitialAd adToShow = _interstitialAd!;
      _interstitialAd = null;
      _isInterstitialAdReady = false;
      
      adToShow.show();
      _lastInterstitialShownTime = DateTime.now();
      loadInterstitialAd();
      return true;
    } catch (e) {
      print("❌ Error showing interstitial ad: $e");
      _isInterstitialAdReady = false;
      loadInterstitialAd();
      return false;
    }
  }
  
  // Dispose ads
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _bannerAd = null;
    _interstitialAd = null;
  }
  
  // Set test mode
  static void setTestMode(bool isTestMode) {
    _isTestMode = isTestMode;
    print("🔧 Test mode set to: $_isTestMode");
  }
}