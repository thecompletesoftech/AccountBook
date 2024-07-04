import 'dart:convert';
import 'dart:io';
import 'package:account_book/Constant/TextStyles/Textstyles.dart';
import 'package:account_book/insertdatamodel.dart';
import 'package:account_book/screens/CustomerScreen.dart';
import 'package:account_book/screens/customertransactions.dart';
import 'package:account_book/screens/homescreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:get/utils.dart';

import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Api/Api.dart';
import '../Constant/navigaotors/Navagate_Next.dart';

class MoneyGaveScreen extends StatefulWidget {
  final String mobile_no;
  final String name;
  final iscustomer;
  final u_id;
  final amount;
  final entry_id;
  final des;
  final p_image;
  final token;
  MoneyGaveScreen({
    Key? key,
    required this.mobile_no,
    required this.name,
    this.iscustomer,
    this.u_id,
    this.amount,
    this.entry_id,
    this.des,
    this.p_image,
    this.token,
  }) : super(key: key);

  @override
  State<MoneyGaveScreen> createState() => _MoneyGaveScreenState();
}

class _MoneyGaveScreenState extends State<MoneyGaveScreen> {
  TextEditingController amount = TextEditingController();
  int amountshow = 0;
  TextEditingController description = TextEditingController();
  TextEditingController dateinput = TextEditingController();
  File? imageFile;
  String? validation;
  bool valid = false;
  bool othersfiledshow = false;
  bool isloading = false;

  String? role;

  @override
  void initState() {
    getrole();
    print("hii" + widget.u_id.toString());
    print("hii token" + widget.token.toString());

    if (widget.amount != null) {
      amount.text = widget.amount;
      description.text = widget.des;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (amount.text.isNotEmpty) {
      setState(() {
        othersfiledshow = true;
      });
    } else
      setState(() {
        othersfiledshow = false;
      });

    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        backScreen(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.red,
                        size: 30,
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(width: 20),
                  Container(
                    width: size.width * 0.8,
                    child: Text(
                      "You Gave " + '\u{20B9} ' + "$amountshow " + widget.name,
                      style: TextStyles.withColor(
                        TextStyles.mb20,
                        Colors.red,
                      ),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.all(Radius.circular(10)),
                //   color: Colors.grey,
                // ),
                height: size.height * 0.06,
                width: size.width,
                child: TextField(
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      amount.text.isEmpty
                          ? amountshow = 0
                          : amountshow = int.parse(value.toString());
                    });
                  },
                  controller: amount,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.currency_rupee_sharp,
                        color: Colors.red,
                        size: 30,
                      ),
                      border: OutlineInputBorder(),
                      hintText: 'Enter Amount',
                      hintStyle: TextStyles.mb24),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              othersfiledshow == true
                  ? Container(
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.all(Radius.circular(10)),
                      //   color: Colors.grey,
                      // ),
                      height: size.height * 0.05,
                      width: size.width,
                      child: TextField(
                        autofocus: true,
                        controller: description,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter details(Decription)',
                            hintStyle: TextStyles.mn14),
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 20,
              ),
              othersfiledshow == true
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: size.width * 0.5,
                          child: DateTimePicker(
                            type: DateTimePickerType.date,
                            dateMask: 'd MMM, yyyy',
                            initialValue: DateTime.now().toString(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            icon: Icon(Icons.event),
                            // dateLabelText: 'Date',
                            // timeLabelText: "Hour",
                            selectableDayPredicate: (date) {
                              // Disable weekend days to select from the calendar
                              // if (date.weekday == 6 || date.weekday == 7) {
                              //   return false;
                              // }

                              return true;
                            },
                            onChanged: (val) {
                              print("data" + val.toString());
                              setState(() {
                                dateinput.text = val;
                              });
                            },
                            validator: (val) {
                              print(val);
                              return null;
                            },
                            onSaved: (val) {
                              print("data" + val.toString());
                              setState(() {
                                dateinput.text = val!;
                              });
                            },
                          ),
                        ),

                        // GestureDetector(
                        //   onTap: () async {
                        //     datepicker();
                        //   },
                        //   child: Container(
                        //     padding: EdgeInsets.all(10),
                        //     decoration: BoxDecoration(
                        //       color: Colors.blueGrey,
                        //       borderRadius:
                        //           BorderRadius.all(Radius.circular(10)),
                        //     ),
                        //     height: size.height * 0.04,
                        //     child: Row(
                        //       children: [
                        //         Icon(
                        //           Icons.date_range_outlined,
                        //           color: Colors.red,
                        //         ),
                        //         SizedBox(
                        //           width: 5,
                        //         ),
                        //         dateinput.text == ""
                        //             ? Text(
                        //                 DateFormat('MM-dd-yyyy HH:mm')
                        //                     .format(DateTime.now())
                        //                     .toString(),
                        //                 style: TextStyles.withColor(
                        //                     TextStyles.mn14, Colors.white))
                        //             : Text(dateinput.text.toString(),
                        //                 style: TextStyles.withColor(
                        //                     TextStyles.mn14, Colors.white)),
                        //       ],
                        //     ),
                        //   ),
                        // ),

                        GestureDetector(
                          onTap: () {
                            _getFromGallery();
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.red,
                                ),
                                Text("Attach bills",
                                    style: TextStyles.withColor(
                                        TextStyles.mn14, Colors.white)),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  : Container(),
              SizedBox(height: 10),
              valid == true
                  ? Text(
                      validation.toString(),
                      style: TextStyles.withColor(TextStyles.mb14, Colors.red),
                    )
                  : Container()
            ],
          ),
        ),
        floatingActionButton: new FloatingActionButton.extended(
          onPressed: () async {
            if (amount.text.isEmpty) {
              setState(() {
                valid = true;
                validation = 'please enter amount';
              });
            } else {
              if (widget.amount != null) {
                if (!isloading) {
                  setState(() {
                    isloading = true;
                  });
                  await update_entry();
                  await updatecustomerlastupdate_youwillget();
                  nextScreen(
                      context,
                      Customertransaction(
                        p_image: widget.p_image == " " ? " " : widget.p_image,
                        name: widget.name,
                        id: widget.u_id,
                      ));
                  setState(() {
                    isloading = false;
                  });
                }
              } else {
                if (!isloading) {
                  setState(() {
                    isloading = true;
                  });
                  DateTime dt = DateTime.now();
                  var datetime = DateFormat('yyyy-MM-dd').format(dt);
                  if (widget.iscustomer == "0") {
                    // is customer 0 new customer
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await Provider.of<Insetdatamodel>(context, listen: false)
                        .insertdata(
                            role == "collector"
                                ? prefs.getString('login_person_id')
                                : null,
                            widget.name,
                            role == "collector" ? "0" : "1",
                            widget.mobile_no,
                            description.text.isEmpty ? ' ' : description.text,
                            dateinput.text.isEmpty
                                ? datetime.toString()
                                : dateinput.text,
                            dt.millisecondsSinceEpoch.toString(),
                            '0',
                            amount.text,
                            imageFile == null ? ' ' : imageFile!.path,
                            "0",
                            "0",
                            " ",
                            " ",
                            context,
                            widget.token);
                    await updatetotaluserwillget();
                    sendnotification();
                  } else {
                    // is customer 1 exits customer
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await Provider.of<Insetdatamodel>(context, listen: false)
                        .insertentry(
                            role == "collector"
                                ? prefs.getString('login_person_id')
                                : null,
                            widget.name,
                            role == "collector" ? "0" : "1",
                            description.text.isEmpty ? ' ' : description.text,
                            amount.text,
                            dateinput.text.isEmpty
                                ? datetime.toString()
                                : dateinput.text,
                            dt.millisecondsSinceEpoch.toString(),
                            imageFile == null ? ' ' : imageFile!.path,
                            "0",
                            widget.u_id,
                            "0",
                            context,
                            widget.mobile_no,
                            imageFile == null ? ' ' : imageFile!.path,
                            widget.token);
                    await updatetotaluserwillget();
                    sendnotification();
                  }
                  setState(() {
                    isloading = false;
                  });
                }
              }
            }
          },
          label: isloading
              ? Center(
                  child: CircularProgressIndicator(
                  color: Colors.white,
                ).paddingSymmetric(horizontal: 10))
              : Padding(
                  padding: const EdgeInsets.all(50),
                  child: Text("SAVE"),
                ),
          focusColor: Colors.red,
          backgroundColor: Colors.red,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  getrole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getString('role')!;
    });
  }

  _getFromGallery() async {
    final XFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (XFile != null) {
      setState(() {
        imageFile = File(XFile.path);
        print("image name" + imageFile.toString());
      });
    }
  }

  sendnotification() {
    try {
      Api()
          .apicall_post(
              "https://fcm.googleapis.com/fcm/send",
              {
                "to": widget.token,
                "notification": {
                  "body": "please return amount in return date",
                  "title": "${amount.text} you Got"
                }
              },
              context)
          .then((value) {});
    } catch (e) {
      print("error" + e.toString());
    }
  }

  updatetotaluserwillget() async {
    double userwillget =
        await Provider.of<Insetdatamodel>(context, listen: false)
            .get_total_Userwillget(widget.u_id);

    await Provider.of<Insetdatamodel>(context, listen: false)
        .updatecustomertable(
            collectionname: "customer_record",
            id: widget.u_id,
            jsondata: {"youllgetamount": userwillget});
  }

  updatecustomerlastupdate_youwillget() async {
    double userwillget =
        await Provider.of<Insetdatamodel>(context, listen: false)
            .get_total_Userwillget(widget.u_id);
    await Provider.of<Insetdatamodel>(context, listen: false)
        .updatecustomertable(
            collectionname: "customer_record",
            id: widget.u_id,
            jsondata: {
          "youllgetamount": userwillget,
          'last_updated_date': dateinput.text.isEmpty
              ? dateinput.text = DateFormat('yyyy-MM-dd HH:mm')
                  .format(DateTime.now())
                  .toString()
              : dateinput.text
        });
  }

  update_entry() async {
    await Provider.of<Insetdatamodel>(context, listen: false)
        .updatecustomertable(
            collectionname: "Entry",
            id: widget.entry_id,
            jsondata: {
          'amount': amount.text,
          'description': description.text,
          'date': dateinput.text.isEmpty
              ? DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()
              : dateinput.text,
        });
  }
}
