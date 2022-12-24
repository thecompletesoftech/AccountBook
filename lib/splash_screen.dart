import 'package:account_book/Constant/Strings/Strings.dart';
import 'package:account_book/Constant/TextStyles/Textstyles.dart';
import 'package:account_book/Constant/navigaotors/Navagate_Next.dart';
import 'package:account_book/login.dart';
import 'package:account_book/screens/LockScreen.dart';
import 'package:account_book/screens/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class splash extends StatefulWidget {
  splash({Key? key}) : super(key: key);

  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  bool _hasFingerPrintSupport = false;
  var bio;
  var pin;
  @override
  void initState() {
    super.initState();
    getpin();
    getsetbiometric();
    // _getBiometricsSupport();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
    Future.delayed(const Duration(milliseconds: 500), () {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 150,
              ),
              Padding(
                padding: const EdgeInsets.all(80.0),
                child: Image(image: AssetImage('image/logo.png')),
              ),
              Text(ConstStr.app_name,
                  style: TextStyles.withColor(TextStyles.mb20, Colors.white))
            ],
          ),
          // nextScreen: login(),
        ),
      ),
    );
  }

  checkloginornot() async {
    var data;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    data = prefs.getString("mobile_no");
    if (data == null) {
      nextScreen(context, HomeScreen());
      nextScreen(context, login());
    } else {
      nextScreen(context, HomeScreen());
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });

      return;
    }
    if (authenticated == true) {
      checkloginornot();
    }

    if (!mounted) {
      return;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
  }

  Future<void> _getBiometricsSupport() async {
    // 6. this method checks whether your device has biometric support or not
    bool hasFingerPrintSupport = false;
    try {
      hasFingerPrintSupport = await auth.canCheckBiometrics;
    } catch (e) {
      print(e);
    }
    if (!mounted) return;
    if (hasFingerPrintSupport == true) {
      if (bio == true) {
        _authenticateWithBiometrics();
      } else {
        Future.delayed(const Duration(milliseconds: 500), () {
          checkloginornot();
        });
      }
    } else {
      Future.delayed(const Duration(milliseconds: 500), () {
        checkloginornot();
      });
      print("not Supported");
    }
    setState(() {
      _hasFingerPrintSupport = hasFingerPrintSupport;
    });
  }

  getsetbiometric() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bio = prefs.getBool('setbiometric');
    print(bio);
  }

  getpin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    pin = prefs.getBool('setpin');
    print("pin" + pin.toString());

    if (pin == true) {
      print("pin false");
      nextScreen(context, LockScreen());
    } else {
      print("print trye");
      _getBiometricsSupport();
    }
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
