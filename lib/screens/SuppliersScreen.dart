import 'package:account_book/Constant/Colors/Colors.dart';
import 'package:account_book/Constant/TextStyles/Textstyles.dart';
import 'package:flutter/material.dart';

class SuppliersScreen extends StatefulWidget {
  SuppliersScreen({Key? key}) : super(key: key);

  @override
  State<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends State<SuppliersScreen> {
  List data = [
    {"name": "sunil", "hours": "3"},
    {"name": "sunils", "hours": "3"},
    {"name": "sunilc", "hours": "3"},
    {"name": "sunilc", "hours": "3"},
    {"name": "sunilc", "hours": "3"},
    {"name": "sunilc", "hours": "3"},
    {"name": "sunilc", "hours": "3"},
    {"name": "sunilc", "hours": "3"},
    {"name": "sunilc", "hours": "3"},
    {"name": "sunilc", "hours": "3"},
    {"name": "sunilc", "hours": "3"},
    {"name": "sunilc", "hours": "3"},
    {"name": "sunilc", "hours": "3"},
    {"name": "sunilc", "hours": "3"},
  ];
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(top: 170),
      height: 500,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Card(
                child: Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total purchase for june",
                              style: TextStyles.mn16,
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text('\u{20B9}'),
                                    SizedBox(width: 10),
                                    Text(
                                      "1000",
                                      style: TextStyles.mn26,
                                    ),
                                  ],
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: MyColors.primarycolor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    height: size.height * 0.04,
                                    width: size.width * 0.1,
                                    child: Icon(Icons.keyboard_arrow_right,
                                        color: MyColors.primarycolor)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        width: size.width,
                        color: MyColors.green_color,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("you'll give"),
                            SizedBox(width: 10),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Text('\u{20B9}'),
                                    SizedBox(width: 5),
                                    Text(
                                      "1000",
                                      style: TextStyles.mn14,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        height: size.height * 0.04,
                        width: size.width * 0.78,
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search),
                            hintText: 'search customer',
                          ),
                        ),
                      ),
                      Icon(
                        Icons.filter_alt_outlined,
                        size: 30,
                      ),
                      Icon(
                        Icons.picture_as_pdf,
                        size: 30,
                      )
                    ],
                  ),
                  Divider(),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundImage: AssetImage('image/profile.png'),
                              radius: 32,
                            ),
                            trailing: Text(
                              '\u{20B9} ' + "0",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                            subtitle: Text(data[index]['hours'] + " hours"),
                            title: Text(data[index]['name'].toString()));
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bottomsheet() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            children: [],
          );
        });
  }
}
