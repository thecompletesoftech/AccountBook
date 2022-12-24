import 'package:account_book/Constant/navigaotors/Navagate_Next.dart';
import 'package:account_book/screens/Collector_Profile.dart';
import 'package:account_book/screens/Collector_Screen.dart';
import 'package:account_book/screens/Customer_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Constant/TextStyles/Textstyles.dart';

class update_collector_address extends StatefulWidget {
  final id;
  final address;
  update_collector_address({Key? key, this.id, this.address}) : super(key: key);

  @override
  State<update_collector_address> createState() => _Update_addressState();
}

class _Update_addressState extends State<update_collector_address> {
  TextEditingController address = TextEditingController();
  @override
  void initState() {
    address.text = widget.address;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        bottomSheet: Padding(
          padding: const EdgeInsets.all(10),
          child: GestureDetector(
            onTap: () {
              final users = FirebaseFirestore.instance.collection("admin");
              users
                  .doc(widget.id)
                  .update({'address': address.text})
                  .then((value) => print("address updated"))
                  .catchError(
                      (error) => print("Failed to update user: $error"));

              nextScreen(context, Collector_Screen());
            },
            child: Container(
              alignment: Alignment.center,
              color: Colors.blue,
              width: size.width,
              height: size.height * 0.05,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Save',
                  style: TextStyles.withColor(TextStyles.mb14, Colors.white),
                ),
              ),
            ),
          ),
        ),
        appBar: AppBar(
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Text(
                "Collector Address",
                style: TextStyles.mb18,
              )
            ])),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Address",
                style: TextStyles.mb14,
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.only(left: 10, top: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                width: size.width,
                child: TextField(
                  onChanged: (text) {},
                  controller: address,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter address',
                      hintStyle: TextStyles.mb14),
                ),
              ),
            ],
          ),
        ));
  }
}
