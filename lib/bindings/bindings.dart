import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hyperhire_app/utils/constants.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

void intBinding() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top],
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
        statusBarColor: AppColors.bgColor,
        systemNavigationBarColor: AppColors.bgColor),
  );

  await SendbirdChat.init(appId: 'BC823AD1-FBEA-4F08-8F41-CF0D9D280FBF');
}
