import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:pie/pages/history.dart';
import 'package:pie/resources/style_constants.dart';
import 'package:pie/pages/payment.dart';
import 'package:pie/pages/ticket.dart';
import 'package:pie/services/load.dart';
import 'package:pie/pages/home.dart';
import 'package:pie/pages/sign_in.dart';
import 'package:pie/pages/sign_up.dart';
import 'package:pie/pages/qr_scan.dart';
import 'package:pie/services/network_check.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pie/resources/network_error_widget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const RunApp());
}

class RunApp extends StatefulWidget {
  const RunApp({super.key});

  @override
  State<RunApp> createState() => _RunAppState();
}

class _RunAppState extends State<RunApp> {

  @override
  void initState() {
    OverlaySupportEntry? entry;
    DataConnectivityService()
        .connectivityStreamController
        .stream
        .listen((event) {
      if (event == InternetStatus.disconnected) {
        entry = showOverlayNotification((context) {
          return NetworkErrorAnimation();
        }, duration: Duration(hours: 1));
      } else {
        if (entry != null) {
          entry?.dismiss();
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        home: Load(),
        routes: {
          '/home': (context) => HomePage(),
          '/sign_in': (context) => SignInPage(),
          '/sign_up': (context) => SignUpPage(),
          '/qr_scan': (context) => QrScanPage(),
          '/ticket': (context) => TicketPage(),
          '/payment': (context) => PaymentPage(),
          '/history': (context) => HistoryPage(),
        },
        theme: ThemeData(
            fontFamily: "Poppins",
            textTheme: TextTheme(
              headlineLarge: TextStyle(color: kPieNavy),
              headlineMedium: TextStyle(color: kPieNavy),
              headlineSmall: TextStyle(color: kPieNavy),
              titleLarge: TextStyle(color: kPieNavy),
              titleMedium: TextStyle(color: kPieNavy),
              titleSmall: TextStyle(color: kPieNavy),
              bodyLarge: TextStyle(color: kPieNavy),
              bodyMedium: TextStyle(color: kPieNavy),
              bodySmall: TextStyle(color: kPieNavy),
            )
        ),
      ),
    );
  }
}