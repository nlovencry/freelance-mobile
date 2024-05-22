part of '../main.dart';

Map<String, WidgetBuilder> get _routes => <String, WidgetBuilder>{
      '/': (context) => SplashView(),
      '/login': (context) => Login2View(),
      '/home': (context) => MainHome(),
      // '/forgot': (context) => ForgotView(),
      '/token': (context) => TokenView(),
      '/confirm': (context) => ConfirmationView(),
      '/transaction': (context) => TransactionView(),
      '/assetMeter': (context) => ConfirmationView(),
    };
