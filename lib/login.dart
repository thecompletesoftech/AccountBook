import 'dart:io';

import 'package:account_book/Constant/Strings/Strings.dart';
import 'package:account_book/Constant/TextStyles/Textstyles.dart';
import 'package:account_book/Constant/navigaotors/Navagate_Next.dart';
import 'package:account_book/screens/homescreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class login extends StatefulWidget {
  const login({
    Key? key,
  }) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  var data = [];
  var fcmtoken;
  bool validation = false;

  Future openDialog() => showDialog(
        context: context,
        builder: (context) => const Padding(
          padding: EdgeInsets.all(25.0),
          child: AlertDialog(
            title: Text(
              'LOGIN Succesfully',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
      );
  Future closeDialog() => showDialog(
        context: context,
        builder: (context) => Padding(
          padding: const EdgeInsets.all(25.0),
          child: AlertDialog(
            title: Text(
              'Invalid Inputs',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
      );

  final _myFormKey = GlobalKey<FormState>();
  TextEditingController number = TextEditingController();
  TextEditingController pwd = TextEditingController();
  @override
  void initState() {
    FirebaseMessaging.instance.getToken().then((token) {
      fcmtoken = token;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        return showAlertDialog(context);
      },
      child: Scaffold(
        bottomSheet: Padding(
          padding: const EdgeInsets.all(10),
          child: GestureDetector(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();

              if (_myFormKey.currentState!.validate()) {
                _login('admin', number.text, pwd.text);
                prefs.setString("mobile_no", number.text);
                prefs.setString('password', pwd.text);
              }
            },
            child: Container(
              alignment: Alignment.center,
              color: Colors.blue,
              width: size.width,
              height: size.height * 0.05,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.login,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Login',
                      style:
                          TextStyles.withColor(TextStyles.mb14, Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.grey[200],
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            automaticallyImplyLeading: false,
              elevation: 2.0,
              backgroundColor: Colors.white,
              systemOverlayStyle: SystemUiOverlayStyle(
                // Status bar color
                statusBarColor: Colors.blue[800],

                // Status bar brightness (optional)
                statusBarIconBrightness:
                    Brightness.dark, // For Android (dark icons)
                statusBarBrightness: Brightness.light, // For iOS (dark icons)
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'image/logo.png',
                    fit: BoxFit.contain,
                    height: 45,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      ConstStr.app_name.toString(),
                      style:
                          TextStyles.withColor(TextStyles.mb18, Colors.black),
                    ),
                  ),
                ],
              )),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(children: <Widget>[
            Positioned(
              child: SingleChildScrollView(
                child: Form(
                  key: _myFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 30.0, horizontal: 20.0),
                        child: TextFormField(
                          controller: number,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Mobile number';
                            }
                            if (value.length != 10) {
                              return 'Mobile number should be of 10 digits';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: "Mobile number",
                              hintText: "Enter your mobile number",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blueAccent,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          obscureText: true,
                          controller: pwd,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Password';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: "Password",
                              hintText: "Enter your Password",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blueAccent,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              )),
                        ),
                      ),
                      SizedBox(height: 40),
                      validation == true
                          ? Container(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                "Invalid mobile no or password",
                                style: TextStyles.withColor(
                                    TextStyles.mb14, Colors.red),
                              ))
                          : Text("")
                    ],
                  ),
                ),
              ),
            ),
            // Positioned(
            //   child: Container(
            //     margin: EdgeInsets.only(bottom: 15),
            //     child: Align(
            //       alignment: Alignment.bottomCenter,
            //       child: ElevatedButton.icon(
            //           icon: Icon(Icons.login),
            //           label: Text('Login'),
            //           style: ElevatedButton.styleFrom(
            //               primary: Colors.blue[800],
            //               elevation: 6,
            //               padding: EdgeInsets.only(left: 40, right: 40)),
            //           onPressed: () async {
            //             SharedPreferences prefs =
            //                 await SharedPreferences.getInstance();

            //             if (_myFormKey.currentState!.validate()) {
            //               _login('admin', number.text, pwd.text);
            //               prefs.setString("mobile_no", number.text);
            //               prefs.setString('password', pwd.text);
            //             }
            //             // } else {
            //             //   closeDialog();
            //             // }
            //           }),
            //     ),
            //   ),
            // ),
          ]),
        ),
      ),
    );
  }

  _login(tablename, mobile_no, password) async {
    var fetchcollector = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();

    FirebaseFirestore.instance
        .collection(tablename)
        .where('mobile_no', isEqualTo: mobile_no)
        .where('password', isEqualTo: password)
        .get()
        .then((QuerySnapshot querySnapshot) {
      {
        querySnapshot.docs.forEach((element) {
          prefs.setString("login_person_id", element.id);
          setState(() {
            data.add(element.data());
          });
        });
        if (data.length > 0) {
          print("business name" + data.toString());
          fetchcollector =
              data.where((element) => element['role'] == "collector").toList();

          print(fetchcollector);

          if (fetchcollector.length > 0) {
            prefs.setString("role", "collector");
            prefs.setString("name", fetchcollector[0]['name']);
            prefs.setString("mobile_no", fetchcollector[0]['mobile_no']);
            prefs.setString(
                "p_image",
                fetchcollector[0]['p_image'] == null
                    ? " "
                    : fetchcollector[0]['p_image']);
            prefs.setString(
                "business_name", fetchcollector[0]['business_name']);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else {
            prefs.setString("business_name", data[0]['business_name']);
            prefs.setString("role", "admin");
            prefs.setString("fcmtoken_admin", fcmtoken);
            
            final users = FirebaseFirestore.instance.collection("admin");
            users
                .doc(prefs.getString("login_person_id"))
                .update({'token': fcmtoken})
                .then((value) => print("token updated"))
                .catchError((error) => print("Failed to update user: $error"));

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          }
        } else {
          setState(() {
            validation = true;
          });
        }
      }
    });

    // DatabaseReference dataf = databaseReference.child(tablename);
    // dataf
    //     .orderByChild('mobile_no')
    //     .equalTo(mobile_no)
    //     .once()
    //     .then((DataSnapshot snapshot) {
    //   var key = snapshot.key.toString();
    //   var value = snapshot.value;

    //   if (value != null) {
    //     for (var value in snapshot.value.values) {
    //       setState(() {
    //         data.add(value);
    //       });

    //     }
    //     data =
    //         data.where((element) => element['password'] == password).toList();
    //     print("admin data" + data.toString());
    //     prefs.setString("business_name", data[0]['business_name']);
    //     if (data.length > 0) {
    //       Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(builder: (context) => HomeScreen()),
    //       );
    //     } else {
    //       validation = true;
    //     }
    //   } else
    //     print("No Data");
    // });
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("yes"),
      onPressed: () {
        exit(0);
      },
    );
    Widget cancelButton = TextButton(
      child: Text("no"),
      onPressed: () {
        backScreen(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Are you sure want to exit"),
      actions: [okButton, cancelButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
