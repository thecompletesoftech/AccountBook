import 'package:account_book/Constant/Colors/Colors.dart';
import 'package:account_book/widget/BottomBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Constant/TextStyles/Textstyles.dart';
import '../Constant/navigaotors/Navagate_Next.dart';
import 'Contact_List_payment.dart';

class MoneyScreen extends StatefulWidget {
  const MoneyScreen({Key? key}) : super(key: key);

  @override
  State<MoneyScreen> createState() => _MoneyScreenState();
}

class _MoneyScreenState extends State<MoneyScreen> {
  bool isLoading = true;
  bool applePayEnabled = false;
  bool googlePayEnabled = false;

  var data = [];

  @override
  void initState() {
    get_recent_deleted_customer('customer_record');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: PreferredSize(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {},
                    splashColor: Colors.black,
                    child: InkWell(
                        onTap: () {},
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
                              Text('Money Transaction',
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
            ),
            preferredSize: Size.fromHeight(80)),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Card(
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        nextScreen(
                            context,
                            Contact_List_payment(
                                msg: "i have request amount "));
                      },
                      child: SizedBox(
                        height: 130,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: const <Widget>[
                              CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    AssetImage('image/receive_money.png'),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text('Request \n Money',
                                  textAlign: TextAlign.center,
                                  style: TextStyles.mb14)
                            ],
                          ),
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
                        nextScreen(context,
                            Contact_List_payment(msg: "i have send amount "));
                      },
                      child: SizedBox(
                        height: 130,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const <Widget>[
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage(
                                  'image/send_money.jpg',
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text('Send \n Money',
                                  textAlign: TextAlign.center,
                                  style: TextStyles.mb14)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              "Recently deleted contacts",
              style: TextStyles.mb14,
            ),
            SizedBox(height: 10),
            data.length == 0
                ? Container(
                    padding: EdgeInsets.all(20),
                    child: Center(
                        child: Text(
                      "No Data found",
                      style: TextStyles.mb14,
                    )),
                  )
                : Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        var fname = data[index][1]['name'].split('');
                        return Dismissible(
                          background: Container(
                              padding: EdgeInsets.only(left: 10),
                              alignment: Alignment.centerLeft,
                              color: Colors.red,
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              )),
                          key: UniqueKey(),
                          onDismissed: (DismissDirection direction) {
                            if (direction == DismissDirection.endToStart) {
                              // Provider.of<Insetdatamodel>(context,
                              //         listen: false)
                              //     .deleterecord(data[index][0]);
                
                              // Provider.of<Insetdatamodel>(context,
                              //         listen: false)
                              //     .upadtedeltestatus(data[index]['id'], '0',
                              //         'customer_record');
                            } else {
                              setState(() {
                                // _callNumber(
                                //     data[index]['mobile_no'].toString());
                                // _launchPhoneURL(
                                //     data[index]['mobile_no'].toString());
                              });
                            }
                          },
                          child: GestureDetector(
                            onTap: () async {
                              // _callNumber(
                              //     data[index]['mobile_no'].toString());
                              // _launchPhoneURL(
                              //     data[index]['mobile_no'].toString());
                
                              // final fullContact =
                              //     await FlutterContacts.getContact(
                              //         data[index]['contact_id']);
                              // nextScreen(
                              //     context,
                              //     customertransaction(
                              //       iscustomer: '1',
                              //     ));
                            },
                            child: Container(
                              child: Card(
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.blueGrey,
                                        child: Text(
                                          fname[0].toString(),
                                          style: TextStyles.mb18,
                                        ),
                                        radius: 30,
                                      ),
                                      // trailing: Text(
                                      //   '\u{20B9} ' + data[index]['amount'],
                                      //   style: TextStyle(
                                      //       color: Colors.black, fontSize: 15),
                                      // ),
                                      subtitle: Text(
                                        data[index][1]['date'].toString(),
                                        style: TextStyles.mb12,
                                      ),
                                      title: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 10),
                                        child: Text(
                                          data[index][1]['name'].toString(),
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
          ]),
        ),
        bottomNavigationBar: BottomBar(
          index: 1,
        ),
      ),
    );
  }

  get_recent_deleted_customer(tablename) async {
    FirebaseFirestore.instance
        .collection('customer_record')
        .where('deleted', isEqualTo: "1")
        .get()
        .then((QueryDocumentSnapshot) {
      for (var queryDocumentSnapshot in QueryDocumentSnapshot.docs) {
        print("id=" + queryDocumentSnapshot.id);

        Map<String, dynamic> fetchdata = queryDocumentSnapshot.data();

        setState(() {
          data.add([queryDocumentSnapshot.id, fetchdata]);
        });
      }
    });
  }
}
