import 'package:applovin_max/applovin_max.dart';
import 'package:exd_morning/ad_services/ads_services.dart';
import 'package:exd_morning/home/homeController.dart';
import 'package:exd_morning/home/home_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  HomeController homeController = Get.put(HomeController());
  //  HomeController homeController2 = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    AdsServices.initializeRewardedAds();
    AdsServices.initializeInterstitialAds();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      bottomNavigationBar: AdsServices.displayBannerAd(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
              onPressed: () {
                AdsServices.displayRewardedAds();
              },
              child: const Text("Go To Map Page")),
          HomeWidgets.submitBtn(),

          AdsServices.displayBannerAd(),
          Obx((() {
            return Text(
              homeController.count.toString(),
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            );
          })),
          AdsServices.displayNativeMRECAd(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    AdsServices.displayInterstitialAds();
                  },
                  child: const Text("Increment")),
              MaxAdView(
                  adUnitId: '',
                  adFormat: AdFormat.banner,
                  listener: AdViewAdListener(
                      onAdLoadedCallback: (ad) {},
                      onAdLoadFailedCallback: (adUnitId, error) {},
                      onAdClickedCallback: (ad) {},
                      onAdExpandedCallback: (ad) {},
                      onAdCollapsedCallback: (ad) {})),
              ElevatedButton(
                  onPressed: () {
                    homeController.count.value = homeController.count.value - 1;
                  },
                  child: const Text("Decrement")),
            ],
          ),
          Obx(() => Text("Name is: ${homeController.name.value}")),
          ElevatedButton(
              onPressed: () {
                homeController.name.value = "exd LAhore";
              },
              child: const Text("Name Update")),

          // ------------------------------
          GetBuilder<HomeController>(builder: (controller) {
            return Column(
              children: [
                Text("count: ${controller.count}"),
                Text("count: ${controller.name}"),
                ElevatedButton(
                    onPressed: () {
                      // controller.updateValues();
                      controller.incrementValue();
                    },
                    child: const Text("Builder Update")),
              ],
            );
          }),
        ],
      ),
    );
  }
}
