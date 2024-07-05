import 'package:account_book/Constant/navigaotors/Navagate_Next.dart';
import 'package:account_book/screens/Collector_Profile.dart';
import 'package:account_book/screens/homescreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';
import '../Constant/TextStyles/Textstyles.dart';
class Collection_List extends StatefulWidget {
  final mobile_no;
  final name;
  final collector_id;
  final p_image;
  final address;

  Collection_List(
      {Key? key,
      this.mobile_no,
      this.name,
      this.collector_id,
      this.p_image,
      this.address})
      : super(key: key);

  @override
  State<Collection_List> createState() => _Collection_ListState();
}

class _Collection_ListState extends State<Collection_List> {
  List c_data = [];

  double total_collection = 0;

  bool showloading = false;
  @override
  void initState() {
    print(widget.collector_id);
    _get_collector_collectios_data('Entry', widget.collector_id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              widget.p_image == null
                  ? CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blueGrey,
                      child:
                          // child: widget.p_image == " "
                          Text(widget.name.toString().split('')[0].toString())
                      // : Container(
                      //     width: 100,
                      //     height: 110,
                      //     decoration: BoxDecoration(
                      //         border: Border.all(
                      //           color: Colors.blueGrey,
                      //         ),
                      //         image: DecorationImage(
                      //           fit: BoxFit.fill,
                      //           image: NetworkImage(
                      //             widget.p_image,
                      //           ),
                      //         ),
                      //         borderRadius:
                      //             BorderRadius.all(Radius.circular(100))),
                      //   ),
                      )
                  //  CircleAvatar(
                  //     radius: 20,
                  //     backgroundColor: Colors.blueGrey,
                  //     child: Text("s".split('').first.toString())
                  //     //  Container(
                  //     //     width: 100,
                  //     //     height: 110,
                  //     //     decoration: BoxDecoration(
                  //     //         border: Border.all(
                  //     //           color: Colors.blueGrey,
                  //     //         ),
                  //     //         // image: DecorationImage(
                  //     //         //   fit: BoxFit.fill,
                  //     //         //   image: NetworkImage(
                  //     //         //     widget.p_image,
                  //     //         //   ),
                  //     //         // ),
                  //     //         borderRadius:
                  //     //             BorderRadius.all(Radius.circular(100))),
                  //     //   ),
                  //     ),

                  : Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blueGrey,
                          ),
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                              widget.p_image,
                            ),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(100))),
                    ),
              SizedBox(width: 10),

              Text(
                widget.name.toString(),
                style: TextStyles.mb14,
              )
              //
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  onTap: () {
                    _callNumber(widget.mobile_no);
                  },
                  child: Icon(
                    Icons.call,
                    size: 25,
                  )),
              //  GestureDetector(
              //     onTap: () {
              //       // _callNumber(widget.contact!.phones.first.number);
              //     },
              //     child: Icon(
              //       Icons.call,
              //       size: 25,
              //     )),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  nextScreen(
                      context,
                      Collector_Profile(
                          name: widget.name,
                          mobile_no: widget.mobile_no,
                          p_image:
                              widget.p_image == null ? null : widget.p_image,
                          id: widget.collector_id,
                          address:
                              widget.address == " " ? " " : widget.address));
                },
                child: Icon(
                  Icons.more_vert,
                  size: 25,
                ),
              ),
              SizedBox(width: 20),
              // GestureDetector(
              //   onTap: () {
              //     // showCustomRangePicker();
              //   },
              //   child: Icon(
              //     Icons.filter_alt_outlined,
              //     size: 25,
              //   ),
              // )
            ],
          )
        ],
      )),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            height: size.height * 0.1,
            width: size.width,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total collection",
                      style:
                          TextStyles.withColor(TextStyles.mb14, Colors.black),
                    ),
                    Text(
                      "\u{20B9} " + total_collection.toString(),
                      style: TextStyles.withColor(TextStyles.mb14, Colors.red),
                    )
                  ],
                ),
              ),
            ),
          ),
          if (showloading == true) Center(child: CircularProgressIndicator()),
          if (c_data.length == 0 && showloading == false)
            Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                  child: Text(
                "NO DATA FOUND",
                style: TextStyles.mb14,
              )),
            ),
          SingleChildScrollView(
            child: Container(
              height: size.height * 0.68,
              child: ListView.builder(
                  itemCount: c_data.length,
                  itemBuilder: (BuildContext context, int index) {
                    // print("entry_id" + entry_data_id[index].toString());
                    // print("name" + widget.name.toString());

                    return GestureDetector(
                      onTap: () {},
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  c_data[index]['name'].toString(),
                                  maxLines: 2,
                                  style: TextStyles.mn12,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  c_data[index]['amount'].toString(),
                                  maxLines: 2,
                                  style: TextStyles.withColor(
                                      TextStyles.mb14, Colors.red),
                                ),
                                //         entry_data[index]['description'] !=
                                //                 " "
                                //             ? Text(
                                //                 entry_data[index]
                                //                         ['description']
                                //                     .toString(),
                                //                 style: TextStyles.mn12,
                                //               )
                                //             : Text(
                                //                 " No Description",
                                //                 style: TextStyles.mn12,
                                //               )
                                //       ],
                                //     )),
                                // entry_data[index]['type'] == "0"
                                //     ? Text(
                                //         entry_data[index]['amount']
                                //             .toString(),
                                //         style: TextStyles.withColor(
                                //             TextStyles.mb12, Colors.red),
                                //       )
                                //     : Container(),
                                // entry_data[index]['type'] == "1"
                                //     ? Text(
                                //         entry_data[index]['amount']
                                //             .toString(),
                                //         style: TextStyles.withColor(
                                //             TextStyles.mb12, Colors.green),
                                //       )
                                //     : Container(),
                              ]),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () {
            print("hiii");
            _update_list_approvelist(widget.collector_id);
          },
          child: Container(
            color: Colors.green,
            height: size.height * 0.05,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Appove',
                  style: TextStyles.withColor(TextStyles.mb14, Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }

  _callNumber(String phoneNumber) async {
    String number = phoneNumber;
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  _get_collector_collectios_data(tablename, id) {
    setState(() {
      showloading = true;
    });
    FirebaseFirestore.instance
        .collection(tablename)
        .where('collector_id', isEqualTo: id)
        .where('status', isEqualTo: "0")
        .where('date',
            isEqualTo:
                DateFormat('yyyy-MM-dd').format(DateTime.now()).toString())
        .get()
        .then((QuerySnapshot querySnapshot) {
      {
        querySnapshot.docs.forEach((element) {
          print("data collection" + element.data().toString());
          setState(() {
            c_data.add(element.data());
          });
        });
        setState(() {
          showloading = false;
        });
        // for (var value in c_data) {
        //   print(DateFormat("yyyy-MM-dd ")
        //       .parse(value['date'].toString())
        //       .toString()
        //       .replaceAll("00:00:00.000", ""));
        // }
        // c_data = c_data
        //     .where((element) =>
        //         DateFormat("yyyy-MM-dd")
        //             .parse(element['date'])
        //             .toString()
        //             .replaceAll("00:00:00.000", "") ==
        //         DateFormat('yyyy-MM-dd').format(DateTime.now()).toString())
        //     .toList();

        // print("filter data" + c_data.toString());

        for (var i = 0; i <= c_data.length; i++) {
          setState(() {
            total_collection =
                double.parse(c_data[i]['amount']) + total_collection;
          });
        }
        print("total" + total_collection.toString());
      }
    });
  }

  _update_list_approvelist(c_id) {
    FirebaseFirestore.instance
        .collection('Entry')
        .where('collector_id', isEqualTo: c_id)
        .get()
        .then((QueryDocumentSnapshot) {
      for (var value in QueryDocumentSnapshot.docs) {
        print("data where id" + value.data().toString());
        final users = FirebaseFirestore.instance.collection('Entry');
        users
            .doc(value.id)
            .update({'status': "1"})
            .then((value) =>
                print("all collections of particular collector Updated"))
            .catchError((error) => print("Failed to update user: $error"));
      }
    });
    nextScreen(context, HomeScreen());
  }
}
