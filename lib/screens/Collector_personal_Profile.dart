import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constant/TextStyles/Textstyles.dart';
import '../Constant/navigaotors/Navagate_Next.dart';
import '../login.dart';
import '../widget/BottomBar.dart';
import '../widget/Collector_Bottom_Bar.dart';

class Collector_personal_Profile extends StatefulWidget {
  Collector_personal_Profile({Key? key}) : super(key: key);

  @override
  State<Collector_personal_Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Collector_personal_Profile> {
  var data;

  String? p_image;

  String? mobile_no;

  String? name;

  String? passowrd;

  String? id;
  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Profile",
            style: TextStyles.mb16,
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  child: p_image == " "
                      ? Text(
                          name!.split('')[0].toString(),
                          style: TextStyles.mb18,
                        )
                      : Container(
                          width: 100,
                          height: 100,
                          // child: CachedNetworkImage(
                          //   imageUrl: p_image!,
                          //   placeholder: (context, url) =>
                          //       CircularProgressIndicator(),
                          //   errorWidget: (context, url, error) =>
                          //       Icon(Icons.error),
                          // ),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blueGrey,
                              ),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                  p_image!,
                                ),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                        ),
                  radius: 40,
                ),
              ),
              Divider(),
              menu("Name", name),
              SizedBox(
                height: 10,
              ),
              menu("Mobile number", mobile_no),
              SizedBox(
                height: 10,
              ),
              // GestureDetector(
              //   onTap: () async {
              //     // nextScreen(context, change_passowrd(id: id));
              //   },
              //   child: Card(
              //     child: Container(
              //       padding: EdgeInsets.all(10),
              //       height: size.height * 0.07,
              //       width: size.width,
              //       child: Row(
              //         children: [
              //           Icon(
              //             Icons.password,
              //             color: Colors.red,
              //           ),
              //           SizedBox(
              //             width: 10,
              //           ),
              //           Text("Change Password", style: TextStyles.mb14),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.clear();
                  nextScreen(context, login());
                },
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    height: size.height * 0.07,
                    width: size.width,
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("logout", style: TextStyles.mb14),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: Collector_Bottom_Bar(
          index: 1,
        ),
      ),
    );
  }

  getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      p_image = prefs.getString(
        "p_image",
      );
      id = prefs.getString(
        "login_person_id",
      );
      name = prefs.getString(
        "name",
      );
      mobile_no = prefs.getString(
        "mobile_no",
      );
      passowrd = prefs.getString(
        "password",
      );
    });
  }

  menu(heading, value) {
    var size = MediaQuery.of(context).size;
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              heading,
              style: TextStyles.mn12,
            ),
            SizedBox(
              height: 5,
            ),
            Text(value, style: TextStyles.mb14),
          ],
        ),
      ),
    );
  }

}
