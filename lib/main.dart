import 'package:hy_tutorial/src/auth/view/login2_view.dart';
import 'package:hy_tutorial/src/data/provider/data_add_provider.dart';
import 'package:hy_tutorial/src/report/asset_performance/provider/asset_performance_provider.dart';
import 'package:hy_tutorial/src/report/download_ba/provider/ba_provider.dart';
import 'package:hy_tutorial/src/report/provider/report_provider.dart';
import 'package:hy_tutorial/src/tower/provider/tower_provider.dart';
import 'package:hy_tutorial/src/transaction/asset_downtime/provider/asset_downtime_provider.dart';
import 'package:hy_tutorial/src/transaction/asset_meter/provider/asset_meter_provider.dart';
import 'package:hy_tutorial/src/transaction/operation_hours/provider/operation_hours_provider.dart';
import 'package:hy_tutorial/src/transaction/provider/transaction_provider.dart';
import 'package:hy_tutorial/src/transaction/view/transaction_view.dart';
import 'package:hy_tutorial/src/turbine/provider/turbine_provider.dart';
import 'package:hy_tutorial/src/work_order/provider/work_order_provider.dart';
import 'package:hy_tutorial/src/work_order/wo_agreement/provider/wo_agreement_provider.dart';
import 'package:hy_tutorial/src/work_order/wo_realization/provider/wo_realization_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:hy_tutorial/common/helper/constant.dart';
import 'package:hy_tutorial/src/auth/provider/auth_provider.dart';
import 'package:hy_tutorial/src/auth/provider/change_password_provider.dart';
import 'package:hy_tutorial/src/auth/view/login_view.dart';
import 'package:hy_tutorial/src/home/provider/home_provider.dart';
import 'package:hy_tutorial/src/home/view/main_home.dart';

import 'package:hy_tutorial/src/notifikasi/provider/notifikasi_provider.dart';
import 'package:hy_tutorial/src/region/provider/region_provider.dart';
import 'package:hy_tutorial/src/splash_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:timeago/timeago.dart' as TIMEAGO;
import 'common/component/timezone.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'dart:io';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'common/library/firebase_manager.dart';
import 'src/auth/view/confirmation_view.dart';
import 'src/auth/view/token_view.dart';

import 'src/user/provider/user_provider.dart';
import 'utils/nav_observer.dart';
import 'utils/utils.dart';
import 'firebase_options.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

part 'common/routes.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();

  await requestPermission(Permission.location);
  await requestPermission(Permission.storage);
  await requestPermission(Permission.accessMediaLocation);
  await requestPermission(Permission.manageExternalStorage);
  await requestPermission(Permission.photos);

  /// [START] initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  /// [START] Google maps config for reduce crash event while using Google Maps SDK
  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = true;
  }

  /// [END]

  /// [START] initialize locale
  // init lib easy localization
  await EasyLocalization.ensureInitialized();
  // localized indonesian time ago
  TIMEAGO.setLocaleMessages("id", TIMEAGO.IdMessages());
  if (kDebugMode) {
    log(getTimezone());
  }

  /// [END] initialize locale

  // initialize crashlytics
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  FirebaseManager().initNotification();

  FirebaseMessaging.instance.getToken().then((value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Constant.kSetPrefFcmToken, "${value ?? ""}");
    log("FCM token : $value");
  });

  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  /// [END] initialize Firebase

  // check current device is emulator
  // if (Platform.isAndroid) {
  //   // if (await MethodChannel(Constant.APP_NAME).invokeMethod('is_emulator')) {
  //   final deviceInfo = await DeviceInfoPlugin().androidInfo;
  //   final data = {
  //     "board": deviceInfo.board,
  //     "brand": deviceInfo.brand,
  //     "product": deviceInfo.product,
  //     "full": deviceInfo.toString(),
  //     "timestamp": DateTime.now().millisecond
  //   };

  //   // await FirebaseCrashlytics.instance
  //   //     .log("Emulated user, data: ${jsonEncode(data)}");
  //   // await FirebaseCrashlytics.instance
  //   //     .recordError(Exception("Emulated Device Detected"), StackTrace.current);

  //   runApp(
  //     EasyLocalization(
  //       supportedLocales: [
  //         Locale('id', 'ID'),
  //         Locale('en'),
  //       ],
  //       path: 'assets/translations',
  //       // <-- change the path of the translation files
  //       fallbackLocale: Locale('id', 'ID'),
  //       child: Builder(
  //         builder: (context) {
  //           return MaterialApp(
  //             localizationsDelegates: context.localizationDelegates,
  //             supportedLocales: context.supportedLocales,
  //             locale: context.locale,
  //             transaction: EmulatorDetectedView(),
  //           );
  //         },
  //       ),
  //     ),
  //   );
  //   return;
  //   // }
  // }

  // initialize flutter downloader
  await FlutterDownloader.initialize(
    debug: false, // optional: set false to disable loging logs to console
  );
  FlutterAppBadger.removeBadge();

  /// [START] Cache directory system management for storing Face Recognition Tflite Model & maintain lost image from state restoration
  /// Bersihkan directory cache
  getTemporaryDirectory().then((value) {
    Directory dir = Directory(value.path + '/download');
    if (dir.existsSync()) {
      dir.listSync().forEach((file) {
        file.deleteSync(recursive: true);
      });
    }
  });

  /// Buat temp directory untuk open only
  getTemporaryDirectory().then((value) {
    Directory dir = Directory(value.path + '/download');
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
  });

  /// [END] Handle state restoration

  /// [START] initialRoute definition
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String initialRoute;

  if (kDebugMode) {
    log("[Bearer Token]");
    log(prefs.getString(Constant.kSetPrefToken) ?? "");
    log("[/Bearer Token]");

    log("[FCM Registration Token]");
    log(await FirebaseMessaging.instance.getToken() ?? "");
    log("[/FCM Registration Token]");
  }

  if (prefs.getString(Constant.kSetPrefToken) == null) {
    //not signed in
    initialRoute = '/';
    // initialRoute = '/splash';
  } else {
    //signed in
    initialRoute = '/';
  }

  log("INITIAL ROUTE : $initialRoute");

  /// [END] initialRoute definition
  runApp(
    //   MyApp(
    //   initialRoute: initialRoute,
    // )
    EasyLocalization(
      supportedLocales: [
        Locale('id', 'ID'),
        Locale('en'),
      ],
      path: 'assets/translations',
      // <-- change the path of the translation files
      fallbackLocale: Locale('id', 'ID'),
      child: MyApp(/*initialRoute: initialRoute*/),
    ),
    // MyApp())
  );
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

Future<bool> requestPermission(Permission permission) async {
  PermissionStatus status = await permission.request();
  return [PermissionStatus.granted, PermissionStatus.limited].contains(status);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    checkLang(context);
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<UserProvider>(
                create: (context) => UserProvider()),
            ChangeNotifierProvider<DataAddProvider>(
                create: (context) => DataAddProvider()),
            ChangeNotifierProvider<TowerProvider>(
                create: (context) => TowerProvider()),
            ChangeNotifierProvider<TurbineProvider>(
                create: (context) => TurbineProvider()),
            ChangeNotifierProvider<AuthProvider>(
                create: (context) => AuthProvider()),
            ChangeNotifierProvider<HomeProvider>(
                create: (context) => HomeProvider()),
            ChangeNotifierProvider<TransactionProvider>(
                create: (context) => TransactionProvider()),
            ChangeNotifierProvider<AssetMeterProvider>(
                create: (context) => AssetMeterProvider()),
            ChangeNotifierProvider<AssetDowntimeProvider>(
                create: (context) => AssetDowntimeProvider()),
            ChangeNotifierProvider<OperationHoursProvider>(
                create: (context) => OperationHoursProvider()),
            // ChangeNotifierProvider<ProfileProvider>(
            //     create: (context) => ProfileProvider()),
            ChangeNotifierProvider<ChangePasswordProvider>(
                create: (context) => ChangePasswordProvider()),
            ChangeNotifierProvider<WorkOrderProvider>(
                create: (context) => WorkOrderProvider()),
            ChangeNotifierProvider<WOAgreementProvider>(
                create: (context) => WOAgreementProvider()),
            ChangeNotifierProvider<WORealizationProvider>(
                create: (context) => WORealizationProvider()),
            ChangeNotifierProvider<ReportProvider>(
                create: (context) => ReportProvider()),
            ChangeNotifierProvider<AssetPerformanceProvider>(
                create: (context) => AssetPerformanceProvider()),
            ChangeNotifierProvider<BAProvider>(
                create: (context) => BAProvider()),
            // ChangeNotifierProvider<SubAgenProvider>(
            //     create: (context) => SubAgenProvider()),
            // ChangeNotifierProvider<JamaahProvider>(
            //     create: (context) => JamaahProvider()),
            // ChangeNotifierProvider<PaketProvider>(
            //     create: (context) => PaketProvider()),
            // ChangeNotifierProvider<DetailJamaahProvider>(
            //     create: (context) => DetailJamaahProvider()),
            // ChangeNotifierProvider<DetailSubAgenProvider>(
            //     create: (context) => DetailSubAgenProvider()),
            // ChangeNotifierProvider<JamaahRombonganProvider>(
            //     create: (context) => JamaahRombonganProvider()),
            ChangeNotifierProvider<RegionProvider>(
                create: (context) => RegionProvider()),
            ChangeNotifierProvider<NotifikasiProvider>(
                create: (context) => NotifikasiProvider()),
            // ChangeNotifierProvider<NotifikasiDetailProvider>(
            //     create: (context) => NotifikasiDetailProvider()),
            // ChangeNotifierProvider<KomisiProvider>(
            //     create: (context) => KomisiProvider()),
            // ChangeNotifierProvider<TarikKomisiProvider>(
            //     create: (context) => TarikKomisiProvider()),
            // ChangeNotifierProvider<RiwayatPenarikanKomisiProvider>(
            //     create: (context) => RiwayatPenarikanKomisiProvider()),
            // ChangeNotifierProvider<RiwayatTabunganProvider>(
            //     create: (context) => RiwayatTabunganProvider()),
            // ChangeNotifierProvider<DetailPenarikanKomisiProvider>(
            //     create: (context) => DetailPenarikanKomisiProvider()),
          ],
          child: MaterialApp(
            title: 'HY TUTORIAL',
            restorationScopeId: 'root',
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            navigatorObservers: [XNObsever()],
            navigatorKey: NavigationService.navigatorKey,
            theme: Constant.mainThemeData,
            color: Constant.primaryColor,
            initialRoute: '/',
            routes: _routes,
            builder: (context, child) {
              child = EasyLoading.init()(
                  context, child); // assuming this is returning a widget
              log(MediaQuery.of(context).size.toString());
              return MediaQuery(
                child: child,
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              );
            },
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}

Future checkLang(BuildContext context) async {
  try {
    final lang = Localizations.localeOf(context).languageCode;
    Intl.defaultLocale = lang;
  } catch (exception, stack) {}
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log("Handling a background message");
  log(message.data.toString());
}

Future<Response> WrapLoading<Response>(Future<Response> future) async {
  try {
    Utils.showLoading();
    Response data = await future;
    Utils.dismissLoading();
    return data;
  } catch (e, s) {
    Utils.dismissLoading();
    rethrow;
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
