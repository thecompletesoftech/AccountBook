import 'dart:async';
import 'dart:developer';
import 'package:account_book/Constant/navigaotors/Navagate_Next.dart';
import 'package:account_book/screens/customertransactions.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constant/TextStyles/Textstyles.dart';
import '../insertdatamodel.dart';
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
  TextEditingController serachtext = TextEditingController();
  bool isAuthenticated = false;
  bool showloading = false;
  List dataonly = [];
  String? role;

  @override
  void initState() {
    getrole();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    FutureBuilder<double>(
                                      future: Provider.of<Insetdatamodel>(
                                              context)
                                          .netamount(), // function where you call your api
                                      builder: (BuildContext context,
                                          AsyncSnapshot<double> snapshot) {
                                        // AsyncSnapshot<Your object type>
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                              child: Text(
                                                  '\u{20B9} ' +
                                                      "0.0".toString(),
                                                  style: TextStyles.withColor(
                                                      TextStyles.mb20,
                                                      Colors.red)));
                                        } else {
                                          if (snapshot.hasError)
                                            return Center(
                                                child: Text(
                                                    'Error: ${snapshot.error}'));
                                          else
                                            return Text(
                                                '\u{20B9} ' +
                                                    snapshot.data.toString(),
                                                style: TextStyles.withColor(
                                                    TextStyles.mb20,
                                                    Colors
                                                        .red)); // snapshot.data  :- get your object which is pass from your downloadData() function
                                        }
                                      },
                                    ),
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
                                    FutureBuilder<double>(
                                      future:
                                          Provider.of<Insetdatamodel>(context)
                                              .gettotal_amount_got(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<double> snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                              child: Text('\u{20B9}' + "0.0",
                                                  style: TextStyles.withColor(
                                                      TextStyles.mb20,
                                                      Colors.green)));
                                        } else {
                                          if (snapshot.hasError)
                                            return Center(
                                                child: Text(
                                                    'Error: ${snapshot.error}'));
                                          else
                                            return Text(
                                                '\u{20B9}' +
                                                    snapshot.data.toString(),
                                                style: TextStyles.withColor(
                                                    TextStyles.mb20,
                                                    Colors.green));
                                        }
                                      },
                                    ),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: TextField(
                      // textAlign: TextAlign.center,
                      onChanged: (value) async {
                        await searchedcustomertest(value);
                      },
                      controller: serachtext,
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
                ),
                serachtext.text.length > 0
                    ? ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: seachresult.length,
                        itemBuilder: (BuildContext context, int index) {
                          var fname = seachresult[index]['name'].split('');
                          return GestureDetector(
                            onTap: () async {
                              GetStorage().write("searchtxt", serachtext.text);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Customertransaction(
                                          name: seachresult[index]['name'],
                                          iscustomer: "1",
                                          id: seachresult[index]['id']
                                              .toString(),
                                          // idlist[index].toString(),
                                          mobile_no: seachresult[index]
                                              ['mobile_no'],
                                          contact: null,
                                          p_image: seachresult[index]
                                              ['p_image'],
                                          address: seachresult[index]
                                              ['address'],
                                          token: seachresult[index]['token'],
                                          searchtxt: serachtext.text)));
                            },
                            child: Column(
                              children: [
                                Dismissible(
                                  background: Container(
                                      alignment: Alignment.centerLeft,
                                      color: Colors.green,
                                      child: Icon(
                                        Icons.call,
                                        color: Colors.white,
                                      )),
                                  key: UniqueKey(),
                                  onDismissed: (DismissDirection direction) {
                                    if (direction ==
                                        DismissDirection.endToStart) {
                                    } else {
                                      setState(() {
                                        _callNumber(seachresult[index]
                                                ['mobile_no']
                                            .toString());
                                      });
                                    }
                                  },
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.blueGrey,
                                      child: seachresult[index]['p_image'] ==
                                              " "
                                          ? Text(
                                              fname[0].toString(),
                                              style: TextStyles.mb18,
                                            )
                                          : Container(
                                              width: 55,
                                              height: 100,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: CachedNetworkImage(
                                                  imageUrl: seachresult[index]
                                                      ['p_image'],
                                                  placeholder: (context, url) =>
                                                      CircularProgressIndicator(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.blueGrey,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              100))),
                                            ),
                                      radius: 30,
                                    ),
                                    trailing: Column(
                                      children: [
                                        Text(
                                          seachresult[index]['youllgetamount']
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                        ).paddingOnly(bottom: 5),
                                        Text(
                                          "you'll Get",
                                          style: TextStyles.withColor(
                                              TextStyles.mn14, Colors.red),
                                        ),
                                      ],
                                    ),
                                    subtitle: Text(
                                      Jiffy(seachresult[index]
                                                  ['last_updated_date']
                                              .toString())
                                          .fromNow()
                                          .toString(),
                                      style: TextStyles.mb12,
                                    ),
                                    title: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        seachresult[index]['name'].toString(),
                                        style: TextStyles.mb14,
                                      ),
                                    ),
                                  ),
                                ).paddingSymmetric(horizontal: 15),
                                SizedBox(height: 0.2, child: Divider())
                              ],
                            ),
                          );
                        })
                    : StreamBuilder<QuerySnapshot>(
                        stream: getcustomerdata(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final List<DocumentSnapshot> documents =
                                snapshot.data!.docs;
                            print("length" + documents.length.toString());
                            return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: documents.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var fname =
                                      documents[index]['name'].split('');

                                  // DateTime dateTime = documents[index] == 2
                                  //     ? DateTime.fromMillisecondsSinceEpoch(
                                  //         documents[index]['last_updated_date']
                                  //                     .seconds *
                                  //                 1000 +
                                  //             documents[index]
                                  //                         ['last_updated_date']
                                  //                     .nanoseconds ~/
                                  //                 1000000)
                                  //     : DateTime.parse(documents[index]
                                  //         ['last_updated_date']);
                                  // String formattedDate =
                                  //     DateFormat('yyyy-MM-dd HH:mm:ss')
                                  //         .format(dateTime);
                                  log("Dateee" +
                                      documents[index]['last_updated_date']
                                          .toString());
                                  return GestureDetector(
                                    onTap: () async {
                                      GetStorage()
                                          .write("searchtxt", serachtext.text);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Customertransaction(
                                                      name: documents[index]
                                                          ['name'],
                                                      iscustomer: "1",
                                                      id: documents[index]['id']
                                                          .toString(),
                                                      // idlist[index].toString(),
                                                      mobile_no:
                                                          documents[index]
                                                              ['mobile_no'],
                                                      contact: null,
                                                      p_image: documents[index]
                                                          ['p_image'],
                                                      address: documents[index]
                                                          ['address'],
                                                      token: documents[index]
                                                          ['token'],
                                                      searchtxt:
                                                          serachtext.text)));
                                    },
                                    child: Column(
                                      children: [
                                        Dismissible(
                                          background: Container(
                                              alignment: Alignment.centerLeft,
                                              color: Colors.green,
                                              child: Icon(
                                                Icons.call,
                                                color: Colors.white,
                                              )),
                                          key: UniqueKey(),
                                          onDismissed:
                                              (DismissDirection direction) {
                                            if (direction ==
                                                DismissDirection.endToStart) {
                                            } else {
                                              setState(() {
                                                _callNumber(documents[index]
                                                        ['mobile_no']
                                                    .toString());
                                              });
                                            }
                                          },
                                          child: ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            leading: CircleAvatar(
                                              backgroundColor: Colors.blueGrey,
                                              child: documents[index]
                                                          ['p_image'] ==
                                                      " "
                                                  ? Text(
                                                      fname[0].toString(),
                                                      style: TextStyles.mb18,
                                                    )
                                                  : Container(
                                                      width: 55,
                                                      height: 100,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: documents[
                                                                      index]
                                                                  ['p_image']
                                                              .toString(),
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
                                                            color:
                                                                Colors.blueGrey,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          100))),
                                                    ),
                                              radius: 30,
                                            ),
                                            trailing: Column(
                                              children: [
                                                Text(
                                                  documents[index]
                                                          ['youllgetamount']
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15),
                                                ).paddingOnly(bottom: 5),
                                                Text(
                                                  "you'll Get",
                                                  style: TextStyles.withColor(
                                                      TextStyles.mn14,
                                                      Colors.red),
                                                ),
                                              ],
                                            ),
                                            subtitle: Text(
                                              // '',
                                              Jiffy(documents[index]
                                                          ['last_updated_date']
                                                      .toString())
                                                  .fromNow()
                                                  .toString(),
                                              style: TextStyles.mb12,
                                            ),
                                            title: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: Text(
                                                documents[index]['name']
                                                    .toString(),
                                                style: TextStyles.mb14,
                                              ),
                                            ),
                                          ),
                                        ).paddingSymmetric(horizontal: 15),
                                        SizedBox(height: 0.2, child: Divider())
                                      ],
                                    ),
                                  );
                                });
                          } else if (snapshot.hasError) {
                            return Center(child: Text("NO USER FOUND !"));
                          } else {
                            return Center(child: Text("NO USER FOUND !"));
                          }
                        }),
                SizedBox(height: 40)
              ],
            )
          ],
        ),
      ),
    );
  }

  _callNumber(String phoneNumber) async {
    String number = phoneNumber;
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  getrole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getString('role')!;
    });
  }

  Stream<QuerySnapshot> getcustomerdata() {
    return FirebaseFirestore.instance
        .collection('customer_record')
        .orderBy('last_updated_date', descending: true)
        .where('deleted', isEqualTo: '0')
        .snapshots();
  }

  var seachresult = [];
  searchedcustomertest(searchtext) async {
    var serachlist = [];

    await FirebaseFirestore.instance
        .collection('customer_record')
        .orderBy('last_updated_date', descending: true)
        .where('deleted', isEqualTo: '0')
        .get()
        .then((QueryDocumentSnapshot) {
      for (var value in QueryDocumentSnapshot.docs) {
        Map<String, dynamic> fetchdata = value.data();
        serachlist.add(fetchdata);
      }
    });
    setState(() {
      seachresult = serachlist
          .where((user) =>
              user["name"].toLowerCase().contains(searchtext.toLowerCase()))
          .toList();
    });
    print("result data" + seachresult.length.toString());
    return seachresult;
  }
}
