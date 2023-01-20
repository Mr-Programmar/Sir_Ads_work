import 'package:get/state_manager.dart';

class HomeController extends GetxController {
  RxInt count = 0.obs;
  RxString name = "".obs;
  RxBool loading  = false.obs;

  updateValues() {
    count.value = 500;
    name.value = "Pakistan 55555555555";
    update();
  }

  incrementValue() {
    count.value = count.value + 1;
    update();
  }
}
