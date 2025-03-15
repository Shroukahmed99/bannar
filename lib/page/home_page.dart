// lib/views/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:omra/page/models/home_view_model.dart';
import 'package:omra/page/widgets/banner_ad_widget.dart';
import 'package:omra/page/widgets/drawer_item.dart';
import 'package:omra/page/widgets/reservation_botton.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  final HomeViewModel _viewModel = HomeViewModel();

  @override
  void initState() {
    super.initState();
    print("🎬 HomeScreen Initialized!");

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..forward();

    _viewModel.initialize();

    Future.delayed(Duration(seconds: 3), () {
      if (!_viewModel.adViewModel.isBannerAdLoaded) {
        _viewModel.adViewModel.loadBannerAd();
      }
    });

    Future.delayed(Duration(seconds: 2), () {
      if (mounted) setState(() {});
    });

    Future.delayed(Duration(seconds: 5), () {
      _viewModel.adViewModel.showInterstitialAd();
    });
  }

  @override
  void dispose() {
    print("🛑 HomeScreen Disposed!");
    _animationController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

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
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildMainContent(),
                ),
              ),
            ),
            BannerAdWidget(adViewModel: _viewModel.adViewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    final reservationOptions = _viewModel.getReservationOptions();
    
    return Column(
      children: reservationOptions.map((option) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: _buildAnimatedReservationButton(
            option.arabicTitle,
            option.englishTitle,
            option.primaryColor,
            option.secondaryColor,
            getIconForName(option.iconName),
            option.url,
          ),
        );
      }).toList(),
    );
  }

  IconData getIconForName(String iconName) {
    switch (iconName) {
      case 'mosque': return Icons.mosque;
      case 'account_balance': return Icons.account_balance;
      case 'holiday_village': return Icons.holiday_village;
      case 'help_outline': return Icons.help_outline;
      default: return Icons.error;
    }
  }

  Widget _buildAnimatedReservationButton(
    String arabicText, 
    String englishText,
    Color color, 
    Color secondaryColor, 
    IconData icon, 
    String url
  ) {
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
          await _viewModel.adViewModel.showInterstitialAd(force: true);
          _viewModel.launchUrl(url, context);
        },
      ),
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
    final reservationOptions = _viewModel.getReservationOptions();
    
    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        children: reservationOptions.map((option) {
          return DrawerItem(
            text: option.arabicTitle,
            icon: getIconForName(option.iconName),
            onTap: () async {
              Navigator.pop(context);
              await _viewModel.adViewModel.showInterstitialAd();
              _viewModel.launchUrl(option.url, context);
            },
          );
        }).toList(),
      ),
    );
  }
}