import 'dart:math';
import 'package:account_book/Constant/TextStyles/Textstyles.dart';
import 'package:account_book/Constant/navigaotors/Navagate_Next.dart';
import 'package:account_book/screens/customertransactions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactListScreen extends StatefulWidget {
  ContactListScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();
  TextEditingController customer = TextEditingController();
  TextEditingController phoneno = TextEditingController();
  List<Contact>? _contacts;
  bool _permissionDenied = false;
  var customer_data = [];
  Contact? fullContact;

  bool showtextbox = false;

  bool validation = false;
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts();
      setState(() => _contacts = contacts);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                  onTap: () {
                    backScreen(context);
                  },
                  child: Icon(Icons.arrow_back)),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(left: 10, top: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                width: size.width,
                child: TextField(
                  autofocus: true,
                  onChanged: (text) {
                    _runFilter(text);
                  },
                  controller: customer,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      suffixIcon: showtextbox == true
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  customer.text = " ";
                                });
                              },
                              child: Icon(
                                Icons.cancel,
                                size: 30,
                              ),
                            )
                          : Icon(
                              Icons.search,
                              size: 30,
                            ),
                      hintText: 'Enter customers name to add entries',
                      hintStyle: TextStyles.mb14),
                ),
              ),
              SizedBox(height: 20),
              showtextbox == true
                  ? add_new_customer()
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          showtextbox = true;
                        });
                      },
                      child: Container(
                        child: Row(
                          children: [
                            DottedBorder(
                                borderType: BorderType.RRect,
                                radius: Radius.circular(40),
                                dashPattern: [5, 5],
                                color: Colors.grey,
                                strokeWidth: 2,
                                child: Card(
                                  color: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    size: 30,
                                  ),
                                )),
                            SizedBox(width: 15),
                            Container(
                              child: Text(
                                "Add new Customer",
                                style: TextStyles.mb16,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
              SizedBox(height: 10),
              validation == true
                  ? Text("please enter name or mobile no",
                      style: TextStyles.withColor(TextStyles.mb14, Colors.red))
                  : Container(),
              SizedBox(height: 20),
              Container(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(height: size.height * 0.82, child: _body()),
                  ],
                ),
              ))
            ],
          ),
        ),
      )),
    );
  }

  Widget _body() {
    if (_permissionDenied) return Center(child: Text('Permission denied'));
    if (_contacts == null) return Center(child: CircularProgressIndicator());
    return Container(
        child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: _contacts!.length,
            itemBuilder: (context, i) {
              return ListTile(
                  title: Text(
                    _contacts![i].displayName,
                    style: TextStyles.mb12,
                  ),
                  onTap: () async {
                    fullContact =
                        await FlutterContacts.getContact(_contacts![i].id);
                    CircularProgressIndicator();
                    print("number" + fullContact!.phones.first.number);
                    await check_already_customer_or_not(fullContact!
                        .phones.first.number
                        .replaceAll(" ", "")
                        .toString()
                        .replaceAll("+91", ''));

                    print(fullContact!.phones.first.number);

                    // var cus_data = check_already_customer_or_not(
                    //     _contacts![i].phones.first.number);
                    // if (cus_data != null) {
                    //   print("data null");
                    // } else
                    //   print("data not null");
                  });
            }));
  }

  void _runFilter(String enteredKeyword) {
    List<Contact> results = [];

    if (enteredKeyword.isEmpty) {
      _fetchContacts();
      // if the search field is empty or only contains white-space, we'll display all users
    } else {
      results = _contacts!
          .where(
              (user) => user.displayName.contains(enteredKeyword.toLowerCase()))
          .toList();

      print("data" + results.toString());
      // we use the toLowerCase() method to make it case-insensitive
    }
    // Refresh the UI
    setState(() {
      _contacts = results;
    });
  }

  check_already_customer_or_not(mobile_no) {
    var data = [];
    FirebaseFirestore.instance
        .collection('customer_record')
        .where('mobile_no', isEqualTo: mobile_no)
        .where('deleted', isEqualTo: "0")
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.length > 0) {
        querySnapshot.docs.forEach((element) {
          print("element id" + element.id);

          print('data is exits');
          setState(() {
            data.add(element.data());
          });
          nextScreen(
              context,
              Customertransaction(
                p_image: data[0]['p_image'],
                contact: fullContact,
                iscustomer: "1",
                name: null,
                id: element.id,
                address: data[0]['address'],
              ));
        });
      } else {
        print('data is not exits');
        nextScreen(
            context,
            Customertransaction(
              p_image: " ",
              contact: fullContact,
              iscustomer: "0",
              name: null,
              id: null,
              address: " ",
            ));
      }
    });

    // DatabaseReference dataf = databaseReference.child('customer_record');

    // dataf
    //     .orderByChild('mobile_no')
    //     .equalTo(mobile_no)
    //     .once()
    //     .then((DataSnapshot snapshot) {
    //   var key = snapshot.key.toString();
    //   var value = snapshot.value;

    //   if (value != null) {
    //     print("data not null");
    //     for (var value in snapshot.value.values) {
    //       setState(() {
    //         customer_data.add(value);
    //       });
    //     }

    //     List datade = customer_data
    //         .where((element) => element['deleted'] == "0")
    //         .toList();

    //     print("datades" + datade.toString());
    //     // print("key" + key);
    //     // print("value" + snapshot.value['id'].toString());

    //     if (datade.length > 0) {
    //       nextScreen(
    //           context,
    //           Customertransaction(
    //             contact: fullContact,
    //             iscustomer: "1",
    //             name: null,
    //             id: customer_data[0]['id'],
    //           ));
    //     } else {
    //       nextScreen(
    //           context,
    //           Customertransaction(
    //             contact: fullContact,
    //             iscustomer: "0",
    //             name: null,
    //             id: null,
    //           ));
    //     }

    //     print("filter_data" + customer_data.toString());
    //   } else {
    //     print("No Data");
    //     nextScreen(
    //         context,
    //         Customertransaction(
    //           contact: fullContact,
    //           iscustomer: "0",
    //           name: null,
    //           id: null,
    //         ));
    //   }
    // });
  }

  add_new_customer() {
    var size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 10, top: 10),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          width: size.width * 0.6,
          height: size.height * 0.05,
          child: TextField(
            keyboardType: TextInputType.number,
            controller: phoneno,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter phone number',
                hintStyle: TextStyles.mb14),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            if (customer.text.isEmpty && phoneno.text.isEmpty) {
              setState(() {
                validation = true;
              });
              print("enter value");
            } else
              nextScreen(
                  context,
                  Customertransaction(
                    contact: null,
                    name: customer.text,
                    mobile_no: phoneno.text,
                    iscustomer: "0",
                    id: null,
                    p_image: " ",
                  ));
          },
          child: Container(
            alignment: Alignment.center,
            color: Colors.blue,
            width: size.width,
            height: size.height * 0.05,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Countinue',
                style: TextStyles.withColor(TextStyles.mb14, Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// class Customertransaction extends StatefulWidget {
//   final Contact contact;
//   final iscustomer;
//   Customertransaction({Key? key, required this.contact, this.iscustomer})
//       : super(key: key);

//   @override
//   State<Customertransaction> createState() => _CustomertransactionState();
// }

// class _CustomertransactionState extends State<Customertransaction> {
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Scaffold(
//         appBar: AppBar(
//             title: Row(
//           children: [
//             CircleAvatar(
//               radius: 20,
//               backgroundImage: NetworkImage('https://via.placeholder.com/150'),
//               backgroundColor: Colors.transparent,
//             ),
//             SizedBox(width: 10),
//             Text(
//               widget.contact.displayName,
//               style: TextStyles.mb14,
//             ),
//           ],
//         )),
//         // Text('First name: ${contact.name.first}'),
//         // Text('Last name: ${contact.name.last}'),
//         // Text(
//         //     'Phone number: ${contact.phones.isNotEmpty ? contact.phones.first.number : '(none)'}'),
//         // Text(
//         //     'Email address: ${contact.emails.isNotEmpty ? contact.emails.first.address : '(none)'}'),
//         body: Padding(
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,

//             // mainAxisSize: MainAxisSize.max,
//             // mainAxisAlignment: MainAxisAlignment.end,

//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "ENTRIES",
//                     style: TextStyles.mb12,
//                   ),
//                   Container(
//                     width: size.width * 0.4,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "You Gave",
//                           style: TextStyles.mb12,
//                         ),
//                         Text(
//                           "You GOT",
//                           style: TextStyles.mb12,
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//               GestureDetector(
//                 onTap: () {
//                   // nextScreen(
//                   //     context,
//                   //     MoneyGaveScreen(
//                   //         name: contact.displayName.toString(),
//                   //         mobile_no: contact.phones.first.number.toString()));
//                 },
//                 child: Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(10),
//                     child: Container(
//                         decoration: BoxDecoration(
//                             color: Colors.red,
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(10))),
//                         width: size.width * 0.8,
//                         height: size.height * 0.05,
//                         alignment: Alignment.bottomCenter,
//                         child: Center(
//                             child: Text(
//                           "You Gave  " + '\u{20B9} ',
//                           style: TextStyles.withColor(
//                               TextStyles.mb16, Colors.white),
//                         ))),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }
// }
