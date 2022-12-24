import 'package:account_book/Constant/TextStyles/Textstyles.dart';
import 'package:account_book/login.dart';
import 'package:account_book/screens/LockScreen.dart';
import 'package:account_book/screens/Recycle_Bin.dart';
import 'package:account_book/screens/biometriclock.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constant/Colors/Colors.dart';
import '../Constant/navigaotors/Navagate_Next.dart';
import '../insertdatamodel.dart';
import '../widget/BottomBar.dart';
import 'ApplockenbleScreen.dart';

class MoreScreen extends StatefulWidget {
  MoreScreen({Key? key}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  TextEditingController business = TextEditingController();
  String? business_name = "JD Finance";
  @override
  void initState() {
    // getbusiness_name();
    super.initState();
  }

  Widget build(BuildContext context) {
    // var business_name = Provider.of<Insetdatamodel>(context, listen: false)
    //     .businessname
    //     .toString()
    //     .split('');

    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
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
                            Image.asset(
                              'image/logo_bar.png',
                              height: 35,
                              width: 35,
                            ),
                            SizedBox(
                              width: 13,
                            ),
                            Text(business_name.toString(),
                                style: TextStyles.withColor(
                                    TextStyles.mb16, Colors.white)),
                            SizedBox(
                              width: 14,
                            ),
                            // Icon(
                            //   Icons.edit,
                            //   size: 20,
                            //   color: Colors.white,
                            // ),
                          ],
                        ),
                      )),
                ),
              ],
            ),
            preferredSize: Size.fromHeight(80)),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 15),
                    width: MediaQuery.of(context).size.width,
                    height: 110,
                    decoration: BoxDecoration(color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blueGrey,
                              child: Text(
                                business_name
                                    .toString()
                                    .split('')[0]
                                    .toString(),
                                style: TextStyles.mb18,
                              ),
                              radius: 30,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(business_name.toString(),
                                  style: TextStyles.mb14),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: OutlinedButton(
                            onPressed: () {
                              _business_bottomsheet();
                            },
                            child: Text('Edit',
                                style: TextStyle(color: Colors.blueAccent)),
                            style: OutlinedButton.styleFrom(
                                side: BorderSide(
                              width: 1.5,
                              color: Colors.blueAccent,
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Card(
                          child: InkWell(
                            splashColor: Colors.blue.withAlpha(30),
                            onTap: () {
                              debugPrint('Card tapped.');
                            },
                            child: SizedBox(
                              height: 140,
                              child: Column(
                                children: const <Widget>[
                                  SizedBox(
                                    height: 10,
                                  ),
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        AssetImage('image/business_card.jpg'),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Business \n Card',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Card(
                          child: InkWell(
                            splashColor: Colors.blue.withAlpha(30),
                            onTap: () {
                              debugPrint('Card tapped.');
                            },
                            child: SizedBox(
                              height: 140,
                              child: Column(
                                children: const <Widget>[
                                  SizedBox(
                                    height: 10,
                                  ),
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: AssetImage(
                                      'image/cashbook.jpg',
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'Cashbook',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Card(
                          child: InkWell(
                            splashColor: Colors.blue.withAlpha(30),
                            onTap: () {
                              debugPrint('Card tapped.');
                            },
                            child: SizedBox(
                              height: 140,
                              child: Column(
                                children: const <Widget>[
                                  SizedBox(
                                    height: 10,
                                  ),
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        AssetImage('image/business_stamp.png'),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Business \n Stamp',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    color: Colors.white,
                    child: ExpansionTile(
                      leading: Icon(
                        Icons.settings,
                        size: 30,
                      ),
                      backgroundColor: Colors.white,
                      title: Text(
                        'Settings',
                        style: TextStyles.mb16,
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 56.0),
                          child: GestureDetector(
                            onTap: () {
                              nextScreen(context, Recycle_Bin());
                            },
                            child: ListTile(
                              trailing: Padding(
                                padding: EdgeInsets.only(right: 7.0),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16,
                                ),
                              ),
                              title:
                                  Text('Recycle Bin', style: TextStyles.mb14),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 56.0),
                          child: GestureDetector(
                            onTap: () {
                              nextScreen(context, ApplockEnable());
                            },
                            child: ListTile(
                              trailing: Padding(
                                padding: EdgeInsets.only(right: 7.0),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16,
                                ),
                              ),
                              title: Text('App Lock', style: TextStyles.mb14),
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: EdgeInsets.only(left: 56.0),
                        //   child: GestureDetector(
                        //     onTap: () {
                        //       print("hii");
                        //       nextScreen(context, ApplockEnable());
                        //     },
                        //     child: ListTile(
                        //       trailing: Padding(
                        //         padding: EdgeInsets.only(right: 7.0),
                        //         child: Icon(
                        //           Icons.arrow_forward_ios_rounded,
                        //           size: 16,
                        //         ),
                        //       ),
                        //       title: Text('App Lock'),
                        //     ),
                        //   ),
                        // ),

                        // Padding(
                        //   padding: EdgeInsets.only(left: 56.0),
                        //   child: ListTile(
                        //     trailing: Padding(
                        //       padding: EdgeInsets.only(right: 7.0),
                        //       child: Icon(
                        //         Icons.arrow_forward_ios_rounded,
                        //         size: 16,
                        //       ),
                        //     ),
                        //     title: Text('Language'),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: EdgeInsets.only(left: 56.0),
                        //   child: ListTile(
                        //     trailing: Padding(
                        //       padding: EdgeInsets.only(right: 7.0),
                        //       child: Icon(
                        //         Icons.arrow_forward_ios_rounded,
                        //         size: 16,
                        //       ),
                        //     ),
                        //     title: Text('Backup Information'),
                        //   ),
                        // ),

                        Padding(
                          padding: EdgeInsets.only(left: 56.0),
                          child: ListTile(
                            trailing: Padding(
                              padding: EdgeInsets.only(right: 7.0),
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                              ),
                            ),
                            title: Text('App Update', style: TextStyles.mb14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    color: Colors.white,
                    child: const ExpansionTile(
                      leading: Icon(
                        Icons.question_answer_outlined,
                        size: 30,
                      ),
                      backgroundColor: Colors.white,
                      title: Text(
                        'Help & Support',
                        style: TextStyles.mb16,
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 56.0),
                          child: ListTile(
                            trailing: Padding(
                              padding: EdgeInsets.only(right: 7.0),
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                              ),
                            ),
                            title: Text('FAQs', style: TextStyles.mb14),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 56.0),
                          child: ListTile(
                            trailing: Padding(
                              padding: EdgeInsets.only(right: 7.0),
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                              ),
                            ),
                            title: Text('Help on WhatsApp',
                                style: TextStyles.mb14),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 56.0),
                          child: ListTile(
                            trailing: Padding(
                              padding: EdgeInsets.only(right: 7.0),
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                              ),
                            ),
                            title: Text('Call Us', style: TextStyles.mb14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    color: Colors.white,
                    child: const ExpansionTile(
                      leading: Icon(
                        Icons.search_rounded,
                        size: 30,
                      ),
                      backgroundColor: Colors.white,
                      title: Text('About Us', style: TextStyles.mb16),
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 56.0),
                          child: ListTile(
                            trailing: Padding(
                              padding: EdgeInsets.only(right: 7.0),
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                              ),
                            ),
                            title: Text('About Accountbook',
                                style: TextStyles.mb14),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 56.0),
                          child: ListTile(
                            trailing: Padding(
                              padding: EdgeInsets.only(right: 7.0),
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                              ),
                            ),
                            title:
                                Text('Privacy Policy', style: TextStyles.mb14),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 56.0),
                          child: ListTile(
                            trailing: Padding(
                              padding: EdgeInsets.only(right: 7.0),
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                              ),
                            ),
                            title: Text('Terms & Conditions',
                                style: TextStyles.mb14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      print('hii');
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.clear();
                      nextScreen(context, login());
                    },
                    child: Container(
                      height: size.height * 0.05,
                      width: size.width,
                      padding: EdgeInsets.only(
                        top: 5,
                        left: 20,
                      ),
                      color: Colors.white,
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Text(
                            "Logout",
                            style: TextStyles.mb16,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        bottomNavigationBar: BottomBar(
          index: 2,
        ),
      ),
    );
  }

  getbusiness_name() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      business_name = prefs.getString('business_name')!;
    });
  }

  _business_bottomsheet() {
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
                  "Business name",
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
                    controller: business,
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
                    onPressed: () async {
                      var id;
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      id = prefs.getString("admin_id");
                      final users =
                          FirebaseFirestore.instance.collection("admin");
                      users
                          .doc(id)
                          .update({'business_name': business.text})
                          .then((value) => print("business name updated"))
                          .catchError((error) =>
                              print("Failed to update user: $error"));
                      setState(() {
                        business_name =
                            Provider.of<Insetdatamodel>(context, listen: false)
                                .setusinessname(business.text);
                        backScreen(context);
                      });
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
}
