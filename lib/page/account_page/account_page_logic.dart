import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountPageLogic extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this, // Correctly using the mixin for the vsync parameter
    );
  }

  void startRotation() {
    animationController.repeat(); // Use repeat to keep it spinning
  }

  void stopRotation() {
    animationController.stop(canceled: false); // Stop the animation
  }

  @override
  void onClose() {
    animationController.dispose(); // Dispose of animationController properly
    super.onClose();
  }

  Future<void> fetchData() async {
    startRotation();
    try {
      // Simulates network request
      await Future.delayed(Duration(seconds: 5));
    } finally {
      stopRotation();
    }
  }
}
