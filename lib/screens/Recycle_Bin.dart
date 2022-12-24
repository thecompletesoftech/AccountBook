import 'package:account_book/Constant/navigaotors/Navagate_Next.dart';
import 'package:account_book/screens/homescreen.dart';
import 'package:account_book/screens/morescreeen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Constant/TextStyles/Textstyles.dart';
import '../insertdatamodel.dart';

class Recycle_Bin extends StatefulWidget {
  Recycle_Bin({Key? key}) : super(key: key);

  @override
  State<Recycle_Bin> createState() => _Recycle_BinState();
}

class _Recycle_BinState extends State<Recycle_Bin> {
  List data = [];
  List Idlist = [];
  @override
  void initState() {
    get_recent_deleted_customer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          "Recycle Bin",
          style: TextStyles.mb18,
        )
      ])),
      body: Column(
        children: [
          data.length == 0
              ? Container(
                  padding: EdgeInsets.all(20),
                  child: Center(
                      child: Text(
                    "No Data found",
                    style: TextStyles.mb14,
                  )),
                )
              : SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    height: size.height * 0.9,
                    child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          var fname = data[index][1]['name'].split('');

                          return Dismissible(
                            background: Container(
                                padding: EdgeInsets.only(left: 10),
                                alignment: Alignment.centerLeft,
                                color: Colors.red,
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                )),
                            key: UniqueKey(),
                            onDismissed: (DismissDirection direction) {
                              if (direction == DismissDirection.endToStart) {
                                Provider.of<Insetdatamodel>(context,
                                        listen: false)
                                    .deleterecord(data[index][0]);
                                Provider.of<Insetdatamodel>(context,
                                        listen: false)
                                    .upadtedeltestatus_entry(
                                        data[index][0], "0", "Entry");
                                Provider.of<Insetdatamodel>(context,
                                        listen: false)
                                    .upadtedeltestatus(
                                        data[index][0], '0', 'customer_record');
                              } else {
                                setState(() {
                                  // _callNumber(
                                  //     data[index]['mobile_no'].toString());
                                  // _launchPhoneURL(
                                  //     data[index]['mobile_no'].toString());
                                });
                              }
                            },
                            child: GestureDetector(
                              onTap: () async {
                                // _callNumber(
                                //     data[index]['mobile_no'].toString());
                                // _launchPhoneURL(
                                //     data[index]['mobile_no'].toString());

                                // final fullContact =
                                //     await FlutterContacts.getContact(
                                //         data[index]['contact_id']);
                                // nextScreen(
                                //     context,
                                //     customertransaction(
                                //       iscustomer: '1',
                                //     ));
                              },
                              child: Container(
                                child: Card(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child: ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            leading: CircleAvatar(
                                              backgroundColor: Colors.blueGrey,
                                              child: Text(
                                                fname[0].toString(),
                                                style: TextStyles.mb18,
                                              ),
                                              radius: 30,
                                            ),
                                            // trailing: Text(
                                            //   '\u{20B9} ' + data[index]['amount'],
                                            //   style: TextStyle(
                                            //       color: Colors.black, fontSize: 15),
                                            // ),
                                            subtitle: Text(
                                              data[index][1]['date'].toString(),
                                              style: TextStyles.mb12,
                                            ),
                                            title: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: Text(
                                                data[index][1]['name']
                                                    .toString(),
                                                style: TextStyles.mb14,
                                              ),
                                            )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Provider.of<Insetdatamodel>(
                                                        context,
                                                        listen: false)
                                                    .upadtedeltestatus_entry(
                                                        data[index][0],
                                                        "0",
                                                        "Entry");
                                                Provider.of<Insetdatamodel>(
                                                        context,
                                                        listen: false)
                                                    .upadtedeltestatus(
                                                        data[index][0],
                                                        '0',
                                                        'customer_record');
                                                nextScreen(
                                                    context, MoreScreen());
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Undo",
                                                      style: TextStyles.mb14,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .replay_circle_filled,
                                                      color: Colors.blue,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                showAlertDialog(
                                                    context,
                                                    data[index][1]['name'],
                                                    data[index][0]);
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Delete",
                                                      style: TextStyles.mb14,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context, name, id) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("yes"),
      onPressed: () {
        Provider.of<Insetdatamodel>(context, listen: false).deleterecord(id);
        get_recent_deleted_customer();
        backScreen(context);

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
      title: Text("Are you sure want to delete $name "),
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

  get_recent_deleted_customer() async {
    FirebaseFirestore.instance
        .collection('customer_record')
        .where('deleted', isEqualTo: "1")
        .get()
        .then((QueryDocumentSnapshot) {
      for (var queryDocumentSnapshot in QueryDocumentSnapshot.docs) {
        Idlist.add(queryDocumentSnapshot.id);

        Map<String, dynamic> fetchdata = queryDocumentSnapshot.data();

        setState(() {
          data.add([queryDocumentSnapshot.id, fetchdata]);
        });
      }
    });
  }
}
