import 'package:account_book/Constant/navigaotors/Navagate_Next.dart';
import 'package:account_book/screens/CustomerScreen.dart';
import 'package:account_book/screens/Customer_profile.dart';
import 'package:account_book/screens/homescreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Constant/TextStyles/Textstyles.dart';

class Update_name extends StatefulWidget {
  final id;
  final name;
  Update_name({Key? key, this.id, this.name}) : super(key: key);

  @override
  State<Update_name> createState() => _Update_addressState();
}

class _Update_addressState extends State<Update_name> {
  TextEditingController name = TextEditingController();
  @override
  void initState() {
    name.text = widget.name;
    print(widget.id);
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
              final users =
                  FirebaseFirestore.instance.collection("customer_record");
              users
                  .doc(widget.id)
                  .update({'name': name.text})
                  .then((value) => print("name updated"))
                  .catchError(
                      (error) => print("Failed to update user: $error"));

              nextScreen(context, HomeScreen());
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
                "Customer name",
                style: TextStyles.mb18,
              )
            ])),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                "Name",
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
                  controller: name,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter Name',
                      hintStyle: TextStyles.mb14),
                ),
              ),
            ],
          ),
        ));
  }
}
