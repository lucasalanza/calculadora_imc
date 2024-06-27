// ignore_for_file: file_names

import 'dart:io';

class AdmobService {
  String getBannerAdUnit() {
    if (Platform.isAndroid) {
      return "ca-app-pub-4776225290568659/1060210197";
      return "ca-app-pub-3940256099942544/6300978111"; //anncio de teste do google
    } else {
      return "";
    }
  }

  String getIntersticialAdUnit() {
    if (Platform.isAndroid) {
      return "ca-app-pub-4776225290568659/4016163133";
    } else {
      return "";
    }
  }

  String getAberturaAdUnit() {
    if (Platform.isAndroid) {
      return "ca-app-pub-4776225290568659/9436010777";
    } else {
      return "";
    }
  }
}
