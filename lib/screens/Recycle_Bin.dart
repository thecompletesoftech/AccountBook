import 'package:account_book/Constant/navigaotors/Navagate_Next.dart';
import 'package:account_book/screens/homescreen.dart';
import 'package:account_book/screens/morescreeen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:provider/provider.dart';

import '../Constant/TextStyles/Textstyles.dart';
import '../insertdatamodel.dart';

class Recycle_Bin extends StatefulWidget {
  Recycle_Bin({Key? key}) : super(key: key);

  @override
  State<Recycle_Bin> createState() => _Recycle_BinState();
}

class _Recycle_BinState extends State<Recycle_Bin> {
  List recyledata = [];
  // List Idlist = [];
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
          recyledata.length == 0
              ? Container(
                  padding: EdgeInsets.all(20),
                  child: Center(
                      child: Text(
                    "No Data found",
                    style: TextStyles.mb14,
                  )),
                )
              : Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: recyledata.length,
                      itemBuilder: (BuildContext context, int index) {
                        var fname = recyledata[index][1]['name'].split('');

                        return Column(
                          children: [
                            Dismissible(
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
                                      .deleterecord(recyledata[index][0]);
                                  Provider.of<Insetdatamodel>(context,
                                          listen: false)
                                      .upadtedeltestatus_entry(
                                          recyledata[index][0], "0", "Entry");
                                  Provider.of<Insetdatamodel>(context,
                                          listen: false)
                                      .upadtedeltestatus(recyledata[index][0],
                                          '0', 'customer_record');
                                } else {}
                              },
                              child: Column(
                                children: [
                                  ListTile(
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
                                        recyledata[index][1]['date'].toString(),
                                        style: TextStyles.mb12,
                                      ),
                                      title: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          recyledata[index][1]['name']
                                              .toString(),
                                          style: TextStyles.mb14,
                                        ),
                                      )).paddingSymmetric(horizontal: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Provider.of<Insetdatamodel>(context,
                                                  listen: false)
                                              .upadtedeltestatus_entry(
                                                  recyledata[index][0],
                                                  "0",
                                                  "Entry");
                                          Provider.of<Insetdatamodel>(context,
                                                  listen: false)
                                              .upadtedeltestatus(
                                                  recyledata[index][0],
                                                  '0',
                                                  'customer_record');
                                          nextScreen(context, MoreScreen());
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
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
                                                Icons.replay_circle_filled,
                                                color: Colors.blue,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          showAlertDialog(
                                              context, recyledata, index);
                                          //   data[index][1]['name'],
                                          // data[index][0]
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
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
                                  ).paddingSymmetric(horizontal: 10)
                                ],
                              ),
                            ),
                            Divider(thickness: 1)
                          ],
                        );
                      }).paddingSymmetric(horizontal: 10),
                ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context, List list, index) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("Yes"),
      onPressed: () async {
        backScreen(context);
        await Provider.of<Insetdatamodel>(context, listen: false)
            .deleterecord(list[index][0]);
        get_recent_deleted_customer();
      },
    );
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        backScreen(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Are you sure want to delete ${list[index][1]['name']} "),
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
  await  FirebaseFirestore.instance
        .collection('customer_record')
        .where('deleted', isEqualTo: "1")
        .get()
        .then((QueryDocumentSnapshot) {
      for (var queryDocumentSnapshot in QueryDocumentSnapshot.docs) {
        Map<String, dynamic> fetchdata = queryDocumentSnapshot.data();
        setState(() {
          recyledata.add([queryDocumentSnapshot.id, fetchdata]);
        });
      }
    });
  }
}
