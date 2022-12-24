import 'package:account_book/Constant/navigaotors/Navagate_Next.dart';
import 'package:account_book/screens/Collector_Screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constant/Colors/Colors.dart';
import '../Constant/TextStyles/Textstyles.dart';
import '../insertdatamodel.dart';

class Collector_Register extends StatefulWidget {
  Collector_Register({Key? key}) : super(key: key);

  @override
  State<Collector_Register> createState() => _Collector_RegisterState();
}

class _Collector_RegisterState extends State<Collector_Register> {
  TextEditingController name = TextEditingController();
  TextEditingController mobile_no = TextEditingController();
  TextEditingController password = TextEditingController();
  String _selectedGender = 'male';
  bool validation = false;

  String? token;
  @override
  void initState() {
    gettoken();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        bottomSheet: Padding(
          padding: const EdgeInsets.all(10),
          child: GestureDetector(
            onTap: () async {
              if (name.text.isEmpty ||
                  mobile_no.text.isEmpty ||
                  password.text.isEmpty) {
                setState(() {
                  validation = true;
                });
              } else {
                SharedPreferences prefs = await SharedPreferences.getInstance();

                Provider.of<Insetdatamodel>(context, listen: false)
                    .add_collectors(
                        name.text,
                        prefs.getString('business_name'),
                        mobile_no.text,
                        password.text,
                        _selectedGender,
                        context,
                        token);
                nextScreen(context, Collector_Screen());
              }
              // final users =
              //     FirebaseFirestore.instance.collection("customer_record");
              // users
              //     .doc(widget.id)
              //     .update({'address': address.text})
              //     .then((value) => print("address updated"))
              //     .catchError(
              //         (error) => print("Failed to update user: $error"));
              // nextScreen(context, Customer_profile());
            },
            child: Container(
              alignment: Alignment.center,
              color: Colors.blue,
              width: size.width,
              height: size.height * 0.05,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Register',
                  style: TextStyles.withColor(TextStyles.mb14, Colors.white),
                ),
              ),
            ),
          ),
        ),
        appBar: PreferredSize(
            child: Column(
              children: [
                InkWell(
                  onTap: () {},
                  splashColor: Colors.black,
                  child: InkWell(
                      onTap: () {
                        // _business_bottomsheet();
                      },
                      child: Container(
                        height: size.height * 0.07,
                        padding: EdgeInsets.only(left: 10),
                        color: MyColors.primarycolor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Image.asset(
                            //   'image/logo_bar.png',
                            //   height: 35,
                            //   width: 35,
                            // ),
                            SizedBox(
                              width: 13,
                            ),
                            Text("Add Collector",
                                style: TextStyles.withColor(
                                    TextStyles.mb16, Colors.white)),
                            SizedBox(
                              width: 14,
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ),
            preferredSize: Size.fromHeight(80)),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              field("Name", name, "enter name", false, TextInputType.text),
              SizedBox(height: 10),
              field("Mobile_no", mobile_no, "enter mobile_no", false,
                  TextInputType.number),
              SizedBox(height: 10),
              field("password", password, "password", true,
                  TextInputType.visiblePassword),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Gender",
                  style: TextStyles.mb14,
                ),
              ),
              ListTile(
                leading: Radio<String>(
                  value: 'male',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
                title: const Text('Male'),
              ),
              ListTile(
                leading: Radio<String>(
                  value: 'female',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
                title: const Text('Female'),
              ),
              SizedBox(height: 25),
              SizedBox(
                height: 20,
              ),
              validation == true
                  ? Text(
                      "please enter all field values",
                      style: TextStyles.withColor(TextStyles.mb12, Colors.red),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  field(hedaing, contr, hint, pwd_sec, type) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hedaing,
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
              keyboardType: type,
              onChanged: (text) {},
              obscureText: pwd_sec,
              controller: contr,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle: TextStyles.mb14),
            ),
          ),
        ],
      ),
    );
  }

  gettoken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("fcmtoken_admin");
    });
  }
}
