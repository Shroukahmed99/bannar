// lib/views/widgets/banner_ad_widget.dart
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:omra/page/models/ad_view_model.dart';

class BannerAdWidget extends StatefulWidget {
  final AdViewModel adViewModel;

  const BannerAdWidget({
    Key? key,
    required this.adViewModel,
  }) : super(key: key);

  @override
  _BannerAdWidgetState createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        Future.delayed(Duration(seconds: 2), () {
          if (mounted) {
            setState(() {});
          }
        });

        if (widget.adViewModel.isBannerAdLoaded && widget.adViewModel.bannerAd != null) {
          return Container(
            alignment: Alignment.center,
            width: widget.adViewModel.bannerAd!.size.width.toDouble(),
            height: widget.adViewModel.bannerAd!.size.height.toDouble(),
            margin: EdgeInsets.symmetric(vertical: 10),
            child: AdWidget(ad: widget.adViewModel.bannerAd!),
          );
        } else {
          if (!widget.adViewModel.isBannerAdLoaded) {
            Future.delayed(Duration(seconds: 5), () {
              widget.adViewModel.loadBannerAd();
              if (mounted) setState(() {});
            });
          }

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
}