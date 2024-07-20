import 'dart:developer';
import 'dart:io';
import 'package:account_book/Constant/Colors/Colors.dart';
import 'package:account_book/Constant/Strings/Strings.dart';
import 'package:account_book/Constant/TextStyles/Textstyles.dart';
import 'package:account_book/Constant/navigaotors/Navagate_Next.dart';
import 'package:account_book/login.dart';
import 'package:account_book/screens/contactListScreen.dart';
import 'package:account_book/widget/BottomBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../insertdatamodel.dart';
import '../widget/Collector_Bottom_Bar.dart';
import 'CustomerScreen.dart';

class HomeScreen extends StatefulWidget {
  final searchtxt;
  HomeScreen({
    Key? key,
    this.searchtxt,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

@override
class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  TextEditingController business = TextEditingController();
  final databaseReference = FirebaseDatabase.instance.reference();
  List data = [];
  List iddata = [];
  String business_name = 'JD Finance';
  String? role;

  // TabController? _controller;

  void initState() {
    // getbusiness_name();
    getrole();
    // get_customer_record("customer_record");
    // _controller = TabController(length: 2, vsync: this);
    // _controller!.addListener(() {
    //   setState(() {
    //     _selectedIndex = _controller!.index;
    //   });
    //   print("Selected Index: " + _controller!.index.toString());
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        return showAlertDialog(context);
      },
      child: SafeArea(
        child: Scaffold(
            appBar: PreferredSize(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {},
                      splashColor: Colors.black,
                      child: InkWell(
                          onTap: () {
                            // _business_bottomsheet();
                          },
                          child: Container(
                              height: size.height * 0.07,
                              padding: EdgeInsets.only(left: 10, right: 10),
                              color: MyColors.primarycolor,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        'image/logo.png',
                                        height: 35,
                                        width: 35,
                                      ),
                                      SizedBox(
                                        width: 13,
                                      ),
                                      Text(business_name,
                                          style: TextStyles.withColor(
                                              TextStyles.mb16, Colors.white)),
                                      SizedBox(
                                        width: 14,
                                      ),
                                      // Icon(
                                      //   Icons.edit,
                                      //   size: 20,
                                      //   color: Colors.white,
                                      // ),
                                    ],
                                  ),
                                ],
                              ))),
                    ),
                  ],
                ),
                preferredSize: Size.fromHeight(80)),
            body: CustomerScreen(searchtxt: widget.searchtxt),
            bottomNavigationBar: role == "collector"
                ? Collector_Bottom_Bar(
                    index: 0,
                  )
                : BottomBar(
                    index: 0,
                  ),
            floatingActionButton: role == "collector"
                ? Container()
                : FloatingActionButton(
                    onPressed: () {
                      nextScreen(context, ContactListScreen());
                    },
                    child: Icon(Icons.person_add_alt_rounded),
                    backgroundColor: Colors.pink,
                    // label: Text(""),
                    // icon: const
                    // backgroundColor: Colors.pink,
                  )),
      ),
    );
  }

  // get_customer_record(tablename) async {

  //   DatabaseReference dataf = databaseReference.child(tablename);

  //   dataf.once().then((DataSnapshot snapshot) {
  //     var key = snapshot.key.toString();
  //     var value = snapshot.value;

  //     if (value != null) {
  //       for (var value in snapshot.value.values) {
  //         setState(() {
  //           data.add(value);
  //         });
  //       }
  //       for (int i = 0; i <= data.length; i++) {
  //         setState(() {
  //           iddata.add(data[i]['contact_id']);
  //         });
  //       }
  //     } else
  //       print("No Data");
  //   });
  // }

  _business_bottomsheet() {
    var size = MediaQuery.of(context).size;
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: size.height * 0.38,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text(
                  "Business name",
                  style: TextStyles.mb16,
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.only(left: 10, top: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  width: size.width,
                  child: TextField(
                    onChanged: (text) {},
                    controller: business,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter business name',
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Center(
                  child: ElevatedButton(
                    child: Text(' Save '),
                    onPressed: () async {
                      var id;
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      id = prefs.getString("admin_id");
                      final users =
                          FirebaseFirestore.instance.collection("admin");
                      users
                          .doc(id)
                          .update({'business_name': business.text})
                          .then((value) => print("business name updated"))
                          .catchError((error) =>
                              print("Failed to update user: $error"));
                      setState(() {
                        business_name =
                            Provider.of<Insetdatamodel>(context, listen: false)
                                .setusinessname(business.text);
                        backScreen(context);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: MyColors.primarycolor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      textStyle: TextStyles.mb14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // getbusiness_name() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     business_name = prefs.getString('business_name')!;
  //   });
  // }

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

  getrole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    log("Roe===> " + prefs.getString('role').toString());
    setState(() {
      role = prefs.getString('role')!;
    });
    log("Role===> " + role.toString());
  }

  // getbusiness_name() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     business_name = prefs.getString('business_name')!;
  //   });
  // }
}
