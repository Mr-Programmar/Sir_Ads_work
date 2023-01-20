import 'package:flutter/material.dart';
import 'package:applovin_max/applovin_max.dart';
import 'dart:math' as m;

class AdsServices {
  static var sdkKey =
      "2MUk_Fq0UafQGZkmSOKcfnpy67su3ddUd6I7o77CPGESea05sQvHJKUgu3BbW9QcUp6GPRowXANMXeeT4So_Jd";
  static var bannerAdID = "6d8b8ac7b273ae03";
  static var interstitialAdID = "e1b63b89569fd2e4";
  static var mrecAdID = 'a0ba3a14d644fb73';
  static var rewardedAdID = 'bd7f8c4683150d8a';

// ---------------------  Ads Initialize -----------------------------

  static adsInitialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    Map? sdkConfiguration = await AppLovinMAX.initialize(sdkKey);
  }

// ---------------------  Banner ads -----------------------------

  static Widget displayBannerAd() {
    return MaxAdView(
        adUnitId: bannerAdID,
        adFormat: AdFormat.banner,
        listener: AdViewAdListener(
            onAdLoadedCallback: (ad) {},
            onAdLoadFailedCallback: (adUnitId, error) {},
            onAdClickedCallback: (ad) {},
            onAdExpandedCallback: (ad) {},
            onAdCollapsedCallback: (ad) {}));
  }

// ---------------------  Interstitial ads -----------------------------
  static initializeInterstitialAds() {
    var interstitialRetryAttempt = 0;
    AppLovinMAX.setInterstitialListener(InterstitialListener(
      onAdLoadedCallback: (ad) {
        // Interstitial ad is ready to be shown. AppLovinMAX.isInterstitialReady(_interstitial_ad_unit_id) will now return 'true'
        print('Interstitial ad loaded from ${ad.networkName}');

        // Reset retry attempt
        interstitialRetryAttempt = 0;
      },
      onAdLoadFailedCallback: (adUnitId, error) {
        // Interstitial ad failed to load
        // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)
        interstitialRetryAttempt = interstitialRetryAttempt + 1;

        int retryDelay = m.pow(2, m.min(6, interstitialRetryAttempt)).toInt();

        print(
            'Interstitial ad failed to load with code ${error.code} - retrying in ${retryDelay}s');

        Future.delayed(Duration(milliseconds: retryDelay * 1000), () {
          AppLovinMAX.loadInterstitial(interstitialAdID);
        });
      },
      onAdDisplayedCallback: (ad) {},
      onAdDisplayFailedCallback: (ad, error) {},
      onAdClickedCallback: (ad) {},
      onAdHiddenCallback: (ad) {},
    ));

    // Load the first interstitial
    AppLovinMAX.loadInterstitial(interstitialAdID);
  }

  static displayInterstitialAds() async {
    await initializeInterstitialAds();
    bool isReady = (await AppLovinMAX.isInterstitialReady(interstitialAdID))!;
    if (isReady) {
      AppLovinMAX.showInterstitial(interstitialAdID);
    }
  }

// ---------------------  Native MREC  -------------------------------

  static Widget displayNativeMRECAd() {
    return MaxAdView(
        adUnitId: mrecAdID,
        adFormat: AdFormat.mrec,
        listener: AdViewAdListener(
            onAdLoadedCallback: (ad) {},
            onAdLoadFailedCallback: (adUnitId, error) {},
            onAdClickedCallback: (ad) {},
            onAdExpandedCallback: (ad) {},
            onAdCollapsedCallback: (ad) {}));
  }

// ---------------------Rewarded Ads  -------------------------------

  static void initializeRewardedAds() {
    var rewardedAdRetryAttempt = 0;

    AppLovinMAX.setRewardedAdListener(RewardedAdListener(
        onAdLoadedCallback: (ad) {
          // Rewarded ad is ready to be shown. AppLovinMAX.isRewardedAdReady(_rewarded_ad_unit_id) will now return 'true'
          print('Rewarded ad loaded from ${ad.networkName}');

          // Reset retry attempt
          rewardedAdRetryAttempt = 0;
        },
        onAdLoadFailedCallback: (adUnitId, error) {
          // Rewarded ad failed to load
          // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)
          rewardedAdRetryAttempt = rewardedAdRetryAttempt + 1;

          int retryDelay = m.pow(2, m.min(6, rewardedAdRetryAttempt)).toInt();
          print(
              'Rewarded ad failed to load with code ${error.code} - retrying in ${retryDelay}s');

          Future.delayed(Duration(milliseconds: retryDelay * 1000), () {
            AppLovinMAX.loadRewardedAd(rewardedAdID);
          });
        },
        onAdDisplayedCallback: (ad) {},
        onAdDisplayFailedCallback: (ad, error) {},
        onAdClickedCallback: (ad) {},
        onAdHiddenCallback: (ad) {},
        onAdReceivedRewardCallback: (ad, reward) {
          
        }));
  }

  static displayRewardedAds() async {
    bool isReady = (await AppLovinMAX.isRewardedAdReady(rewardedAdID))!;
    if (isReady) {
      AppLovinMAX.showRewardedAd(rewardedAdID);
    }
  }
}
