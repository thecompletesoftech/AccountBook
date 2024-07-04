import 'package:account_book/Constant/TextStyles/Textstyles.dart';
import 'package:account_book/Constant/navigaotors/Navagate_Next.dart';
import 'package:account_book/screens/LockScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplockEnable extends StatefulWidget {
  ApplockEnable({Key? key}) : super(key: key);

  @override
  State<ApplockEnable> createState() => _ApplockEnableState();
}

class _ApplockEnableState extends State<ApplockEnable> {
  bool status = false;
  bool statuspin = false;
  TextEditingController spin = TextEditingController();
  TextEditingController cpin = TextEditingController();
  var bio;
  var pin;

  @override
  void initState() {
    getsetbiometric();
    getpin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('App lock'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       "Set App Lock Biometric",
            //       style: TextStyles.mb14,
            //     ),
            //     Container(
            //       child: FlutterSwitch(
            //         width: 60,
            //         height: 30,
            //         valueFontSize: 25.0,
            //         toggleSize: 20,
            //         value: status,
            //         borderRadius: 30.0,
            //         padding: 8.0,
            //         showOnOff: false,
            //         onToggle: (val) {
            //           setState(() {
            //             status = val;
            //             setbiometric(val);
            //           });
            //         },
            //       ),
            //     ),
            //   ],
            // ),
            SizedBox(height: 15),
            GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Set App Lock Pin",
                    style: TextStyles.mb14,
                  ),
                  Container(
                    child: FlutterSwitch(
                      width: 60,
                      height: 30,
                      valueFontSize: 25.0,
                      toggleSize: 20,
                      value: statuspin,
                      borderRadius: 30.0,
                      padding: 8.0,
                      showOnOff: false,
                      onToggle: (val) {
                        setState(() {
                          statuspin = val;
                          setpin(statuspin);
                        });
                        if (val) {
                          showDialog(
                            barrierDismissible: false,
                              context: context,
                              builder: (_) => AlertDialog(
                                    title: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        children: [
                                          TextField(
                                            maxLength: 4,
                                            keyboardType: TextInputType.number,
                                            controller: spin,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: 'set pin',
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextField(
                                            maxLength: 4,
                                            keyboardType: TextInputType.number,
                                            controller: cpin,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: 'confitm pin',
                                            ),
                                          ),
                                          ElevatedButton(
                                            child: Text('save'),
                                            onPressed: () async {
                                              if (spin.text.length ==
                                                  cpin.text.length) {
                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                prefs.setString(
                                                    "savepin", spin.text);
                                                statuspin = true;
                                                setpin(true);
                                                backScreen(context);
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.purple,
                                                textStyle: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )).then((value) {
                            // setState(() {
                            //   statuspin = false;
                            //   setpin(false);
                            // });
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  setbiometric(s) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('setbiometric', s);
  }

  setpin(s) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('setpin', s);
  }

  getsetbiometric() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bio = prefs.getBool('setbiometric');
    print(bio);
    if (bio == true) {
      setState(() {
        status = true;
      });
    }
  }

  getpin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    pin = prefs.getBool('setpin');
    print(bio);
    if (pin == true) {
      setState(() {
        statuspin = true;
      });
    }
  }
}
