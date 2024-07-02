import 'dart:convert';
import 'dart:io';
import 'package:account_book/Api/Api.dart';
import 'package:account_book/Constant/TextStyles/Textstyles.dart';
import 'package:account_book/insertdatamodel.dart';
import 'package:account_book/screens/customertransactions.dart';
import 'package:account_book/screens/homescreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constant/navigaotors/Navagate_Next.dart';

class MoneyGotScreen extends StatefulWidget {
  final String mobile_no;
  final String name;
  final iscustomer;
  final u_id;
  final amount;
  final entry_id;
  final des;
  final p_image;
  final token;
  MoneyGotScreen({
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
  State<MoneyGotScreen> createState() => _MoneyGaveScreenState();
}

class _MoneyGaveScreenState extends State<MoneyGotScreen> {
  TextEditingController amount = TextEditingController();
  int amountshow = 0;
  TextEditingController description = TextEditingController();
  TextEditingController dateinput = TextEditingController();
  final databaseReference = FirebaseDatabase.instance.reference();
  File? imageFile;
  String? validation;
  bool valid = false;
  bool isloading = false;

  bool othersfiledshow = false;

  String? role;

  @override
  void initState() {
    print("got screen" + widget.token.toString());

    getrole();
    if (widget.amount != null) {
      amount.text = widget.amount;
      description.text = widget.des;
    }
    // printFirebase('customer_record');
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
              SizedBox(height: 10),
              Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        backScreen(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.green,
                        size: 30,
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: size.width * 0.8,
                    child: Text(
                      "You Gave " + '\u{20B9} ' + "$amountshow " + widget.name,
                      style:
                          TextStyles.withColor(TextStyles.mb20, Colors.green),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
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
                        color: Colors.green,
                      ),
                      border: OutlineInputBorder(),
                      hintText: 'Enter Amount',
                      hintStyle: TextStyles.mb24),
                ),
              ),
              SizedBox(
                height: 20,
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
                          width: size.width * 0.6,
                          child: DateTimePicker(
                            type: DateTimePickerType.date,
                            dateMask: 'd MMM, yyyy',
                            initialValue: DateFormat("yyyy-MM-dd")
                                .format(DateTime.now())
                                .toString(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            icon: Icon(Icons.event),
                            selectableDayPredicate: (date) {
                              print(date.toString());
                              // Disable weekend days to select from the calendar
                              // if (date.weekday == 6 || date.weekday == 7) {
                              //   return false;
                              // }
                              return true;
                            },
                            onChanged: (val) {
                              print(val);
                              setState(() {
                                dateinput.text = val;
                              });
                            },
                            validator: (val) {
                              print(val);
                              return null;
                            },
                            onSaved: (val) {
                              print(val);
                              setState(() {
                                dateinput.text = val!;
                              });
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print("hii");
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
                              children: [
                                Icon(
                                  Icons.camera_alt_outlined,
                                  color: Color.fromARGB(255, 109, 240, 76),
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
            setState(() {
              isloading = true;
            });

            if (isloading == false) {
              if (amount.text.isEmpty) {
                setState(() {
                  valid = true;
                  validation = 'please enter values';
                });
              } else {
                if (widget.amount != null) {
                  //  update entry
                  await update_entry();
                  await updatecustomerlastupdate_youwillget();
                  nextScreen(
                      context,
                      Customertransaction(
                          p_image: widget.p_image == " " ? " " : widget.p_image,
                          name: widget.name,
                          id: widget.u_id));
                } else {
                  if (widget.iscustomer == "0") {
                    //  is customer 0 = new customer
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
                                ? dateinput.text = DateFormat('yyyy-MM-dd')
                                    .format(DateTime.now())
                                : dateinput.text,
                            '0',
                            amount.text,
                            imageFile == null ? ' ' : imageFile!.path,
                            "1",
                            "0",
                            " ",
                            " ",
                            context,
                            widget.token);
                    await updatetotaluserwillget();
                    await sendnotification();
                  } else {
                    //  is customer 0 = exits customer
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
                                ? dateinput.text = DateFormat('yyyy-MM-dd')
                                    .format(DateTime.now())
                                : dateinput.text,
                            imageFile == null ? ' ' : imageFile!.path,
                            "1",
                            widget.u_id,
                            "0",
                            context,
                            widget.mobile_no,
                            imageFile == null ? ' ' : imageFile!.path,
                            widget.token);
                    updatetotaluserwillget();
                    sendnotification();
                  }
                }
              }
            }

            setState(() {
              isloading = false;
            });
          },
          label: Padding(
            padding: const EdgeInsets.all(50),
            child: isloading ? CircularProgressIndicator() : Text("SAVE"),
          ),
          focusColor: Colors.red,
          backgroundColor: Colors.red,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
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

  datepicker() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(
            2000), //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2101));

    if (pickedDate != null) {
      print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      print(
          formattedDate); //formatted date output using intl package =>  2021-03-16
      //you can implement different kind of Date Format here according to your requirement

      setState(() {
        dateinput.text = formattedDate; //set output date to TextField value.
      });
    } else {
      dateinput.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
  }

  getrole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getString('role')!;
    });
  }

  sendnotification() {
    try {
      Api()
          .apicall_post(
              "https://fcm.googleapis.com/fcm/send",
              {
                "to": widget.token,
                "notification": {
                  "body": "successfully you give ${amount.text} ",
                  "title": "${amount.text} you Give "
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
