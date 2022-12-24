import 'package:account_book/screens/Collection_list.dart';
import 'package:account_book/widget/BottomBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../Constant/Colors/Colors.dart';
import '../Constant/Strings/Strings.dart';
import '../Constant/TextStyles/Textstyles.dart';
import '../Constant/navigaotors/Navagate_Next.dart';
import '../insertdatamodel.dart';
import 'Collector_Register.dart';

class Collector_Screen extends StatefulWidget {
  Collector_Screen({Key? key}) : super(key: key);

  @override
  State<Collector_Screen> createState() => _Collector_ScreenState();
}

class _Collector_ScreenState extends State<Collector_Screen> {
  TextEditingController customer = TextEditingController();

  bool showloading = false;

  List data = [];

  List c_id_list = [];
  @override
  void initState() {
    _get_collector_data('admin');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
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
                        padding: EdgeInsets.only(left: 15),
                        color: MyColors.primarycolor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Image.asset(
                            //   'image/logo_bar.png',
                            //   height: 35,
                            //   width: 35,
                            // ),
                            // SizedBox(
                            //   width: 13,
                            // ),
                            Text("Collectors",
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
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10, top: 5, right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  height: size.height * 0.06,
                  width: size.width,
                  child: TextField(
                    onChanged: (text) {
                      _runFilter(text);
                    },
                    controller: customer,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          size: 30,
                        ),
                        hintText: 'search Collector',
                        hintStyle: TextStyles.mb14),
                  ),
                ),
                SizedBox(width: 10),
                Divider(),
                if (showloading == true)
                  Center(child: CircularProgressIndicator()),
                if (data.length == 0 && showloading == false)
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
                    height: size.height * 0.6,
                    child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          var fname = data[index]['name'].split('');

                          return GestureDetector(
                            onTap: () async {
                              nextScreen(
                                  context,
                                  Collection_List(
                                      mobile_no: data[index]['mobile_no'],
                                      name: data[index]['name'],
                                      p_image: data[index]['p_image'] == null
                                          ? null
                                          : data[index]['p_image'],
                                      address: data[index]['address'],
                                      collector_id: c_id_list[index]));
                              // final fullContact =
                              //     await FlutterContacts.getContact(
                              //         data[index]['contact_id']);

                              // nextScreen(
                              //     context,
                              //     Customertransaction(
                              //         name: data[index]['name'],
                              //         iscustomer: "1",
                              //         id: idlist[index].toString(),
                              //         mobile_no: data[index]['mobile_no'],
                              //         contact: null,
                              //         p_image: data[index]['p_image'],
                              //         address: data[index]['address']));
                            },
                            child: Container(
                              child: Card(
                                child: Dismissible(
                                  background: Container(
                                      alignment: Alignment.centerLeft,
                                      color: Colors.green,
                                      child: Icon(
                                        Icons.call,
                                        color: Colors.white,
                                      )),
                                  secondaryBackground: Container(
                                    padding: EdgeInsets.only(right: 10),
                                    color: Colors.red,
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                  key: UniqueKey(),
                                  onDismissed: (DismissDirection direction) {
                                    if (direction ==
                                        DismissDirection.endToStart) {
                                      // Provider.of<Insetdatamodel>(context,
                                      //         listen: false)
                                      //     .upadtedeltestatus(
                                      //         idlist[index].toString(),
                                      //         "1",
                                      //         "customer_record");

                                      // Provider.of<Insetdatamodel>(context,
                                      //         listen: false)
                                      //     .upadtedeltestatus_entry(
                                      //         idlist[index].toString(),
                                      //         "1",
                                      //         "Entry");

                                      data.removeAt(index);
                                    } else {
                                      setState(() {
                                        // _callNumber(data[index]['mobile_no']
                                        //     .toString());
                                        // _launchPhoneURL(
                                        //     data[index]['mobile_no'].toString());
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: data[index]['p_image'] == null
                                            ? CircleAvatar(
                                                backgroundColor:
                                                    Colors.blueGrey,
                                                child: Text(
                                                  fname[0].toString(),
                                                  style: TextStyles.mb18,
                                                ),
                                                radius: 30,
                                              )
                                            : Container(
                                                width: 55,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.blueGrey,
                                                    ),
                                                    image: DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: NetworkImage(
                                                        data[index]['p_image'],
                                                      ),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                100))),
                                              ),
                                        // trailing: Text(
                                        //   '\u{20B9} ' + data[index]['amount'],
                                        //   style: TextStyle(
                                        //       color: Colors.black, fontSize: 15),
                                        // ),
                                        subtitle: Text(
                                          data[index]['date'].toString(),
                                          style: TextStyles.mb12,
                                        ),
                                        title: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: Text(
                                            data[index]['name'].toString(),
                                            style: TextStyles.mb14,
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            nextScreen(context, Collector_Register());
          },
          label: Text(ConstStr.Add_collector.toUpperCase().toString()),
          icon: const Icon(Icons.person_add_alt_rounded),
          backgroundColor: Colors.pink,
        ),
        bottomNavigationBar: BottomBar(index: 3),
      ),
    );
  }

  void _runFilter(String enteredKeyword) {
    var results = [];

    if (enteredKeyword.isEmpty) {
      _get_collector_data('admin');
      // if the search field is empty or only contains white-space, we'll display all users
    } else {
      results = data
          .where((user) =>
              user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }
    setState(() {
      data = results;
    });
  }

  _get_collector_data(tablename) {
    setState(() {
      showloading = true;
    });
    FirebaseFirestore.instance
        .collection(tablename)
        .where('role', isEqualTo: "collector")
        .get()
        .then((QuerySnapshot querySnapshot) {
      {
        querySnapshot.docs.forEach((element) {
          c_id_list.add(element.id);
          print(element.data());
          setState(() {
            data.add(element.data());
            // collector_data.add(element.id);
          });
        });
        setState(() {
          showloading = false;
        });
      }
    });
  }
}
