import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:account_book/Constant/navigaotors/Navagate_Next.dart';
import 'package:account_book/screens/customertransactions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiffy/jiffy.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import '../Constant/TextStyles/Textstyles.dart';
import '../insertdatamodel.dart';
import '../widget/BottomBar.dart';
import 'ViewReport.dart';

class CustomerScreen extends StatefulWidget {
  final searchtxt;

  CustomerScreen({Key? key, this.searchtxt}) : super(key: key);
  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  var customerlistdata = [];
  var entry_data = [];
  var dataenty = [];
  List idlist = [];
  TextEditingController customer = TextEditingController();

  bool isAuthenticated = false;

  bool showloading = false;

  List dataonly = [];

  String? role;

  @override
  void initState() {
    getrole();
    Provider.of<Insetdatamodel>(context, listen: false).gettotal_amount_gave();
    Provider.of<Insetdatamodel>(context, listen: false).gettotal_amount_got();
    // _get_customer_record('customer_record');
    // _get_entry_record('Entry');
    _getEventsFromFirestore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => _getEventsFromFirestore(),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            // shrinkWrap: true,
            children: [
              role == "collector"
                  ? Container()
                  : Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                          '\u{20B9} ' +
                                              Provider.of<Insetdatamodel>(
                                                      context)
                                                  .t_amout_gave
                                                  .toString(),
                                          style: TextStyles.withColor(
                                              TextStyles.mb20, Colors.red)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text("you  Gave",
                                          style: TextStyles.withColor(
                                              TextStyles.mn14, Colors.red))
                                    ],
                                  ),
                                  VerticalDivider(
                                    width: 5,
                                    color: Colors.black,
                                    thickness: 2,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                          '\u{20B9} ' +
                                              Provider.of<Insetdatamodel>(
                                                      context)
                                                  .t_amout_got
                                                  .toString(),
                                          style: TextStyles.withColor(
                                              TextStyles.mb20, Colors.green)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text("you  Got",
                                          style: TextStyles.withColor(
                                              TextStyles.mn14, Colors.green))
                                    ],
                                  ),
                                ],
                              ),
                              Divider(),
                              GestureDetector(
                                onTap: () {
                                  nextScreen(context, ViewReport());
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("View Report",
                                          style: TextStyles.withColor(
                                              TextStyles.mb14, Colors.black)),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      size: 15,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // padding: EdgeInsets.only(left: 10, top: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: TextField(
                        // textAlign: TextAlign.center,
                        onChanged: (text) {
                          _runFilter(text);
                        },
                        controller: customer,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.search,
                              size: 30,
                            ),
                            hintText: 'search customer',
                            hintStyle: TextStyles.mb14),
                      ),
                    ),
                    Divider(),
                    if (showloading == true)
                      Center(child: CircularProgressIndicator()),
                    if (customerlistdata.length == 0 && showloading == false)
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Center(
                            child: Text(
                          "NO DATA FOUND",
                          style: TextStyles.mb14,
                        )),
                      ),
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: customerlistdata.length,
                        itemBuilder: (BuildContext context, int index) {
                          var fname = customerlistdata[index]['name'].split('');
                          return GestureDetector(
                            onTap: () async {
                              // final fullContact =
                              //     await FlutterContacts.getContact(
                              //         data[index]['contact_id']);
                              GetStorage().write("searchtxt", customer.text);
                              nextScreen(
                                  context,
                                  Customertransaction(
                                      name: customerlistdata[index]['name'],
                                      iscustomer: "1",
                                      id: customerlistdata[index]['id'].toString(),
                                      // idlist[index].toString(),
                                      mobile_no: customerlistdata[index]['mobile_no'],
                                      contact: null,
                                      p_image: customerlistdata[index]['p_image'],
                                      address: customerlistdata[index]['address'],
                                      token: customerlistdata[index]['token'],
                                      searchtxt: customer.text));
                            },
                            child: Container(
                              child: Card(
                                child: Dismissible(
                                  background: Container(
                                      alignment: Alignment.centerLeft,
                                      color: Colors.green,
                                      child: Icon(
                                        Icons.call,
                                        color: Colors.white,
                                      )),
                                  // secondaryBackground: Container(
                                  //   padding: EdgeInsets.only(right: 10),
                                  //   color: Colors.red,
                                  //   alignment: Alignment.centerRight,
                                  //   child: Icon(
                                  //     Icons.delete,
                                  //     color: Colors.white,
                                  //   ),
                                  // ),
                                  key: UniqueKey(),
                                  onDismissed: (DismissDirection direction) {
                                    if (direction ==
                                        DismissDirection.endToStart) {
                                      // Provider.of<Insetdatamodel>(
                                      //         context,
                                      //         listen: false)
                                      //     .upadtedeltestatus(
                                      //         idlist[index].toString(),
                                      //         "1",
                                      //         "customer_record");

                                      // Provider.of<Insetdatamodel>(
                                      //         context,
                                      //         listen: false)
                                      //     .upadtedeltestatus_entry(
                                      //         idlist[index].toString(),
                                      //         "1",
                                      //         "Entry");

                                      // data.removeAt(index);
                                    } else {
                                      setState(() {
                                        _callNumber(customerlistdata[index]['mobile_no']
                                            .toString());
                                        // _launchPhoneURL(
                                        //     data[index]['mobile_no'].toString());
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.blueGrey,
                                          child: customerlistdata[index]['p_image'] == " "
                                              ? Text(
                                                  fname[0].toString(),
                                                  style: TextStyles.mb18,
                                                )
                                              : Container(
                                                  width: 55,
                                                  height: 100,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    child: CachedNetworkImage(
                                                      imageUrl: customerlistdata[index]
                                                          ['p_image'],
                                                      placeholder: (context,
                                                              url) =>
                                                          CircularProgressIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.blueGrey,
                                                      ),
                                                      // image:
                                                      //     DecorationImage(
                                                      //   fit: BoxFit.fill,
                                                      //   image: NetworkImage(
                                                      //     data[index]
                                                      //         ['p_image'],
                                                      //   ),
                                                      // ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  100))),
                                                ),
                                          radius: 30,
                                        ),
                                        // trailing: Text(
                                        //   '\u{20B9} ' + data[index]['amount'],
                                        //   style: TextStyle(
                                        //       color: Colors.black, fontSize: 15),
                                        // ),
                                        subtitle: Text(
                                          Jiffy(customerlistdata[index]['last_updated_date']
                                                  .toString())
                                              .fromNow()
                                              .toString(),
                                          style: TextStyles.mb12,
                                        ),
                                        title: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: Text(
                                            customerlistdata[index]['name'].toString(),
                                            style: TextStyles.mb14,
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                    SizedBox(height: 40)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // get_data() {
  //   FirebaseFirestore.instance
  //       .collection('customer_record')
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     querySnapshot.docs.forEach((doc) {
  //       setState(() {
  //         data = json.decode(doc.data().toString());
  //         print("fetch data" + data.toString());
  //       });
  //     });
  //   });
  // }

  _getEventsFromFirestore() async {
    customerlistdata.clear();
    idlist.clear();
    Provider.of<Insetdatamodel>(context, listen: false).gettotal_amount_gave();
    Provider.of<Insetdatamodel>(context, listen: false).gettotal_amount_got();
    setState(() {
      showloading = true;
    });

    FirebaseFirestore.instance
        .collection('customer_record')
        .orderBy('last_updated_date', descending: true)
        .where('deleted', isEqualTo: '0')
        .get()
        .then((QueryDocumentSnapshot) {
      for (var queryDocumentSnapshot in QueryDocumentSnapshot.docs) {
        print("id=" + queryDocumentSnapshot.id);
        idlist.add(queryDocumentSnapshot.id);
        print("idlkist" + idlist.toString());
        Map<String, dynamic> fetchdata = queryDocumentSnapshot.data();
        setState(() {
          customerlistdata.add(fetchdata);
        });

        // setState(() {
        //   customer.text = widget.searchtxt;
        // });

        // _runFilter(customer.text);

        // setState(() {
        //   data.add([queryDocumentSnapshot.id, fetchdata]);
        // });
        // print("filterdata" + datafilter.toString());
      }
      setState(() {
        showloading = false;
      });
      if (GetStorage().read("searchtxt") != null) {
        setdata();
      }

      // setState(() {
      //   data = data.where((element) => element['deleted'] == "0").toList();

      // });

      // print("data fetch" + customerlistdata.toString());
    });
    // for (var i = 0; i <= tmplist.length; i++) {
    //   setState(() {
    //     data.add(tmplist[i][1]);
    //   });
    // }
  }

  // _get_customer_record(tablename) async {
  //   DatabaseReference dataf = databaseReference.child(tablename);
  //   dataf
  //       .orderByChild('deleted')
  //       .equalTo('0')
  //       .once()
  //       .then((DataSnapshot snapshot) {
  //     var key = snapshot.key.toString();
  //     var value = snapshot.value;
  //     if (value != null) {
  //       showloading = true;
  //       for (var value in snapshot.value.values) {
  //         setState(() {
  //           data.add(value);
  //         });
  //       }
  //     } else
  //       print("No Data");
  //   });
  // }
  // _get_entry_record(tablename) async {
  //   DatabaseReference dataf = databaseReference.child(tablename);
  //   dataf.once().then((DataSnapshot snapshot) {
  //     var key = snapshot.key.toString();
  //     var value = snapshot.value;
  //     if (value != null) {
  //       for (var value in snapshot.value.keys) {
  //         setState(() {
  //           entry_data.add(value);
  //         });
  //       }
  //       print(" entry key data" + entry_data.toString());
  //     } else
  //       print("No Data");
  //   });
  // }

  void _runFilter(String enteredKeyword) {
    var results = [];

    if (enteredKeyword.isEmpty) {
      _getEventsFromFirestore();
      GetStorage().erase();
      // if the search field is empty or only contains white-space, we'll display all users
    } else {
      results = customerlistdata
          .where((user) =>
              user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }
    setState(() {
      customerlistdata = results;
    });
  }

  _callNumber(String phoneNumber) async {
    String number = phoneNumber;
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  _showPopupMenu() {
    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(400, 300, 500,
          0), //position where you want to show the menu on screen
      items: [
        PopupMenuItem<String>(child: const Text('A to z'), value: '1'),
        PopupMenuItem<String>(child: const Text('Z to A'), value: '2'),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value == '1') {
        setState(() {
          customerlistdata.sort();
        });
      } else {
        setState(() {
          customerlistdata.reversed;
        });
      }
    });
  }

  //contact permission
  // _contactsPermissions() async {
  //   PermissionStatus permission = await Permission.contacts.status;
  //   if (permission != PermissionStatus.granted &&
  //       permission != PermissionStatus.denied) {
  //     Map<Permission, PermissionStatus> permissionStatus =
  //         await [Permission.contacts].request();
  //     return permissionStatus[Permission.contacts] ??
  //         PermissionStatus.undetermined;
  //   } else {
  //     return permission;
  //   }
  // }

  getrole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getString('role')!;
    });
  }

  setdata() {
    customer.text = GetStorage().read("searchtxt");
    _runFilter(customer.text);
  }
}
