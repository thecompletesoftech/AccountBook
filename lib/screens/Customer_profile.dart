import 'dart:convert';
import 'dart:io';
import 'package:account_book/Constant/TextStyles/Textstyles.dart';
import 'package:account_book/Constant/navigaotors/Navagate_Next.dart';
import 'package:account_book/screens/CustomerScreen.dart';
import 'package:account_book/screens/Update_Address.dart';
import 'package:account_book/screens/Update_Name.dart';
import 'package:account_book/screens/Update_mobile_no.dart';
import 'package:account_book/screens/homescreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constant/Colors/Colors.dart';
import '../insertdatamodel.dart';

class Customer_profile extends StatefulWidget {
  final name;
  final mobile_no;
  final id;
  final p_image;
  final address;
  Customer_profile({
    Key? key,
    this.name,
    this.mobile_no,
    this.id,
    this.p_image,
    this.address,
  }) : super(key: key);

  @override
  State<Customer_profile> createState() => _Customer_profileState();
}

class _Customer_profileState extends State<Customer_profile> {
  File? imageFile;
  TextEditingController name = TextEditingController();

  String? role;
  @override
  void initState() {
    print("id for update profile" + widget.id.toString());
    print("add ress" + widget.address.toString());
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
          "Customer Profile",
          style: TextStyles.mb18,
        )
      ])),
      body: Column(
        children: [
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              _business_bottomsheet(context);
            },
            child: Stack(
              children: [
                widget.p_image == " "
                    ? CircleAvatar(
                        backgroundColor: Colors.blueGrey,
                        child: imageFile != null
                            ? CircleAvatar(
                                radius: 45,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.file(
                                    imageFile!,
                                    // width: 200.0,
                                    // height: 200.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : Text(
                                widget.name.toString().split('')[0].toString(),
                                style: TextStyles.mb18,
                              ),
                        radius: 45,
                      )
                    : imageFile == null
                        ? Container(
                            width: 100,
                            height: 100,
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100))),
                          )
                        : CircleAvatar(
                            radius: 45,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.file(
                                imageFile!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                Container(
                  padding: EdgeInsets.only(
                    left: 5,
                  ),
                  child: CircleAvatar(
                    child: Icon(
                      Icons.edit,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                fields("Name", Icons.person, widget.name, context,
                    Update_name(id: widget.id, name: widget.name)),
                SizedBox(
                  height: 15,
                ),
                fields(
                    "Mobile no",
                    Icons.call,
                    widget.mobile_no,
                    context,
                    Update_mobile_no(
                        id: widget.id,
                        mobile_no:
                            widget.mobile_no == null ? "" : widget.mobile_no)),
                SizedBox(
                  height: 15,
                ),
                fields(
                    "Address",
                    Icons.location_on_outlined,
                    widget.address == " " ? "no address" : widget.address,
                    context,
                    Update_address(
                      id: widget.id,
                      address:
                          widget.address == " " ? "no address" : widget.address,
                    ))
              ],
            ),
          ),
          SizedBox(height: 50),
          Container(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                showAlertDialog(context, widget.name);
                // Provider.of<Insetdatamodel>(context, listen: false)
                //     .deleterecord(widget.id);
                // nextScreen(context, HomeScreen());
              },
              child: Container(
                alignment: Alignment.center,
                color: Colors.red,
                width: size.width * 0.9,
                height: size.height * 0.05,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Delete Customer',
                        style:
                            TextStyles.withColor(TextStyles.mb14, Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  fields(headingtxt, icon, fvalue, cnt, page) {
    return Container(
      padding: EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () {
          nextScreen(cnt, page);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 30,
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      headingtxt,
                      style: TextStyles.mb14,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      fvalue,
                      style: TextStyles.mb16,
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(
                onTap: () {
                  // _business_bottomsheet(context);
                  // _update_bottomsheet(context, "Customer_name", name);
                },
                child: Icon(Icons.arrow_forward_ios_sharp)),
          ],
        ),
      ),
    );
  }

  _business_bottomsheet(context) {
    var size = MediaQuery.of(context).size;
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: size.height * 0.2,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select options",
                  style: TextStyles.mb14,
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: ElevatedButton(
                        child: Row(
                          children: [
                            Icon(Icons.camera),
                            Text(' camera'),
                          ],
                        ),
                        onPressed: () {
                          _getFromCamera();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: MyColors.primarycolor,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          textStyle: TextStyles.mb14,
                        ),
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        child: Row(
                          children: [
                            Icon(Icons.photo),
                            SizedBox(
                              width: 10,
                            ),
                            Text(' Gallary '),
                          ],
                        ),
                        onPressed: () {
                          _getFromGallery();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: MyColors.primarycolor,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          textStyle: TextStyles.mb14,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
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
      uploadFile();
    }
  }

  _getFromCamera() async {
    final XFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (XFile != null) {
      setState(() {
        imageFile = File(XFile.path);
      });
      uploadFile();
    }
  }

  getrole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getString('role')!;
    });
  }

  uploadFile() async {
    var urldata;
    if (imageFile == null) return;

    // final fileName = basename(imageFile!.path);

    // final destination = 'files/$fileName';

    try {
      // final ref = FirebaseStorage.instance.ref().child('file/');
      // ref.putFile(imageFile!);

      // final String downloadUrl = await ref.child('file/').getDownloadURL();
      // print("data" + downloadUrl);

      // final ref = FirebaseStorage.instance.ref().child('file/');
      // ref.putFile(imageFile!);

      // final String downloadUrl = await ref.child('file/').getDownloadURL();
      // print("data" + downloadUrl);

      Reference reference = FirebaseStorage.instance.ref().child("file/");

      final TaskSnapshot snapshot = await reference.putFile(imageFile!);

      var data = await snapshot.ref.getDownloadURL();

      final users = FirebaseFirestore.instance.collection("customer_record");
      users
          .doc(widget.id)
          .update({'p_image': data})
          .then((value) => print("customer profile updated"))
          .catchError((error) => print("Failed to update user: $error"));
      print("data" + urldata.toString());
    } catch (e) {
      print('error occured' + e.toString());
    }
  }

  _update_bottomsheet(context, cname, controller) {
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
                  cname,
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
                    controller: controller,
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
                    onPressed: () {
                      // Provider.of<Insetdatamodel>(context, listen: false)
                      //     .setusinessname(business.text);
                      // backScreen(context);
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

  showAlertDialog(BuildContext context, name) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("yes"),
      onPressed: () {
        print(widget.id);
        // Provider.of<Insetdatamodel>(context, listen: false)
        //     .deleterecord(widget.id);
        Provider.of<Insetdatamodel>(context, listen: false)
            .upadtedeltestatus(widget.id, "1", "customer_record");

        Provider.of<Insetdatamodel>(context, listen: false)
            .upadtedeltestatus_entry(widget.id, "1", "Entry");
        nextScreen(context, HomeScreen());
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
}
