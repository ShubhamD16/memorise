import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobHelper {
  // static String get bannerID => Platform.isAndroid ? 'ca-app-pub-3940256099942544/6300978111' : 'ca-app-pub-3940256099942544/6300978111';

  static get bannerIdMainpage => BannerAd.testAdUnitId;
  static get bannerIdMainpageInlist => BannerAd.testAdUnitId;
  static get bannerIdOtherpage => BannerAd.testAdUnitId;
  static get bannerIdOtherspageInlist => BannerAd.testAdUnitId;
  static initialize() {
    if (MobileAds.instance == null) {
      MobileAds.instance.initialize();
    }
  }

  static BannerAd getBannerAdMainpage() {
    BannerAd bAd = BannerAd(
        size: AdSize.banner,
        adUnitId: bannerIdMainpage,
        listener: BannerAdListener(onAdClosed: (Ad ad) {
          print("Ad Closed");
        }, onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        }, onAdLoaded: (Ad ad) {
          print('Ad Loaded');
        }, onAdOpened: (Ad ad) {
          print('Ad opened');
        }),
        request: AdRequest());

    return bAd;
  }

  static Widget MainpageAdWidget() {
    return SizedBox(
      height: 10,
    );

    return Container(
      alignment: Alignment.center,
      child: AdWidget(
        ad: getBannerAdMainpage()..load(),
        key: UniqueKey(),
      ),
      width: getBannerAdMainpage().size.width.toDouble(),
      height: getBannerAdMainpage().size.height.toDouble(),
    );
  }

  static BannerAd getBannerAdMainpageInlist() {
    BannerAd bAd = BannerAd(
        size: AdSize.mediumRectangle,
        adUnitId: bannerIdMainpageInlist,
        listener: BannerAdListener(onAdClosed: (Ad ad) {
          print("Ad Closed");
        }, onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        }, onAdLoaded: (Ad ad) {
          print('Ad Loaded');
        }, onAdOpened: (Ad ad) {
          print('Ad opened');
        }),
        request: AdRequest());

    return bAd;
  }

  static Widget MainpageAdWidgetInlist() {
    return SizedBox(
      height: 10,
    );

    return Container(
      alignment: Alignment.center,
      child: AdWidget(
        ad: getBannerAdMainpageInlist()..load(),
        key: UniqueKey(),
      ),
      width: getBannerAdMainpageInlist().size.width.toDouble(),
      height: getBannerAdMainpageInlist().size.height.toDouble(),
    );
  }

  static BannerAd getBannerAdOtherPage() {
    BannerAd bAd = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: bannerIdOtherpage,
        listener: BannerAdListener(onAdClosed: (Ad ad) {
          print("Ad Closed");
        }, onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        }, onAdLoaded: (Ad ad) {
          print('Ad Loaded');
        }, onAdOpened: (Ad ad) {
          print('Ad opened');
        }),
        request: AdRequest());

    return bAd;
  }

  static Widget OtherpageAdWidget() {
    return SizedBox(
      height: 10,
    );

    return Container(
      alignment: Alignment.center,
      child: AdWidget(
        ad: getBannerAdOtherPage()..load(),
        key: UniqueKey(),
      ),
      width: getBannerAdOtherPage().size.width.toDouble(),
      height: getBannerAdOtherPage().size.height.toDouble(),
    );
  }

  static BannerAd getBannerAdOtherpageinlist() {
    BannerAd bAd = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: bannerIdOtherspageInlist,
        listener: BannerAdListener(onAdClosed: (Ad ad) {
          print("Ad Closed");
        }, onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        }, onAdLoaded: (Ad ad) {
          print('Ad Loaded');
        }, onAdOpened: (Ad ad) {
          print('Ad opened');
        }),
        request: AdRequest());

    return bAd;
  }

  static Widget OtherpageAdWidgetInlist() {
    return SizedBox(
      height: 10,
    );

    return Container(
      alignment: Alignment.center,
      child: AdWidget(
        ad: getBannerAdOtherpageinlist()..load(),
        key: UniqueKey(),
      ),
      width: getBannerAdOtherpageinlist().size.width.toDouble(),
      height: getBannerAdOtherpageinlist().size.height.toDouble(),
    );
  }
}
